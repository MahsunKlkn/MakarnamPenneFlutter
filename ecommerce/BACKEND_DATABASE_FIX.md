# 🔧 Backend Hatası: "An error occurred while saving the entity changes"

## ❌ Sorun

Backend'de Payment kaydı oluşturulurken veritabanı hatası oluşuyor:
```
"An error occurred while saving the entity changes. See the inner exception for details."
```

## 🔍 Neden Oluşuyor?

1. **Payment** entity'si muhtemelen **OrderId** foreign key'e sahip
2. Henüz bir **Order** kaydı oluşturulmadığı için foreign key constraint hatası veriyor
3. Backend şu anda ödeme başlatılırken hemen Payment kaydı yaratmaya çalışıyor

## ✅ Çözüm 1: Payment Kaydını Callback'de Yap (ÖNERİLEN)

`Business/Concrete/PaymentService.cs` dosyasında `InitiatePayment` metodunu düzenleyin:

### Değişiklik Öncesi:
```csharp
public async Task<PaymentResponseDto> InitiatePayment(PaymentRequestDto request)
{
    // İyzico'dan HTML al
    var iyzicoResult = await CallIyzico(request);
    
    // ❌ SORUN: Hemen veritabanına kaydet
    var payment = new Payment
    {
        OrderId = request.BasketId, // OrderId yok, hata!
        Status = "Pending",
        // ...
    };
    _context.Payments.Add(payment);
    await _context.SaveChangesAsync(); // ❌ HATA BURADA!
    
    return new PaymentResponseDto { /* ... */ };
}
```

### Değişiklik Sonrası:
```csharp
public async Task<PaymentResponseDto> InitiatePayment(PaymentRequestDto request)
{
    try
    {
        // 1. Conversation ID oluştur
        string conversationId = Guid.NewGuid().ToString();
        
        // 2. İyzico ayarları
        Options options = new Options
        {
            ApiKey = _configuration["Iyzico:ApiKey"],
            SecretKey = _configuration["Iyzico:SecretKey"],
            BaseUrl = _configuration["Iyzico:BaseUrl"]
        };

        // 3. İyzico'ya istek gönder
        CreatePaymentRequest iyzicoRequest = new CreatePaymentRequest
        {
            Locale = Locale.TR.ToString(),
            ConversationId = conversationId,
            Price = request.Price.ToString("F2", CultureInfo.InvariantCulture),
            PaidPrice = request.PaidPrice.ToString("F2", CultureInfo.InvariantCulture),
            Currency = Currency.TRY.ToString(),
            Installment = 1,
            PaymentChannel = PaymentChannel.WEB.ToString(),
            PaymentGroup = PaymentGroup.PRODUCT.ToString(),
            CallbackUrl = request.CallbackUrl,
            // ... buyer, shipping, billing bilgileri
            // ... basket items
        };

        ThreedsInitialize threedsInitialize = ThreedsInitialize.Create(iyzicoRequest, options);

        if (threedsInitialize.Status != "success")
        {
            return new PaymentResponseDto
            {
                Success = false,
                Message = threedsInitialize.ErrorMessage,
                ErrorCode = threedsInitialize.ErrorCode
            };
        }

        // 4. ✅ ŞİMDİLİK VERİTABANINA KAYDETME!
        // Callback geldiğinde kaydedecegiz

        // 5. Sadece HTML'i döndür
        return new PaymentResponseDto
        {
            Success = true,
            Message = "Ödeme sayfası oluşturuldu",
            ThreeDSHtmlContent = threedsInitialize.HtmlContent,
            PaymentId = threedsInitialize.PaymentId,
            ConversationId = conversationId
        };
    }
    catch (Exception ex)
    {
        return new PaymentResponseDto
        {
            Success = false,
            Message = $"Ödeme başlatılamadı: {ex.Message}"
        };
    }
}
```

### Callback Metodunda Kaydet:
```csharp
public async Task<PaymentCallbackResponseDto> HandleCallback(PaymentCallbackDto callback)
{
    try
    {
        // İyzico'dan ödeme sonucunu kontrol et
        var options = new Options { /* ... */ };
        var request = new CreateThreedsPaymentRequest
        {
            ConversationId = callback.ConversationId,
            PaymentId = callback.PaymentId,
            // ...
        };

        ThreedsPayment payment = ThreedsPayment.Create(request, options);

        if (payment.Status == "success")
        {
            // ✅ ŞİMDİ VERİTABANINA KAYDET
            var paymentEntity = new Payment
            {
                PaymentId = payment.PaymentId,
                ConversationId = payment.ConversationId,
                OrderId = null, // Henüz Order yok, nullable olmalı
                Amount = decimal.Parse(payment.Price),
                PaidPrice = decimal.Parse(payment.PaidPrice),
                Currency = payment.Currency,
                Status = "Success",
                CardFamily = payment.CardFamily,
                CardType = payment.CardType,
                PaymentDate = DateTime.UtcNow
            };

            _context.Payments.Add(paymentEntity);
            await _context.SaveChangesAsync();

            return new PaymentCallbackResponseDto
            {
                Success = true,
                Message = "Ödeme başarılı",
                Status = "SUCCESS",
                // ...
            };
        }
        else
        {
            return new PaymentCallbackResponseDto
            {
                Success = false,
                Message = "Ödeme başarısız",
                Status = "FAILED"
            };
        }
    }
    catch (Exception ex)
    {
        return new PaymentCallbackResponseDto
        {
            Success = false,
            Message = $"Callback işlenemedi: {ex.Message}"
        };
    }
}
```

---

## ✅ Çözüm 2: OrderId'yi Nullable Yap

Eğer Payment kaydını hemen yapmak istiyorsanız:

### 1. Payment Entity'sini Düzenleyin:
```csharp
// Entities/Concrete/Payment.cs
public class Payment
{
    public int Id { get; set; }
    public int? OrderId { get; set; } // ✅ Nullable yaptık
    public string PaymentId { get; set; }
    public string ConversationId { get; set; }
    public decimal Amount { get; set; }
    public decimal PaidPrice { get; set; }
    public string Currency { get; set; }
    public string Status { get; set; }
    public string? CardFamily { get; set; }
    public string? CardType { get; set; }
    public DateTime? PaymentDate { get; set; }
    
    // Navigation property
    public Order? Order { get; set; } // ✅ Nullable
}
```

### 2. Migration Oluşturun:
```powershell
cd YourBackendFolder
dotnet ef migrations add MakePaymentOrderIdNullable --project .\DataAccessLayer\DataAccessLayer.csproj --startup-project .\API\API.csproj
dotnet ef database update --project .\DataAccessLayer\DataAccessLayer.csproj --startup-project .\API\API.csproj
```

### 3. PaymentService'te OrderId'yi Null Yapın:
```csharp
var payment = new Payment
{
    OrderId = null, // ✅ Null
    PaymentId = iyzicoResult.PaymentId,
    ConversationId = conversationId,
    Amount = request.Price,
    PaidPrice = request.PaidPrice,
    Currency = request.Currency,
    Status = "Pending",
    PaymentDate = DateTime.UtcNow
};

_context.Payments.Add(payment);
await _context.SaveChangesAsync();
```

---

## ✅ Çözüm 3: Önce Order Oluştur (Tam Çözüm)

En doğru yaklaşım - sipariş akışı:

```csharp
public async Task<PaymentResponseDto> InitiatePayment(PaymentRequestDto request)
{
    try
    {
        // 1. Önce Order oluştur
        var order = new Order
        {
            UserId = int.Parse(request.BuyerId),
            TotalAmount = request.PaidPrice,
            Status = "Pending",
            CreatedDate = DateTime.UtcNow
        };
        
        _context.Orders.Add(order);
        await _context.SaveChangesAsync(); // Order kaydedildi, ID alındı
        
        // 2. İyzico'ya istek gönder
        string conversationId = Guid.NewGuid().ToString();
        var iyzicoRequest = CreateIyzicoRequest(request, conversationId);
        ThreedsInitialize threedsInitialize = ThreedsInitialize.Create(iyzicoRequest, options);
        
        if (threedsInitialize.Status != "success")
        {
            // Order'ı sil veya Failed yap
            order.Status = "Failed";
            await _context.SaveChangesAsync();
            
            return new PaymentResponseDto { Success = false, /* ... */ };
        }
        
        // 3. Payment kaydı oluştur
        var payment = new Payment
        {
            OrderId = order.Id, // ✅ Artık var!
            PaymentId = threedsInitialize.PaymentId,
            ConversationId = conversationId,
            Amount = request.Price,
            PaidPrice = request.PaidPrice,
            Currency = request.Currency,
            Status = "Pending",
            PaymentDate = DateTime.UtcNow
        };
        
        _context.Payments.Add(payment);
        await _context.SaveChangesAsync();
        
        return new PaymentResponseDto
        {
            Success = true,
            ThreeDSHtmlContent = threedsInitialize.HtmlContent,
            PaymentId = threedsInitialize.PaymentId,
            ConversationId = conversationId
        };
    }
    catch (Exception ex)
    {
        return new PaymentResponseDto { Success = false, Message = ex.Message };
    }
}
```

---

## 🎯 Hangi Çözümü Seçmeli?

| Çözüm | Avantajı | Dezavantajı | Önerilen |
|-------|----------|-------------|----------|
| **Çözüm 1** | En basit, hızlı | Payment kaydı gecikmeli | ✅ Test için |
| **Çözüm 2** | Orta karmaşık | OrderId null kalıyor | ⚠️ Geçici |
| **Çözüm 3** | En doğru akış | Biraz karmaşık | ✅ Production |

---

## 📝 Hızlı Test İçin

**ŞİMDİLİK EN HIZLI ÇÖZÜM** → Çözüm 1'i uygulayın:
1. `InitiatePayment`'ta veritabanına kaydetmeyin
2. Sadece İyzico'dan HTML'i alıp döndürün
3. Payment kaydını `HandleCallback`'de yapın

Backend dosyası: `Business/Concrete/PaymentService.cs`

---

## 🚀 Test Adımları

1. ✅ Backend'de yukarıdaki değişiklikleri yapın
2. ✅ Backend'i yeniden başlatın: `dotnet run`
3. ✅ Flutter'da tekrar deneyin: "Satın Al"
4. ✅ Artık WebView açılmalı!

---

**Not**: Flutter tarafında `basketId: 0` yaptık, backend'de bunu kullanmayacaksanız sorun yok.

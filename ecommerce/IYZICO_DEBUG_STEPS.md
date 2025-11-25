# 🔍 İyzico "PaymentCard gönderilmesi zorunludur" Hatası - Debug

## ✅ API Anahtarları Doğru
```
ApiKey: sandbox-rmmRNQqs82pDe7Wk1diKhHr96JZXcYBq
SecretKey: sandbox-r5mU1RudySfgruykpfhrgInH099dYeUs
BaseUrl: https://sandbox-api.iyzipay.com
```

## 🔍 Sorun

İyzico hata veriyor: **"PaymentCard gönderilmesi zorunludur (5013)"**

Bu hata şu durumlarda olur:
1. `Payment.Create()` kullanılıyorsa → PaymentCard gerekir
2. `ThreedsInitialize.Create()` kullanılıyorsa → PaymentCard gerekmez

Backend log'unda görmek istediğimiz:
```
🚀 İyzico ThreedsInitialize.Create çağrılıyor...
✅ İyzico 3DS başarılı
```

## 📝 Backend Dosyasına Eklenecek Debug Kodu

`C:\ECommerce\API\Business\Concrete\PaymentService.cs` dosyasında `InitiatePayment` metoduna:

```csharp
public async Task<PaymentResponseDto> InitiatePayment(PaymentRequestDto request)
{
    try
    {
        string conversationId = Guid.NewGuid().ToString();
        
        // ✅ DEBUG: Ayarları kontrol et
        Console.WriteLine("=" .PadRight(50, '='));
        Console.WriteLine("🔍 İyzico Ayarları:");
        Console.WriteLine($"   API Key: {_configuration["Iyzico:ApiKey"]}");
        Console.WriteLine($"   Secret Key: {_configuration["Iyzico:SecretKey"]?.Substring(0, 20)}...");
        Console.WriteLine($"   Base URL: {_configuration["Iyzico:BaseUrl"]}");
        Console.WriteLine("=" .PadRight(50, '='));

        Options options = new Options
        {
            ApiKey = _configuration["Iyzico:ApiKey"],
            SecretKey = _configuration["Iyzico:SecretKey"],
            BaseUrl = _configuration["Iyzico:BaseUrl"]
        };

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
            
            Buyer = new Buyer
            {
                Id = request.BuyerId,
                Name = request.BuyerName,
                Surname = request.BuyerSurname,
                Email = request.BuyerEmail,
                IdentityNumber = request.BuyerIdentityNumber,
                RegistrationAddress = request.BuyerRegistrationAddress,
                City = request.BuyerCity,
                Country = request.BuyerCountry,
                ZipCode = request.BuyerZipCode,
                Ip = "85.34.78.112"
            },
            
            ShippingAddress = new Address
            {
                ContactName = request.ShippingContactName,
                City = request.ShippingCity,
                Country = request.ShippingCountry,
                Description = request.ShippingAddress,
                ZipCode = request.ShippingZipCode
            },
            
            BillingAddress = new Address
            {
                ContactName = request.BillingContactName,
                City = request.BillingCity,
                Country = request.BillingCountry,
                Description = request.BillingAddress,
                ZipCode = request.BillingZipCode
            },
            
            BasketItems = request.BasketItems.Select(item => new BasketItem
            {
                Id = item.Id,
                Name = item.Name,
                Category1 = item.Category1,
                ItemType = item.ItemType,
                Price = item.Price.ToString("F2", CultureInfo.InvariantCulture)
            }).ToList()
        };

        // ✅ DEBUG: Request detayları
        Console.WriteLine("📦 İyzico Request:");
        Console.WriteLine($"   ConversationId: {iyzicoRequest.ConversationId}");
        Console.WriteLine($"   Price: {iyzicoRequest.Price}");
        Console.WriteLine($"   PaidPrice: {iyzicoRequest.PaidPrice}");
        Console.WriteLine($"   Currency: {iyzicoRequest.Currency}");
        Console.WriteLine($"   BasketItems Count: {iyzicoRequest.BasketItems.Count}");
        Console.WriteLine($"   Buyer Email: {iyzicoRequest.Buyer.Email}");

        // ✅ ÖNEMLİ: ThreedsInitialize kullandığınızı doğrulayın
        Console.WriteLine("🚀 İyzico ThreedsInitialize.Create() çağrılıyor...");
        Console.WriteLine($"   Metod: ThreedsInitialize.Create");
        
        // ❌ EĞER BU SATIR VARSA SİLİN:
        // Payment payment = Payment.Create(iyzicoRequest, options);
        
        // ✅ SADECE BU OLMALI:
        ThreedsInitialize threedsInitialize = ThreedsInitialize.Create(iyzicoRequest, options);

        // ✅ DEBUG: Response kontrolü
        Console.WriteLine("📥 İyzico Response:");
        Console.WriteLine($"   Status: {threedsInitialize.Status}");
        Console.WriteLine($"   ErrorCode: {threedsInitialize.ErrorCode ?? "null"}");
        Console.WriteLine($"   ErrorMessage: {threedsInitialize.ErrorMessage ?? "null"}");
        Console.WriteLine($"   PaymentId: {threedsInitialize.PaymentId ?? "null"}");
        Console.WriteLine($"   HtmlContent Length: {threedsInitialize.HtmlContent?.Length ?? 0}");
        Console.WriteLine("=" .PadRight(50, '='));

        if (threedsInitialize.Status != "success")
        {
            Console.WriteLine($"❌ İyzico Hatası: {threedsInitialize.ErrorMessage}");
            Console.WriteLine($"❌ Hata Kodu: {threedsInitialize.ErrorCode}");
            
            return new PaymentResponseDto
            {
                Success = false,
                Message = threedsInitialize.ErrorMessage ?? "Ödeme başlatılamadı",
                ErrorCode = threedsInitialize.ErrorCode,
                ErrorMessage = threedsInitialize.ErrorMessage
            };
        }

        Console.WriteLine($"✅ İyzico 3DS başarılı - PaymentId: {threedsInitialize.PaymentId}");

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
        Console.WriteLine($"❌ Exception: {ex.Message}");
        Console.WriteLine($"❌ StackTrace: {ex.StackTrace}");
        
        return new PaymentResponseDto
        {
            Success = false,
            Message = $"Ödeme başlatılamadı: {ex.Message}",
            ErrorCode = null,
            ErrorMessage = ex.Message
        };
    }
}
```

## 🎯 Kontrol Edilecek Noktalar

### 1. Using İfadeleri
Dosyanın en üstünde olmalı:
```csharp
using Iyzipay;
using Iyzipay.Model;
using Iyzipay.Request;
```

### 2. Kesinlikle KULLANILMAMASI Gerekenler
```csharp
// ❌ BU SATIR VARSA SİLİN - PaymentCard gerektirir
Payment payment = Payment.Create(iyzicoRequest, options);

// ❌ BU SATIR VARSA SİLİN - 3DS'de kartı kullanıcı girer
iyzicoRequest.PaymentCard = new PaymentCard { ... };
```

### 3. Kesinlikle KULLANILMASI Gerekenler
```csharp
// ✅ BU OLMALI - 3D Secure için
ThreedsInitialize threedsInitialize = ThreedsInitialize.Create(iyzicoRequest, options);

// ✅ Response dönerken
return new PaymentResponseDto
{
    ThreeDSHtmlContent = threedsInitialize.HtmlContent, // payment.HtmlContent DEĞİL!
    PaymentId = threedsInitialize.PaymentId
};
```

## 🚀 Test Adımları

1. Yukarıdaki debug kodunu `PaymentService.cs`'e ekleyin
2. Backend'i **tamamen durdurun** (Ctrl+C)
3. Yeniden başlatın: `dotnet run`
4. Flutter'da "Satın Al" butonuna basın
5. Backend console'da şu logları arayın:
   ```
   ==================================================
   🔍 İyzico Ayarları:
      API Key: sandbox-...
   📦 İyzico Request:
      ConversationId: ...
   🚀 İyzico ThreedsInitialize.Create() çağrılıyor...
      Metod: ThreedsInitialize.Create
   📥 İyzico Response:
      Status: success
   ✅ İyzico 3DS başarılı
   ```

## ❓ Beklenen Sonuçlar

### ✅ Başarılı Durumda Göreceksiniz:
```
🚀 İyzico ThreedsInitialize.Create() çağrılıyor...
   Metod: ThreedsInitialize.Create
📥 İyzico Response:
   Status: success
   ErrorCode: null
   PaymentId: 123456
   HtmlContent Length: 5000+
✅ İyzico 3DS başarılı
```

### ❌ Hatalı Durumda Göreceksiniz:
```
🚀 İyzico ThreedsInitialize.Create() çağrılıyor...
📥 İyzico Response:
   Status: failure
   ErrorCode: 5013
   ErrorMessage: PaymentCard gönderilmesi zorunludur
```

Bu durumda muhtemelen kod içinde yanlışlıkla `Payment.Create()` kullanılıyor demektir.

---

## 🔧 Olası Sorun: Payment.Create Kullanılıyor Olabilir

Eğer başka bir yerde (örneğin helper metod veya base class'ta) `Payment.Create()` çağrılıyorsa:

```csharp
// ❌ YANLIŞ - Helper metodda bile kullanmayın
private Payment CallIyzico(CreatePaymentRequest request, Options options)
{
    return Payment.Create(request, options); // ❌ BU YANLIŞ!
}

// ✅ DOĞRU
private ThreedsInitialize CallIyzico(CreatePaymentRequest request, Options options)
{
    return ThreedsInitialize.Create(request, options); // ✅ BU DOĞRU!
}
```

---

**Backend'i yukarıdaki debug kodlarıyla çalıştırın ve console çıktısını paylaşın!**

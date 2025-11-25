## 🔍 Ödeme Başlatılamadı Hatası - Çözüm Adımları

### 1️⃣ Console Loglarını Kontrol Edin

Flutter uygulamasını çalıştırın ve "Satın Al" butonuna bastığınızda console'da şu logları göreceksiniz:

```
💳 Ödeme başlatılıyor...
💰 Toplam: 150.00 TL
🛍️ Ürün sayısı: 2
📦 Basket ID: 1
👤 User ID: 123
💳 Payment Service: Ödeme başlatılıyor...
📍 Endpoint: https://localhost:7197/api/Payment/initiate
📦 Request Data: {...}
```

**HATA MESAJLARI** şöyle olabilir:
- `DioException Type: DioExceptionType.connectionTimeout` → Backend çalışmıyor
- `Durum Kodu: 404` → Endpoint yanlış
- `Durum Kodu: 500` → Backend hatası
- `Durum Kodu: 400` → Request data hatası

---

### 2️⃣ Backend'in Çalıştığını Doğrulayın

```powershell
# Backend klasörüne gidin
cd YourBackendFolder

# Backend'i başlatın
dotnet run
```

Backend başladığında şöyle bir çıktı göreceksiniz:
```
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: https://localhost:7197
      Now listening on: http://localhost:5118
```

---

### 3️⃣ Endpoint URL'ini Kontrol Edin

Backend Controller'ınız şöyle tanımlı:
```csharp
[Route("api/[controller]")]
[ApiController]
public class PaymentController : ControllerBase
```

Bu durumda endpoint: `/api/Payment/initiate` (büyük P ile)

**Flutter tarafında zaten düzelttim**, ama emin olalım:
- ✅ `Payment.dart` → `_serviceUrl = '${AppConfig.instance.apiBaseUrl}/Payment';`

---

### 4️⃣ İyzico API Anahtarlarını Kontrol Edin

Backend'inizin `appsettings.json` dosyasında:

```json
{
  "Iyzico": {
    "ApiKey": "sandbox-GERÇEK_ANAHTAR",
    "SecretKey": "sandbox-GERÇEK_SECRET",
    "BaseUrl": "https://sandbox-api.iyzipay.com"
  }
}
```

⚠️ `SIZIN_API_KEYINIZ` yazısını gerçek anahtarlarla değiştirdiğinizden emin olun!

Test anahtarları için: https://sandbox-merchant.iyzipay.com

---

### 5️⃣ HTTPS Sertifika Sorunları (Windows)

Eğer `DioException: HandshakeException` hatası alıyorsanız:

```powershell
# Developer sertifikasına güvenin
dotnet dev-certs https --trust
```

---

### 6️⃣ Test Senaryosu

1. ✅ Backend çalıştırın: `dotnet run`
2. ✅ Flutter uygulamasını başlatın: `flutter run`
3. ✅ Giriş yapın
4. ✅ Sepete ürün ekleyin
5. ✅ "Satın Al" butonuna tıklayın
6. ✅ Console loglarını okuyun

---

### 7️⃣ Hata Durumunda Debug Checklist

**Backend çalışıyor mu?**
```powershell
curl https://localhost:7197/api/Payment/initiate
```
404 dönerse endpoint yanlış, 405 dönerse backend çalışıyor demektir.

**İyzico bağlantısı çalışıyor mu?**
Backend console'unda şu logları arayın:
- "Ödeme başlatma isteği alındı"
- "İyzico'ya istek gönderiliyor"

**Request data doğru mu?**
Console'da göreceksiniz:
```
📦 Request Data: {
  price: 150.0,
  paidPrice: 150.0,
  currency: 'TRY',
  basketId: 1,
  ...
}
```

Eğer `basketId: 0` ise → Sepet yüklenmemiş!

---

### 8️⃣ En Sık Karşılaşılan Hatalar ve Çözümleri

#### ❌ "Ödeme başlatılamadı - Backend'den yanıt alınamadı"
**Çözüm**: Backend çalışmıyor veya port farklı
```powershell
# Backend'i başlatın
dotnet run

# Port'u kontrol edin (main.dart'ta AppConfig.setup yapılandırması)
```

#### ❌ "Status 404: Not Found"
**Çözüm**: Endpoint yanlış
- Backend: `/api/Payment/initiate`
- Flutter: `Payment.dart` → `_serviceUrl = '.../Payment'` ✅

#### ❌ "Status 500: Internal Server Error"
**Çözüm**: Backend hatası, backend console'u kontrol edin
- İyzico API anahtarları yanlış olabilir
- `appsettings.json` eksik olabilir

#### ❌ "Invalid API Key"
**Çözüm**: İyzico test anahtarlarınızı kontrol edin
- https://sandbox-merchant.iyzipay.com → Settings → API Keys

#### ❌ "Sepetiniz boş"
**Çözüm**: Önce sepete ürün ekleyin

#### ❌ "Lütfen önce giriş yapın"
**Çözüm**: Uygulamada giriş yapın

---

### 9️⃣ Manuel Test (Postman ile)

Backend'in çalışıp çalışmadığını test etmek için:

**Endpoint**: `POST https://localhost:7197/api/Payment/initiate`

**Headers**:
```
Content-Type: application/json
```

**Body**:
```json
{
  "price": 100.0,
  "paidPrice": 100.0,
  "currency": "TRY",
  "basketId": 1,
  "callbackUrl": "https://example.com/callback",
  "buyerId": "123",
  "buyerName": "Test",
  "buyerSurname": "User",
  "buyerEmail": "test@example.com",
  "buyerIdentityNumber": "12345678901",
  "buyerRegistrationAddress": "Test Address",
  "buyerCity": "Istanbul",
  "buyerCountry": "Turkey",
  "buyerZipCode": "34000",
  "buyerPhone": "+905551234567",
  "shippingContactName": "Test User",
  "shippingCity": "Istanbul",
  "shippingCountry": "Turkey",
  "shippingAddress": "Test Address",
  "shippingZipCode": "34000",
  "billingContactName": "Test User",
  "billingCity": "Istanbul",
  "billingCountry": "Turkey",
  "billingAddress": "Test Address",
  "billingZipCode": "34000",
  "basketItems": [
    {
      "id": "1",
      "name": "Test Product",
      "category1": "Electronics",
      "itemType": "PHYSICAL",
      "price": 100.0
    }
  ]
}
```

**Beklenen Sonuç**:
```json
{
  "success": true,
  "message": "Ödeme sayfası oluşturuldu",
  "threeDSHtmlContent": "<html>...</html>",
  "paymentId": "...",
  "conversationId": "..."
}
```

---

### 🔟 Son Çare: Hepsini Sıfırdan Başlatın

```powershell
# Backend
cd YourBackendFolder
dotnet clean
dotnet build
dotnet run

# Flutter (yeni terminal)
cd c:\FlutterCalismalar\ECommerceApp\ecommerce
flutter clean
flutter pub get
flutter run
```

---

### 📞 Hala Çalışmıyor mu?

Şu bilgileri paylaşın:
1. Console'daki **tam hata mesajı** (📍 Endpoint, ❌ DioException)
2. Backend console çıktısı
3. `appsettings.json` içindeki İyzico kısmı (API key'leri gizleyin)
4. Backend çalışıyor mu? (`dotnet run` çıktısı)

---

**Başarılar! 🚀**

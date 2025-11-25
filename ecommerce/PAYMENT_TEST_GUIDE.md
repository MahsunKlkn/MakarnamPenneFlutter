# 💳 İyzico Ödeme Entegrasyonu - Test Kılavuzu

## 🚀 Hızlı Başlangıç

### 1. Backend Hazırlığı

Backend'inizin çalıştığından ve şu endpoint'lerin hazır olduğundan emin olun:

```
POST /api/payment/initiate
POST /api/payment/callback
GET  /api/payment/conversation/{conversationId}
GET  /api/payment/payment/{paymentId}
GET  /api/payment/order/{orderId}
```

Backend'inizde İyzico test anahtarlarınızı `appsettings.json`'a ekleyin:

```json
{
  "Iyzico": {
    "ApiKey": "sandbox-SIZIN_API_KEYINIZ",
    "SecretKey": "sandbox-SIZIN_SECRET_KEYINIZ",
    "BaseUrl": "https://sandbox-api.iyzipay.com"
  }
}
```

Test anahtarları için: https://sandbox-merchant.iyzipay.com

### 2. Flutter Paketlerini Yükleyin

```powershell
flutter pub get
```

### 3. Callback URL Ayarı

⚠️ **ÖNEMLİ**: İyzico'nun callback yapabilmesi için backend'inizin dışarıdan erişilebilir olması gerekiyor.

#### Geliştirme Ortamı İçin (ngrok kullanarak):

```powershell
# ngrok'u indirin: https://ngrok.com/download
ngrok http 5000  # Backend portunu kullanın
```

ngrok size bir URL verecek, örnek: `https://abc123.ngrok.io`

`confirm_button.dart` dosyasında callback URL'ini güncelleyin:

```dart
// Satır ~72
const callbackUrl = 'https://abc123.ngrok.io/api/payment/callback';
```

#### Production İçin:

Gerçek domain'inizi kullanın:
```dart
const callbackUrl = 'https://yourdomain.com/api/payment/callback';
```

---

## 🧪 Test Adımları

### 1. Backend'i Başlatın

```powershell
cd Backend_Projenizin_Yolu
dotnet run
```

### 2. Flutter Uygulamasını Çalıştırın

```powershell
cd c:\FlutterCalismalar\ECommerceApp\ecommerce
flutter run
```

### 3. Test Akışı

1. **Giriş Yapın**: Uygulamada giriş yapın (kullanıcı ID'si gerekli)
2. **Sepete Ürün Ekleyin**: En az 1 ürün ekleyin
3. **Sepete Gidin**: Alt menüden sepet sayfasına gidin
4. **Satın Al'a Tıklayın**: Sayfanın altındaki "Satın Al" butonuna basın
5. **3D Secure Sayfası**: WebView içinde İyzico'nun test sayfası açılacak
6. **Test Kartı Girin**: Aşağıdaki test kartlarından birini kullanın
7. **OTP Kodu**: İyzico test ortamında herhangi bir OTP kodu kabul edilir (örn: 123456)
8. **Ödeme Tamamlansın**: Callback yakalanınca sepet ekranına döneceksiniz

---

## 💳 Test Kartları (İyzico Sandbox)

### ✅ Başarılı Ödeme Kartları

| Kart Numarası      | Son Kullanma | CVC | Sonuç              |
|--------------------|--------------|-----|--------------------|
| 5528790000000008   | 12/30        | 123 | Başarılı           |
| 4603450000000000   | 12/30        | 123 | Başarılı           |
| 5311570000000005   | 12/30        | 123 | 3DS ile Başarılı   |

### ❌ Test Hata Kartları

| Kart Numarası      | Son Kullanma | CVC | Sonuç              |
|--------------------|--------------|-----|--------------------|
| 5406670000000009   | 12/30        | 123 | Yetersiz Bakiye    |
| 4111111111111129   | 12/30        | 123 | Genel Hata         |

---

## 🔍 Debugging

### Console Logları

Flutter tarafında:
```
💳 Ödeme başlatılıyor...
💰 Toplam: 150.00 TL
🛍️ Ürün sayısı: 2
✅ Ödeme sayfası alındı, WebView açılıyor...
🌐 WebView: Sayfa yükleniyor - ...
✅ WebView: Sayfa yüklendi
🎯 Callback URL yakalandı!
🎉 Ödeme başarılı!
```

Backend tarafında:
```
Ödeme başlatma isteği alındı - ConversationId: xxx
İyzico'dan cevap alındı - Status: success
Callback alındı - PaymentId: xxx
```

### Sık Karşılaşılan Hatalar

#### ❌ "Callback URL'e ulaşılamıyor"
**Çözüm**: ngrok ile backend'inizi expose edin ve callback URL'ini güncelleyin

#### ❌ "Invalid conversation id"
**Çözüm**: Backend'de her ödeme için yeni ConversationId oluşturulduğundan emin olun

#### ❌ "Sepetiniz boş"
**Çözüm**: Önce sepete ürün ekleyin

#### ❌ "Lütfen önce giriş yapın"
**Çözüm**: Uygulamada giriş yapmayı unutmayın

---

## 📱 Test Senaryoları

### Senaryo 1: Normal Ödeme Akışı
1. Sepete 2 ürün ekle
2. "Satın Al" butonuna tıkla
3. Test kartı gir: `5528790000000008`
4. Ödemeyi tamamla
5. ✅ Başarı mesajı görülmeli

### Senaryo 2: Ödeme İptali
1. Sepete ürün ekle
2. "Satın Al" butonuna tıkla
3. WebView açıldığında geri tuşuna bas
4. "Ödemeyi iptal etmek istediğinizden emin misiniz?" popup'ı gelecek
5. "Evet" seç
6. ✅ Sepet ekranına dönülmeli

### Senaryo 3: Yetersiz Bakiye
1. Sepete ürün ekle
2. "Satın Al" butonuna tıkla
3. Test kartı gir: `5406670000000009`
4. ❌ Hata mesajı görülmeli

---

## 🔐 Güvenlik Notları

⚠️ **ASLA** aşağıdakileri yapmayın:
- İyzico Secret Key'i Flutter koduna koymayın
- Production API Key'lerini git'e commit etmeyin
- Callback URL'ini HTTP olarak bırakmayın (sadece HTTPS)

✅ **Yapılması gerekenler**:
- Tüm ödeme işlemleri backend üzerinden yapılmalı
- Flutter sadece API endpoint'lerini çağırmalı
- Callback URL HTTPS olmalı
- Production'da environment variables kullanın

---

## 📊 Ödeme Akış Şeması

```
[Flutter App]
    │
    ├─> Sepete Ürün Ekle
    │
    ├─> "Satın Al" Butonuna Tıkla
    │
    └─> POST /api/payment/initiate
            │
            ├─> Backend → İyzico API
            │       │
            │       └─> 3D Secure HTML döner
            │
            └─> Flutter WebView'da HTML gösterir
                    │
                    ├─> Kullanıcı kart bilgilerini girer
                    │
                    ├─> İyzico OTP kontrolü yapar
                    │
                    └─> POST /api/payment/callback (İyzico → Backend)
                            │
                            └─> Flutter callback yakaladı → Ödeme Başarılı! 🎉
```

---

## 🆘 Destek

- **İyzico Dokümantasyon**: https://dev.iyzipay.com/tr
- **Sandbox Test Paneli**: https://sandbox-merchant.iyzipay.com
- **ngrok Dokümantasyon**: https://ngrok.com/docs

---

## ✅ Kontrol Listesi

Test öncesi kontrol edin:

- [ ] Backend çalışıyor
- [ ] İyzico API anahtarları appsettings.json'da
- [ ] ngrok ile backend expose edildi (dev için)
- [ ] callback URL güncellendi (confirm_button.dart)
- [ ] Flutter pub get yapıldı
- [ ] Kullanıcı giriş yaptı
- [ ] Sepette en az 1 ürün var
- [ ] Test kartı bilgileri hazır

---

**Başarılı testler! 🚀**

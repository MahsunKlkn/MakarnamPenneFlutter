# Sepet Yönetimi Kullanım Kılavuzu

## 📦 Genel Bakış

Bu proje, kullanıcıların e-ticaret uygulamasında sepet işlemlerini yönetmelerini sağlayan kapsamlı bir sepet yönetim sistemi içerir. Backend'de `productIds` string formatında (örn: "7,8,9") saklanan sepet verileri, uygulama katmanında düzgün bir şekilde işlenir.

## 🏗️ Mimari

### Model Katmanı
- **BasketModel** (`lib/app/data/models/Basket.dart`)
  - Backend API ile uyumlu model
  - `productIds`: Virgülle ayrılmış ürün ID'leri (string)
  - `getProductIdsList()`: String'i List<int>'e dönüştürür

### Service Katmanı
- **BasketApiService** (`lib/app/data/services/Basket.dart`)
  - HTTP istekleri için Dio kullanır
  - CRUD işlemleri: getAllBaskets, getBasketById, getBasketByUserId, addBasket, updateBasket, deleteBasket

### Repository Katmanı
- **BasketRepository** (`lib/app/repository/BasketRepository.dart`)
  - Service katmanını sarmallar
  - Detaylı hata yönetimi ve loglama

### ViewModel Katmanı
- **BasketViewModel** (`lib/app/viewmodels/basket_view_model.dart`)
  - State management için ChangeNotifier kullanır
  - İş mantığını yönetir
  - UI'a temiz bir arayüz sağlar

## 🔑 Ana Özellikler

### 1. Sepete Ürün Ekleme

```dart
final basketViewModel = Provider.of<BasketViewModel>(context, listen: false);
final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

final userId = int.parse(authViewModel.currentUserId!);
final success = await basketViewModel.addProductToBasket(userId, productId);

if (success) {
  // Başarılı mesajı göster
  print('Ürün sepete eklendi!');
} else {
  // Hata mesajını göster
  print(basketViewModel.errorMessage);
}
```

**Çalışma Mantığı:**
1. Kullanıcının mevcut sepeti kontrol edilir
2. Sepet varsa:
   - Ürün ID'leri listesine yeni ürün eklenir
   - `productIds` string güncellenir (örn: "7,8" → "7,8,10")
   - Sepet PUT ile güncellenir
3. Sepet yoksa:
   - Yeni bir sepet oluşturulur
   - İlk ürün ID'si eklenir
   - Sepet POST ile kaydedilir

### 2. Sepetten Ürün Çıkarma

```dart
final success = await basketViewModel.removeProductFromBasket(userId, productId);

if (success) {
  print('Ürün sepetten çıkarıldı!');
}
```

**Çalışma Mantığı:**
1. Kullanıcının sepeti bulunur
2. Ürün ID'si listeden çıkarılır
3. Liste boşsa → Sepet tamamen silinir (DELETE)
4. Liste boş değilse → Sepet güncellenir (PUT)

### 3. Kullanıcı Sepetini Yükleme

```dart
await basketViewModel.loadUserBasket(userId);

// Sepetteki ürün sayısını al
int itemCount = basketViewModel.basketItemCount;

// Sepet verilerine eriş
BasketModel? basket = basketViewModel.userBasket;
```

### 4. Ürünün Sepette Olup Olmadığını Kontrol Etme

```dart
bool isInBasket = basketViewModel.isProductInBasket(productId);

// UI'da kullanım
Icon(
  isInBasket ? Icons.check_circle : Icons.add_circle,
  color: isInBasket ? Colors.green : Colors.orange,
)
```

### 5. Sepeti Temizleme

```dart
final success = await basketViewModel.clearBasket(userId);

if (success) {
  print('Sepet temizlendi!');
}
```

## 🎨 UI Entegrasyonu

### Product Card'da Sepete Ekleme Butonu

```dart
// lib/app/ui/screens/menu/widgets/product_menu_card.dart

IconButton(
  icon: const Icon(Icons.add, color: Colors.deepOrange),
  onPressed: () async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final basketViewModel = Provider.of<BasketViewModel>(context, listen: false);
    
    // Kullanıcı kontrolü
    if (!authViewModel.isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sepete ürün eklemek için giriş yapmalısınız!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    final userId = int.parse(authViewModel.currentUserId!);
    final success = await basketViewModel.addProductToBasket(userId, product.id);
    
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${product.name} sepete eklendi!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  },
)
```

### Sepet Ekranında Ürünleri Gösterme

```dart
// lib/app/ui/screens/basket/widgets/card_item.dart

Consumer<BasketViewModel>(
  builder: (context, basketViewModel, child) {
    if (basketViewModel.isLoading) {
      return const CircularProgressIndicator();
    }
    
    if (basketViewModel.userBasket == null) {
      return const Text('Sepetiniz boş');
    }
    
    List<int> productIds = basketViewModel.userBasket!.getProductIdsList();
    
    return ListView.builder(
      itemCount: productIds.length,
      itemBuilder: (context, index) {
        // Ürün detaylarını getir ve göster
      },
    );
  },
)
```

## 🔄 Kullanıcı Giriş Akışı

Kullanıcı giriş yaptığında otomatik olarak sepeti yüklenir:

```dart
// lib/app/ui/screens/home/index.dart

void _loadUserBasket() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final basketViewModel = Provider.of<BasketViewModel>(context, listen: false);
    
    if (authViewModel.isLoggedIn && authViewModel.currentUserId != null) {
      final userId = int.parse(authViewModel.currentUserId!);
      basketViewModel.loadUserBasket(userId);
    }
  });
}
```

## 📊 Backend API Formatı

### GET /api/Basket/user/{userId}
Kullanıcının sepetini getirir.

**Response:**
```json
{
  "id": 1,
  "kullaniciId": 1,
  "productIds": "10",  // İlk ürün eklendiğinde
  "dateCreated": "2025-10-24T14:49:32.427",
  "dateUpdated": "2025-10-24T14:49:32.427"
}
```

### POST /api/Basket
Yeni sepet oluşturur.

**Request:**
```json
{
  "kullaniciId": 1,
  "productIds": "10"
}
```

### PUT /api/Basket/{id}
Sepeti günceller.

**Request:**
```json
{
  "id": 1,
  "kullaniciId": 1,
  "productIds": "10,15,20"  // Yeni ürünler eklendikçe virgülle ayrılır
}
```

## 🎯 Örnek Senaryo

**Kullanıcı 1, ID'si 10 olan ürünü sepete ekliyor:**

1. **İlk Durum:** Kullanıcının sepeti yok
   ```json
   GET /api/Basket/user/1 → 404 Not Found
   ```

2. **Yeni Sepet Oluştur:**
   ```json
   POST /api/Basket
   {
     "kullaniciId": 1,
     "productIds": "10"
   }
   ```

3. **İkinci Ürün Ekleniyor (ID: 15):**
   ```json
   PUT /api/Basket/1
   {
     "id": 1,
     "kullaniciId": 1,
     "productIds": "10,15"
   }
   ```

4. **Üçüncü Ürün Ekleniyor (ID: 20):**
   ```json
   PUT /api/Basket/1
   {
     "id": 1,
     "kullaniciId": 1,
     "productIds": "10,15,20"
   }
   ```

5. **Bir Ürün Çıkarılıyor (ID: 15):**
   ```json
   PUT /api/Basket/1
   {
     "id": 1,
     "kullaniciId": 1,
     "productIds": "10,20"
   }
   ```

## 🔍 Debug ve Loglama

Tüm işlemler detaylı loglanır:

```
🛒 BasketViewModel: Kullanıcı 1 için ürün 10 ekleniyor...
📦 BasketViewModel: Mevcut sepet bulundu - ID: 1
📦 BasketViewModel: Mevcut ürünler: 7,8
📦 BasketViewModel: Güncellenmiş ürünler: 7,8,10
✅ BasketViewModel: Sepet güncellendi - Ürün eklendi
```

## ⚠️ Önemli Notlar

1. **Giriş Kontrolü:** Sepet işlemleri için kullanıcı girişi zorunludur
2. **Duplicate Kontrol:** Aynı ürün tekrar eklenmez, hata mesajı gösterilir
3. **Boş Sepet:** Son ürün çıkarıldığında sepet otomatik silinir
4. **String Format:** `productIds` her zaman virgülle ayrılmış string formatında saklanır
5. **State Management:** Provider kullanılarak reaktif UI güncellemeleri sağlanır

## 🚀 Gelecek Geliştirmeler

- [ ] Sepet öğesi miktarı yönetimi (quantity)
- [ ] Sepet toplam fiyat hesaplama
- [ ] Sepet senkronizasyonu (offline/online)
- [ ] Sepet geçmişi ve kaydetme
- [ ] Sepet paylaşma özelliği

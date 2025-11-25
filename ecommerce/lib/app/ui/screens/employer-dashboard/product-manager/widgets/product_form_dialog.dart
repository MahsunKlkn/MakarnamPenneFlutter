// lib/features/menu/presentation/widgets/product_form_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../data/models/Product.dart';
import '../../../../../data/models/Category.dart';

class ProductFormDialog extends StatefulWidget {
  final ProductModel? product;
  final List<CategoryModel> categories;
  final Function(ProductModel) onSave;

  const ProductFormDialog({
    super.key,
    this.product,
    required this.categories,
    required this.onSave,
  });

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _discountRateController;
  late TextEditingController _stockController;
  late TextEditingController _skuController;
  late int _selectedCategoryId;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    final product = widget.product;

    _nameController = TextEditingController(text: product?.name ?? '');
    _descriptionController = TextEditingController(
      text: product?.description ?? '',
    );
    _priceController = TextEditingController(
      text: product?.price.toString() ?? '0.0',
    );
    _discountRateController = TextEditingController(
      text: product?.discountRate?.toString() ?? '0',
    );
    _stockController = TextEditingController(
      text: product?.stockQuantity.toString() ?? '0',
    );
    _skuController = TextEditingController(text: product?.sku ?? '');
    _selectedCategoryId =
        product?.categoryId ?? (widget.categories.isNotEmpty ? widget.categories.first.id : 0); // Kategori listesi boşsa diye kontrol eklendi

    _isActive = product?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _discountRateController.dispose();
    _stockController.dispose();
    _skuController.dispose();
    super.dispose();
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      
      // Varsayılan resim URL'i - API imageUrl'yi zorunlu tutuyor
      String defaultImageUrl = widget.product?.imageUrl ?? 
                               'https://via.placeholder.com/150?text=Product';
      
      final product = ProductModel(
        id: widget.product?.id ?? 0,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        price: double.parse(_priceController.text),
        discountRate: _discountRateController.text.isEmpty ||
                _discountRateController.text == '0'
            ? null
            : double.parse(_discountRateController.text),
        stockQuantity: int.parse(_stockController.text),
        sku: _skuController.text.trim().isEmpty
            ? null
            : _skuController.text.trim(),
        isActive: _isActive,
        imageUrl: defaultImageUrl,
        categoryId: _selectedCategoryId,
        dateCreated: widget.product?.dateCreated ?? now,
        dateUpdated: now,
      );

      widget.onSave(product);
      Navigator.of(context).pop();
    }
  }

  // --- RESPONSIVE WIDGET BUILDERLARI ---

  /// Fiyat ve İndirim alanlarını responsive olarak oluşturan metod
  Widget _buildResponsivePriceRow(bool isNarrow) {
    final priceField = TextFormField(
      controller: _priceController,
      decoration: const InputDecoration(
        labelText: 'Fiyat (TL) *',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.monetization_on),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Fiyat gereklidir';
        }
        if (double.tryParse(value) == null) {
          return 'Geçerli bir fiyat giriniz';
        }
        return null;
      },
    );

    final discountField = TextFormField(
      controller: _discountRateController,
      decoration: const InputDecoration(
        labelText: 'İndirim %',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.discount),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          final discount = double.tryParse(value);
          if (discount == null || discount < 0 || discount > 100) {
            return '0-100 arası';
          }
        }
        return null;
      },
    );

    if (isNarrow) {
      // Dar ekranlar için: Dikey (Column) düzen
      return Column(
        children: [
          priceField,
          const SizedBox(height: 16),
          discountField,
        ],
      );
    } else {
      // Geniş ekranlar için: Yatay (Row) düzen (orijinal hali)
      return Row(
        children: [
          Expanded(flex: 2, child: priceField),
          const SizedBox(width: 16),
          Expanded(flex: 1, child: discountField),
        ],
      );
    }
  }

  /// Stok ve SKU alanlarını responsive olarak oluşturan metod
  Widget _buildResponsiveStockRow(bool isNarrow) {
    final stockField = TextFormField(
      controller: _stockController,
      decoration: const InputDecoration(
        labelText: 'Stok Adedi *',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.inventory),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Stok adedi gereklidir';
        }
        return null;
      },
    );

    final skuField = TextFormField(
      controller: _skuController,
      decoration: const InputDecoration(
        labelText: 'SKU',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.qr_code),
      ),
    );

    if (isNarrow) {
      // Dar ekranlar için: Dikey (Column) düzen
      return Column(
        children: [
          stockField,
          const SizedBox(height: 16),
          skuField,
        ],
      );
    } else {
      // Geniş ekranlar için: Yatay (Row) düzen (orijinal hali)
      return Row(
        children: [
          Expanded(child: stockField),
          const SizedBox(width: 16),
          Expanded(child: skuField),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = (widget.product?.id ?? 0) > 0;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500), // Maksimum genişlik korunuyor
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            // LayoutBuilder ile mevcut genişliği alıyoruz
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                // 350px'den darsa, dar ekran olarak kabul et
                final bool isNarrow = constraints.maxWidth < 350;

                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isEdit ? Icons.edit : Icons.add_circle,
                            color: Colors.deepOrange,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            isEdit ? 'Ürün Düzenle' : 'Yeni Ürün Ekle',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Ürün Adı *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.shopping_bag),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Ürün adı gereklidir';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Açıklama',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.description),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<int>(
                        value: _selectedCategoryId,
                        decoration: const InputDecoration(
                          labelText: 'Kategori *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.category),
                        ),
                        items: widget.categories.map((category) {
                          return DropdownMenuItem(
                            value: category.id,
                            child: Text(category.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedCategoryId = value;
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value == 0) {
                            return 'Kategori seçiniz';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Responsive Fiyat/İndirim bölümü
                      _buildResponsivePriceRow(isNarrow),
                      
                      const SizedBox(height: 16),
                      
                      // Responsive Stok/SKU bölümü
                      _buildResponsiveStockRow(isNarrow),
                      
                      const SizedBox(height: 16),

                      // Durum Switch
                      SwitchListTile(
                        title: const Text('Ürün Durumu'),
                        subtitle: Text(_isActive ? 'Aktif' : 'Pasif'),
                        value: _isActive,
                        onChanged: (value) {
                          setState(() {
                            _isActive = value;
                          });
                        },
                        activeColor: Colors.green,
                        contentPadding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: 24),

                      // Butonlar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('İptal'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: _saveProduct,
                            label: Text(isEdit ? 'Güncelle' : 'Kaydet'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0), // Değeri buradan ayarlayabilirsiniz
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
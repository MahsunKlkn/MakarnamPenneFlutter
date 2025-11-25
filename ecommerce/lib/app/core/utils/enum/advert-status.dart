// lib/utils/ilan_durumlari.dart

enum IlanDurumu {
  silinmis(-1),
  pasif(0),
  aktif(1),
  onaylanmamis(3);

  final int value;
  const IlanDurumu(this.value);
}
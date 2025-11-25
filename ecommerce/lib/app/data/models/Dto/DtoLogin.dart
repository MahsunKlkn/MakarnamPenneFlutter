class LoginDtoModel {
  String? eposta;
  String? sifre;

  LoginDtoModel({
    required this.eposta,
    required this.sifre,
  });

  Map<String, dynamic> toJson() {
    return {
      'eposta': eposta,
      'sifre': sifre,
    };
  }

  factory LoginDtoModel.fromJson(Map<String, dynamic> json) {
    return LoginDtoModel(
      eposta: json['eposta'] as String?,
      sifre: json['sifre'] as String?,
    );
  }
}

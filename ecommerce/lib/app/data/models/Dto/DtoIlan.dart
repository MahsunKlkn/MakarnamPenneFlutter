class IlanListeDtoModel {
  final int id;
  final int state;
  final String city;
  final String district;
  final String jobTitle;
  final String? jobTitleEn;
  final String? jobTitleRu;
  final String? jobTitleDe;
  final String industry;
  final String? industryEn;
  final String? industryRu;
  final String? industryDe;
  final DateTime? publishDate;
  final DateTime? endingDate;
  final String company;
  final int sirket;
  final int pozisyon;
  final int sektor;
  final String workType;
  final String workModels;
  final int advertDateDay;
  final String logo;
  final int applicationCount;
  final int? workTypeId;
  final int? workModelsId;
  final bool isApplied;
  final bool isFavorite;
  final String degree;
  final int? maxExperience;
  final int? minExperience;
  final String? description;
  final String? tag;
  final String? totalRoom;
  final String? numberOfStars;
  final int? ulkeId;
  final String? daysRemaining;
  final int? daysRemainingInt;
  final DateTime? createdAt;
  final int? createdBy;
  final String? yabanciDil;
  final int? yabanciDilId;
  final String? dilSeviye;
  final int? dilSeviyeId;
  final DateTime? aktifSure;
  final String? createdByName;
  final String? detail;
  final String? detailEn;
  final String? detailRu;
  final String? detailDe;

  IlanListeDtoModel({
    required this.id,
    required this.state,
    required this.city,
    required this.district,
    required this.jobTitle,
    this.jobTitleEn,
    this.jobTitleRu,
    this.jobTitleDe,
    required this.industry,
    this.industryEn,
    this.industryRu,
    this.industryDe,
    this.publishDate,
    this.endingDate,
    required this.company,
    required this.sirket,
    required this.pozisyon,
    required this.sektor,
    required this.workType,
    required this.workModels,
    required this.advertDateDay,
    required this.logo,
    required this.applicationCount,
    this.workTypeId,
    this.workModelsId,
    required this.isApplied,
    required this.isFavorite,
    required this.degree,
    this.maxExperience,
    this.minExperience,
    this.description,
    this.tag,
    this.totalRoom,
    this.numberOfStars,
    this.ulkeId,
    this.daysRemaining,
    this.daysRemainingInt,
    this.createdAt,
    this.createdBy,
    this.yabanciDil,
    this.yabanciDilId,
    this.dilSeviye,
    this.dilSeviyeId,
    this.aktifSure,
    this.createdByName,
    this.detail,
    this.detailEn,
    this.detailRu,
    this.detailDe,
  });

  factory IlanListeDtoModel.fromJson(Map<String, dynamic> json) {
    // Helper function to safely parse dates
    DateTime? _parseDate(String? dateString) {
      if (dateString == null || dateString.isEmpty) return null;
      return DateTime.tryParse(dateString);
    }

    return IlanListeDtoModel(
      id: json['id'] ?? 0,
      state: json['state'] ?? 0,
      city: json['city'] ?? '',
      district: json['district'] ?? '',
      jobTitle: json['jobTitle'] ?? '',
      jobTitleEn: json['jobTitle_en'],
      jobTitleRu: json['jobTitle_ru'],
      jobTitleDe: json['jobTitle_de'],
      industry: json['industry'] ?? '',
      industryEn: json['industry_en'],
      industryRu: json['industry_ru'],
      industryDe: json['industry_de'],
      publishDate: _parseDate(json['publishDate']),
      endingDate: _parseDate(json['endingDate']),
      company: json['company'] ?? '',
      sirket: json['sirket'] ?? 0,
      pozisyon: json['pozisyon'] ?? 0,
      sektor: json['sektor'] ?? 0,
      workType: json['workType'] ?? '',
      workModels: json['workModels'] ?? '',
      advertDateDay: json['advertDateDay'] ?? 0,
      logo: json['logo'] ?? '',
      applicationCount: json['applicationCount'] ?? 0,
      workTypeId: json['workTypeId'],
      workModelsId: json['workModelsId'],
      isApplied: json['isApplied'] ?? false,
      isFavorite: json['isFavorite'] ?? false,
      degree: json['degree'] ?? '',
      maxExperience: json['maxExperience'],
      minExperience: json['minExperience'],
      description: json['description'],
      tag: json['tag'],
      totalRoom: json['totalRoom'],
      numberOfStars: json['numberOfStars'],
      ulkeId: json['ulkeId'],
      daysRemaining: json['daysRemaining'],
      daysRemainingInt: json['daysRemainingInt'],
      createdAt: _parseDate(json['created_at']),
      createdBy: json['created_by'],
      yabanciDil: json['yabanciDil'],
      yabanciDilId: json['yabanciDilId'],
      dilSeviye: json['dilSeviye'],
      dilSeviyeId: json['dilSeviyeId'],
      aktifSure: _parseDate(json['aktifSure']),
      createdByName: json['created_by_Name'],
      detail: json['detail'],
      detailEn: json['detail_en'],
      detailRu: json['detail_ru'],
      detailDe: json['detail_de'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'state': state,
      'city': city,
      'district': district,
      'jobTitle': jobTitle,
      'jobTitle_en': jobTitleEn,
      'jobTitle_ru': jobTitleRu,
      'jobTitle_de': jobTitleDe,
      'industry': industry,
      'industry_en': industryEn,
      'industry_ru': industryRu,
      'industry_de': industryDe,
      'publishDate': publishDate?.toIso8601String(),
      'endingDate': endingDate?.toIso8601String(),
      'company': company,
      'sirket': sirket,
      'pozisyon': pozisyon,
      'sektor': sektor,
      'workType': workType,
      'workModels': workModels,
      'advertDateDay': advertDateDay,
      'logo': logo,
      'applicationCount': applicationCount,
      'workTypeId': workTypeId,
      'workModelsId': workModelsId,
      'isApplied': isApplied,
      'isFavorite': isFavorite,
      'degree': degree,
      'maxExperience': maxExperience,
      'minExperience': minExperience,
      'description': description,
      'tag': tag,
      'totalRoom': totalRoom,
      'numberOfStars': numberOfStars,
      'ulkeId': ulkeId,
      'daysRemaining': daysRemaining,
      'daysRemainingInt': daysRemainingInt,
      'created_at': createdAt?.toIso8601String(),
      'created_by': createdBy,
      'yabanciDil': yabanciDil,
      'yabanciDilId': yabanciDilId,
      'dilSeviye': dilSeviye,
      'dilSeviyeId': dilSeviyeId,
      'aktifSure': aktifSure?.toIso8601String(),
      'created_by_Name': createdByName,
      'detail': detail,
      'detail_en': detailEn,
      'detail_ru': detailRu,
      'detail_de': detailDe,
    };
  }
}
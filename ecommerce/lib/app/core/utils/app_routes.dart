import 'package:flutter/material.dart';
import '../../ui/screens/home/index.dart';


/// Uygulama rotalarını yöneten sınıf.
/// Burası uygulamanın tüm navigasyon haritasıdır.
class AppRoutes {
  AppRoutes._(); // Nesne oluşturulmasını engeller.

  // =========================
  // === COMPANY DASHBOARD ===
  // =========================
  static const String companyDashboardHome = "/company-dashboard/dashboard";
  static const String companyProfile = "/company-dashboard/company-profile";
  static const String companyPostNewJob = "/company-dashboard/post-jobs";
  static const String allJobApplications = "/company-dashboard/all-applicants";
  static const String companyAllInternApplications = "/company-dashboard/all-applicants-intern";
  static const String generalApplicationCompany = "/company-dashboard/general-application-company";
  static const String generalApplicationCompanyCv = "/company-dashboard/general-application-company-cv";
  static const String companyAllAnnouncements = "/company-dashboard/all-announcements";
  static const String companyChangePassword = "/company-dashboard/change-password";
  static const String companyLogout = "/logout";

  // =========================
  // === CANDIDATE DASHBOARD ===
  // =========================
  static const String candidateDashboardHome = "/candidates-dashboard/dashboard";
  static const String candidateProfile = "/candidates-dashboard/my-resume";
  static const String candidateAppliedJobs = "/candidates-dashboard/applied-jobs";
  static const String candidateBookmarkedJobs = "/candidates-dashboard/short-listed-jobs";
  static const String candidateAllAnnouncements = "/candidates-dashboard/all-announcements";
  static const String candidateChangePassword = "/candidates-dashboard/change-password";
  static const String candidateLogout = "/logout";

  // =========================
  // === EMPLOYERS DASHBOARD ===
  // =========================
  // Statik Menü Rotaları
  static const String dashboardHome = "/employers-dashboard/dashboard";
  static const String employersPostNewJob = "/employers-dashboard/post-jobs";
  static const String manageJobs = "/employers-dashboard/manage-jobs";

  // Duyuru Yönetimi Rotaları
  static const String addAnnouncements = "/employers-dashboard/announcements";
  static const String allAnnouncements = "/employers-dashboard/all-announcements";
  static const String updateAnnouncements = "/employers-dashboard/update-announcements";

  // Başvurular Rotaları
  static const String alljobApplications = "/employers-dashboard/all-applicants";
  static const String employersAllInternApplications = "/employers-dashboard/all-applicants-intern";
  static const String generalApplicationAdmin = "/employers-dashboard/general-application-admin";
  static const String generalApplicationCvView = "/employers-dashboard/general-application-admin-cv";

  // Tanımlamalar Rotaları
  static const String departmentAndPosition = "/employers-dashboard/post-sector";
  static const String pageForeignLanguage = "/employers-dashboard/post-foreignLanguage";
  static const String createDrivingLicense = "/employers-dashboard/post-drivingLicense";

  // Ayarlar Rotaları
  static const String settingsHomepageView = "/employers-dashboard/settings-management/homepage-view";
  static const String settingsGeneralApplication = "/employers-dashboard/settings-management/general-application-settings";
  static const String settingsJobPostingCreation = "/employers-dashboard/settings-management/job-posting-creation-settings";
  static const String settingsJobPostingApplication = "/employers-dashboard/settings-management/job-posting-application-settings";
  static const String settingsCustomization = "/employers-dashboard/settings-management/customization-settings";

  // Diğer Rotalar
  static const String shortlistedResume = "/employers-dashboard/shortlisted-resumes";
  static const String shortlistedCandidate = "/employers-dashboard/shortlisted-candidates";
  static const String approvalManagement = "/employers-dashboard/approval-management";
  static const String postingApproval = "/employers-dashboard/posting-approval";
  static const String changePassword = "/employers-dashboard/change-password";
  static const String logout = "/logout";

  // Dinamik Menü Rotaları
  static const String allInfoCards = "/employers-dashboard/all-infocards";
  static const String addInfoCard = "/employers-dashboard/infocard";
  static const String addSponsor = "/employers-dashboard/sponsor";
  static const String allSponsors = "/employers-dashboard/all-sponsors";
  static const String allSponsorTypes = "/employers-dashboard/all-sponsorTypes";
  static const String addProject = "/employers-dashboard/project";
  static const String allProjects = "/employers-dashboard/all-projects";
  static const String postNews = "/employers-dashboard/post-news";
  static const String postNewsList = "/employers-dashboard/post-newslist";

  /// === Tüm Uygulama Rotaları ===
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      // =====================
      // === COMPANY ROUTES ===
      // =====================
      companyDashboardHome: (context) => const HomePage(),
      companyProfile: (context) => const Placeholder(),
      companyPostNewJob: (context) => const Placeholder(),
      allJobApplications: (context) => const Placeholder(),
      companyAllInternApplications: (context) => const Placeholder(),
      generalApplicationCompany: (context) => const Placeholder(),
      generalApplicationCompanyCv: (context) => const Placeholder(),
      companyAllAnnouncements: (context) => const Placeholder(),
      companyChangePassword: (context) => const Placeholder(),
      companyLogout: (context) => const Placeholder(),

      // =====================
      // === CANDIDATE ROUTES ===
      // =====================
      candidateDashboardHome: (context) => const HomePage(),
      candidateProfile: (context) => const Placeholder(),
      candidateAppliedJobs: (context) => const Placeholder(),
      candidateBookmarkedJobs: (context) => const Placeholder(),
      candidateAllAnnouncements: (context) => const Placeholder(),
      candidateChangePassword: (context) => const Placeholder(),
      

      // =====================
      // === EMPLOYERS ROUTES ===
      // =====================
      dashboardHome: (context) => const HomePage(),
      employersPostNewJob: (context) => const Placeholder(),
      manageJobs: (context) => const Placeholder(),
      addAnnouncements: (context) => const Placeholder(),
      allAnnouncements: (context) => const Placeholder(),
      updateAnnouncements: (context) => const Placeholder(),
      alljobApplications: (context) => const Placeholder(),
      employersAllInternApplications: (context) => const Placeholder(),
      generalApplicationAdmin: (context) => const Placeholder(),
      generalApplicationCvView: (context) => const Placeholder(),
      departmentAndPosition: (context) => const Placeholder(),
      pageForeignLanguage: (context) => const Placeholder(),
      createDrivingLicense: (context) => const Placeholder(),
      settingsHomepageView: (context) => const Placeholder(),
      settingsGeneralApplication: (context) => const Placeholder(),
      settingsJobPostingCreation: (context) => const Placeholder(),
      settingsJobPostingApplication: (context) => const Placeholder(),
      settingsCustomization: (context) => const Placeholder(),
      shortlistedResume: (context) => const Placeholder(),
      shortlistedCandidate: (context) => const Placeholder(),
      approvalManagement: (context) => const Placeholder(),
      postingApproval: (context) => const Placeholder(),
      changePassword: (context) => const Placeholder(),
      
      allInfoCards: (context) => const Placeholder(),
      addInfoCard: (context) => const Placeholder(),
      addSponsor: (context) => const Placeholder(),
      allSponsors: (context) => const Placeholder(),
      allSponsorTypes: (context) => const Placeholder(),
      addProject: (context) => const Placeholder(),
      allProjects: (context) => const Placeholder(),
      postNews: (context) => const Placeholder(),
      postNewsList: (context) => const Placeholder(),
    };
  }
}

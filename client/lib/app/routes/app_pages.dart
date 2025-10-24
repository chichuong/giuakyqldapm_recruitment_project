// lib/app/routes/app_pages.dart
import 'package:get/get.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/job_detail/bindings/job_detail_binding.dart';
import '../modules/job_detail/views/job_detail_view.dart';
import '../modules/recruiter_dashboard/bindings/recruiter_dashboard_binding.dart';
import '../modules/recruiter_dashboard/views/recruiter_dashboard_view.dart';
import '../modules/create_job/bindings/create_job_binding.dart';
import '../modules/create_job/views/create_job_view.dart';
import '../modules/applicant_list/bindings/applicant_list_binding.dart';
import '../modules/applicant_list/views/applicant_list_view.dart';
import '../modules/report/bindings/report_binding.dart';
import '../modules/report/views/report_view.dart';
import '../bindings/initial_binding.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/my_applications/bindings/my_applications_binding.dart';
import '../modules/my_applications/views/my_applications_view.dart';
import '../modules/saved_jobs/bindings/saved_jobs_binding.dart';
import '../modules/saved_jobs/views/saved_jobs_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/application_detail/bindings/application_detail_binding.dart';
import '../modules/application_detail/views/application_detail_view.dart';
import '../modules/company_profile/bindings/company_profile_binding.dart';
import '../modules/company_profile/views/company_profile_view.dart';
import '../modules/admin_dashboard/bindings/admin_dashboard_binding.dart';
import '../modules/admin_dashboard/views/admin_dashboard_view.dart';
import '../modules/admin_user_list/bindings/admin_user_list_binding.dart';
import '../modules/admin_user_list/views/admin_user_list_view.dart';
import '../modules/admin_company_list/bindings/admin_company_list_binding.dart';
import '../modules/admin_company_list/views/admin_company_list_view.dart';
import '../modules/admin_job_list/bindings/admin_job_list_binding.dart';
import '../modules/admin_job_list/views/admin_job_list_view.dart';
import '../modules/admin_application_list/bindings/admin_application_list_binding.dart';
import '../modules/admin_application_list/views/admin_application_list_view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(name: Routes.HOME, page: () => HomeView(), binding: HomeBinding()),

    GetPage(
      name: Routes.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),

    GetPage(
      name: Routes.JOB_DETAIL,
      page: () => JobDetailView(),
      binding: JobDetailBinding(),
    ),

    GetPage(
      name: Routes.RECRUITER_DASHBOARD,
      page: () => RecruiterDashboardView(),
      binding: RecruiterDashboardBinding(),
    ),

    GetPage(
      name: Routes.CREATE_JOB,
      page: () => CreateJobView(),
      binding: CreateJobBinding(),
    ),

    GetPage(
      name: Routes.APPLICANT_LIST,
      page: () => ApplicantListView(),
      binding: ApplicantListBinding(),
    ),

    GetPage(
      // Thêm GetPage mới
      name: Routes.REPORT,
      page: () => ReportView(),
      binding: ReportBinding(),
    ),

    GetPage(
      name: Routes.MY_APPLICATIONS,
      page: () => MyApplicationsView(),
      binding: MyApplicationsBinding(),
    ),

    GetPage(
      name: Routes.SAVED_JOBS,
      page: () => SavedJobsView(),
      binding: SavedJobsBinding(),
    ),

    GetPage(
      name: Routes.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),

    // Thêm GetPage cho ApplicationDetail
    GetPage(
      name: Routes.APPLICATION_DETAIL,
      page: () => ApplicationDetailView(),
      binding: ApplicationDetailBinding(),
    ),

    GetPage(
      name: Routes.COMPANY_PROFILE,
      page: () => CompanyProfileView(),
      binding: CompanyProfileBinding(),
    ),

    GetPage(
      name: _Paths.ADMIN_DASHBOARD,
      page: () => AdminDashboardView(),
      binding: AdminDashboardBinding(),
    ),

    GetPage(
      name: Routes.ADMIN_USER_LIST,
      page: () => AdminUserListView(),
      binding: AdminUserListBinding(),
    ),

    GetPage(
      name: Routes.ADMIN_COMPANY_LIST,
      page: () => AdminCompanyListView(),
      binding: AdminCompanyListBinding(),
    ),

    GetPage(
      name: Routes.ADMIN_JOB_LIST,
      page: () => AdminJobListView(),
      binding: AdminJobListBinding(),
    ),

    GetPage(
      name: Routes.ADMIN_APPLICATION_LIST,
      page: () => AdminApplicationListView(),
      binding: AdminApplicationListBinding(),
    ),
  ];
}

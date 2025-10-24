part of 'app_pages.dart';

abstract class Routes {
  static const LOGIN = _Paths.LOGIN;
  static const HOME = _Paths.HOME;
  static const REGISTER = _Paths.REGISTER;
  static const JOB_DETAIL = _Paths.JOB_DETAIL;
  static const RECRUITER_DASHBOARD = _Paths.RECRUITER_DASHBOARD;
  static const CREATE_JOB = _Paths.CREATE_JOB;
  static const APPLICANT_LIST = _Paths.APPLICANT_LIST;
  static const REPORT = _Paths.REPORT;
  static const MY_APPLICATIONS = _Paths.MY_APPLICATIONS;
  static const SAVED_JOBS = _Paths.SAVED_JOBS;
  static const PROFILE = _Paths.PROFILE;
  static const APPLICATION_DETAIL = _Paths.APPLICATION_DETAIL;
  static const COMPANY_PROFILE = _Paths.COMPANY_PROFILE;
  static const ADMIN_DASHBOARD = _Paths.ADMIN_DASHBOARD;
  static const ADMIN_USER_LIST = _Paths.ADMIN_USER_LIST;
  static const ADMIN_COMPANY_LIST = _Paths.ADMIN_COMPANY_LIST;
  static const ADMIN_JOB_LIST = _Paths.ADMIN_JOB_LIST;
  static const ADMIN_APPLICATION_LIST = _Paths.ADMIN_APPLICATION_LIST;
}

abstract class _Paths {
  static const LOGIN = '/login';
  static const HOME = '/home';
  static const REGISTER = '/register';
  static const JOB_DETAIL = '/job-detail';
  static const RECRUITER_DASHBOARD = '/recruiter-dashboard';
  static const CREATE_JOB = '/create-job';
  static const APPLICANT_LIST = '/applicant-list';
  static const REPORT = '/report';
  static const MY_APPLICATIONS = '/my-applications';
  static const SAVED_JOBS = '/saved-jobs';
  static const PROFILE = '/profile';
  static const APPLICATION_DETAIL = '/application-detail';
  static const COMPANY_PROFILE = '/company-profile';
  static const ADMIN_DASHBOARD = '/admin-dashboard';
  static const ADMIN_USER_LIST = '/admin-user-list';
  static const ADMIN_COMPANY_LIST = '/admin-company-list';
  static const ADMIN_JOB_LIST = '/admin-job-list';
  static const ADMIN_APPLICATION_LIST = '/admin-application-list';
}

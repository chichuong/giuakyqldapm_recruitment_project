// lib/app/data/constants/api_constants.dart
import 'dart:io';

class ApiConstants {
  // static String baseUrl = Platform.isAndroid
  //     ? 'http://10.0.2.2:3000'
  //     : 'http://localhost:3000';
  static String baseUrl = Platform.isAndroid
      ? 'http://192.168.1.4:3000'
      : 'http://localhost:3000';
  static String loginUrl = '$baseUrl/api/auth/login';
  static String registerUrl = '$baseUrl/api/auth/register';
  static String jobsUrl = '$baseUrl/api/jobs';
}

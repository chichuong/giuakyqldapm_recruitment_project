// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/bindings/initial_binding.dart';
import 'app/core/theme/app_theme.dart';
import 'app/routes/app_pages.dart';
import 'app/data/services/socket_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(SocketService());

  runApp(
    GetMaterialApp(
      title: "Recruitment Application",
      theme: AppTheme.theme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      getPages: AppPages.routes,
      home: SplashScreen(), // Bắt đầu bằng SplashScreen
      debugShowCheckedModeBanner: false,
    ),
  );
}

// Màn hình chờ đơn giản để chạy logic checkLoginStatus
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      InitialBinding.checkLoginStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

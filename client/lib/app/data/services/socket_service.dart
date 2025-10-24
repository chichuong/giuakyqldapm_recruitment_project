import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../constants/api_constants.dart';

class SocketService extends GetxService {
  io.Socket? socket;

  void connectAndListen(String userId) {
    if (socket != null && socket!.connected) {
      print("Socket đã được kết nối rồi.");
      return;
    }

    if (socket != null) {
      socket!.dispose();
    }

    socket = io.io(ApiConstants.baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket!.connect();

    socket!.onConnect((_) {
      debugPrint('Đã kết nối tới Socket Server');
      socket!.emit('registerUser', userId);
    });

    socket!.on('status_update', (data) {
      debugPrint('Nhận được cập nhật trạng thái: $data');
      Get.snackbar(
        data['title'] ?? 'Thông báo',
        data['body'] ?? '',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.black.withOpacity(0.5),
        colorText: Colors.white,
      );
    });

    socket!.onDisconnect((_) => debugPrint('Đã ngắt kết nối'));
  }

  void disconnect() {
    if (socket != null) {
      socket!.dispose();
      socket = null;
    }
  }
}

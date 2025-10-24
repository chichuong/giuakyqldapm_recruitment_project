// lib/app/modules/application_detail/views/application_detail_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/models/application_detail_model.dart'; // Ensure correct model import
import '../controllers/application_detail_controller.dart';

class ApplicationDetailView extends GetView<ApplicationDetailController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chi tiết Hồ sơ')),
      body: Obx(() {
        // **Show loading indicator while fetching**
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        // **Handle case where data loading failed**
        if (controller.applicationDetail.value == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Không thể tải chi tiết hồ sơ.',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () => controller.fetchDetails(),
                    icon: Icon(Icons.refresh),
                    label: Text("Thử lại"),
                  ),
                ],
              ),
            ),
          );
        }

        // **Data is available, build the UI**
        final ApplicationDetail detail = controller.applicationDetail.value!;

        return RefreshIndicator(
          onRefresh: () => controller.fetchDetails(),
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              // --- Job & Recruiter Info ---
              Text(detail.jobTitle, style: Get.textTheme.headlineSmall),
              SizedBox(height: 8),
              Text(
                "Tuyển bởi: ${detail.recruiterName}",
                style: Get.textTheme.titleMedium,
              ),
              Divider(height: 32),

              // --- Conditional Cards ---

              // **Card 1: Interview Response/Status**
              // Show this card ONLY if an interview has been scheduled (interviewId exists)
              if (detail.interviewId != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildInterviewResponseCard(detail),
                ),

              // **Card 2: Interview Details**
              // Show this card ONLY if the interview is CONFIRMED and details exist
              if (detail.interviewStatus == 'confirmed' &&
                  detail.interviewDate != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildInterviewInfoCard(detail),
                ),

              // **Card 3: Job Offer**
              // Show this card ONLY if an offer has been made (offerId exists)
              if (detail.status == 'passed_interview')
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Card(
                    color: Colors.lightGreen.shade50,
                    child: ListTile(
                      leading: Icon(
                        Icons.check_circle,
                        color: Colors.lightGreen.shade700,
                      ),
                      title: Text(
                        'Chúc mừng!',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Bạn đã vượt qua vòng phỏng vấn. Vui lòng chờ thư mời chính thức từ nhà tuyển dụng.',
                      ),
                    ),
                  ),
                ),
              if (detail.offerId != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildOfferCard(detail),
                ),

              // **Card 4: Rejection Info**
              // Show this card ONLY if the application status is 'rejected'
              if (detail.status == 'rejected')
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildRejectedCard(detail),
                ),

              // **Fallback/General Status (Optional)**
              // You could add a simple status card here if none of the above specific cards apply
              // e.g., if status is 'pending' or 'screening'
              if (detail.interviewId == null &&
                  detail.offerId == null &&
                  detail.status != 'rejected')
                Card(
                  child: ListTile(
                    leading: Icon(Icons.info_outline, color: Colors.blueGrey),
                    title: Text(
                      'Trạng thái hiện tại: ${detail.status.capitalizeFirst ?? detail.status}',
                    ),
                    subtitle: Text('Vui lòng đợi phản hồi từ nhà tuyển dụng.'),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  // --- Card Building Functions ---

  Widget _buildInterviewResponseCard(ApplicationDetail detail) {
    final deadline = detail.confirmationDeadline;
    final now = DateTime.now();
    bool isExpired = deadline != null && now.isAfter(deadline);

    // Case 1: Waiting for response & within deadline
    if (detail.interviewStatus == 'scheduled' && !isExpired) {
      return Card(
        color: Colors.yellow.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Nhà tuyển dụng đã gửi lịch phỏng vấn. Vui lòng phản hồi${deadline != null ? " trước hạn" : ""}.',
                textAlign: TextAlign.center,
              ),
              if (deadline != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Hạn chót: ${DateFormat('HH:mm dd/MM/yyyy').format(deadline.toLocal())}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => controller.respondToInterview('confirmed'),
                    icon: Icon(Icons.check_circle_outline),
                    label: Text('Xác nhận'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => controller.respondToInterview('declined'),
                    icon: Icon(Icons.cancel_outlined),
                    label: Text('Từ chối'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    // Case 2: Responded or Expired
    String statusText;
    IconData statusIcon;
    Color statusColor;

    if (detail.interviewStatus == 'confirmed') {
      statusText = 'Bạn đã xác nhận tham gia phỏng vấn.';
      statusIcon = Icons.check_circle;
      statusColor = Colors.green;
    } else if (detail.interviewStatus == 'declined') {
      statusText = (isExpired && detail.confirmationDeadline != null)
          ? 'Bạn đã không xác nhận trước hạn.'
          : 'Bạn đã từ chối lịch phỏng vấn.';
      statusIcon = Icons.cancel;
      statusColor = Colors.red;
    } else if (detail.interviewStatus == 'scheduled' && isExpired) {
      statusText = 'Đã quá hạn xác nhận lịch phỏng vấn.';
      statusIcon = Icons.timer_off_outlined;
      statusColor = Colors.grey;
    } else {
      // Should ideally not happen if logic is correct, but handles unexpected status
      statusText = 'Trạng thái lịch hẹn: ${detail.interviewStatus ?? 'N/A'}';
      statusIcon = Icons.info_outline;
      statusColor = Colors.blueGrey;
    }

    return Card(
      child: ListTile(
        leading: Icon(statusIcon, color: statusColor),
        title: Text(statusText, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildInterviewInfoCard(ApplicationDetail detail) {
    // Check if interviewDate is actually not null before formatting
    if (detail.interviewDate == null) return SizedBox.shrink();

    return Card(
      color: Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thông tin phỏng vấn',
              style: Get.textTheme.titleLarge?.copyWith(
                color: Colors.orange.shade800,
              ),
            ),
            SizedBox(height: 16),
            _buildDetailRow(
              Icons.calendar_today,
              'Ngày giờ: ${DateFormat('dd/MM/yyyy, HH:mm').format(detail.interviewDate!.toLocal())}',
            ), // Added ! null check
            _buildDetailRow(
              Icons.location_on,
              'Địa điểm: ${detail.interviewLocation ?? 'Chưa cập nhật'}',
            ),
            if (detail.interviewNotes != null &&
                detail.interviewNotes!.isNotEmpty) // Added ! null check
              _buildDetailRow(Icons.notes, 'Ghi chú: ${detail.interviewNotes}'),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferCard(ApplicationDetail detail) {
    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thư mời nhận việc',
              style: Get.textTheme.titleLarge?.copyWith(
                color: Colors.green.shade800,
              ),
            ),
            SizedBox(height: 16),
            Text(
              detail.offerLetterContent ?? 'Nội dung thư mời không có.',
              style: Get.textTheme.bodyMedium,
            ),
            SizedBox(height: 24),
            if (detail.offerStatus == 'sent')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => controller.respondToOffer('accepted'),
                    child: Text('Chấp nhận'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () => controller.respondToOffer('declined'),
                    child: Text('Từ chối'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
                ],
              )
            else
              Center(
                child: Chip(
                  label: Text(
                    detail.offerStatus == 'accepted'
                        ? 'Bạn đã chấp nhận'
                        : 'Bạn đã từ chối',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: detail.offerStatus == 'accepted'
                      ? Colors.green
                      : Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRejectedCard(ApplicationDetail detail) {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kết quả ứng tuyển',
              style: Get.textTheme.titleLarge?.copyWith(
                color: Colors.red.shade800,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Rất tiếc, hồ sơ của bạn chưa phù hợp với vị trí này.',
              style: Get.textTheme.bodyMedium,
            ),
            if (detail.rejectionReason != null &&
                detail.rejectionReason!.isNotEmpty) ...[
              // Added ! null check
              SizedBox(height: 8),
              Text(
                'Phản hồi từ NTD: ${detail.rejectionReason}',
                style: Get.textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: Get.textTheme.bodyMedium?.color ?? Colors.grey,
          ), // Added null check fallback
          SizedBox(width: 8),
          Expanded(child: Text(text, style: Get.textTheme.bodyLarge)),
        ],
      ),
    );
  }
}

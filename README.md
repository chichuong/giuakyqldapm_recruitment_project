# Ứng dụng Tuyển dụng Việc làm
(Mobile App — Flutter) + (Admin Web — Node.js / EJS)

Một dự án mẫu phục vụ quy trình tuyển dụng: Ứng viên, Nhà tuyển dụng và Quản trị viên. Bao gồm mobile app đa nền tảng (Flutter) và backend + admin web (Node.js + EJS). README này được viết lại để rõ ràng, dễ đọc và dễ triển khai.

---

✨ Tính năng chính
- Hệ thống 3 vai trò: Candidate (Ứng viên), Recruiter (Nhà tuyển dụng), Admin (Quản trị viên).
- Authentication: Đăng ký / Đăng nhập (API sử dụng JWT; Admin sử dụng session).
- Quản lý tin tuyển dụng: tạo, chỉnh sửa, đóng/mở, xóa.
- Ứng tuyển: upload CV (PDF/DOC/DOCX), nộp hồ sơ, quản lý trạng thái.
- Lịch phỏng vấn: lên lịch, deadline xác nhận, email mời, thông báo real-time qua Socket.IO.
- CV Online: thêm/sửa/xóa kinh nghiệm và học vấn.
- Thông báo real-time (Socket.IO) cho cả ứng viên và nhà tuyển dụng.
- Admin dashboard (EJS): thống kê, quản lý Users / Companies / Jobs / Applications.
- File upload (multer), gửi email (nodemailer), scheduled tasks (node-cron).

---

Mục lục
- [Yêu cầu hệ thống](#yêu-cầu-hệ-thống)
- [Kiến trúc dự án](#kiến-trúc-dự-án)
- [Công nghệ sử dụng](#công-nghệ-sử-dụng)
- [Cài đặt & chạy thử](#cài-đặt--chạy-thử)
  - [Backend (Server)](#backend-server)
  - [Frontend (Mobile App)](#frontend-mobile-app)
- [Cấu hình môi trường](#cấu-hình-môi-trường)
- [Database](#database)
- [Tài liệu API (Swagger)](#tài-liệu-api-swagger)
- [Triển khai & Gợi ý phát triển](#triển-khai--gợi-ý-phát-triển)
- [Đóng góp](#đóng-góp)
- [Giấy phép](#giấy-phép)
- [Liên hệ](#liên-hệ)

---

Yêu cầu hệ thống
- Node.js v18+ (hoặc v20+)
- MySQL (8+ khuyến nghị)
- Flutter SDK (v3.x, Dart v3.x)
- npm hoặc yarn
- (Tùy chọn) SMTP testing: Ethereal / Mailtrap / SMTP thật

Kiến trúc dự án (ví dụ)
- /server — Node.js + Express + EJS (Admin)
- /client — Flutter mobile app
- /docs — (tài liệu, SQL exports, seed scripts)

Công nghệ chính
- Backend: Node.js, Express, MySQL (mysql2), JWT, bcryptjs, multer, socket.io, nodemailer, node-cron, swagger-jsdoc
- Admin Web: EJS + Express (session-based)
- Mobile: Flutter, GetX, Dio, socket_io_client, shared_preferences, file_picker, image_picker

---

Cài đặt & chạy thử

Backend (Server)
1. Clone repo:
   ```bash
   git clone <your-repo-url>
   cd server
   ```
2. Cài dependencies:
   ```bash
   npm install
   ```
3. Thiết lập database:
   - Cài MySQL, tạo database (ví dụ: recruitment_db).
   - Export hoặc tạo file schema SQL (ví dụ: `database_schema.sql`) và chạy lên DB.
   - (Tùy chọn) Chạy `seed_data.sql` để thêm dữ liệu mẫu.
4. Tạo file .env
   - Copy `.env.example` → `.env` (nếu có) và điền các biến sau:
     - DB_HOST
     - DB_USER
     - DB_PASSWORD
     - DB_NAME
     - JWT_SECRET
     - SESSION_SECRET
     - SERVER_PORT
     - SMTP_HOST, SMTP_PORT, SMTP_USER, SMTP_PASS (nếu muốn test email)
5. Chạy server:
   ```bash
   npm start
   ```
   - Mặc định server sẽ trên http://localhost:3000 (hoặc port trong .env)
6. Tài nguyên:
   - API docs (Swagger): `http://localhost:3000/api-docs`
   - Admin login: `http://localhost:3000/api/admin/login` (route có thể khác — kiểm tra routes)

Frontend (Mobile App)
1. Cài Flutter SDK theo hướng dẫn chính thức và kiểm tra:
   ```bash
   flutter doctor
   ```
2. Mở terminal:
   ```bash
   cd client
   flutter pub get
   ```
3. Cấu hình baseUrl:
   - Mở: `lib/app/data/constants/api_constants.dart`
   - Chỉnh `baseUrl`:
     - Android emulator: `http://10.0.2.2:3000`
     - iOS simulator / web: `http://localhost:3000`
     - Thiết bị thật: `http://<YOUR_LAN_IP>:3000`

4. Chạy app:
   ```bash
   flutter run
   ```

Cấu hình môi trường (ví dụ .env)
- DB_HOST=localhost
- DB_USER=root
- DB_PASSWORD=yourpassword
- DB_NAME=recruitment_db
- JWT_SECRET=long_random_string
- SERVER_PORT=3000

Database
- File schema: export từ MySQL Workbench → `database_schema.sql` (nên lưu vào repo `/server/database/schema.sql`)
- Seed dữ liệu: `seed_data.sql` (tùy chọn)
- Các bảng cơ bản: users, companies, jobs, applications, interviews, notifications, files, ... (kiểm tra schema thực tế trong repo)

Tài liệu API
- Swagger UI (nếu đã cấu hình): `http://localhost:3000/api-docs`

Gợi ý phát triển & triển khai
- Dev: dùng `nodemon` cho backend để tự reload khi thay đổi.
- Prod: dùng PM2 / Docker / container để triển khai; bảo mật biến môi trường.
- Lưu trữ file: hiện lưu trên server (multer). Với production, cân nhắc dùng S3 / CDN.
- Email: test với Ethereal/Mailtrap; cấu hình SMTP thật khi deploy.
- Real-time: Socket.IO cho thông báo; kiểm tra CORS và origin khi triển khai.

Các vấn đề thường gặp
- Lỗi kết nối DB: kiểm tra `DB_HOST`, `DB_USER`, `DB_PASSWORD`, `DB_NAME` & quyền user.
- Mobile không gọi được API trên máy thật: dùng IP LAN thay vì localhost; kiểm tra firewall.
- Lỗi upload file: kiểm tra quyền thư mục lưu file và cấu hình multer.



Liên hệ
- Author: nhóm 5 (Lý Chí Chương, Lê Công Đạt) môn Quản lý dự án phần mền
- Repo: https://github.com/chichuong/giuakyqldapm_recruitment_project

---

-- =================================================================
-- SCRIPT TẠO DỮ LIỆU ẢO
-- Mật khẩu mặc định: 123456
-- Hash: $2b$10$SMLeqG7au9sPwB7D/E4WNufTA08T/98XAM9fM1.cahuNKqSgDTiOS
-- =================================================================

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE applications;
TRUNCATE TABLE saved_jobs;
TRUNCATE TABLE results;
TRUNCATE TABLE interviews;
TRUNCATE TABLE jobs;
TRUNCATE TABLE companies;
TRUNCATE TABLE educations;
TRUNCATE TABLE work_experiences;
TRUNCATE TABLE users;
SET FOREIGN_KEY_CHECKS = 1;

-- Sử dụng hash 
SET @local_hashed_password = '$2b$10$SMLeqG7au9sPwB7D/E4WNufTA08T/98XAM9fM1.cahuNKqSgDTiOS';

-- 1. TẠO TÀI KHOẢN NGƯỜI DÙNG (USERS)
INSERT INTO `users` (`id`, `email`, `password`, `full_name`, `phone_number`, `role`, `avatar_url`, `headline`, `bio`, `skills`) VALUES
(1, 'admin@app.com', @local_hashed_password, 'Quản Trị Viên', '0900000001', 'admin', 'https://i.pravatar.cc/150?u=admin', 'System Administrator', 'Quản lý toàn bộ hệ thống.', 'System, Database'),
-- Nhà tuyển dụng
(2, 'ntd.an@fpt.com', @local_hashed_password, 'Nguyễn Văn An', '0900000002', 'recruiter', 'https://i.pravatar.cc/150?u=recruiter1', 'Talent Acquisition @ FPT', 'Tìm kiếm tài năng cho FPT Software.', NULL),
(3, 'ntd.binh@vng.com', @local_hashed_password, 'Trần Ngọc Bình', '0900000003', 'recruiter', 'https://i.pravatar.cc/150?u=recruiter2', 'HR Manager @ VNG', 'Kết nối những con người xuất sắc.', NULL),
(4, 'ntd.mai@momo.com', @local_hashed_password, 'Lê Thị Mai', '0900000004', 'recruiter', 'https://i.pravatar.cc/150?u=recruiter3', 'Recruiter @ Momo', 'Tuyển dụng cho mảng Fintech.', NULL),
-- Ứng viên
(5, 'uv.chi@email.com', @local_hashed_password, 'Nguyễn Thùy Chi', '0911111111', 'candidate', 'https://i.pravatar.cc/150?u=candidate1', 'Flutter Developer', 'Có 2 năm kinh nghiệm phát triển ứng dụng di động đa nền tảng.', 'Flutter,Dart,GetX,Firebase'),
(6, 'uv.dung@email.com', @local_hashed_password, 'Phạm Tiến Dũng', '0922222222', 'candidate', 'https://i.pravatar.cc/150?u=candidate2', 'Backend Developer (NodeJS)', 'Chuyên xây dựng các hệ thống API hiệu suất cao.', 'NodeJS,Express,MySQL,Docker'),
(7, 'uv.hoa@email.com', @local_hashed_password, 'Hoàng Thị Hoa', '0933333333', 'candidate', 'https://i.pravatar.cc/150?u=candidate3', 'UI/UX Designer', 'Đam mê tạo ra những trải nghiệm người dùng đẹp và thân thiện.', 'Figma,Adobe XD,Prototyping'),
(8, 'uv.long@email.com', @local_hashed_password, 'Vũ Thành Long', '0944444444', 'candidate', 'https://i.pravatar.cc/150?u=candidate4', 'Product Manager', 'Có kinh nghiệm quản lý sản phẩm trong lĩnh vực E-commerce.', 'Agile,Scrum,Product Roadmap');

-- 2. TẠO CÁC CÔNG TY (COMPANIES)
INSERT INTO `companies` (`id`, `owner_id`, `name`, `logo_url`, `description`, `address`) VALUES
(1, 2, 'FPT Software', 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/11/FPT_logo_2010.svg/1200px-FPT_logo_2010.svg.png', 'FPT Software là công ty phần mềm toàn cầu của Việt Nam, cung cấp các dịch vụ và giải pháp chuyển đổi số hàng đầu thế giới.', 'Khu công nghệ cao, TP. Thủ Đức, TP. HCM'),
(2, 3, 'VNG Corporation', 'https://upload.wikimedia.org/wikipedia/commons/2/25/VNG_New_Logo.png', 'VNG là công ty công nghệ Việt Nam với các sản phẩm đa dạng từ Zalo, ZaloPay đến các tựa game đình đám.', '182 Lê Đại Hành, Phường 15, Quận 11, TP. HCM'),
(3, 4, 'Momo (M_Service)', 'https://upload.wikimedia.org/wikipedia/vi/f/fe/MoMo_Logo.png', 'Momo là ví điện tử số 1 Việt Nam, cung cấp các giải pháp thanh toán và dịch vụ tài chính toàn diện.', 'Tòa nhà Empress, 13-15 Hai Bà Trưng, P. Bến Nghé, Quận 1, TP.HCM');

-- 3. TẠO CÁC TIN TUYỂN DỤNG (JOBS)
INSERT INTO `jobs` (`id`, `recruiter_id`, `company_id`, `title`, `description`, `location`, `salary`, `application_limit`, `status`) VALUES
(1, 2, 1, 'Senior Flutter Developer', 'Chúng tôi đang tìm kiếm một Senior Flutter Developer có kinh nghiệm để tham gia vào các dự án quốc tế. Yêu cầu ít nhất 3 năm kinh nghiệm làm việc với Flutter.', 'Đà Nẵng', '2000-3000 USD', 10, 'open'),
(2, 2, 1, 'Junior Java Developer', 'Cơ hội cho các bạn sinh viên mới ra trường hoặc có dưới 1 năm kinh nghiệm. Được đào tạo bài bản trong môi trường chuyên nghiệp.', 'Hà Nội', 'Thỏa thuận', NULL, 'open'),
(3, 3, 2, 'Backend Engineer (Go/NodeJS)', 'Tham gia phát triển các hệ thống backend cho ZaloPay, yêu cầu hiệu năng cao và khả năng chịu tải lớn. Ưu tiên ứng viên có kinh nghiệm với Go.', 'TP. Hồ Chí Minh', 'Up to 2500 USD', 5, 'open'),
(4, 3, 2, 'Game Designer', 'Lên ý tưởng, thiết kế kịch bản và các tính năng cho các sản phẩm game mới của VNG.', 'TP. Hồ Chí Minh', 'Cạnh tranh', NULL, 'closed'),
(5, 4, 3, 'Senior Android Developer (Kotlin)', 'Phát triển các tính năng mới cho Siêu ứng dụng Momo. Yêu cầu thành thạo Kotlin, Coroutines, và kiến trúc MVVM.', 'TP. Hồ Chí Minh', 'Rất hấp dẫn', 1, 'open'); -- Job này chỉ tuyển 1 người

-- 4. TẠO HỒ SƠ ONLINE (KINH NGHIỆM, HỌC VẤN)
INSERT INTO `work_experiences` (`user_id`, `job_title`, `company_name`, `start_date`, `end_date`, `description`) VALUES
(5, 'Mobile Developer', 'ABC Corp', '2021-06-01', '2023-05-30', 'Phát triển ứng dụng XYZ bằng Flutter'),
(6, 'Web Developer', 'XYZ Inc.', '2020-01-15', NULL, 'Xây dựng API backend bằng NodeJS'),
(7, 'Graphic Designer', 'Design Studio', '2022-03-01', '2023-01-01', 'Thiết kế giao diện cho web và app');

INSERT INTO `educations` (`user_id`, `school`, `degree`, `field_of_study`, `start_date`, `end_date`) VALUES
(5, 'Đại học Bách Khoa HCM', 'Kỹ sư', 'Công nghệ Thông tin', '2017-09-01', '2021-06-01'),
(6, 'Đại học Khoa học Tự nhiên HCM', 'Cử nhân', 'Hệ thống Thông tin', '2016-09-01', '2020-06-01'),
(7, 'Đại học Kiến trúc HCM', 'Cử nhân', 'Thiết kế Đồ họa', '2018-09-01', '2022-06-01');

-- 5. TẠO TƯƠNG TÁC (ỨNG TUYỂN, LƯU VIỆC, PHỎNG VẤN)
INSERT INTO `applications` (`id`, `job_id`, `candidate_id`, `status`, `rejection_reason`, `cv_url`) VALUES
(1, 1, 5, 'interviewing', NULL, 'http://localhost:3000/public/cvs/cv-placeholder.pdf'), -- Chi nộp vào FPT
(2, 3, 5, 'rejected', 'Chưa đủ kinh nghiệm về Golang', 'http://localhost:3000/public/cvs/cv-placeholder.pdf'), -- Chi nộp vào VNG
(3, 3, 6, 'screening', NULL, 'http://localhost:3000/public/cvs/cv-placeholder.pdf'), -- Dũng nộp vào VNG
(4, 5, 8, 'pending', NULL, 'http://localhost:3000/public/cvs/cv-placeholder.pdf'), -- Long nộp vào Momo
(5, 5, 7, 'rejected', 'Hồ sơ chưa phù hợp', 'http://localhost:3000/public/cvs/cv-placeholder.pdf'), -- Hoa nộp vào Momo (Job này giới hạn 1)
(6, 1, 6, 'passed_interview', NULL, 'http://localhost:3000/public/cvs/cv-placeholder.pdf'); -- Dũng nộp FPT, đã pass PV

INSERT INTO `saved_jobs` (`user_id`, `job_id`) VALUES
(5, 2), 
(6, 1), 
(7, 4); 

INSERT INTO `interviews` (`application_id`, `interview_date`, `location`, `notes`, `status`, `confirmation_deadline`) VALUES
(1, '2025-10-28 09:00:00', 'Online via Google Meet', 'Phỏng vấn kỹ thuật', 'confirmed', '2025-10-26 09:00:00'), -- Chi đã confirm lịch FPT
(6, '2025-10-29 14:00:00', 'Văn phòng FPT', 'Phỏng vấn vòng cuối', 'scheduled', '2025-10-27 14:00:00'); -- Dũng đang chờ confirm

INSERT INTO `results` (`interview_id`, `result`, `comments`) VALUES
(2, 'pass', 'Kiến thức tốt, phù hợp vị trí.');

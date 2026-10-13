# Kiểm tra bản cập nhật 13/10/2026

- 68 kiểm tra API/lưu dữ liệu cũ và 34 kiểm tra API mới đạt (102 tổng cộng), kèm các khẳng định về phân chia theo thời gian và chống rò rỉ dữ liệu kiểm tra.
- Đã kiểm tra trình duyệt: khởi tạo, huấn luyện, hiển thị báo cáo/biểu đồ, danh bạ và thêm sân mô phỏng, gợi ý giờ, đặt Nambe demo, cọc 30% và vé xác nhận. Đã xem bố cục màn hình rộng và dạng menu thu gọn.
- Kiểm tra danh bạ, thêm sân không trùng, quyền xem vé, quyền nhận sân, cửa sổ nhận sân, ghi nhận không trùng và dữ liệu nhận sân được đọc lại.
- Thay đổi nhãn của 7 ngày kiểm tra không đổi mô hình hay thứ tự chọn ứng viên; chỉ đổi chỉ số kiểm tra.
- Python đã so sánh 3 mô hình trên kỳ validation, chọn rồi đánh giá kỳ test độc lập; JSON nhập vào API và kết quả suy luận khớp scikit-learn trong 1e-6.
- Frontend offline đã biên dịch thành công.
- Kiểm tra bằng dữ liệu độc lập, không chỉnh sửa database cá nhân của người dùng.

- Bản Vinext/Worker cũng biên dịch thành công ngày 13/10/2026.
- Bản phát hành cho người dùng là website local SQLite; chưa triển khai lên dịch vụ hosting.
- Các con số chất lượng mô hình được tính từ dữ liệu demo, không phải khảo sát nhu cầu thực tế ở Quy Nhơn.
- ZIP mới đã được giải nén độc lập: chạy bằng Node.js không có node_modules; khởi tạo SQLite, 4 sân demo Quy Nhơn, huấn luyện và tải HTML/CSS/JS đều đạt.

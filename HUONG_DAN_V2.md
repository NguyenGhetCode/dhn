# Cầu Lông Online · bản nâng cấp Quy Nhơn

## Chạy bản mới

Giải nén ZIP, mở thư mục `cau-long-online`, nhấp đúp `start.cmd`, vào http://127.0.0.1:3000. Cần Node.js 22.13 trở lên. Không cần XAMPP, npm install hoặc Internet để chạy các chức năng nội bộ; tra nguồn và chỉ đường cần Internet.

Nếu đang chạy bản cũ, dừng cửa sổ chạy bằng Ctrl+C trước. Giải nén bản mới vào thư mục riêng. Muốn giữ tài khoản và lịch sử: sao lưu toàn bộ thư mục `data` của bản cũ khi đã dừng, rồi sao chép `data` vào thư mục `cau-long-online` của bản mới. Đừng chỉ sao chép file SQLite khi server còn chạy vì dữ liệu có thể nằm trong WAL. Bản mới tự thêm bảng `checkins`, giữ dữ liệu cũ. Không nhập lại `schema.sql` vào database có sẵn.

Nếu không sao chép `data`, bản mới bắt đầu độc lập. Tạo tài khoản quản trị và giữ chọn **Tạo sân và lịch sử mẫu**. Có 4 sân demo tại các địa chỉ tham khảo Quy Nhơn và 35 ngày lịch sử giả lập. Mật khẩu tài khoản mẫu `khach@example.com` / `chusan@example.com` là `Demo@123456`. Email/mật khẩu quản trị do bạn chọn.

## Trình bày cho giáo viên trong 5 phút

1. **Sân tại Quy Nhơn:** tìm Hoa Lư, mở nguồn hoặc chỉ đường. Các địa điểm là dữ liệu tham khảo từ web, không có hợp đồng hay kết nối lịch với sân thật. Quản trị có nút thêm 1 sân mô phỏng, không thêm trùng khi bấm nhiều lần.
2. **Tìm & đặt sân:** chọn ngày tương lai, sân, giờ, ghi chú. Bấm giữ chỗ để thấy vé với mã đơn, đếm ngược 15 phút và bước tiếp theo.
3. **Vé đặt sân:** thanh toán cọc mô phỏng 30%, thấy lời xác nhận và số tiền còn lại. Tải phiếu TXT, lưu lịch ICS có nhắc trước 30 phút, mở chỉ đường. Phiếu/lịch đã tải không tự cập nhật sau khi hủy; website giữ trạng thái chính thức trong ứng dụng.
4. **Quản lý:** xem lịch sân, mở vé khách và xác nhận nhận sân từ 30 phút trước giờ bắt đầu đến hết khung giờ. Khách không có quyền nhận sân thay người quản lý. Tổng quan có số đơn hôm nay, đơn chờ cọc và khoản còn phải thu mô phỏng.
5. **Dự báo nhu cầu:** quản trị bấm Huấn luyện & so sánh mô hình. Chọn ngày, xem giờ đông/vắng, biểu đồ, MAE và số đơn hiện tại. Mở phần giải thích để xem ứng viên và tải CSV thực tế/dự báo của kỳ kiểm tra.
6. **Gợi ý giờ chơi:** khách chọn ngày, ứng dụng xếp khung giờ theo dự báo thấp và lọc sân còn trống trong lịch hiện tại. Nếu chưa có mô hình, ứng dụng gợi ý theo số sân còn trống. Đặt sân luôn kiểm tra trùng ở SQL lần nữa.

## Học máy đã thay đổi thế nào?

- Đầu vào: thứ trong tuần, cuối tuần, giờ, bình phương giờ và buổi tối. Nhãn: tổng lượt đặt hợp lệ của hệ thống trong ngày/giờ. Điền 0 cho giờ không có đơn; không lấy đơn tương lai làm dữ liệu học.
- Cần ít nhất 28 ngày. Chia theo thời gian: phần đầu để học, 7 ngày tiếp theo để chọn mô hình, 7 ngày cuối chỉ để kiểm tra. Với 35 ngày demo: 21 ngày học, 7 ngày chọn, 7 ngày kiểm tra.
- Web so sánh trung bình theo giờ/cuối tuần, hồi quy tuyến tính có điều chuẩn và tổ hợp 16 cây hồi quy dùng mẫu bootstrap. Chọn MAE thấp nhất ở kỳ chọn mô hình; học lại trên toàn bộ dữ liệu trước kỳ kiểm tra; giữ kỳ kiểm tra ngoài quá trình chọn và học.
- Python so sánh Linear Regression, Random Forest và Gradient Boosting bằng quy trình thời gian tương tự. Xuất JSON để nhập vào web, kiểm tra kết quả suy luận JSON trùng với scikit-learn.
- Báo cáo hiển thị MAE, RMSE, R², mức cải thiện so với trung bình theo giờ/cuối tuần và CSV đối chiếu. Không đổi sai số thành “độ chính xác 99%”. Mô hình chưa tốt hơn baseline cũng được ghi rõ.
- Khoảng dự báo ± MAE chỉ là khoảng tham khảo, không phải khoảng tin cậy. Dự báo giới hạn theo công suất đang mở; số đơn hiện tại hiển thị riêng, không cộng chồng lên dự báo.
- Đây là nhu cầu đã được phục vụ qua lịch đặt, không đo người muốn đặt khi hết sân. Chưa có dữ liệu thời tiết, sự kiện, lịch sử thay đổi số sân hoặc giá. Demo không chứng minh nhu cầu thực tế hay hiệu quả kinh doanh.

Tài liệu phương pháp: https://scikit-learn.org/stable/modules/cross_validation.html#cross-validation-of-time-series-data

## Địa điểm tham khảo

Nguồn tra cứu 13/10/2026: https://shopvnb.com/san-cau-long-quy-nhon.html

| Địa điểm | Tuyến đường / địa chỉ để tra bản đồ |
|---|---|
| Tân Tiến Thắng | 131 Tây Sơn, khu vực Quy Nhơn |
| Nambe Badminton | 57 Hoa Lư, khu vực Quy Nhơn |
| Bệnh viện Quân y 13 | 54 An Dương Vương, khu vực Quy Nhơn |
| Quân Đội Quy Nhơn | 48 Nguyễn Thị Định, khu vực Quy Nhơn |
| CLB Công an / Hà Huy Tập | 59 Hà Huy Tập, khu vực Quy Nhơn |

Dùng tên đường và khu vực Quy Nhơn để hỗ trợ tìm địa điểm trong Bình Định cũ, không khẳng định địa giới phường hiện tại. Giá/giờ tham khảo có thể thay đổi. Các sân được nhập vào ứng dụng mang nhãn demo: 1 sân, giá 80.000 đ và giờ 06–22 để thử; không đại diện cho số sân, bảng giá hoặc lịch thực của cơ sở. Dữ liệu khởi tạo cũng là demo. Muốn vận hành thật cần chủ sân cung cấp, xác nhận thông tin và lịch.

## SQL và API bổ sung

SQLite ở `data/cau-long.sqlite`; SQL tạo bảng ở `database/schema.sql`. Migration mới `drizzle/0002_schema.sql` tạo bảng nhận sân `checkins` liên kết với đơn đặt và người quản lý. Bộ tài khoản, giá, thanh toán, phân quyền, chống trùng, hết hạn và thống kê cũ tiếp tục hoạt động.

- `GET /api/venues`: danh bạ công khai.
- `POST /api/venues`: quản trị thêm sân mô phỏng theo `venueId`.
- `GET /api/bookings/:id`: vé theo quyền khách/chủ sân/quản trị.
- `POST /api/bookings/:id/checkin`: người quản lý ghi nhận khách đến, có kiểm tra thời gian, quyền và trạng thái.
- `GET /api/forecast`: thêm tình trạng dữ liệu, khoảng tham khảo, số đơn hiện tại và báo cáo mô hình.

Thanh toán vẫn là mô phỏng. Website chạy trên máy; chưa phải dịch vụ đặt sân trực tiếp cho các cơ sở hoặc bản triển khai công khai.

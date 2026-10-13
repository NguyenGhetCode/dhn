# Bản cập nhật 13/10/2026

Đọc `HUONG_DAN_V2.md` để cập nhật, giữ dữ liệu cũ và trình bày các chức năng mới.

# Cầu Lông Online

Website quản lý đặt sân cầu lông có cơ sở dữ liệu SQL và dự báo nhu cầu, xây dựng theo tài liệu đề tài của nhóm.

## Chạy nhanh trên máy

1. Cài Node.js từ 22.13 trở lên (khuyến nghị Node 24).
2. Giải nén bộ mã nguồn.
3. Mở `start.cmd` trên Windows, hoặc chạy `node local/server.mjs` trong thư mục dự án.
4. Mở **http://127.0.0.1:3000**.
5. Ở lần đầu, nhập email và mật khẩu quản trị ít nhất 10 ký tự. Có thể bật tạo dữ liệu minh họa.

**Không cần npm install, MySQL hoặc kết nối Internet để chạy bản local đã đóng gói.** Giao diện React đã được biên dịch trong `local/www`; Backend dùng các thư viện có sẵn trong Node.js. Dữ liệu được lưu tại `data/cau-long.sqlite` và tự động tạo từ các migration SQL. Server local chỉ lắng nghe trên máy của bạn.

Muốn đổi cổng: đặt biến `PORT` trước khi chạy. Muốn đổi vị trí dữ liệu: đặt `DATABASE_PATH` thành đường dẫn tuyệt đối tới tệp SQLite. Tắt server trước khi sao lưu thư mục `data` để bao gồm dữ liệu đã ghi; không xóa thư mục này nếu muốn giữ tài khoản và lịch đặt.

## Tài khoản mẫu

Chỉ được tạo khi chọn dữ liệu minh họa ở màn hình khởi tạo.

| Vai trò | Email | Mật khẩu |
|---|---|---|
| Quản trị viên | Do bạn nhập khi khởi tạo | Do bạn tự đặt |
| Chủ sân | chusan@example.com | Demo@123456 |
| Khách hàng | khach@example.com | Demo@123456 |

Dữ liệu mẫu gồm bốn sân và 35 ngày lịch sử được sinh để minh họa. Các màn hình thống kê và dự báo hiển thị nhãn dữ liệu minh họa. Tài khoản dùng email example.com, hệ thống không gửi email.

## Chức năng đã triển khai

- Đăng ký, đăng nhập, đăng xuất, cập nhật hồ sơ, đổi mật khẩu.
- Ba vai trò khách hàng, chủ sân, quản trị viên; khóa tài khoản và thay đổi quyền.
- Tìm sân theo tên hoặc địa chỉ, ngày và khung giờ còn trống.
- Chi tiết sân, giá cơ bản, lịch trống và giờ hoạt động.
- Đặt một sân trong một khung giờ một tiếng; ràng buộc SQL chống đặt trùng.
- Giữ chỗ 15 phút, cọc tối thiểu 30% hoặc thanh toán đủ, trả phần còn lại.
- Thanh toán thành công hoặc thất bại mô phỏng; mã giao dịch bảo vệ khi gửi lại.
- Hủy trước giờ chơi tối thiểu hai tiếng; đánh dấu hoàn tiền mô phỏng và giải phóng lịch.
- Lịch đặt cá nhân, lịch sử giao dịch, lịch quản lý sân theo ngày.
- Thêm, sửa, ngừng sân; giờ mở/đóng trong khoảng 06:00–22:00; giá riêng theo khung giờ.
- Khách hàng của chủ sân, quản lý toàn bộ tài khoản dành cho quản trị viên.
- Thống kê lượt đặt, tiền thanh toán, khung giờ, sân và tỷ lệ lấp đầy tham khảo; xuất CSV.
- So sánh 3 ứng viên trên web bằng tập chọn theo thời gian; báo cáo MAE, RMSE, R², baseline, gợi ý giờ và CSV đối chiếu.
- Xuất tập dữ liệu; nhập mô hình JSON được huấn luyện từ Python.
- Nhật ký thao tác quản lý, băm mật khẩu PBKDF2, session HttpOnly, kiểm tra Origin và giới hạn thử đăng nhập.

**Thanh toán trong dự án là mô phỏng và không thu tiền thật.** Chưa tích hợp tài khoản merchant của VNPay/MoMo hoặc ngân hàng. Để thu tiền thật cần cấu hình cổng thanh toán, xác thực webhook, đối chiếu số tiền và bổ sung quy trình hoàn tiền thật. Không dùng endpoint thanh toán mô phỏng làm bằng chứng thanh toán thật.

## Quy tắc nghiệp vụ mẫu

- Mỗi đơn đặt một sân, một ngày và một khung giờ; đặt tối đa trước 90 ngày.
- Sân chỉ nhận lịch trong giờ hoạt động và khi trạng thái là Hoạt động.
- Đơn `pending` giữ chỗ 15 phút. Bản local có tác vụ mỗi phút; bản hosted dọn đơn hết hạn khi truy vấn lịch và xử lý nghiệp vụ, nên việc chọn sân vẫn kiểm tra hạn giữ chỗ trước khi đặt.
- Tiền cọc lần đầu phải ít nhất 30% tổng tiền. Giao dịch thành công đầu tiên xác nhận đơn; phần còn lại được trả sau.
- Sau giờ kết thúc, đơn đã xác nhận được chuyển Hoàn thành khi hệ thống xử lý lịch. Hoàn thành chỉ nói về lịch chơi; số tiền còn thiếu được giữ riêng.
- Đơn đã hủy hoặc hết hạn không khóa lịch sân. Đơn đã hoàn thành vẫn giữ lịch lịch sử.
- Đổi giá chỉ ảnh hưởng đơn mới. Ngừng sân hoặc thu hẹp giờ hoạt động bị từ chối nếu có đơn chưa xử lý bị ảnh hưởng.
- Giữ các tài khoản, sân và giao dịch đã phát sinh; ngừng/khóa thay vì xóa lịch sử.
- Chủ sân chỉ quản lý sân thuộc tài khoản; khách chỉ xem và hủy đơn của mình. Quản trị viên quản lý toàn bộ.

Các thời hạn trên là phương án mẫu vì tài liệu chưa chốt chính sách cụ thể. Khung giờ trong bản này chia thành các giờ cố định; chưa có đặt nhiều giờ trong một đơn, nhiều cơ sở theo tổ chức hoặc nhiều chủ cùng quản lý một sân.

## Cơ sở dữ liệu SQL

Đây là **SQLite SQL** ở bản local và **Cloudflare D1 SQL** ở bản hosted, không phải MySQL. Hai bản sử dụng cùng logic và cùng migration. Tài liệu gốc đề xuất MySQL nhưng chưa chốt công nghệ; lựa chọn này giúp chạy thử trên máy mà không phải cài thêm máy chủ dữ liệu. Nếu môn học bắt buộc MySQL, cần thay bộ kết nối dữ liệu và chuyển cú pháp migration trước khi nộp.

- `database/schema.sql`: bản SQL tổng hợp để đọc và trình bày.
- `drizzle/*.sql`: migration thực tế, được áp dụng theo thứ tự.
- `db/schema.ts`: mô tả cấu trúc và quan hệ bằng Drizzle.
- `database/design.md`: giải thích bảng, quan hệ và ràng buộc.

Các bảng gồm `users`, `sessions`, `courts`, `slots`, `prices`, `bookings`, `payments`, `models`, `audit_logs`, `settings`, `auth_attempts`.

Chỉ mục duy nhất có điều kiện trên `court_id, play_date, slot_id` bảo vệ lịch đang giữ chỗ, đã xác nhận và đã hoàn thành. Các câu truy vấn nhận dữ liệu người dùng bằng tham số, không ghép trực tiếp giá trị vào SQL. Giao dịch thanh toán sử dụng batch nguyên tử để ghi nhận giao dịch và cập nhật đơn cùng lúc.

## Học máy

Đơn vị dự báo là **toàn bộ sân trong một ngày và một khung giờ**. Mỗi sân đơn lẻ chỉ có tối đa một lượt đặt hợp lệ ở một ngày và giờ. Dữ liệu đầu vào gồm thứ trong tuần, cuối tuần, giờ, giờ bình phương và cờ buổi tối. Biến mục tiêu đếm đơn đã xác nhận/hoàn thành; các ngày và giờ không có đơn được bổ sung số 0.

Cần ít nhất 28 ngày: phần đầu để học, 7 ngày tiếp theo chọn mô hình và 7 ngày cuối kiểm tra độc lập. Web so sánh trung bình theo giờ/cuối tuần, hồi quy tuyến tính có điều chuẩn và tổ hợp 16 cây hồi quy; chọn bằng MAE ở kỳ chọn rồi học lại trên dữ liệu trước kỳ kiểm tra. Dự báo được giới hạn trong khoảng từ 0 đến số sân hiện hoạt động ở khung giờ đó. Chỉ số đánh giá tính trên dự đoán chưa giới hạn trên theo năng lực, nhưng có giới hạn dưới ở 0.

So sánh ba mô hình bằng Python:

```text
python -m venv .venv
.venv\Scripts\activate
pip install -r ml/requirements.txt
python ml/train.py dataset.json --out model.json
```

Trên macOS/Linux dùng `source .venv/bin/activate`. Lấy `dataset.json` từ nút **Xuất dữ liệu** trong trang Dự báo. Chương trình so sánh Linear Regression, Random Forest Regressor và Gradient Boosting Regressor, chọn MAE thấp nhất trên kỳ chọn mô hình riêng và xuất mô hình cùng chỉ số của kỳ kiểm tra độc lập. Nút **Nhập mô hình** tải `model.json` lên cơ sở dữ liệu. Chỉ quản trị viên được xuất dữ liệu, huấn luyện và nhập mô hình.

Bản JSON lưu cấu trúc cây hoặc hệ số, không dùng pickle; chương trình kiểm tra dự đoán từ JSON khớp với scikit-learn trước khi xuất. Bản mới đã tách học, chọn và kiểm tra theo thời gian; dữ liệu kiểm tra không tham gia chọn hoặc học mô hình. Báo cáo baseline và CSV đối chiếu đi kèm.

Nếu không có mô hình, đặt sân vẫn hoạt động bình thường. Dự báo không thay thế truy vấn lịch trống. Dữ liệu minh họa không được dùng để kết luận về hiệu quả thực tế. Lịch sử giờ mở cửa, số sân hoạt động và các sự kiện chưa được mô hình hóa; tỷ lệ lấp đầy dùng năng lực hiện tại nên là chỉ số tham khảo khi năng lực thay đổi.

## Cấu trúc mã nguồn

```text
app/page.tsx                 Giao diện React tiếng Việt
app/theme.css               Kiểu dáng và bố cục điện thoại
app/api/[...path]/route.ts   API cho bản hosted
lib/api.js                  Xử lý nghiệp vụ dùng chung
db/schema.ts                Cấu trúc dữ liệu
drizzle/                    Migration và metadata
local/sqlite.mjs            Bộ kết nối SQLite
local/server.mjs            Máy chủ local
local/build-client.mjs      Biên dịch frontend offline
local/www/                  Giao diện đã biên dịch
ml/train.py                 So sánh và xuất mô hình học máy
tests/integration.mjs       Kiểm tra API và dữ liệu
```

## Phát triển và kiểm tra

Nếu muốn chỉnh sửa và biên dịch lại giao diện, cài thư viện rồi chạy:

```text
npm ci
npm run build:local
npm run test:local
npm run start:local
```

Kiểm tra tích hợp tạo một cơ sở dữ liệu thử riêng trong `tests/tmp`, không sửa dữ liệu đang sử dụng. Khi chỉnh cấu trúc bảng, chạy `npm run db:generate`; không sửa các migration đã áp dụng. Công cụ sinh SQL dùng API chính thức Drizzle Kit và giữ snapshot/journal.

Cho bản hosted Vinext: `npm run build` tạo Worker và tài nguyên trong `dist`. Cấu hình `.openai/hosting.json` khai báo D1 binding `DB`. Migration hosted được nền tảng áp dụng khi triển khai. Dữ liệu local và hosted độc lập; không tự đồng bộ với nhau.

## Các API chính

| API | Chức năng |
|---|---|
| POST `/api/bootstrap` | Khởi tạo một lần; local hoặc chủ website đã đăng nhập nền tảng |
| POST `/api/auth/register`, `/api/auth/login`, `/api/auth/logout` | Tài khoản và phiên đăng nhập |
| GET `/api/auth/me` | Thông tin tài khoản hiện tại |
| PUT `/api/profile` | Cập nhật hồ sơ và mật khẩu |
| GET `/api/courts?date=YYYY-MM-DD`, `/api/slots` | Sân, giá, lịch đã chiếm và khung giờ |
| GET/POST `/api/bookings` | Xem và tạo đơn; `mine=1` lấy lịch cá nhân |
| POST `/api/bookings/{id}/cancel` | Hủy đơn đủ điều kiện |
| GET/POST `/api/payments` | Xem và ghi giao dịch mô phỏng |
| GET/POST `/api/admin/courts`, PUT `/api/admin/courts/{id}` | Quản lý sân |
| GET/PUT `/api/admin/prices` | Giá từng sân và khung giờ |
| GET `/api/admin/users`, PUT `/api/admin/users/{id}` | Tài khoản và phân quyền |
| GET `/api/stats?from=YYYY-MM-DD&to=YYYY-MM-DD` | Thống kê theo kỳ |
| GET/POST `/api/forecast` | Dự báo và huấn luyện trên web |
| GET `/api/dataset`, POST `/api/models` | Xuất dữ liệu và nhập mô hình |
| GET `/api/admin/audit` | Nhật ký cho quản trị viên |

## Điều kiện trước khi vận hành với khách thật

Cần bỏ tài khoản mẫu, đổi mật khẩu, chốt điều khoản hủy/cọc, tích hợp thanh toán thật, sao lưu dữ liệu và triển khai HTTPS. Chưa có chức năng gửi email/SMS, quên mật khẩu qua email, xác minh email, tải ảnh sân hoặc thông báo đẩy. Đây là bộ mã hoàn chỉnh để chạy và trình bày các nghiệp vụ chính của đề tài, với các phần ngoài phạm vi được nêu rõ.

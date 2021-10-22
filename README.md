# HỢP NGỮ MIPS - HANGMAN

## Mô tả các hàm
### a) Hàm nhập tên: (Nhập tên người chơi và kiểm tra tính hợp lệ)
- Người chơi được yêu cầu nhập tên và tên được quy định bao gồm các chữ cái in hoa, in thường hoặc kí tự số (A-Z, a-z, 0-9), không có các kí tự đặc biệt
### b) Hàm hiện từ ngẫu nhiên từ đề thi:
- Đọc tập tin “dethi.txt” đã lưu trữ, thực hiện lấy 1 từ ngẫu nhiên và hiện ra màn hình dạng
### c) Hàm dự đoán:
- Cho người chơi dự đoán 7 lần, mỗi lần sẽ lựa chọn
+ “Đoán ký tự” :
- Sau mỗi lần đoán sai, màn hình sẽ hiển thị hình ảnh là trạng thái của người chơi tùy vào số lần đoán sai.
+ “Đoán đáp án”:
- Sau đó tính điểm cho mỗi trường hợp
### d) Hàm cho trường hợp trả lời đúng từ:
- Lấy ngẫu nhiên từ mới và tiếp tục lại trò chơi
### e) Hàm cho trường hợp sai từ :
- Nếu thua, lưu kết quả vào file. Xuất thông tin: Tên người chơi - Tổng số điểm - Số lượt chiến thắng.
- Cho người chơi lựa chọn: 1) Tiếp tục chơi (không cần nhập lại tên) hoặc 2) Thoát trò chơi
### f) Hàm hiển thị 10 người chơi điểm cao nhất:
- Đọc file “nguoichoi.txt”
- Cắt thông tin của từng người chơi. Sau đó cắt điểm của người đó và lưu vào mảng chứa điểm
- Tạo mảng chứa số thứ tự từ 0 đến số người chơi
- Sắp xếp mảng điểm theo thứ tự giảm dần, trong lúc đó hoán vị mảng chứa số thứ tự
- Dựa vào mảng số thứ tự sau khi sắp xếp, xuất ra màn hình vị trí của người chơi đó.


## Thành viên trong nhóm
- [@MyrtilleKim](https://github.com/MyrtilleKim): Lê Thiên Kim – 19126022 
- [@ThQuang21](https://github.com/ThQuang21): Ngô Thiên Quang – 19126031 
- [@vuhoanganh6401](https://github.com/vuhoanganh6401): Vũ Hoàng Anh – 19126039 
- [@thtngan](https://github.com/thtngan): Trần Hoàng Thảo Ngân – 19126055 
- [@DiDiPhan](https://github.com/DiDiPhan): Phan Tường Vy - 19126072

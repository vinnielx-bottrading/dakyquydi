# Dạ Ký

Website truyện ma dân gian kèm trang quản trị nội dung, phù hợp triển khai trên GitHub và Vercel.

## Chạy thử

Mở thư mục `dist` bằng một web server tĩnh. Nếu chưa cấu hình Supabase, trang công khai tự dùng ba truyện mẫu trong `dist/data/demo-stories.json`.

## Kết nối Supabase

1. Tạo một dự án Supabase.
2. Mở SQL Editor và chạy `supabase/schema.sql`.
3. Trong Authentication, tạo tài khoản quản trị bằng email và mật khẩu.
4. Lấy UUID của tài khoản, sau đó chạy:

```sql
insert into public.admins(user_id) values ('UUID_CUA_TAI_KHOAN');
```

5. Mở `dist/assets/js/config.js`, điền Project URL và anon key. Không sử dụng service role key ở frontend.
6. Đăng nhập tại `/admin.html` để thêm, sửa, xuất bản hoặc xóa truyện.

## Triển khai

- GitHub lưu toàn bộ mã nguồn.
- Vercel chọn thư mục dự án và nhận `dist` làm thư mục xuất bản.
- Nếu dùng GitHub Pages, xuất bản trực tiếp nội dung trong `dist`.

## Bảo mật

Row Level Security đã được bật. Người đọc chỉ thấy bài có trạng thái `published` và đã đến thời điểm xuất bản. Chỉ tài khoản nằm trong bảng `admins` mới quản lý được nội dung.

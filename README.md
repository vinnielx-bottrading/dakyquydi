# Dạ Ký — bản GitHub Ready

Đây là cấu trúc thư mục gốc của repository. `main` là tên nhánh GitHub, không phải một file hoặc thư mục. Hãy upload toàn bộ nội dung của thư mục này vào nhánh `main`.

## Cấu trúc

- `index.html`: trang chủ.
- `story.html`: trang đọc truyện.
- `admin.html`: trang quản trị.
- `assets/`: CSS, JavaScript và cấu hình kết nối.
- `data/`: ba truyện mẫu dùng khi chưa kết nối Supabase.
- `database.sql`: cấu trúc cơ sở dữ liệu và phân quyền.
- `vercel.json`: cấu hình để Vercel nhận website tĩnh.

## Deploy Vercel

1. Tạo repository GitHub mới.
2. Chọn **Add file → Upload files**.
3. Kéo toàn bộ file và thư mục trong gói này lên repository, rồi Commit vào nhánh `main`.
4. Vào Vercel → **Add New Project** → Import repository.
5. Framework Preset chọn **Other**; để trống Build Command và Output Directory.
6. Bấm **Deploy**.

## Kết nối Supabase

1. Tạo dự án Supabase và chạy toàn bộ `database.sql` trong SQL Editor.
2. Tạo tài khoản trong Authentication.
3. Chạy lệnh sau với UUID của tài khoản:

```sql
insert into public.admins(user_id) values ('UUID_CUA_TAI_KHOAN');
```

4. Điền Project URL và anon key vào `assets/js/config.js`.
5. Commit thay đổi lên GitHub; Vercel sẽ tự động deploy lại.

Không đưa `service_role key` vào website.

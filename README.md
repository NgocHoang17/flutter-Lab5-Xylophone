# Xylophone

Ứng dụng đàn Xylophone gồm bảy phím màu, phát âm thanh bằng audioplayers.

Dự án Flutter độc lập, dùng Flutter 3.38.6 / Dart 3.10.7.

## Chức năng

- Bảy phím tương ứng với các nốt Đô, Rê, Mi, Fa, Sol, La, Si.
- Phát các file WAV thực từ assets/audio/.
- Có hiệu ứng khi nhấn phím và thông báo khi phát âm thanh thất bại.

## Chạy và kiểm tra

```powershell
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```

Tài nguyên cần thiết đã có sẵn trong dự án. Đã kiểm tra bằng analyze, unit/widget test và build web.


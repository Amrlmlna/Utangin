# UTANGIN - Platform Pinjaman Pribadi Aman & Terpercaya

UTANGIN adalah platform mobile yang dirancang untuk mengelola pinjaman antar individu secara formal dan transparan, menghilangkan beban emosional dalam mengelola utang-piutang antar teman dan keluarga sambil menyediakan sistem pelacakan otomatis dan kewajiban hukum yang jelas.

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Java Development Kit (JDK) 11 or higher (JDK 17 recommended)
- Android Studio with Android SDK
- Git

### Java Configuration (Important)
This project has been updated to use Java 17 due to Gradle 8.12 requirements. If you're experiencing build errors, ensure you have JDK 17 installed:

1. Install JDK 17 from [Eclipse Adoptium](https://adoptium.net/)
2. Update the `org.gradle.java.home` path in `android/gradle.properties` if your installation path differs
3. Verify with `java -version` command in terminal

### Environment Setup
1. Clone this repository
2. Run `flutter pub get` to install dependencies
3. Create `.env` file based on `.env.example`
4. Ensure all required environment variables are set

### Running the Application
- For development: `flutter run`
- For release: `flutter run --release`

## Project Structure
- `lib/` - Main Flutter application code
- `android/` - Android-specific configuration
- `ios/` - iOS-specific configuration
- `test/` - Unit and integration tests

## API Integration
The application connects to the UTANGIN backend API. Ensure your backend is running before starting the mobile app.

## Core Features (MVP)
- **Onboarding & Verifikasi Identitas**: Registrasi pengguna dengan verifikasi KTP, selfie, nomor telepon, alamat, dan kontak darurat untuk membangun kepercayaan.
- **Pembuatan Perjanjian Utang**: Formulir detail pinjaman yang diisi bersama oleh pemberi dan penerima pinjaman termasuk jumlah, tanggal jatuh tempo, bunga, dan aturan pembayaran.
- **Konfirmasi QR Code**: Sistem tanda tangan digital menggunakan QR code unik yang dipindai oleh kedua belah pah untuk mengonfirmasi perjanjian.
- **Sistem Pengumpulan Otomatis**: Pengingat otomatis berdasarkan jatuh tempo dan metode eskalasi yang disetujui sebelumnya.
- **Dasbor Utang**: Tampilan komprehensif total pinjaman, total utang, riwayat aktif, terlambat, dan pembayaran.
- **Sistem Reputasi & Rating**: Sistem penilaian berdasarkan pembayaran tepat waktu untuk menilai kelayakan kredit.

## Tech Stack
- **Frontend**: Flutter (untuk cross-platform mobile app)
- **Backend**: Supabase (PostgreSQL, Auth, Storage) with Node.js API
- **Authentication**: Supabase Auth
- **QR Code**: flutter_qr plugin
- **Notifications**: Firebase Cloud Messaging (FCM)

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:
- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
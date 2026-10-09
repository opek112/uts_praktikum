# README UTS Praktikum Pemrograman Perangkat Bergerak

| | |
|---|---|
| Nama | Taufiq Hidayat |
| NIM | (isi NIM) |
| Aplikasi | Tugas Praktikum (pencatat tugas) |
| Tanggal | (isi tanggal ujian) |

---

## 1. Jawaban Teori


### Soal 1 - Daftar tugas dan UI responsif (KAD-1)
Aplikasi menyesuaikan jumlah kolom secara dinamis dengan memanfaatkan widget `LayoutBuilder` yang membaca batasan lebar layar (`constraints.maxWidth`). Di dalam `LayoutBuilder`, kita menggunakan `GridView.builder` dengan properti `crossAxisCount`.
Batas 700 px dipilih sebagai titik potong (*breakpoint*) standar yang membedakan tampilan layar telepon seluler (*mobile layout*) dengan layar tablet atau desktop (*wide layout*). Pada lebar kurang dari 700 px (seperti telepon 360 px), `crossAxisCount` bernilai 1 agar kartu tugas memenuhi lebar layar tanpa menyebabkan *overflow* horizontal. Pada lebar 700 px atau lebih, `crossAxisCount` bernilai 2 sehingga kartu tersusun rapi dalam dua kolom.

### Soal 2 - Form, validasi, dan navigasi (KAD-2)
Validasi form diimplementasikan menggunakan `GlobalKey<FormState>` dan fungsi `validator` pada setiap `TextFormField`. Validasi dilakukan dengan metode `.trim()` pada teks input (misalnya `_titleController.text.trim()`). Metode ini menghapus semua karakter spasi di awal dan akhir teks. Jika setelah di-*trim* teks bernilai kosong (`isEmpty`), maka input ditolak dengan pesan error validasi.
Pada alur **Simpan**, kode memeriksa validasi `_formKey.currentState!.validate()`. Jika valid, objek `Task` baru dirakit dan dikembalikan ke halaman sebelumnya melalui `Navigator.pop(context, newTask)`.
Pada alur **Batal**, halaman langsung ditutup menggunakan `Navigator.pop(context)` tanpa membawa parameter data apa pun (`null`), sehingga daftar tugas di halaman utama tidak mengalami perubahan.

### Soal 3 - State dan interaksi daftar (KAD-3)
Tampilan berubah secara otomatis setelah tugas ditambah atau statusnya diubah karena adanya mekanisme pemanggilan `setState()` atau `_loadTasks()`. Ketika tugas baru diterima dari form atau status *checkbox* dicentang, daftar tugas di memori/penyimpanan lokal diperbarui, lalu `_loadTasks()` memicu pembaruan state pada `FutureBuilder` untuk merefresh UI.
Angka ringkasan tugas (misalnya "2 dari 5 tugas selesai") dihasilkan secara dinamis dengan menghitung jumlah elemen di dalam list tugas yang bernilai `isDone == true` menggunakan ekspresi `tasks.where((t) => t.isDone).length`, dibandingkan dengan total panjang list `tasks.length`.

### Soal 4 - Operasi asynchronous dan state UI (KAD-4)
`FutureBuilder` menangani empat kondisi tampilan (*state*) berdasarkan nilai `AsyncSnapshot`:
1. **Loading**: Ditampilkan saat `snapshot.connectionState == ConnectionState.waiting`, berupa `CircularProgressIndicator`.
2. **Error**: Ditampilkan saat `snapshot.hasError` bernilai `true`, berupa pesan kesalahan beserta tombol "Coba Lagi".
3. **Empty**: Ditampilkan saat data selesai dimuat (`hasData`) namun list tugas kosong (`tasks.isEmpty`), berupa pesan informasi bahwa belum ada tugas.
4. **Data (Success)**: Ditampilkan saat data berhasil dimuat dan tidak kosong, berupa `GridView` daftar tugas.

Saat tombol **Coba Lagi** ditekan, fungsi `_loadTasks()` dipanggil kembali untuk memicu ulang eksekusi `Future` pada `FutureBuilder` sehingga proses pemuatan data diulang dari awal.

### Soal 5 - Penyimpanan lokal dan verifikasi (KAD-5)
Model `Task` memiliki dua fungsi untuk konversi data. `toJson()` mengubah objek
Dart menjadi Map, sedangkan `fromJson()` mengubah Map kembali menjadi objek
Dart. Pengubahan antara Map atau List dan String JSON dilakukan di
`TaskStorage` dengan `jsonEncode` dan `jsonDecode`.

Saat tugas ditambahkan, daftar tugas disimpan melalui method `save()` yang
bersifat asinkron. Setiap tugas diubah menjadi Map dengan `toJson()`, seluruh
daftar diubah menjadi satu String JSON dengan `jsonEncode`, lalu String itu
disimpan ke SharedPreferences. Semua data disimpan dalam satu key yang sama
agar `save`, `load`, dan `clear` selalu menunjuk ke tempat yang sama.

Saat aplikasi dibuka, method `load()` dipanggil dari `initState`. `load()`
membaca String JSON dari penyimpanan, mengubahnya menjadi List yang berisi Map
dengan `jsonDecode`, lalu mengubah setiap Map menjadi objek `Task` dengan
`fromJson()` agar datanya dapat dipahami dan dipakai oleh Dart. Hasilnya
dimasukkan ke daftar tugas dengan `setState`, sehingga tampilan dibangun ulang.

Jika data belum pernah disimpan, misalnya saat aplikasi dibuka pertama kali,
`load()` menghasilkan list kosong sehingga tampilan awal kosong. Jika bentuk
data tidak sesuai, misalnya hasil decode bukan List atau isinya bukan Map, maka
`load()` melempar pesan bahwa data tidak sesuai dan tampilan menampilkan state
error.

Untuk verifikasi, saya menjalankan aplikasi dengan perintah
`flutter run -d web-server --web-port=5000`, lalu menambahkan beberapa tugas
dengan status yang berbeda. Setelah itu aplikasi saya tutup dan dibuka kembali.
Hasilnya, tugas-tugas yang dibuat masih ada dengan status yang sama seperti
sebelumnya.

---

## 2. Cara Menjalankan Aplikasi

Prasyarat: Flutter SDK terpasang, (sebutkan perangkat/browser yang dipakai).

```sh
flutter pub get
flutter run -d web-server --web-port=5000
```

Lalu buka `http://localhost:5000` di browser. 
Port 5000 dipasang secara tetap agar URL dan asal penyimpanan Local Storage / SharedPreferences Web tidak berubah setiap kali aplikasi dijalankan ulang di browser Google Chrome

---

## 3. Status Acceptance Criteria

| Kriteria | Status | Cara menguji / catatan |
|---|---|---|
| A. Telepon 360 px tanpa overflow | Berhasil / Belum | |
| B. Tablet >= 700 px dua kolom | Berhasil / Belum | |
| C. Validasi judul dan mata kuliah | Berhasil / Belum | |
| D. Navigasi detail, Simpan, Batal | Berhasil / Belum | |
| E. Tambah dan ubah status langsung terlihat | Berhasil / Belum | |
| F. Loading, empty, data, error, Coba Lagi | Berhasil / Belum | |
| G. Data bertahan setelah aplikasi ditutup | Berhasil / Belum | |
| H. Verifikasi dan bukti | Berhasil / Belum | |

---

## 4. Ringkasan Satu Alur Kode

Alur yang dipilih: 
Menambah tugas baru hingga tersimpan dan muncul kembali saat aplikasi dibuka ulang.

1. User menekan tombol Tambah di lib/screens/task_list_screen.dart, memanggil _openForm().

2. Aplikasi berpindah ke lib/screens/task_form_screen.dart menggunakan Navigator.push.

3. User mengisi judul dan mata kuliah, lalu menekan tombol "Simpan". Fungsi _saveTask() memvalidasi input dengan .trim() agar spasi sebelum atau sesudah teks yang ditulis tidak terbaca.

4. Jika valid, objek Task dirakit dan dikembalikan ke halaman utama via Navigator.pop(context, newTask).

5. Di task_list_screen.dart, objek baru ditambahkan ke list currentTasks, lalu disimpan ke penyimpanan lokal via _repository.saveTasks(currentTasks).

6. TaskStorage.saveTasks() di lib/data/task_storage.dart mengubah list Task menjadi string JSON (jsonEncode) dan menyimpannya ke SharedPreferences dengan kunci 'tasks_key'.

7. _loadTasks() dipanggil untuk merefresh FutureBuilder sehingga tugas baru langsung tampil di UI.

## 5. Bukti Verifikasi

### Langkah uji yang dilakukan
1. Uji Responsif: Mengubah ukuran window browser dari 360 px hingga > 700 px. Hasil: Layout dinamis berubah dari 1 kolom menjadi 2 kolom.

2. Uji Validasi Form: Menginputkan "   " (hanya spasi) pada field judul. Hasil: Pesan "Judul tidak boleh kosong" muncul.

3. Uji Persistensi: Centang tugas dan tambah tugas baru, keluar dari browser dan menggunakan port yang sama untuk menjalankan aplikasi lagi. Hasil: Seluruh data dan status centang tetap bertahan.

4. Uji Simulasi Error: Mengaktifkan forceError pada menu simulasi lalu tekan Refresh. Hasil: Error state dan tombol "Coba Lagi" tampil dengan benar.

### Keluaran `flutter analyze`
```
Analyzing uts_362558302103_Taufiq_Hidayat...                             

warning - The value of the field '_memory' isn't used. Try removing the field, or
        using it - lib\data\task_storage.dart:15:21 - unused_field
warning - The value of the field '_memory' isn't used. Try removing the field, or
        using it - lib\data\task_storage.dart:15:21 - unused_field

2 issues found. (ran in 4.5s)
```
Catatan penyebab: Warning unused_field muncul karena variabel _memory merupakan kode bawaan (starter template) dari dosen pada task_storage.dart yang disiapkan untuk opsi penyimpanan sementara tetapi tidak dipergunakan karena aplikasi sepenuhnya menggunakan SharedPreferences. Sesuai instruksi ujian, kode bawaan starter tidak dihapus.

### Keluaran `flutter test`
```
00:07 +1: D:/dart/uts/uts_362558302103_Taufiq_Hidayat/test/widget_test.dart: Counter increments smoke test
══╡ EXCEPTION CAUGHT BY FLUTTER TEST FRAMEWORK ╞════════════════════════════════════════════════════
The following TestFailure was thrown running a test:
Expected: exactly one matching candidate
  Actual: _TextWidgetFinder:<Found "0": 0 [] text widgets with>
   Which: means none were found but one was expected
...
00:07 +2 -1: Some tests failed.
```
Catatan penyebab: Berkas test/widget_test.dart bawaan dari perintah flutter create adalah tes standar untuk aplikasi bawaan Counter App (yang mencari widget angka "0" dan ikon +). Karena aplikasi UTS ini adalah Task Tracker (bukan Counter App), maka pengujian otomatis tersebut gagal (Test Failure). Sesuai instruksi ujian bahwa file starter/bawaan tidak boleh dihapus, file tes ini tetap dipertahankan.
### Screenshot
- Ukuran telepon: `(/screenshots/tampilan_mobile.PNG)`
- Ukuran tablet: `(/screenshots/tampilan_tablet.PNG)`

---

## 6. Error yang Tersisa

| Error / warning | Penyebab | Rencana perbaikan |
|arning unused_field (_memory)|Variabel bawaan starter tidak terpakai karena penyimpanan menggunakan SharedPreferences.|Dibiarkan karena aturan ujian melarang menghapus berkas/kode starter.|
|test Failure pada widget_test.dart |File tes bawaan flutter create menguji aplikasi Counter bawaan, bukan aplikasi Task Tracker. |Menyesuaikan isi widget_test.dart dengan UI Task Tracker jika instruksi ujian memperbolehkan mengubah file tes. |

---

## 7. Daftar Berkas yang Dikumpulkan

- [ ] `UTS_NIM_Nama.zip` (project Flutter, termasuk `lib/` dan `pubspec.yaml`)
- [ ] `README_UTS.md`
- [ ] Screenshot telepon
- [ ] Screenshot tablet
- [ ] Bukti keluaran `flutter analyze`
- [ ] ZIP sudah dibuka ulang dan dicek sebelum batas waktu

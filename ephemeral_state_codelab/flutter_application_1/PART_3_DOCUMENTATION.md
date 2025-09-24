## Fitur-fitur yang Dibuat

### 1. Local State Counter
- Counter sederhana pakai StatefulWidget
- Cuma bisa dipakai di satu widget aja
- Pakai setState() untuk update nilai

```dart
int _counter = 0;
void _increment() {
  setState(() => _counter++);
}
```

### 2. Global State Counter
- Bisa bikin banyak counter
- Semua counter bisa diakses dari mana aja
- Pakai Provider package

## Cara Kerja State Management

### Local State
- State cuma ada di widget itu doang
- Kalau widget dihapus, state ikut hilang
- Cocok untuk hal-hal sederhana seperti form input

### Global State
- State bisa diakses dari semua widget
- Pakai ChangeNotifier dan Consumer
- Bagus untuk data yang perlu dishare

```dart
class GlobalState extends ChangeNotifier {
  List<CounterModel> _counters = [];
  
  void addCounter() {
    _counters.add(newCounter);
    notifyListeners(); // Kasih tau semua widget
  }
}
```

## Fitur Tambahan yang Saya Buat

1. **Drag and Drop** - Bisa pindah-pindah urutan counter
2. **Animasi** - Ada efek animasi waktu pencet tombol
3. **Warna Custom** - Bisa ganti warna counter
4. **Edit Label** - Bisa ganti nama counter
5. **Dark Mode** - Ada mode gelap
6. **Delete Counter** - Bisa hapus counter

## Struktur Kode

```
lib/
├── main.dart -> setup aplikasi dan UI utama
├── counter.dart -> widget untuk counter
packages/
└── flutter_package_1/
    └── global_state.dart -> class untuk global state
```

## Package yang Dipakai

- **provider** - untuk global state management
- **flutter** - framework utamanya

## Masalah yang Saya Hadapi

1. **Awalnya bingung** antara local dan global state
2. **Provider pattern** agak susah dipahami di awal
3. **Animation** butuh belajar AnimationController
4. **Drag and drop** harus pakai ReorderableListView

## Yang Dipelajari

1. Kapan pakai local state vs global state
2. Cara kerja Provider pattern
3. Membuat animasi sederhana
4. Drag and drop di Flutter
5. Custom dialog dan theme

## Kesimpulan

Proyek ini membantu saya memahami konsep state management di Flutter. Local state cocok untuk hal sederhana, sementara global state bagus untuk data yang perlu dishare antar widget. Provider pattern memang agak rumit di awal tapi setelah paham jadi lebih mudah untuk manage state yang kompleks.

Code saya juga sudah cukup rapi dan ada comment-comment untuk memudahkan pemahaman.
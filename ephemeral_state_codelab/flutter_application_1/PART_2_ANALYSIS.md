# Analisis Part 2: Global State Management

## Checklist Tugas Part 2

### 1. Buat Flutter Package Terpisah ✅
- **Lokasi**: `packages/flutter_package_1/`
- **File**: 
  - `pubspec.yaml` - konfigurasi package
  - `global_state.dart` - class untuk global state

### 2. Buat GlobalState Class ✅
- **Class**: `GlobalState`
- **Fungsi**: 
  - Menyimpan list counter
  - Pakai `ChangeNotifier` untuk update otomatis
  - Ada method untuk manage counter

### 3. Ubah Counter App Pakai GlobalState ✅
- Update `main.dart` dengan `MultiProvider`
- Buat `CounterListScreen` sebagai UI utama
- Integrasikan global state di seluruh app

### 4. Setiap Counter Punya State Sendiri ✅
- `CounterModel` untuk represent counter individual
- Setiap counter punya: `id`, `label`, `value`, `color`
- Ditampilkan dalam bentuk list

### 5. Fungsi yang Dibuat:

#### Tambah Counter Baru ✅
- **Method**: `GlobalState.addCounter()`
- **UI**: FloatingActionButton dengan icon "+"
- **Fitur**: 
  - ID otomatis
  - Label default ("Counter 1", "Counter 2", dll)
  - Warna bergantian

#### Hapus Counter ✅
- **Method**: `GlobalState.removeCounter(String id)`
- **UI**: PopupMenu di setiap counter
- **Fitur**: Hapus counter individual

#### Increment dan Decrement ✅
- **Method**: 
  - `GlobalState.incrementCounter(String id)`
  - `GlobalState.decrementCounter(String id)`
- **UI**: Tombol +/- untuk setiap counter
- **Fitur**: 
  - Tidak bisa kurang dari 0
  - Ada feedback visual

## Penjelasan Implementasi

### Class Utama

1. **CounterModel**
   ```dart
   class CounterModel {
     final String id;      // ID unik
     String label;         // Nama counter
     int value;           // Nilai counter
     Color color;         // Warna counter
   }
   ```

2. **GlobalState**
   ```dart
   class GlobalState extends ChangeNotifier {
     List<CounterModel> _counters = [];
     
     // Method untuk requirements Part 2:
     void addCounter() // tambah counter
     void removeCounter(String id) // hapus counter
     void incrementCounter(String id) // +1
     void decrementCounter(String id) // -1
   }
   ```

### Struktur UI

```
CounterListScreen (Layar Utama)
├── AppBar (toggle dark mode & menu)
├── Body
│   ├── Part 1: LocalCounterWidget (Demo Local State)
│   └── Part 2: CounterListWidget (Demo Global State)
│       └── ListView berisi GlobalCounterItem
└── FloatingActionButton (Tambah Counter)
```

### Fitur Tambahan yang Dibuat

1. **Manage List**: Counter ditampilkan dalam scrollable list
2. **Operasi Individual**: Setiap counter bisa di +/- sendiri-sendiri
3. **Tambah/Hapus**: Bisa tambah dan hapus counter secara dinamis
4. **State Persistence**: Global state tetap ada saat UI update
5. **Visual Feedback**: 
   - Counter punya warna berbeda-beda
   - Ada tooltip di tombol
   - Pesan kalau belum ada counter
6. **Fitur Extra**:
   - Edit nama dan warna counter
   - Reset semua counter
   - Clear semua counter
   - Tampilan jumlah total counter

## Status Part 2: SELESAI ✅

Semua requirements untuk Part 2 sudah berhasil dibuat:

- ✅ Package Flutter terpisah sudah dibuat
- ✅ GlobalState class dengan list counter
- ✅ Counter app diubah pakai GlobalState
- ✅ Individual counter state management
- ✅ Fungsi tambah counter baru
- ✅ Fungsi hapus counter
- ✅ Fungsi increment/decrement individual
- ✅ State management pakai Provider pattern
- ✅ Pemisahan yang jelas antara local state (Part 1) dan global state (Part 2)

Fitur tambahan yang dibuat:
- Customization counter (nama, warna)
- Bulk operations (reset all, clear all)
- UI yang bagus dengan Material Design
- Error handling yang proper
- Struktur kode yang rapi

## Struktur Project
```
flutter_application_1/
├── lib/
│   ├── main.dart (Updated dengan Part 2)
│   └── counter.dart (UI components)
├── packages/
│   └── flutter_package_1/ (Package baru untuk global state)
│       ├── pubspec.yaml
│       └── lib/
│           └── global_state.dart (GlobalState & CounterModel)
├── test/
│   └── widget_test.dart
└── pubspec.yaml
```
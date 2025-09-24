import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Model untuk individual counter
class CounterModel {
  final String id;
  String label;
  int value;
  Color color;

  CounterModel({
    required this.id,
    required this.label,
    this.value = 0,
    required this.color,
  });

  CounterModel copyWith({
    String? id,
    String? label,
    int? value,
    Color? color,
  }) {
    return CounterModel(
      id: id ?? this.id,
      label: label ?? this.label,
      value: value ?? this.value,
      color: color ?? this.color,
    );
  }
}

/// Global State class yang mengelola list of counters - sesuai requirements Part 2
class GlobalState extends ChangeNotifier {
  List<CounterModel> _counters = [];
  int _nextCounterId = 1;
  int _totalOperations = 0; // Track total operations untuk statistics

  List<CounterModel> get counters => List.unmodifiable(_counters);
  int get counterCount => _counters.length;
  int get totalValue => _counters.fold(0, (sum, counter) => sum + counter.value);
  int get totalOperations => _totalOperations;
  
  /// Menambah counter baru - sesuai requirements Part 2
  void addCounter({String? label, Color? color}) {
    final defaultColors = [
      const Color.fromARGB(255, 138, 169, 194), // Light Blue
      const Color.fromARGB(255, 152, 199, 154), // Light Green
      const Color.fromARGB(255, 214, 198, 174), // Beige
      const Color.fromARGB(255, 221, 179, 176), // Light Pink
      const Color.fromARGB(255, 163, 125, 170), // Light Purple
      Colors.brown, // Brown
      const Color.fromARGB(255, 160, 192, 189), // Teal
      const Color.fromARGB(255, 177, 153, 161), // Mauve
    ];
    
    final newCounter = CounterModel(
      id: 'counter_$_nextCounterId',
      label: label ?? 'Counter $_nextCounterId',
      color: color ?? defaultColors[(_nextCounterId - 1) % defaultColors.length],
    );
    
    _counters.add(newCounter);
    _nextCounterId++;
    notifyListeners();
  }

  /// Menghapus counter - sesuai requirements Part 2
  void removeCounter(String id) {
    _counters.removeWhere((counter) => counter.id == id);
    notifyListeners();
  }

  /// Increment counter individual - sesuai requirements Part 2
  void incrementCounter(String id) {
    final index = _counters.indexWhere((counter) => counter.id == id);
    if (index != -1) {
      _counters[index] = _counters[index].copyWith(
        value: _counters[index].value + 1,
      );
      _totalOperations++;
      notifyListeners();
    }
  }

  /// Decrement counter individual - sesuai requirements Part 2
  void decrementCounter(String id) {
    final index = _counters.indexWhere((counter) => counter.id == id);
    if (index != -1 && _counters[index].value > 0) {
      _counters[index] = _counters[index].copyWith(
        value: _counters[index].value - 1,
      );
      _totalOperations++;
      notifyListeners();
    }
  }

  /// Update label counter
  void updateCounterLabel(String id, String newLabel) {
    final index = _counters.indexWhere((counter) => counter.id == id);
    if (index != -1) {
      _counters[index] = _counters[index].copyWith(label: newLabel);
      notifyListeners();
    }
  }

  /// Update color counter
  void updateCounterColor(String id, Color newColor) {
    final index = _counters.indexWhere((counter) => counter.id == id);
    if (index != -1) {
      _counters[index] = _counters[index].copyWith(color: newColor);
      notifyListeners();
    }
  }

  /// Update counter value directly
  void updateCounterValue(String id, int newValue) {
    final index = _counters.indexWhere((counter) => counter.id == id);
    if (index != -1 && newValue >= 0) {
      _counters[index] = _counters[index].copyWith(value: newValue);
      _totalOperations++;
      notifyListeners();
    }
  }

  /// Reorder counters untuk drag-and-drop functionality
  void reorderCounters(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final counter = _counters.removeAt(oldIndex);
    _counters.insert(newIndex, counter);
    notifyListeners();
  }

  /// Reset semua counters
  void resetAllCounters() {
    for (int i = 0; i < _counters.length; i++) {
      _counters[i] = _counters[i].copyWith(value: 0);
    }
    notifyListeners();
  }

  /// Clear semua counters
  void clearAllCounters() {
    _counters.clear();
    _nextCounterId = 1;
    _totalOperations = 0; // Reset operations count
    notifyListeners();
  }
}

/// App State class untuk manage app-level settings
class AppState extends ChangeNotifier {
  String _appTitle = 'Advanced Counter App';
  bool _isDarkMode = false;

  String get appTitle => _appTitle;
  bool get isDarkMode => _isDarkMode;

  void updateTitle(String newTitle) {
    _appTitle = newTitle;
    notifyListeners();
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
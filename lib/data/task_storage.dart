import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

/// Titik akses data tugas.
///
/// Starter memakai memori agar aplikasi dapat langsung dijalankan. Lengkapi
/// TODO 2 dengan SharedPreferences dan JSON; jangan memindahkan akses storage
/// ke widget.
class TaskStorage {
  TaskStorage({this.loadDelay = const Duration(milliseconds: 450)});
  static const String _storageKey = 'tasks_key';

  static List<Task> _memory = <Task>[];

  final Duration loadDelay;

  Future<List<Task>> load({bool simulateError = false}) async {
    await Future<void>.delayed(loadDelay);
    if (simulateError) {
      throw const FormatException('Simulasi data tersimpan yang rusak.');
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? tasksString = prefs.getString(_storageKey);
    if (tasksString == null || tasksString.isEmpty) {
      return <Task>[];
    }
    final Object? decoded = jsonDecode(tasksString);
    if (decoded is! List) {
      throw FormatException('format data tidak valid');
    }
    final List<Task> tasks = <Task>[];
    for (final Object? item in decoded) {
      if (item is! Map<String, dynamic>) {
        throw FormatException('isi tugas tidak valid');
      }
      tasks.add(Task.fromJson(item));
    }
    return tasks;
    // _memory = <Task>[];
  }

  Future<void> save(List<Task> tasks) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<Map<String, Object?>> listJson =
        tasks.map((Task task) => task.toJson()).toList();
    final String jsonToString = jsonEncode(listJson);
    final bool berhasil = await prefs.setString(_storageKey, jsonToString);
    if (!berhasil) {
      throw Exception("gagal menyimpan data");
    }
    // TODO 2b: encode seluruh daftar sebagai JSON String dan tulis melalui
    // SharedPreferences. Periksa nilai bool yang dikembalikan setString.
    // _memory = List<Task>.of(tasks);
  }

  Future<void> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    // TODO 2c: hapus key daftar tugas dari SharedPreferences.
    _memory = <Task>[];
  }

  /// Hanya untuk mengisolasi pengujian lokal.
  static void resetMemoryForTest() => _memory = <Task>[];
}

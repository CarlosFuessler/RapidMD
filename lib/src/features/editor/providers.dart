import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final openFilesProvider = StateNotifierProvider<OpenFilesNotifier, List<File>>((ref) {
  return OpenFilesNotifier();
});

class OpenFilesNotifier extends StateNotifier<List<File>> {
  OpenFilesNotifier() : super([]);

  void addFile(File file) {
    if (!state.any((f) => f.path == file.path)) {
      state = [...state, file];
    }
  }

  void removeFile(File file) {
    state = state.where((f) => f.path != file.path).toList();
  }
}

final previewVisibleProvider = StateProvider<bool>((ref) => true);
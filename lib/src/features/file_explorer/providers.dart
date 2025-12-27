import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedFileProvider = StateProvider<File?>((ref) => null);
final currentDirectoryProvider = StateProvider<String?>((ref) => null);

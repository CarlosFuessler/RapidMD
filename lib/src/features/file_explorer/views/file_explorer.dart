import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:rapdimd/src/core/theme/theme_provider.dart';
import 'package:rapdimd/src/features/editor/providers.dart';
import 'package:rapdimd/src/features/file_explorer/providers.dart';
import 'package:rapdimd/src/features/pdf_viewer/views/pdf_viewer_page.dart';

class FileExplorer extends ConsumerStatefulWidget {
  const FileExplorer({super.key});

  @override
  ConsumerState<FileExplorer> createState() => _FileExplorerState();
}

class _FileExplorerState extends ConsumerState<FileExplorer> {
  List<FileSystemEntity> _files = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    // No initial directory set, user will pick one.
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentDirectory = ref.watch(currentDirectoryProvider);
    print('[_FileExplorerState] didChangeDependencies triggered. currentDirectory: $currentDirectory');
    if (currentDirectory != null) {
      _loadFiles(currentDirectory);
    } else {
      // If no directory is selected, show an empty state or a prompt to select a directory
      setState(() {
        _files = [];
        _loading = false;
      });
    }
  }

  Future<void> _loadFiles(String path) async {
    print('[_loadFiles] Loading files from path: $path');
    setState(() {
      _loading = true;
    });
    try {
      final directory = Directory(path);
      print('[_loadFiles] Directory exists: ${directory.existsSync()}');
      // Also listen for changes in the directory
      directory.watch().listen((event) {
        if (ref.read(currentDirectoryProvider) == path) {
          _loadFiles(path);
        }
      });
      final items = directory.listSync().where((item) {
        return item is Directory ||
            p.extension(item.path).toLowerCase() == '.md' ||
            p.extension(item.path).toLowerCase() == '.pdf';
      }).toList();
      print('[_loadFiles] Found ${items.length} items.');

      items.sort((a, b) {
        if (a is Directory && b is File) {
          return -1;
        }
        if (a is File && b is Directory) {
          return 1;
        }
        return p.basename(a.path).toLowerCase().compareTo(p.basename(b.path).toLowerCase());
      });

      if (mounted) {
        setState(() {
          _files = items;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
      print('[_loadFiles] Error loading files: $e');
    }
  }

  Future<void> _openDirectoryPicker() async {
    final result = await FilePicker.platform.getDirectoryPath();
    if (result != null) {
      ref.read(currentDirectoryProvider.notifier).state = result;
      print('[_openDirectoryPicker] currentDirectoryProvider updated to: $result');
      // _loadFiles(result); // didChangeDependencies will handle this
    } else {
      print('[_openDirectoryPicker] Directory picker cancelled or failed.');
    }
  }

  IconData _getFileIcon(String path) {
    if (p.extension(path).toLowerCase() == '.pdf') {
      return Icons.picture_as_pdf;
    }
    else if (p.extension(path).toLowerCase() == '.md') {
      return Icons.description;
    }
    return Icons.folder;
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    final selectedFile = ref.watch(selectedFileProvider);
    final currentDirectory = ref.watch(currentDirectoryProvider);

    return Container(
      width: 200,
      color: theme.sidebarBackgroundColor,
      child: Column(
        children: [
          AppBar(
            backgroundColor: theme.sidebarBackgroundColor,
            elevation: 1,
            title: Text(
              currentDirectory != null ? currentDirectory : 'Select Directory',
              style: TextStyle(color: theme.sidebarTextColor, fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.folder_open),
                onPressed: _openDirectoryPicker,
                color: theme.sidebarTextColor,
              ),
            ],
            leading: currentDirectory != null &&
                    Directory(currentDirectory).parent.path != currentDirectory
                ? IconButton(
                    icon: Icon(Icons.arrow_back, color: theme.sidebarTextColor),
                    onPressed: () {
                      final parent = Directory(currentDirectory).parent.path;
                      ref.read(currentDirectoryProvider.notifier).state = parent;
                      // _loadFiles(parent); // didChangeDependencies will handle this
                    },
                  )
                : null,
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _files.isEmpty && currentDirectory != null
                    ? Center(child: Text('No files', style: TextStyle(color: theme.sidebarTextColor)))
                    : _files.isEmpty && currentDirectory == null
                        ? Center(child: Text('Please select a directory', style: TextStyle(color: theme.sidebarTextColor)))
                        : Scrollbar(
                            thumbVisibility: true,
                            trackVisibility: true,
                            child: ListView.builder(
                              itemCount: _files.length,
                              itemBuilder: (context, index) {
                                final file = _files[index];
                                final isDirectory = file is Directory;
                                final isSelected = selectedFile != null && selectedFile.path == file.path;

                                return ListTile(
                                  tileColor: isSelected ? theme.sidebarHighlightColor : null,
                                  leading: Icon(_getFileIcon(file.path), color: theme.sidebarTextColor),
                                  title: Text(
                                    p.basename(file.path),
                                    style: TextStyle(color: theme.sidebarTextColor),
                                  ),
                                  onTap: () {
                                    if (isDirectory) {
                                      ref.read(currentDirectoryProvider.notifier).state = file.path;
                                      // _loadFiles(file.path); // didChangeDependencies will handle this
                                    } else if (file is File) {
                                      if (p.extension(file.path).toLowerCase() == '.pdf') {
                                        Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => PdfViewerPage(file: file),
                                        ));
                                      } else if (p.extension(file.path).toLowerCase() == '.md') {
                                        ref.read(openFilesProvider.notifier).addFile(file);
                                        ref.read(selectedFileProvider.notifier).state = file;
                                      }
                                    }
                                  },
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}

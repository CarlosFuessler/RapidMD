import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:rapdimd/src/core/theme/theme_provider.dart';
import 'package:rapdimd/src/features/editor/providers.dart';
import 'package:rapdimd/src/features/editor/views/editor_view.dart';
import 'package:rapdimd/src/features/file_explorer/providers.dart';
import 'package:rapdimd/src/features/file_explorer/views/file_explorer.dart';
import 'package:pdf/pdf.dart';
import 'package:rapdimd/src/core/theme/theme.dart';
import 'package:pdf/widgets.dart' as pw;

class EditorPage extends ConsumerWidget {
  const EditorPage({super.key});

  Future<void> _createNewFile(WidgetRef ref) async {
    final directory = await getApplicationDocumentsDirectory();
    int i = 0;
    File newFile;
    do {
      i++;
      newFile = File('${directory.path}/Untitled-$i.md');
    } while (await newFile.exists());
    await newFile.writeAsString('');

    ref.read(openFilesProvider.notifier).addFile(newFile);
    ref.read(selectedFileProvider.notifier).state = newFile;
  }

  Future<void> _exportToPdf(File file) async {
    final pdf = pw.Document();
    final content = await file.readAsString();
    
    // This is a simplified conversion. For a better result, a more complex
    // parser would be needed to convert markdown to pdf widgets.
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Text(content);
        },
      ),
    );

    final output = await getApplicationDocumentsDirectory();
    final pdfFile = File('${output.path}/${file.path.split('/').last.replaceAll('.md', '.pdf')}');
    await pdfFile.writeAsBytes(await pdf.save());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final openFiles = ref.watch(openFilesProvider);
    final selectedFile = ref.watch(selectedFileProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedFile != null ? selectedFile.path.split('/').last : 'RapdiMD'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _createNewFile(ref),
          ),
          if (selectedFile != null && selectedFile.path.endsWith('.md'))
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              onPressed: () {
                _exportToPdf(selectedFile);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Exported to PDF')),
                );
              },
            ),
          IconButton(
            icon: Icon(theme.name == 'Light' ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              ref.read(themeProvider.notifier).toggleTheme();
            },
          ),
        ],
      ),
      body: Row(
        children: [
          const FileExplorer(),
          const VerticalDivider(width: 1),
          Expanded(
            child: openFiles.isEmpty
                ? const Center(child: Text('No files open'))
                : DefaultTabController(
                    length: openFiles.length,
                    initialIndex: selectedFile != null ? openFiles.indexOf(selectedFile) : 0,
                    child: Builder(builder: (context) {
                      final controller = DefaultTabController.of(context);
                      if (selectedFile != null) {
                        final index = openFiles.indexOf(selectedFile);
                        if (index != -1 && index != controller.index) {
                          controller.animateTo(index);
                        }
                      }
                      controller.addListener(() {
                        if (controller.indexIsChanging) {
                          Future.microtask(() {
                            ref.read(selectedFileProvider.notifier).state = openFiles[controller.index];
                          });
                        }
                      });
                      return Column(
                        children: [
                          TabBar(
                            isScrollable: true,
                            tabs: openFiles
                                .map((file) => Tab(
                                      child: Row(
                                        children: [
                                          Text(file.path.split('/').last),
                                          IconButton(
                                            icon: const Icon(Icons.close, size: 12),
                                            onPressed: () {
                                              ref.read(openFilesProvider.notifier).removeFile(file);
                                            },
                                          ),
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ),
                          Expanded(
                            child: TabBarView(
                              children: openFiles.map((file) => EditorView(file: file)).toList(),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
          ),
        ],
      ),
    );
  }
}

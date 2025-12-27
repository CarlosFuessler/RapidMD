import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rapdimd/src/core/theme/theme_provider.dart';
import 'package:rapdimd/src/features/editor/providers.dart';
import 'package:rapdimd/src/shared/widgets/markdown_toolbar.dart';
import 'package:path/path.dart' as p;

class EditorView extends ConsumerStatefulWidget {
  final File file;

  const EditorView({super.key, required this.file});

  @override
  ConsumerState<EditorView> createState() => _EditorViewState();
}

class _EditorViewState extends ConsumerState<EditorView> {
  late final TextEditingController _controller;
  late final ScrollController _editorScrollController;
  String _markdownData = '';

  @override
  void initState() {
    super.initState();
    _editorScrollController = ScrollController();
    _controller = TextEditingController(text: '# ${p.basename(widget.file.path)}\n\n' + widget.file.readAsStringSync());
    _markdownData = _controller.text;
    _controller.addListener(() {
      setState(() {
        _markdownData = _controller.text;
      });
      widget.file.writeAsStringSync(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _editorScrollController.dispose();
    super.dispose();
  }

  void _onMarkdownAction(String syntax) {
    final text = _controller.text;
    final selection = _controller.selection;

    if (selection.isCollapsed) {
      if (syntax == '[]()') {
        final newText = text.substring(0, selection.start) +
            syntax +
            text.substring(selection.end);
        _controller.text = newText;
        _controller.selection = 
            TextSelection.fromPosition(TextPosition(offset: selection.start + 1));
      } else if (syntax == '```\n\n```') {
        final newText = text.substring(0, selection.start) +
            syntax +
            text.substring(selection.end);
        _controller.text = newText;
        _controller.selection = 
            TextSelection.fromPosition(TextPosition(offset: selection.start + 4));
      } else {
        final newText = text.substring(0, selection.start) +
            syntax +
            syntax +
            text.substring(selection.end);
        _controller.text = newText;
        _controller.selection = 
            TextSelection.fromPosition(TextPosition(offset: selection.start + syntax.length));
      }
    } else {
      final newText = text.substring(0, selection.start) +
          syntax +
          text.substring(selection.start, selection.end) +
          syntax +
          text.substring(selection.end);
      _controller.text = newText;
      _controller.selection = TextSelection(
        baseOffset: selection.start + syntax.length,
        extentOffset: selection.end + syntax.length,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
      final theme = ref.watch(themeProvider);
      final previewVisible = ref.watch(previewVisibleProvider);
  
      return Column(
        children: [
          MarkdownToolbar(onAction: _onMarkdownAction),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: previewVisible
                  ? Row(
                      children: [
                        Expanded(
                          child: Container(
                            color: theme.editorBackgroundColor,
                            child: Scrollbar(
                              controller: _editorScrollController,
                              thumbVisibility: true,
                              trackVisibility: true,
                              child: TextField(
                                controller: _controller,
                                scrollController: _editorScrollController,
                                maxLines: null,
                                style: TextStyle(color: theme.editorTextColor),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter your markdown here...',
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const VerticalDivider(width: 1),
                        Expanded(
                          child: Container(
                            color: theme.previewBackgroundColor,
                            child: Scrollbar(
                              thumbVisibility: true,
                              trackVisibility: true,
                              child: Markdown(
                                data: _markdownData,
                                styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                                  p: Theme.of(context).textTheme.bodyMedium?.copyWith(color: theme.previewTextColor),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(
                      color: theme.editorBackgroundColor,
                      child: Scrollbar(
                        controller: _editorScrollController,
                        thumbVisibility: true,
                        trackVisibility: true,
                        child: TextField(
                          controller: _controller,
                          scrollController: _editorScrollController,
                          maxLines: null,
                          style: TextStyle(color: theme.editorTextColor),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter your markdown here...',
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      );
    }}
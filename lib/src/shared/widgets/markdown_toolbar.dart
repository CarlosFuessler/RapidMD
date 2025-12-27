import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rapdimd/src/features/editor/providers.dart';

class MarkdownToolbar extends ConsumerWidget {
  final Function(String) onAction;

  const MarkdownToolbar({super.key, required this.onAction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Theme.of(context).appBarTheme.backgroundColor,
      child: Wrap(
        children: [
          Tooltip(
            message: 'Bold',
            child: IconButton(
              icon: const Icon(Icons.format_bold),
              onPressed: () => onAction('**'),
              iconSize: 20,
            ),
          ),
          Tooltip(
            message: 'Italic',
            child: IconButton(
              icon: const Icon(Icons.format_italic),
              onPressed: () => onAction('*'),
              iconSize: 20,
            ),
          ),
          Tooltip(
            message: 'Quote',
            child: IconButton(
              icon: const Icon(Icons.format_quote),
              onPressed: () => onAction('> '),
              iconSize: 20,
            ),
          ),
          Tooltip(
            message: 'Code',
            child: IconButton(
              icon: const Icon(Icons.code),
              onPressed: () => onAction('```\n\n```'),
              iconSize: 20,
            ),
          ),
          Tooltip(
            message: 'Link',
            child: IconButton(
              icon: const Icon(Icons.link),
              onPressed: () => onAction('[]()'),
              iconSize: 20,
            ),
          ),
          Tooltip(
            message: 'H1',
            child: IconButton(
              icon: const Text('H1'),
              onPressed: () => onAction('# '),
              iconSize: 20,
            ),
          ),
          Tooltip(
            message: 'H2',
            child: IconButton(
              icon: const Text('H2'),
              onPressed: () => onAction('## '),
              iconSize: 20,
            ),
          ),
          Tooltip(
            message: 'H3',
            child: IconButton(
              icon: const Text('H3'),
              onPressed: () => onAction('### '),
              iconSize: 20,
            ),
          ),
          Tooltip(
            message: 'List',
            child: IconButton(
              icon: const Icon(Icons.format_list_bulleted),
              onPressed: () => onAction('- '),
              iconSize: 20,
            ),
          ),
          Tooltip(
            message: 'Checkbox',
            child: IconButton(
              icon: const Icon(Icons.check_box_outline_blank),
              onPressed: () => onAction('- [ ] '),
              iconSize: 20,
            ),
          ),
          Tooltip(
            message: 'Toggle Preview',
            child: IconButton(
              icon: Icon(ref.watch(previewVisibleProvider) ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                ref.read(previewVisibleProvider.notifier).state = !ref.read(previewVisibleProvider);
              },
              iconSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}



import 'package:flutter/material.dart';

class NotesInput extends StatefulWidget {
  const NotesInput(
      {super.key,
      required this.scrollController,
      required this.editingController});

  final ScrollController scrollController;
  final TextEditingController editingController;

  @override
  State<NotesInput> createState() => _NotesInputState();
}

class _NotesInputState extends State<NotesInput> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Scrollbar(
        controller: widget.scrollController,
        child: TextField(
          style: const TextStyle(color: Colors.white),
          scrollController: widget.scrollController,
          autofocus: false,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          controller: widget.editingController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Add notes',
            contentPadding: EdgeInsets.all(8),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class TextFieldIdentiicationWidget extends StatefulWidget {
  final int maxLines;
  final String label;
  final String text;
  final ValueChanged<String> onChanged;
  final IconData? prefixIcon;

  const TextFieldIdentiicationWidget({
    super.key,
    this.maxLines = 1,
    required this.label,
    required this.text,
    required this.onChanged,
    this.prefixIcon,
  });

  @override
  State<TextFieldIdentiicationWidget> createState() =>
      _TextFieldIdentiicationWidgetState();
}

class _TextFieldIdentiicationWidgetState
    extends State<TextFieldIdentiicationWidget> {
  late final TextEditingController controller;
  bool isTextNotEmpty = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.text);
    controller.addListener(_updateIsTextNotEmpty);
    _updateIsTextNotEmpty();
  }

  @override
  void dispose() {
    controller.removeListener(_updateIsTextNotEmpty);
    controller.dispose();
    super.dispose();
  }

  void _updateIsTextNotEmpty() {
    setState(() {
      isTextNotEmpty = controller.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 60,
            width: 350,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: widget.label,
                labelStyle: const TextStyle(color: Colors.black),
                prefixIcon: widget.prefixIcon != null
                    ? Icon(widget.prefixIcon)
                    : null,
                suffixIcon: isTextNotEmpty
                    ? InkWell(
                        onTap: () {
                          controller.clear();
                          widget.onChanged('');
                          _updateIsTextNotEmpty();
                        },
                        child: const Icon(Icons.clear),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                filled: true,
                fillColor: Colors.white,
              ),
              maxLines: widget.maxLines,
              onChanged: (text) {
                widget.onChanged(text);
                _updateIsTextNotEmpty();
              },
            ),
          ),
        ],
      );
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextReviewWidget extends StatefulWidget {
  final TextEditingController controller;
  final int maxLength;

  const TextReviewWidget({
    super.key,
    required this.controller,
    required this.maxLength,
  });

  @override
  State<TextReviewWidget> createState() => _TextReviewWidgetState();
}

class _TextReviewWidgetState extends State<TextReviewWidget> {
  int textLength = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: TextFormField(
        inputFormatters: [LengthLimitingTextInputFormatter(widget.maxLength)],
        keyboardType: TextInputType.text,
        controller: widget.controller,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          hintMaxLines: 10,
          hintStyle: const TextStyle(fontSize: 14),
          hintText:
              'เขียนรีวิวสินค้าเพิ่มเติม หลังจากใช้งานสินค้าของคุณเป็นอย่างไร กรุณาใช้คำอย่างสุภาพ',
          suffixIcon: Container(
            width: 80,
            alignment: Alignment.bottomCenter,
            height: 120,
            child: Text(
              '$textLength / ${widget.maxLength}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        maxLines: 5,
        style: const TextStyle(fontSize: 14),
        onChanged: (value) {
          setState(() {
            textLength = value.length;
          });
        },
      ),
    );
  }
}

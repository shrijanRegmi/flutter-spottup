import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType type;
  final bool requireWordCapitalization;
  final bool isExpanded;
  AuthField({
    this.hintText,
    this.controller,
    this.isPassword = false,
    this.type = TextInputType.text,
    this.requireWordCapitalization = false,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(3.0, 3.0),
            blurRadius: 10.0,
          ),
        ],
        borderRadius: BorderRadius.circular(100.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: TextFormField(
          maxLines: isExpanded ? 3 : 1,
          minLines: 1,
          textCapitalization: requireWordCapitalization
              ? TextCapitalization.words
              : TextCapitalization.none,
          obscureText: isPassword,
          style: TextStyle(
            fontSize: 14.0,
          ),
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
          ),
        ),
      ),
    );
  }
}

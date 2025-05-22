import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final bool enabled;
  final TextInputType keyboardType;
  final String? hintText;
  final String? initialText;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.prefixIcon,
    this.validator,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.hintText,
    this.initialText,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;

    // ✅ Solo establecer el texto si el controller está vacío
    if (widget.initialText != null && widget.controller.text.isEmpty) {
      widget.controller.text = widget.initialText!;
    }
  }

  void _toggleObscure() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      validator: widget.validator,
      enabled: widget.enabled,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
        labelText: widget.labelText,
        prefixIcon:
            widget.prefixIcon != null
                ? Icon(widget.prefixIcon, size: 20)
                : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon:
            widget.obscureText
                ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    size: 20,
                  ),
                  onPressed: _toggleObscure,
                  tooltip:
                      _obscureText
                          ? "Mostrar contraseña"
                          : "Ocultar contraseña",
                )
                : null,
      ),
    );
  }
}

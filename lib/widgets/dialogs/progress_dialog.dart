import 'package:flutter/material.dart';

Future<void> showProgressDialog(BuildContext context, {String? message}) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  strokeWidth: 4,
                ),
                const SizedBox(height: 28),
                Text(
                  message ?? 'Procesando, por favor espera...',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 17, color: Colors.black87),
                ),
              ],
            ),
          ),
        ),
  );
}

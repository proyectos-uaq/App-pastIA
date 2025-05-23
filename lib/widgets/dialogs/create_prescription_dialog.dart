import 'package:app_pastia/models/prescription_model.dart';
import 'package:app_pastia/services/prescription_service.dart';
import 'package:flutter/material.dart';

Future<String?> showCreatePrescriptionDialog(
  BuildContext context, {
  required String token,
}) {
  final TextEditingController nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool saving = false;

  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            title: Row(
              children: const [
                Icon(Icons.description, color: Colors.blueAccent),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Agregar receta",
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ),
              ],
            ),
            content: Form(
              key: formKey,
              child: TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Nombre de la receta",
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value == null || value.trim().isEmpty
                            ? "Campo requerido"
                            : null,
                enabled: !saving,
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: TextButton(
                      onPressed:
                          saving ? null : () => Navigator.of(context).pop(),
                      child: const Text(
                        "Cancelar",
                        style: TextStyle(color: Colors.red),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: ElevatedButton.icon(
                      icon:
                          saving
                              ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : const Icon(Icons.add, color: Colors.white),
                      label: FittedBox(
                        child: Text(saving ? "Guardando..." : "Agregar"),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed:
                          saving
                              ? null
                              : () async {
                                if (formKey.currentState!.validate()) {
                                  setState(() => saving = true);

                                  Prescription prescription = Prescription(
                                    name: nameController.text.trim(),
                                    source: 'manual',
                                  );

                                  final response =
                                      await PrescriptionService.createPrescription(
                                        prescription: prescription,
                                        token: token,
                                      );

                                  setState(() => saving = false);

                                  if (context.mounted) {
                                    if (response.error == null) {
                                      Navigator.of(
                                        context,
                                      ).pop(nameController.text.trim());
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Receta creada correctamente",
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Ocurrió un error: ${response.error}',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                }
                              },
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      );
    },
  );
}

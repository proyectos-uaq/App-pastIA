import 'package:past_ia/models/prescription_model.dart';
import 'package:past_ia/services/prescription_service.dart';
import 'package:flutter/material.dart';
import 'package:past_ia/widgets/custom_circular_progress_indicator.dart';

Future<String?> showEditPrescriptionDialog(
  BuildContext context, {
  required String initialName,
  required String token, // <-- recibe el token aquí
  required String prescriptionId, // <-- también el id de la receta
}) {
  final TextEditingController nameController = TextEditingController(
    text: initialName,
  );
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
                Icon(Icons.edit, color: Colors.blueAccent),
                SizedBox(width: 10),
                Text("Editar receta"),
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
                  TextButton(
                    onPressed:
                        saving ? null : () => Navigator.of(context).pop(),
                    child: const Text(
                      "Cancelar",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  ElevatedButton.icon(
                    icon:
                        saving
                            ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: MyCustomLoader(),
                            )
                            : const Icon(Icons.save, color: Colors.white),
                    label: Text(saving ? "Guardando..." : "Guardar"),
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
                                );

                                var response =
                                    await PrescriptionService.updatePrescription(
                                      prescription: prescription,
                                      id: prescriptionId,
                                      token: token,
                                    );

                                setState(() => saving = false);

                                if (context.mounted) {
                                  if (response.error == null) {
                                    Navigator.of(
                                      context,
                                    ).pop(nameController.text.trim());
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Receta actualizada correctamente',
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Ocurrió un error: ${response.message}',
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              }
                            },
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

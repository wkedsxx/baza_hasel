import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KontoNewPage extends StatefulWidget {
  const KontoNewPage({super.key});

  @override
  State<KontoNewPage> createState() => _KontoNewPageState();
}

class _KontoNewPageState extends State<KontoNewPage> {
  CollectionReference konta = FirebaseFirestore.instance.collection('konta');

  var loginController = TextEditingController();
  var hasloController = TextEditingController();
  var nazwaBDController = TextEditingController();
  var uwagiController = TextEditingController();
  var kontrahentController = TextEditingController();
  var hostController = TextEditingController();
  var typKontaController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Dodawanie konta')),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              tile(Icons.person, 'Login:', loginController),
              tile(Icons.key, 'Hasło:', hasloController),
              tile(Icons.table_rows_rounded, 'Nazwa BD:', nazwaBDController),
              tile(Icons.feed, 'Uwagi:', uwagiController),
              tile(Icons.groups, 'Kontrahent:', kontrahentController),
              tile(Icons.lan, 'Host:', hostController),
              tile(Icons.manage_accounts, 'Typ konta:', typKontaController),
              const SizedBox(height: 100),
              ElevatedButton.icon(
                onPressed: () {
                  Map<String, dynamic> newKonto = {
                    'login': loginController.text,
                    'haslo': hasloController.text,
                    'nazwa BD': nazwaBDController.text,
                    'uwagi': uwagiController.text,
                    'kontrahent': kontrahentController.text,
                    'host': hostController.text,
                    'typ konta': typKontaController.text,
                    'data utworzenia': FieldValue.serverTimestamp()
                  };
                  konta.add(newKonto);
                },
                icon: const Icon(Icons.person_add),
                label: const Text('Dodaj konto'),
              )
            ],
          ),
        ));
  }

  Row tile(IconData icon, String title, TextEditingController controller) {
    return Row(
      children: [
        Icon(icon),
        Text(title),
        const SizedBox(width: 50),
        Expanded(child: TextField(controller: controller))
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/views/ui_elements/collection_dropdown.dart';

class KontoNewPage extends StatefulWidget {
  const KontoNewPage({super.key});

  @override
  State<KontoNewPage> createState() => _KontoNewPageState();
}

class _KontoNewPageState extends State<KontoNewPage> {
  CollectionReference konta = FirebaseFirestore.instance.collection('konta');
  CollectionReference kontrahenci =
      FirebaseFirestore.instance.collection('kontrahenci');
  CollectionReference hosty = FirebaseFirestore.instance.collection('hosty');
  CollectionReference typyKont =
      FirebaseFirestore.instance.collection('typy kont');

  String? kontrahentValue, hostValue, typKontaValue;
  void updateKontrahent(String? newValue) {
    setState(() {
      kontrahentValue = newValue;
      print(kontrahentValue);
    });
  }

  void updateHost(String? newValue) {
    setState(() {
      hostValue = newValue;
      print(hostValue);
    });
  }

  void updateTypkonta(String? newValue) {
    setState(() {
      typKontaValue = newValue;
      print(typKontaValue);
    });
  }

  var loginController = TextEditingController();
  var hasloController = TextEditingController();
  var nazwaBDController = TextEditingController();
  var uwagiController = TextEditingController();
  // var kontrahentController = TextEditingController();
  // var hostController = TextEditingController();
  // var typKontaController = TextEditingController();
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
              tileDropdown(
                Icons.groups,
                'Kontrahent:',
                kontrahenci,
                updateKontrahent,
              ),
              tileDropdown(Icons.lan, 'Host:', hosty, updateHost),
              tileDropdown(Icons.manage_accounts, 'Typ konta:', typyKont,
                  updateTypkonta),
              const SizedBox(height: 100),
              ElevatedButton.icon(
                onPressed: () {
                  Map<String, dynamic> newKonto = {
                    'login': loginController.text,
                    'haslo': hasloController.text,
                    'nazwa BD': nazwaBDController.text,
                    'uwagi': uwagiController.text,
                    'kontrahent': kontrahentValue,
                    'host': hostValue,
                    'typ konta': typKontaValue,
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

  Row tileDropdown(IconData icon, String title,
      CollectionReference collectionRef, Function callback) {
    return Row(
      children: [
        Icon(icon),
        Text(title),
        const SizedBox(width: 50),
        CollectionDropdown(
          collectionRef: collectionRef,
          callback: callback,
        ),
      ],
    );
  }
}

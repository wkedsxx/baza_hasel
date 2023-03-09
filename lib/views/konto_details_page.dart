import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class KontoDetailsPage extends StatefulWidget {
  const KontoDetailsPage({super.key, required this.kontoDocId});

  final String kontoDocId;
  @override
  State<KontoDetailsPage> createState() => _KontoDetailsPageState();
}

class _KontoDetailsPageState extends State<KontoDetailsPage> {
  var db = FirebaseFirestore.instance;
  late var kontoRef = db.collection('konta').doc(widget.kontoDocId);

  var loginController = TextEditingController();
  var hasloController = TextEditingController();
  var nazwaBDController = TextEditingController();
  var uwagiController = TextEditingController();
  var dataUtworzeniaController = TextEditingController();
  var kontrahentController = TextEditingController();
  var hostController = TextEditingController();
  var typKontaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Szczegóły konta'),
        ),
        body: Column(
          children: [
            Text(widget.kontoDocId),
            FutureBuilder(
              future: kontoRef.get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  var konto = snapshot.data!.data() as Map<String, dynamic>;
                  return Column(
                    children: [
                      tile(Icons.person, 'Login:', konto['login'],
                          loginController, false),
                      tile(Icons.key, 'Hasło:', konto['haslo'], hasloController,
                          true),
                      tile(Icons.table_rows_rounded, 'Nazwa BD:',
                          konto['nazwa BD'], nazwaBDController, true),
                      tile(Icons.feed, 'Uwagi:', konto['uwagi'],
                          uwagiController, true),
                      tile(Icons.groups, 'Kontrahent:', konto['kontrahent'],
                          kontrahentController, false),
                      tile(Icons.lan, 'Host:', konto['host'], hostController,
                          false),
                      tile(Icons.manage_accounts, 'Typ konta:',
                          konto['typ konta'], typKontaController, false),
                      tile(
                          Icons.calendar_today,
                          'Data utworzenia:',
                          DateFormat('dd-MM-yyyy').format(
                              (konto['data utworzenia'] as Timestamp).toDate()),
                          dataUtworzeniaController,
                          false),
                    ],
                  );
                }
                return const Text('Ładowanie');
              },
            )
          ],
        ));
  }

  Row tile(IconData icon, String title, String value,
      TextEditingController controller, bool isEditable) {
    return Row(
      children: [
        Icon(icon),
        Text(title),
        const SizedBox(width: 50),
        Expanded(
            child: TextField(
          controller: controller..text = value,
          readOnly: !isEditable,
        ))
      ],
    );
  }
}

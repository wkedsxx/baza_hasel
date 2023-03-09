import '/views/login_page.dart';
import '/views/konto_details_page.dart';
import '/views/konto_new_page.dart';
import '/views/kontrahenci_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class KontaSearchPage extends StatefulWidget {
  const KontaSearchPage({super.key});
  @override
  State<KontaSearchPage> createState() => _KontaSearchPageState();
}

class _KontaSearchPageState extends State<KontaSearchPage> {
  @override
  Widget build(BuildContext context) {
    CollectionReference konta = FirebaseFirestore.instance.collection('konta');
    String selectedRowDocId = '0';
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              icon: const Icon(Icons.logout),
              label: const Text('Wyloguj'),
            ),
            ElevatedButton.icon(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const KontrahenciPage())),
                icon: const Icon(Icons.groups),
                label: const Text('Kontrahenci')),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const KontoNewPage())),
              icon: const Icon(Icons.person_add),
              label: const Text('Dodaj konto'),
            ),
            FutureBuilder(
                future: konta.get(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    List<dynamic> kontaList = snapshot.data!.docs.map((doc) {
                      dynamic tempMap = doc.data();
                      tempMap['id'] = doc.id;
                      return tempMap;
                    }).toList();
                    return DataTable(showCheckboxColumn: false, columns: const <
                        DataColumn>[
                      DataColumn(
                          label: Text('Login',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Kontrahent',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Host',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Typ konta',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Uwagi',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                    ], rows: <DataRow>[
                      for (var konto in kontaList)
                        DataRow(
                            onSelectChanged: (value) {
                              if (selectedRowDocId == konto['id']) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                      'Kliknięto podwójnie id: ${konto['id']}'),
                                  duration: const Duration(seconds: 1),
                                ));
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => KontoDetailsPage(
                                          kontoDocId: konto['id'],
                                        )));
                              }
                              selectedRowDocId = konto['id'];
                            },
                            cells: <DataCell>[
                              DataCell(Text(konto['login'])),
                              DataCell(Text(konto['kontrahent'])),
                              DataCell(Text(konto['host'])),
                              DataCell(Text(konto['typ konta'])),
                              DataCell(Text(konto['uwagi'])),
                            ])
                    ]);
                  }
                  return const Text('Ładowanie');
                })
          ],
        ),
      ),
    );
  }
}

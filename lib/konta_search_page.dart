import 'package:baza_hasel/login_page.dart';
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
    CollectionReference kontrahenci =
        FirebaseFirestore.instance.collection('kontrahenci');
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
            FutureBuilder(
              future: kontrahenci.get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return const Text("Coś poszło nie tak");
                }

                if (!snapshot.hasData) {
                  return const Text("Problem z kolekcją");
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  List<dynamic> data =
                      snapshot.data!.docs.map((doc) => doc.data()).toList();
                  List<Widget> widgetList = [];
                  for (var doc in data) {
                    widgetList.add(Text('kontrahent: ${doc['nazwa']}'));
                  }
                  return Column(children: widgetList);

                  // return Text('nazwa: ${data['nazwa']}');
                }
                return const Text('Ładowanie');
              },
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
                              if (true) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                      'Kliknięto podwójnie id: ${konto['id']}'),
                                  duration: const Duration(seconds: 1),
                                ));
                                selectedRowDocId = konto['id'];
                              }
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

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KontrahenciPage extends StatefulWidget {
  const KontrahenciPage({super.key});

  @override
  State<KontrahenciPage> createState() => _KontrahenciPageState();
}

class _KontrahenciPageState extends State<KontrahenciPage> {
  CollectionReference kontrahenci =
      FirebaseFirestore.instance.collection('kontrahenci');
  var newKontrahentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zarządzanie kontrahentami'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(children: [
          const Text('Lista kontrahentów:'),
          FutureBuilder(
            future: kontrahenci.get(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                  widgetList.add(Text(doc['nazwa']));
                }
                return Column(children: widgetList);
              }
              return const Text('Ładowanie');
            },
          ),
          Row(
            children: [
              const Text('Nowy kontrahent:'),
              SizedBox(
                  width: 100,
                  child: TextField(controller: newKontrahentController)),
              IconButton(
                  onPressed: () {
                    // Map<String, dynamic> newKontrahent = {
                    //   'nazwa': newKontrahentController..text
                    // };
                    kontrahenci.add({'nazwa': newKontrahentController.text});
                  },
                  icon: const Icon(Icons.add_circle)),
            ],
          )
        ]),
      ),
    );
  }
}

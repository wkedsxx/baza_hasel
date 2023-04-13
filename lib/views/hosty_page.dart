import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HostyPage extends StatefulWidget {
  const HostyPage({super.key});

  @override
  State<HostyPage> createState() => _HostyPageState();
}

class _HostyPageState extends State<HostyPage> {
  CollectionReference hosty = FirebaseFirestore.instance.collection('hosty');
  var newHostController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zarządzanie hostami'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(children: [
          Row(
            children: [
              const Text('Nowy host:'),
              SizedBox(
                  width: 100, child: TextField(controller: newHostController)),
              IconButton(
                  onPressed: () {
                    // Map<String, dynamic> newKontrahent = {
                    //   'nazwa': newKontrahentController..text
                    // };
                    hosty.add({'nazwa': newHostController.text});
                    setState(() {
                      newHostController.text = '';
                    });
                  },
                  icon: const Icon(Icons.add_circle)),
            ],
          ),
          const Text('Lista hostów:'),
          FutureBuilder(
            future: hosty.orderBy('nazwa').get(),
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
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widgetList);
              }
              return const Text('Ładowanie');
            },
          ),
        ]),
      ),
    );
  }
}

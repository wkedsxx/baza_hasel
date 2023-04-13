import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TypyKontPage extends StatefulWidget {
  const TypyKontPage({super.key});

  @override
  State<TypyKontPage> createState() => _TypyKontPageState();
}

class _TypyKontPageState extends State<TypyKontPage> {
  CollectionReference typyKont =
      FirebaseFirestore.instance.collection('typy kont');
  var newTypKontaController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zarządzanie typami kont'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(children: [
          Row(
            children: [
              const Text('Nowy typ konta:'),
              SizedBox(
                  width: 100,
                  child: TextField(controller: newTypKontaController)),
              IconButton(
                  onPressed: () {
                    // Map<String, dynamic> newKontrahent = {
                    //   'nazwa': newKontrahentController..text
                    // };
                    typyKont.add({'nazwa': newTypKontaController.text});
                    setState(() {
                      newTypKontaController.text = '';
                    });
                  },
                  icon: const Icon(Icons.add_circle)),
            ],
          ),
          const Text('Lista typów kont:'),
          FutureBuilder(
            future: typyKont.orderBy('nazwa').get(),
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

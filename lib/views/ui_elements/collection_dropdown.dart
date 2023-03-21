import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CollectionDropdown extends StatefulWidget {
  final CollectionReference collectionRef;
  const CollectionDropdown({super.key, required this.collectionRef});

  @override
  State<CollectionDropdown> createState() => _CollectionDropdownState();
}

class _CollectionDropdownState extends State<CollectionDropdown> {
  late CollectionReference collectionRef;
  late Future<QuerySnapshot<Object?>> collectionRefGet;
  String? dropdownValue;
  @override
  void initState() {
    super.initState();
    collectionRef = widget.collectionRef;
    collectionRefGet = collectionRef.get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: collectionRefGet,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            dropdownValue ??= snapshot.data!.docs.first['nazwa'].toString();
            return DropdownButton(
              items: [
                for (var doc in snapshot.data!.docs)
                  DropdownMenuItem(
                    value: doc['nazwa'].toString(),
                    child: Text(doc['nazwa']),
                  )
              ],
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              value: dropdownValue,
            );
          }
          return const Text('Ładowanie...');
        });
  }
}

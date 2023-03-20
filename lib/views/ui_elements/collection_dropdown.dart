import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CollectionDropdown extends StatefulWidget {
  final CollectionReference collectionRef;
  const CollectionDropdown({super.key, required this.collectionRef});

  @override
  State<CollectionDropdown> createState() => _CollectionDropdownState();
}

class _CollectionDropdownState extends State<CollectionDropdown> {
  String dropdownValue = '';
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.collectionRef.get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
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
            );
          }
          return const Text('Ładowanie...');
        });
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CollectionDropdown extends StatefulWidget {
  final String? additionalValue;
  final CollectionReference collectionRef;
  final Function callback;
  const CollectionDropdown(
      {super.key,
      required this.collectionRef,
      required this.callback,
      this.additionalValue});

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
    collectionRefGet = collectionRef.orderBy('nazwa').get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: collectionRefGet,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return DropdownButton(
              items: [
                if (widget.additionalValue != null)
                  DropdownMenuItem(
                    value: widget.additionalValue,
                    child: Text(widget.additionalValue!),
                  ),
                for (var doc in snapshot.data!.docs)
                  DropdownMenuItem(
                    value: doc['nazwa'].toString(),
                    child: Text(doc['nazwa']),
                  )
              ],
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                  widget.callback(newValue);
                });
              },
              value: dropdownValue,
            );
          }
          return const Text('Ładowanie...');
        });
  }
}

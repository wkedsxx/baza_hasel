import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KontoDetailsPage extends StatefulWidget {
  const KontoDetailsPage({super.key, required this.kontoDocId});

  final String kontoDocId;
  @override
  State<KontoDetailsPage> createState() => _KontoDetailsPageState();
}

class _KontoDetailsPageState extends State<KontoDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Szczegóły konta'),
        ),
        body: Text(widget.kontoDocId));
  }
}

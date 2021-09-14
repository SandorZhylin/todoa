import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TodosCollection extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void addItem(String title) {
    _firestore.collection('Todos').add(
      {
        'todo': title,
        'isSelected': false,
      },
    );
  }

  void updateItem(String id, bool isSelected, String title) {
    _firestore.collection('Todos').doc(id).update(
      {
        'isSelected': isSelected,
      },
    );
  }

  void deleteItem(String id) {
    _firestore.collection('Todos').doc(id).delete();
  }

  getCollectionAsSteam() => _firestore.collection('Todos').snapshots();
}

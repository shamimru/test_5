import 'package:flutter/material.dart';

class Person {
  int? id;
  String name;
  String contact;

  Person({this.id, required this.name, required this.contact});

  // Convert a Person to a Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'contact': contact,
    };
  }

  // Create a Person from a Map (JSON)
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      name: json['name'],
      contact: json['contact'],
    );
  }
}

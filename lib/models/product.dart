// // models/product.dart
// class Product {
//   final int? id;
//   final String name;
//   final String description;
//   final double price;
//   final String image;

//   Product(
//       {this.id,
//       required this.name,
//       required this.description,
//       required this.price,
//       required this.image});

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'name': name,
//       'description': description,
//       'price': price,
//       'image': image
//     };
//   }

//   static Product fromMap(Map<String, dynamic> map) {
//     return Product(
//       id: map['id'],
//       name: map['name'],
//       description: map['description'],
//       price: map['price'],
//       image: map['image'],
//     );
//   }
// }

import 'package:hive/hive.dart';

part 'product.g.dart'; // Make sure this line is present

@HiveType(typeId: 0)
class Product {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  @HiveField(3)
  double price;

  @HiveField(4)
  String image;

  Product(
      {this.id,
      required this.name,
      required this.description,
      required this.price,
      required this.image});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
      image: map['image'],
    );
  }
}

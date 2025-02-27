// // viewmodels/product_viewmodel.dart
// import 'package:flutter/material.dart';
// import 'package:productapp/services/db_services.dart';
// import '../models/product.dart';

// class ProductViewModel with ChangeNotifier {
//   List<Product> _products = [];
//   List<Product> _filteredProducts = [];

//   List<Product> get products => _products;

//   Future<void> fetchProducts() async {
//     _products = await DBService.instance.getProducts();

//     _filteredProducts = _products;
//     notifyListeners();
//   }

//   Future<void> addProduct(Product product) async {
//     await DBService.instance.insertProduct(product);
//     await fetchProducts();
//   }

//   Future<void> updateProduct(Product product) async {
//     await DBService.instance.updateProduct(product);
//     await fetchProducts();
//   }

//   Future<void> deleteProduct(int id) async {
//     await DBService.instance.deleteProduct(id);
//     await fetchProducts();
//   }

//   // Future<void> searchProduct(String query) async {
//   //   await DBService.instance.searchProduct(query);
//   //   await fetchProducts();
//   // }

//   void searchProducts(String query) {
//     if (query.isEmpty) {
//       _filteredProducts = _products;
//     } else {
//       _filteredProducts = _products
//           .where((product) =>
//               product.name.toLowerCase().contains(query.toLowerCase()) ||
//               product.description.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     }
//     notifyListeners();
//   }
// }

import 'package:flutter/material.dart';
import 'package:productapp/services/db_services.dart';
import '../models/product.dart';

class ProductViewModel with ChangeNotifier {
  // bool isGridView = true;
  List<Product> _products = [];
  List<Product> get products => _products;

  Future<void> fetchProducts() async {
    _products = DBService.instance.getProducts();
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    await DBService.instance.insertProduct(product);
    fetchProducts();
  }

  Future<void> updateProduct(int index, Product product) async {
    await DBService.instance.updateProduct(index, product);
    fetchProducts();
  }

  Future<void> deleteProduct(int index) async {
    await DBService.instance.deleteProduct(index);
    fetchProducts();
  }

  void searchProducts(String query) {
    _products = DBService.instance.searchProducts(query);
    notifyListeners();
  }
}

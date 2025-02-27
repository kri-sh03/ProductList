// // views/admin_dashboard.dart
// import 'package:flutter/material.dart';
// import 'package:productapp/viewmodel/product_viewmodel.dart';
// import 'package:provider/provider.dart';
// import '../models/product.dart';

// class AdminDashboard extends StatelessWidget {
//   const AdminDashboard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final productViewModel = Provider.of<ProductViewModel>(context);

//     return Scaffold(
//       appBar: AppBar(title: Text('Admin Dashboard')),
//       body: FutureBuilder(
//         future: productViewModel.fetchProducts(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           return ListView.builder(
//             itemCount: productViewModel.products.length,
//             itemBuilder: (context, index) {
//               final product = productViewModel.products[index];
//               return ListTile(
//                 title: Text(product.name),
//                 subtitle: Text(product.description),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.edit),
//                       onPressed: () {
//                         _showProductDialog(context, product, productViewModel);
//                       },
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.delete),
//                       onPressed: () {
//                         productViewModel.deleteProduct(product.id!);
//                       },
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _showProductDialog(context, null, productViewModel);
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }

//   void _showProductDialog(BuildContext context, Product? product,
//       ProductViewModel productViewModel) {
//     final nameController = TextEditingController(text: product?.name ?? '');
//     final descriptionController =
//         TextEditingController(text: product?.description ?? '');
//     final priceController =
//         TextEditingController(text: product?.price.toString() ?? '');
//     final imageController = TextEditingController(text: product?.image ?? '');

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(product == null ? 'Add Product' : 'Edit Product'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                   controller: nameController,
//                   decoration: InputDecoration(labelText: 'Name')),
//               TextField(
//                   controller: descriptionController,
//                   decoration: InputDecoration(labelText: 'Description')),
//               TextField(
//                   controller: priceController,
//                   decoration: InputDecoration(labelText: 'Price'),
//                   keyboardType: TextInputType.number),
//               TextField(
//                   controller: imageController,
//                   decoration: InputDecoration(labelText: 'Image URL')),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 final newProduct = Product(
//                   id: product?.id,
//                   name: nameController.text,
//                   description: descriptionController.text,
//                   price: double.tryParse(priceController.text) ?? 0.0,
//                   image: imageController.text,
//                 );
//                 if (product == null) {
//                   productViewModel.addProduct(newProduct);
//                 } else {
//                   productViewModel.updateProduct(newProduct);
//                 }
//                 Navigator.pop(context);
//               },
//               child: Text('Save'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:productapp/viewmodel/product_viewmodel.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import 'package:productapp/router/route.dart' as route;

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final productViewModel = Provider.of<ProductViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard', style: TextStyle(fontSize: 22)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.power_settings_new, size: 28),
              onSelected: (value) {
                if (value == 'logout') {
                  _showLogoutConfirmationDialog(context);
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.red),
                      SizedBox(width: 10),
                      Text('Logout', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: productViewModel.products.isEmpty
          ? const Center(
              child: Text(
                "No products available",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: productViewModel.products.length,
              itemBuilder: (context, index) {
                final product = productViewModel.products[index];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    title: Text(
                      product.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      product.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showProductDialog(
                              context, product, productViewModel, index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              _confirmDelete(context, productViewModel, index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _showProductDialog(context, null, productViewModel, -1),
        backgroundColor: Colors.indigo,
        tooltip: 'Add Product',
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),
    );
  }

  void _showProductDialog(BuildContext context, Product? product,
      ProductViewModel productViewModel, int index) {
    final _formKey = GlobalKey<FormState>(); // Validation Key
    final nameController = TextEditingController(text: product?.name ?? '');
    final descriptionController =
        TextEditingController(text: product?.description ?? '');
    final priceController =
        TextEditingController(text: product?.price.toString() ?? '');
    final imageController = TextEditingController(text: product?.image ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            product == null ? 'Add Product' : 'Edit Product',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(nameController, 'Name', Icons.label),
                  _buildTextField(
                      descriptionController, 'Description', Icons.description),
                  _buildTextField(priceController, 'Price', Icons.attach_money,
                      keyboardType: TextInputType.number),
                  _buildTextField(imageController, 'Image URL', Icons.image),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(fontSize: 16)),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final newProduct = Product(
                    id: product?.id,
                    name: nameController.text,
                    description: descriptionController.text,
                    price: double.tryParse(priceController.text) ?? 0.0,
                    image: imageController.text,
                  );
                  if (product == null) {
                    productViewModel.addProduct(newProduct);
                  } else {
                    productViewModel.updateProduct(index, newProduct);
                  }
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text('Save',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, ProductViewModel productViewModel, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this product?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                productViewModel.deleteProduct(index);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child:
                  const Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}

void _showLogoutConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close dialog
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(
                  context, route.productList); // Navigate to Product List
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('Logged out successfully'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Yes', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}

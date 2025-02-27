import 'package:flutter/material.dart';
import 'package:productapp/router/route.dart' as route;
import 'package:productapp/viewmodel/product_viewmodel.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';

class ProductListView extends StatefulWidget {
  const ProductListView({super.key});

  @override
  _ProductListViewState createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  TextEditingController searchController = TextEditingController();
  bool isGridView = true;
  int pageSize = 2; // Default items per page
  int currentPage = 1;
  bool showAll = false; // New flag for "All" option

  @override
  Widget build(BuildContext context) {
    final productViewModel = Provider.of<ProductViewModel>(context);
    final products = productViewModel.products;

    // Pagination logic
    final totalPages = (products.length / pageSize).ceil();

    final startIndex = showAll ? 0 : (currentPage - 1) * pageSize;
    final endIndex = showAll
        ? products.length
        : (currentPage * pageSize).clamp(0, products.length);
    final pageItems = products.sublist(startIndex, endIndex);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List', style: TextStyle(fontSize: 20)),
        actions: [
          IconButton(
            icon: Icon(isGridView ? Icons.list : Icons.grid_view, size: 28),
            onPressed: () {
              setState(() {
                isGridView = !isGridView;
              });
            },
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, route.loginScreen);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15),
            ),
            child: const Text('Admin Login',
                style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search Products',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                productViewModel.searchProducts(value);
              },
            ),
          ),
          // Pagination Controls
          Visibility(
            visible: !isGridView,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Products per Page: '),
                DropdownButton<int>(
                  value: showAll ? -1 : pageSize,
                  items: [2, 4, 6, 10, -1].map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: value == -1
                          ? const Text('All')
                          : Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    setState(() {
                      if (newValue == -1) {
                        showAll = true;
                      } else {
                        showAll = false;
                        pageSize = newValue!;
                        currentPage = 1; // Reset to first page
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: isGridView
                ? GridView.builder(
                    padding: const EdgeInsets.all(10.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: pageItems.length,
                    itemBuilder: (context, index) {
                      return _buildProductCard(pageItems[index]);
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: pageItems.length,
                    itemBuilder: (context, index) {
                      return _buildProductCard(pageItems[index]);
                    },
                  ),
          ),
          // Pagination Buttons (Hide if "All" is selected)
          if (!showAll && !isGridView)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (currentPage > 1)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentPage--;
                      });
                    },
                    child: const Text('Previous Page'),
                  ),
                if (currentPage < totalPages)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentPage++;
                      });
                    },
                    child: const Text('Next Page'),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(
              product.image,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  product.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  'Price: \$${product.price.toString()}',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

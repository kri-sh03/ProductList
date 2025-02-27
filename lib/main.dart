// import 'package:flutter/material.dart';
// import 'package:productapp/services/db_services.dart';
// import 'package:productapp/viewmodel/product_viewmodel.dart';
// import 'package:provider/provider.dart';
// import 'package:productapp/router/route.dart' as route;

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await DBService.instance.initDB();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => ProductViewModel(),
//       child: MaterialApp(
//         onGenerateRoute: route.controller,
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData.light(),
//         darkTheme: ThemeData.dark(),
//         themeMode: ThemeMode.system,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:productapp/models/product.dart';
import 'package:productapp/services/db_services.dart';
import 'package:productapp/viewmodel/product_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'views/admin_dashboard.dart';
import 'package:productapp/router/route.dart' as route;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());
  await DBService.instance.initDB();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductViewModel()..fetchProducts(),
      child: MaterialApp(
        onGenerateRoute: route.controller,
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        // home: AdminDashboard(),
      ),
    );
  }
}

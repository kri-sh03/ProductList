import 'package:flutter/material.dart';
import 'package:productapp/views/admin_dashboard.dart';
import 'package:productapp/views/login_view.dart';
import 'package:page_transition/page_transition.dart';
import 'package:productapp/views/productlist_view.dart';

const productList = "/";
const loginScreen = "/login";
const adminDashnoard = "/dashboard";

// Map routeNames = {
//   adminDashnoard = "Dashboard",
// };
Route<dynamic> controller(RouteSettings settings) {
  Widget page;
  switch (settings.name) {
    case productList:
      page = const ProductListView();
      break;
    case loginScreen:
      page = LoginView();
      break;
    case adminDashnoard:
      page = const AdminDashboard();
      break;
    default:
      throw Exception("Error");
  }

  return PageTransition(child: page, type: PageTransitionType.rightToLeft);
}

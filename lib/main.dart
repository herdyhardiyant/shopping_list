import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import './provider/shop_list_data.dart';
import './pages/shopping_list_page.dart';
import './pages/login_page.dart';
import './pages/register_page.dart';
import './authentication/user.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const ShoppingList());
}

class ShoppingList extends StatelessWidget {
  const ShoppingList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (ctx) => ShopListData()),
        ChangeNotifierProvider(create: (ctx) => User())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.dark(),
        home: const RegisterPage(),
        routes: {
          LoginPage.routeName: (ctx) => const LoginPage(),
          RegisterPage.routeName: (ctx) => const RegisterPage(),
          ShoppingListPage.routeName: (ctx) => const ShoppingListPage()
        },
      ),
    );
  }
}

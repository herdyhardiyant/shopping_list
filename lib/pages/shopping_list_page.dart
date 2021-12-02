import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/shop_item.dart';
import '../provider/shop_list_data.dart';
import '../authentication/user.dart';
import './login_page.dart';

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({Key? key}) : super(key: key);
  static const routeName = '/shopping-list';

  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  late List<ShopItem>? _shoppingList;
  late bool _isLoading;

  @override
  void initState() {
    _isLoading = true;
    _loadItemsToList();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _loadItemsToList() {
    try {
      Provider.of<ShopListData>(context, listen: false)
          .retrieveItems()
          .then((items) {
        if (items!.isNotEmpty) {
          _shoppingList = items;
        } else {
          _shoppingList = [];
        }
      }).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      _showError;
    }
  }

  Future get _showError {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text("Error occurred"),
              content: const Text("Failed to load item list"),
              actions: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        _isLoading = false;
                      });
                      Navigator.pop(context);
                    },
                    child: const Text("Yeah"))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    var isAuthorized = Provider.of<User>(context).isAuthorized;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Shopping List"),
          actions: isAuthorized ? [logout] : [const Icon(Icons.block)],
        ),
        persistentFooterButtons:
            isAuthorized ? [_addItemListButton] : [const Icon(Icons.block)],
        body: widgetBody);
  }

  Widget get widgetBody {
    var isAuthorized = Provider.of<User>(context).isAuthorized;
    if (!isAuthorized) {
      return _unauthorizedScreen;
    }
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return _buildShoppingList;
    }
  }

  Widget get logout {
    return IconButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: const Text("Logout"),
                    content: const Text("Are you sure you want to logout?"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushReplacementNamed(
                                context, LoginPage.routeName);
                          },
                          child: const Text("Yes")),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("No"))
                    ],
                  ));
        },
        icon: const Icon(Icons.logout));
  }

  Widget get _unauthorizedScreen {
    return Center(
      child: Column(
        children: [
          const Text("You are unauthorized!"),
          TextButton(
              onPressed: () {
                Navigator.of(context).popAndPushNamed(LoginPage.routeName);
              },
              child: const Text("Login Here"))
        ],
      ),
    );
  }

  Widget get _buildShoppingList {
    if (_shoppingList!.isEmpty) {
      return const Center(child: Text("You don't have any items..."));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemBuilder: (ctx, index) {
        return _buildShoppingListItem(_shoppingList![index]);
      },
      itemCount: _shoppingList!.length,
    );
  }

  Widget _buildShoppingListItem(ShopItem item) {
    var normalTextItem = Text(
      item.name,
      style: const TextStyle(decoration: TextDecoration.none),
    );
    var lineThroughTextItem = Text(
      item.name,
      style: const TextStyle(
          decoration: TextDecoration.lineThrough,
          decorationColor: Colors.black,
          decorationThickness: 4),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: const BorderRadius.all(Radius.circular(4))),
        child: ListTile(
          onTap: () {
            item.isCheck = !item.isCheck;
            Provider.of<ShopListData>(context, listen: false)
                .updateItem(item)
                .catchError((_) {
              setState(() {
                item.isCheck = !item.isCheck;
              });
            }).then((_) {
              setState(() {
                _loadItemsToList();
              });
            });
          },
          title: item.isCheck ? lineThroughTextItem : normalTextItem,
          trailing: item.isCheck
              ? _deleteItemListButton(item)
              : _buildEditItemListButton(item),
        ),
      ),
    );
  }

  Widget _buildEditItemListButton(ShopItem item) {
    return IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () {
          final textFieldController = TextEditingController(text: item.name);
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (_) => AlertDialog(
                    elevation: 24,
                    title: const Text("Edit text"),
                    content: TextField(
                      controller: textFieldController,
                    ),
                    actions: [
                      TextButton(
                        child: const Text("Apply"),
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                          });
                          item.name = textFieldController.text;
                          Navigator.pop(context);
                          setState(() {
                            Provider.of<ShopListData>(context, listen: false)
                                .updateItem(item)
                                .catchError((_) => _showError)
                                .then((_) {
                              setState(() {
                                _loadItemsToList();
                                _isLoading = false;
                              });
                            });
                          });
                        },
                      ),
                      TextButton(
                        child: const Text("Cancel"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ));
        });
  }

  Widget _deleteItemListButton(ShopItem item) {
    return IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (_) => AlertDialog(
                    elevation: 24,
                    title: const Text("Remove item"),
                    content: const Text("Do you want to remove this item?"),
                    actions: [
                      TextButton(
                        child: const Text("Yes"),
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            _isLoading = true;
                          });
                          Provider.of<ShopListData>(context, listen: false)
                              .deleteItem(item)
                              .then((_) {
                            setState(() {
                              _loadItemsToList();
                              _isLoading = false;
                            });
                          });
                        },
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("No"))
                    ],
                  ));
        });
  }

  Widget get _addItemListButton {
    return IconButton(
      icon: const Icon(Icons.add_circle_outline),
      onPressed: () {
        final textFieldController = TextEditingController();
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (_) => AlertDialog(
                  elevation: 24,
                  title: const Text("Add item"),
                  content: TextField(
                    controller: textFieldController,
                  ),
                  actions: [
                    TextButton(
                        child: const Text("Submit"),
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            _isLoading = true;
                          });
                          Provider.of<ShopListData>(context, listen: false)
                              .addItem(textFieldController.text)
                              .then((_) {
                            setState(() {
                              _loadItemsToList();
                              _isLoading = false;
                            });
                          });
                        }),
                    TextButton(
                        child: const Text("Cancel"),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ],
                ));
      },
    );
  }
}

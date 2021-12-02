import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './shop_item.dart';
import '../authentication/user.dart';

class ShopListData with ChangeNotifier {
  late List<ShopItem> _items;

  Future<void> addItem(String itemName) async {
    final uri = Uri.parse(
        'https://shopping-list-f6c78-default-rtdb.asia-southeast1.firebasedatabase.app/user/${User.userId}/item.json');
    try {
      await http.post(uri,
          body: json.encode({'name': itemName, 'isCheck': false}));
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> _getItemsFromDatabase() async {
    final uri = Uri.parse(
        'https://shopping-list-f6c78-default-rtdb.asia-southeast1.firebasedatabase.app/user/${User.userId}/item.json');

    try {
      final response = await http.get(uri);
      Map<String, dynamic> decodedItems = json.decode(response.body);
      List<ShopItem> loadedItems = [];
      decodedItems.forEach((itemId, item) {
        loadedItems.add(
            ShopItem(name: item["name"], id: itemId, isCheck: item["isCheck"]));
      });
      _items = loadedItems;
      notifyListeners();
    } catch (error) {
      _items = [];
      return;
    }
  }

  Future<List<ShopItem>?> retrieveItems() async {
    await _getItemsFromDatabase();
    return [..._items];
  }

  Future<void> deleteItem(ShopItem item) async {
    final uri = Uri.parse(
        'https://shopping-list-f6c78-default-rtdb.asia-southeast1.firebasedatabase.app/user/${User.userId}/item/${item.id}.json');
    await http.delete(uri);
  }

  Future<void> updateItem(ShopItem item) async {
    final uri = Uri.parse(
        'https://shopping-list-f6c78-default-rtdb.asia-southeast1.firebasedatabase.app/user/${User.userId}/item/${item.id}.json');
    await http.patch(uri,
        body: json.encode({'name': item.name, 'isCheck': item.isCheck}));
  }
}

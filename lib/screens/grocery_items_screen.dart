import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list_app/data/categories.dart';

import 'package:shopping_list_app/models/grocery_item.dart';
import 'package:shopping_list_app/screens/new_Item_screen.dart';

class GroceryItemsScreen extends StatefulWidget {
  const GroceryItemsScreen({super.key});

  @override
  State<GroceryItemsScreen> createState() => _GroceryItemsScreenState();
}

class _GroceryItemsScreenState extends State<GroceryItemsScreen> {
  List<GroceryItem> _groceryItems = [];
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    // TODO: implement initState
    _loadItems();
    super.initState();
  }

  void _loadItems() async {
    final url = Uri.https('flutter-shop-app-cc6dc-default-rtdb.firebaseio.com',
        'shopping-list.json');

    final response = await http.get(url);
    if (response.statusCode > 400) {
      setState(() {
        _error = "Something went wrong!";
      });
    }

    if (response.body == 'null') {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    final responseDecoded = json.decode(response.body);

    List<GroceryItem> _loadedItems = [];

    for (final item in responseDecoded.entries) {
      final category = categories.entries
          .firstWhere((element) => element.value.name == item.value['category'])
          .value;

      final eachItem = GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category);
      _loadedItems.add(eachItem);
    }

    setState(() {
      _groceryItems = _loadedItems;
      _isLoading = false;
    });
    print(_groceryItems);
  }

  void _addItem() async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const NewItemScreen()));

    _loadItems();
  }

  void _removeItem(GroceryItem item) async {
    final index = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.removeAt(index);
    });

    final url = Uri.https('flutter-shop-app-cc6dc-default-rtdb.firebaseio.com',
        'shopping-list/${item.id}.json');

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      setState(() {
        _groceryItems.insert(index, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent;

    if (_isLoading) {
      bodyContent = const Center(
        child: CircularProgressIndicator(),
      );
      if (!(_error == null)) {
        bodyContent = Center(
          child: Text(_error.toString()),
        );
      }
    } else if (_groceryItems.isEmpty) {
      bodyContent = const Center(child: Text("No groceries"));
    } else {
      bodyContent = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          key: ValueKey(_groceryItems[index]),
          onDismissed: (direction) {
            _removeItem(_groceryItems.elementAt(index));
          },
          child: ListTile(
            title: Text(_groceryItems[index].name),
            leading: Container(
              height: 24,
              width: 24,
              color: _groceryItems[index].category.color,
            ),
            trailing: Text(_groceryItems[index].quantity.toString()),
          ),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Your groceries"),
          actions: [
            IconButton(onPressed: _addItem, icon: const Icon(Icons.add))
          ],
        ),
        body: bodyContent);
  }
}

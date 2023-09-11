import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/dummy_items.dart';
import 'package:shopping_list_app/screens/new_Item_screen.dart';

class GroceryItemsScreen extends StatefulWidget {
  const GroceryItemsScreen({super.key});

  @override
  State<GroceryItemsScreen> createState() => _GroceryItemsScreenState();
}

class _GroceryItemsScreenState extends State<GroceryItemsScreen> {
  final _groceryItems = [];
  void _addItem() async {
    final groceryItem = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const NewItemScreen()));

    if (groceryItem.name == null) {
      return;
    }

    setState(() {
      _groceryItems.add(groceryItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your groceries"),
        actions: [IconButton(onPressed: _addItem, icon: Icon(Icons.add))],
      ),
      body: _groceryItems.length == 0
          ? Center(child: Text("No groceries"))
          : ListView.builder(
              itemCount: _groceryItems.length,
              itemBuilder: (ctx, index) => Dismissible(
                key: ValueKey(_groceryItems[index]),
                onDismissed: (direction) {
                  setState(() {
                    _groceryItems.removeAt(index);
                  });
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
            ),
    );
  }
}

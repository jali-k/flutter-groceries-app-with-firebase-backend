import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/categories.dart';

class NewItemScreen extends StatefulWidget {
  const NewItemScreen({super.key});

  @override
  State<NewItemScreen> createState() => _NewItemScreenState();
}

class _NewItemScreenState extends State<NewItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add a new item"),
        ),
        body: Form(
            child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                label: Text("Grocery name"),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      label: Text("Quantity"),
                    ),
                  ),
                ),
                Expanded(
                  child: DropdownButtonFormField(items: [
                    for (final category in categories.entries)
                      DropdownMenuItem(
                          value: category.value,
                          child: Row(
                            children: [
                              Container(
                                height: 24,
                                width: 24,
                                color: category.value.color,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Text(category.value.name)
                            ],
                          ))
                  ], onChanged: (value) {}),
                )
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text("Reset"),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Add item"),
                )
              ],
            )
          ],
        )));
  }
}

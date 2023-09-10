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
    final _formKey = GlobalKey<
        FormState>(); // That gives the access to the internal state of the form.

    void _saveItem() {
      _formKey.currentState!.validate();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Add a new item"),
        ),
        body: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text("Grocery name"),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.length > 50) {
                      return "Must be 1 to 50 characters long";
                    }

                    return null;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          label: Text("Quantity"),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.tryParse(value) == null ||
                              int.tryParse(value)! < 0) {
                            return "Must be 0 or a positive value";
                          }

                          return null;
                        },
                        keyboardType: TextInputType.number,
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
                      onPressed: () {
                        _formKey.currentState!.reset();
                      },
                      child: Text("Reset"),
                    ),
                    ElevatedButton(
                      onPressed: _saveItem,
                      child: Text("Add item"),
                    )
                  ],
                )
              ],
            )));
  }
}

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formGlobalKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Form(
            key: _formGlobalKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //title field
                TextFormField(
                  maxLength: 50,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Title is required';
                    }
                    return null;
                  },
                ),

                // description field
                TextFormField(
                  maxLength: 100,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Description is required';
                    } else if (value.length < 10) {
                      return 'Description must be at least 10 characters';
                    }
                    return null;
                  },
                ),

                // amount field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Amount is required';
                    } else if (value.length < 3) {
                      return 'Amount must be at least 3 digits';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 50),
                //submit button
                ElevatedButton(
                  onPressed: () {
                    if (_formGlobalKey.currentState!.validate()) {
                      print('Form is valid');
                    } else {
                      print('Form is invalid');
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

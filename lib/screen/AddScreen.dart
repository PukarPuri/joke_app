import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:joke/firebaseHelper/firebaseHelper.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  TextEditingController jokeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Joke'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: jokeController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Joke',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (jokeController.text.isEmpty) {
                const snackdemo = SnackBar(
                  content: Text(
                    'Please add a joke',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.all(5),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackdemo);
              } else {
                await FirebaseHelper.instance.addJokeData(jokeController.text);
                const snackdemo = SnackBar(
                  content: Text(
                    'Add Successfully!',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.all(5),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackdemo);
              }
            },
            child: Text('Add'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              fixedSize: Size(200, 50),
              foregroundColor: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:joke/firebaseHelper/firebaseHelper.dart';
import 'package:joke/model/jokeModel.dart';

class EditScreen extends StatefulWidget {
  final jokeModel jokedata;
  const EditScreen({super.key, required this.jokedata});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController jokeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Joke'),
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
                hintText: widget.jokedata.joke.toString(),
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
                jokeModel joked = jokeModel(
                    id: widget.jokedata.id.toString(),
                    joke: jokeController.text,
                    post: FirebaseAuth.instance.currentUser!.uid.toString());
                await FirebaseHelper.instance.updateJoke(joked);
                const snackdemo = SnackBar(
                  content: Text(
                    'Update Successfully!',
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
            child: Text('Update'),
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

import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:joke/firebaseHelper/firebaseHelper.dart';

import 'package:joke/screen/AddScreen.dart';
import 'package:joke/screen/AllJoke.dart';
import 'package:joke/screen/LoginScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int randomNum = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddScreen();
          }));
        },
        child: Icon(Icons.add),
        
      ),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: Text('Joke App'),
      ),
      body: FutureBuilder(
        future: FirebaseHelper.instance.getJokeData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return Text('No data');
          } else {
            int numOfJokes = snapshot.data!.length;
            randomNum = Random().nextInt(numOfJokes);

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      boxShadow: [BoxShadow(spreadRadius: 1)],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          snapshot.data![randomNum].joke.toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'FontMain',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // Generate a new random index
                      randomNum = Random().nextInt(numOfJokes);
                    });
                  },
                  child: Text('Random Joke'), // Change the button text
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    fixedSize: Size(200, 50),
                    foregroundColor: Colors.white,
                  ),
                ),
                
              ],
            );
          }
        },
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ListTile(
                      title: Text("Home"),
                      leading: Icon(Icons.home_outlined),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return AllJokeScreen();
                        })).then((value) {
                          Navigator.pop(context);
                        });
                      }),
                  ListTile(
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    title: Text("Logout"),
                    leading: Icon(Icons.logout),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

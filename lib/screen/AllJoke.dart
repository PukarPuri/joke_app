import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:joke/firebaseHelper/firebaseHelper.dart';
import 'package:joke/model/jokeModel.dart';
import 'package:joke/screen/AddScreen.dart';
import 'package:joke/screen/AllJoke.dart';
import 'package:joke/screen/EditScren.dart';

class AllJokeScreen extends StatefulWidget {
  const AllJokeScreen({super.key});

  @override
  State<AllJokeScreen> createState() => _AllJokeScreenState();
}

class _AllJokeScreenState extends State<AllJokeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: Text('All Joke'),
      ),
      body: FutureBuilder(
          future: FirebaseHelper.instance.getJokeData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || snapshot.data == null) {
              return Center(child: Text('Empty'));
            } else {
              return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: double.infinity,
                      margin: EdgeInsets.all(5),
                      height: 100,
                      decoration: BoxDecoration(
                        boxShadow: [BoxShadow(spreadRadius: 1)],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 310,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  snapshot.data![index].joke.toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: 'FontMain',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (FirebaseAuth.instance.currentUser!.uid ==
                              snapshot.data![index].post.toString())
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => EditScreen(
                                                  jokedata:
                                                      snapshot.data![index])));
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.teal,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  InkWell(
                                    onTap: () async {
                                      setState(() {});
                                      await FirebaseHelper.instance.deleteJoke(
                                          snapshot.data![index].id.toString());

                                      setState(() {});
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            )
                        ],
                      ),
                    );
                  });
            }
          }),
    );
  }
}

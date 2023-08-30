import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:joke/model/jokeModel.dart';

class FirebaseHelper {
  static FirebaseHelper instance = FirebaseHelper();

  Future<String> registration(
      {required String email,
      required String password,
      required String name}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return e.message.toString();
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return e.message.toString();
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<List<jokeModel>> getJokeData() async {
    try {
      final jokes = await FirebaseFirestore.instance.collection('jokes').get();
      final data = jokes.docs.map((e) => jokeModel.fromJson(e.data())).toList();
      debugPrint('get joke data');
      return data;
    } catch (e) {
      debugPrint('error');
      throw Exception(e.toString());
      
    }
  }

  Future<jokeModel> addJokeData(String jokedata) async {
    try {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('jokes').doc();
      jokeModel joke = jokeModel(
          id: documentReference.id,
          joke: jokedata,
          post: FirebaseAuth.instance.currentUser!.uid.toString());
      await documentReference.set(joke.toJson());
      return joke;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> deleteJoke(String id) async {
    try {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('jokes').doc(id);
      await documentReference.delete();
      const snackdemo = SnackBar(
        content: Text(
          'Delete Joke',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(5),
      );
      return 'Delete';
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> updateJoke(jokeModel joke) async {
    try {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('jokes').doc(joke.id);
      await documentReference.update(joke.toJson());
      debugPrint('update');
      return 'Update successfully';
    } catch (e) {
      debugPrint('error');

      throw Exception(e.toString());
    }
  }

  getUserInfo() {}
}

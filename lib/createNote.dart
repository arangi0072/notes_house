import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class createNotePage extends StatefulWidget {
  var myString;

  createNotePage({required this.myString, Key? key});

  @override
  _createNotePageState createState() => _createNotePageState();
}

class _createNotePageState extends State<createNotePage> {
  final noteController = TextEditingController();
  final noteController1 = TextEditingController();
  String key = '';
  bool loading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.myString.toString().isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(109, 216, 180, 1),
          title: const Text(
            "Notes Editor",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop(); // Add functionality to navigate back
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 10,
            child: Padding(
              padding: const EdgeInsets.only(top: 5.0, right: 8, left: 8),
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.5,
                      ),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(2)),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: TextField(
                        controller: noteController1,
                        maxLines: 1,
                        style: const TextStyle(fontSize: 20),
                        // This allows for infinite lines.
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Title ..."),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: noteController,
                      maxLines: 5000,
                      style: const TextStyle(fontSize: 16),
                      // This allows for infinite lines.
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Write Notes Here..."),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: DotLottieLoader.fromAsset(
                          "assets/lottie/process.lottie", frameBuilder:
                              (BuildContext ctx, DotLottie? dotlottie) {
                        if (dotlottie != null) {
                          return Lottie.memory(
                              dotlottie.animations.values.single,
                              fit: BoxFit.fill);
                        } else {
                          return Container();
                        }
                      }),
                    ),
                  ),
                );
              },
            );
            User? user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              String userId =
                  user.uid; // Get the user id from Firebase Authentication
              String textToSave = noteController.text;
              String title = noteController1.text;
              if (key.isEmpty) {
                DatabaseReference id = FirebaseDatabase.instanceFor(
                        app: Firebase.app(),
                        databaseURL:
                            "")
                    .reference()
                    .child(userId)
                    .push();
                key = id.key!;
                await id.set({
                  'note': textToSave,
                  'title': title,
                  'timestamp': ServerValue.timestamp,
                });
                final FirebaseFirestore db = FirebaseFirestore.instance;
                await db.collection(userId).doc(key).set({
                  'note': textToSave.length > 60
                      ? textToSave.substring(0, 60)
                      : textToSave,
                  'title': title,
                  'timestamp': FieldValue.serverTimestamp(),
                });
                Navigator.pop(context);
                Fluttertoast.showToast(
                    msg: "Saved successfully!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else {
                DatabaseReference id = FirebaseDatabase.instanceFor(
                        app: Firebase.app(),
                        databaseURL:
                            "")
                    .reference()
                    .child(userId)
                    .child(key);
                await id.set({
                  'note': textToSave,
                  'title': title,
                  'timestamp': ServerValue.timestamp,
                });
                final FirebaseFirestore db = FirebaseFirestore.instance;
                await db.collection(userId).doc(key).set({
                  'note': textToSave.length > 60
                      ? textToSave.substring(0, 60)
                      : textToSave,
                  'title': title,
                  'timestamp': FieldValue.serverTimestamp(),
                });
                Navigator.pop(context);
                Fluttertoast.showToast(
                    msg: "Updated successfully!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
            }
          },
          child: const Icon(
            Icons.upload_file,
            size: 33,
          ),
        ),
      );
    } else {
      DatabaseReference dbRef = FirebaseDatabase.instanceFor(
              app: Firebase.app(),
              databaseURL:
                  "")
          .reference()
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child(widget.myString);
      dbRef.once().then((DatabaseEvent event) {
        if (loading) {
          setState(() {
            loading = false;
          });
          Object? data = event.snapshot.value;
          Map<Object?, Object?> p = data as Map<Object?, Object?>;
          noteController.text = p['note'].toString();
          noteController1.text = p['title'].toString();
        }
      }).catchError((error) {
        print('Failed to read data: $error');
      });
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(109, 216, 180, 1),
          title: const Text(
            "Notes Editor",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop(); // Add functionality to navigate back
            },
          ),
        ),
        body: loading
            ? SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: DotLottieLoader.fromAsset(
                        "assets/lottie/process.lottie",
                        frameBuilder: (BuildContext ctx, DotLottie? dotlottie) {
                      if (dotlottie != null) {
                        return Lottie.memory(dotlottie.animations.values.single,
                            fit: BoxFit.fill);
                      } else {
                        return Container();
                      }
                    }),
                  ),
                ),
              )
            : SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 10,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5.0, right: 8, left: 8),
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.5,
                            ),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(2)),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: TextField(
                              controller: noteController1,
                              maxLines: 1,
                              style: const TextStyle(fontSize: 20),
                              // This allows for infinite lines.
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Title ..."),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: noteController,
                            maxLines: null,
                            style: const TextStyle(fontSize: 16),
                            // This allows for infinite lines.
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Write Notes Here..."),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: DotLottieLoader.fromAsset(
                          "assets/lottie/process.lottie", frameBuilder:
                              (BuildContext ctx, DotLottie? dotlottie) {
                        if (dotlottie != null) {
                          return Lottie.memory(
                              dotlottie.animations.values.single,
                              fit: BoxFit.fill);
                        } else {
                          return Container();
                        }
                      }),
                    ),
                  ),
                );
              },
            );
            User? user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              String userId =
                  user.uid; // Get the user id from Firebase Authentication
              String textToSave = noteController.text;
              String title = noteController1.text;
              DatabaseReference id = FirebaseDatabase.instanceFor(
                      app: Firebase.app(),
                      databaseURL:
                          "")
                  .reference()
                  .child(userId)
                  .child(widget.myString);
              await id.set({
                'note': textToSave,
                'title': title,
                'timestamp': ServerValue.timestamp,
              });
              final FirebaseFirestore db = FirebaseFirestore.instance;
              await db.collection(userId).doc(widget.myString).set({
                'note': textToSave.length > 60
                    ? textToSave.substring(0, 60)
                    : textToSave,
                'title': title,
                'timestamp': FieldValue.serverTimestamp(),
              });
              Navigator.pop(context);
              Fluttertoast.showToast(
                  msg: "Updated successfully!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          },
          child: const Icon(
            Icons.upload_file,
            size: 33,
          ),
        ),
      );
    }
  }
}

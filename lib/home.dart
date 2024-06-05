import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:notes_house/createNote.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes_house/main.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSearching = false;
  final searchText = TextEditingController();
  String searchTextString = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(109, 216, 180, 1),
        title: _isSearching ? _buildSearchField() :
        const Text("Notes House", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        actions: _buildActions(),
      ),
      body: Stack(children: [
        SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * .85,
            child: StreamBuilder<QuerySnapshot>(
              stream: (searchTextString.trim().isEmpty) ? FirebaseFirestore.instance
                  .collection(FirebaseAuth.instance.currentUser!.uid)
                  .orderBy('timestamp', descending: true)
                  .snapshots() : FirebaseFirestore.instance
                  .collection(FirebaseAuth.instance.currentUser!.uid).where("title", isGreaterThanOrEqualTo: searchText.text)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: Center(
                        child: DotLottieLoader.fromAsset(
                            "assets/lottie/process.lottie", frameBuilder:
                                (BuildContext ctx, DotLottie? dotlottie) {
                          if (dotlottie != null) {
                            return Lottie.memory(
                                dotlottie.animations.values.single);
                          } else {
                            return Container();
                          }
                        }),
                      ),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data?.size == 0) {
                  return Center(
                      child: Lottie.asset("assets/lottie/noData.json"));
                }

                // Display the list of members
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    String formattedDateTime = "";
                    try {
                      Timestamp timestamp =
                          snapshot.data!.docs[index]['timestamp'];
                      DateTime dateTime = timestamp.toDate();
                      formattedDateTime =
                          DateFormat('dd-MM-yyyy h:mm a').format(dateTime);
                    } catch (e) {
                      print(e);
                    }
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => createNotePage(
                                  myString: snapshot.data!.docs[index].id)),
                        );
                      },
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width * .95,
                                constraints: const BoxConstraints(
                                  maxWidth: 500,
                                ),
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
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    // This makes the dialog height dynamic
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .95,
                                        constraints: const BoxConstraints(
                                          maxWidth: 500,
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.only(
                                              top: 2, bottom: 2),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.warning,
                                                color: Colors.red,
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                                child: Text(
                                                  "Delete Note ?",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 2.0, bottom: 2.0),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .95,
                                          constraints: const BoxConstraints(
                                            maxWidth: 500,
                                          ),
                                          height: 2,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.only(top: 2, bottom: 2),
                                        child: Text(
                                          "Are you sure you want to delete this note ?",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 2.0, bottom: 2.0),
                                        child: Text(
                                          snapshot.data!.docs[index]['title'].toString()
                                              .replaceAll('\n', ' '),
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .95,
                                          constraints: const BoxConstraints(
                                            maxWidth: 500,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  // Set your desired background color
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        2.0),
                                                    side: const BorderSide(
                                                      color: Colors.grey,
                                                      // Change this to your desired border color
                                                      width:
                                                      1.0, // Change this to your desired border width
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Padding(
                                                  padding: EdgeInsets.only(left: 10, right: 10),
                                                  child: Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  // Set your desired background color
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2.0),
                                                    side: const BorderSide(
                                                      color: Colors.red,
                                                      // Change this to your desired border color
                                                      width:
                                                          1.0, // Change this to your desired border width
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return SizedBox(
                                                        height: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .height,
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: Center(
                                                          child: Container(
                                                            width: 150,
                                                            height: 150,
                                                            decoration:
                                                                const BoxDecoration(
                                                              color: Colors
                                                                  .transparent,
                                                            ),
                                                            child: DotLottieLoader.fromAsset(
                                                                "assets/lottie/process.lottie",
                                                                frameBuilder:
                                                                    (BuildContext
                                                                            ctx,
                                                                        DotLottie?
                                                                            dotlottie) {
                                                              if (dotlottie !=
                                                                  null) {
                                                                return Lottie.memory(
                                                                    dotlottie
                                                                        .animations
                                                                        .values
                                                                        .single,
                                                                    fit: BoxFit
                                                                        .fill);
                                                              } else {
                                                                return Container();
                                                              }
                                                            }),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection(FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid)
                                                      .doc(snapshot
                                                          .data!.docs[index].id)
                                                      .delete();
                                                  await FirebaseDatabase
                                                          .instanceFor(
                                                              app: Firebase
                                                                  .app(),
                                                              databaseURL:
                                                                  "https://noteshouse-72-default-rtdb.asia-southeast1.firebasedatabase.app/")
                                                      .reference()
                                                      .child(FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid)
                                                      .child(snapshot
                                                          .data!.docs[index].id)
                                                      .remove();
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Deleted successfully!",
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor:
                                                          Colors.grey,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);
                                                },
                                                child: const Padding(
                                                  padding: EdgeInsets.only(left: 10, right: 10),
                                                  child: Text(
                                                    "Delete",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.95,
                          // height: 180,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Color.fromRGBO(109, 216, 180, 1),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(2),
                            width: MediaQuery.of(context).size.width * 0.95,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      width: 44,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100)),
                                        color: Colors.transparent,
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Icon(
                                          Icons.newspaper,
                                          size: 30,
                                          color: Colors.grey,
                                        ),
                                      )),
                                ),
                                Center(
                                  child: Stack(children: [
                                    Column(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              70,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5, bottom: 5),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width * .80,
                                                  child: Text(
                                                    snapshot.data!.docs[index]['title']
                                                        .replaceAll('\n', ' '),
                                                    textAlign: TextAlign.left,
                                                    overflow: TextOverflow.clip,
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width * .80,
                                                  child: Text(
                                                    snapshot.data!.docs[index]['note']
                                                        .replaceAll('\n', ' '),
                                                    textAlign: TextAlign.left,
                                                    overflow: TextOverflow.clip,
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              70,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5, right: 10),
                                            child: Text(
                                              formattedDateTime,
                                              textAlign: TextAlign.right,
                                              overflow: TextOverflow.clip,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => createNotePage(
                  myString: '',
                )),
          );
        },
        child: const Icon(
          Icons.add,
          size: 33,
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      autofocus: true,
      controller: searchText,
      decoration: const InputDecoration(
        hintText: 'Search...',
        hintStyle: TextStyle(color: Colors.white70),
        border: InputBorder.none,
      ),
      style: const TextStyle(color: Colors.white),
      onChanged: (value) {
        setState(() {
          searchTextString = searchText.text;
        });
      },
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            setState(() {
              _isSearching = false;
              searchTextString = '';
              searchText.text = '';
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyHomePage(title: "Notes House")));
          },
        ),
      ];
    } else {
      return [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            setState(() {
              _isSearching = true;
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyHomePage(title: "Notes House")));
          },
        ),
      ];
    }
  }
}

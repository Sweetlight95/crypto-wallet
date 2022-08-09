import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_app/net/api_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../net/flutterfire.dart';
import 'add_view.dart';


class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  double bitcoin = 0.0;
  double tether = 0.0;
  double ethereum = 0.0;

  @override
  void initState() {
    getValues();
  }

  getValues() async {
    bitcoin = await getPrice("Bitcoin");
    tether = await getPrice("Tether");
    ethereum = await getPrice("Ethereum");
    setState(() {

    });
  }

   @override
  Widget build(BuildContext context) {
     getValue(String id, double amount){
       if (id == "Bitcoin"){
         return bitcoin * amount;
       }else if (id == "Tether"){
         return tether * amount;
       }else {
         return ethereum * amount;
       }
     }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.lime,
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users').doc(FirebaseAuth.instance.currentUser?.uid)
                .collection('Coins').snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot) {
                    if(!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return ListView(
                      children: snapshot.data!.docs.map((document) {
                        return Padding(
                          padding: EdgeInsets.only(top: 5.0, left: 15.0, right: 15.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.3,
                            height: MediaQuery.of(context).size.height / 12,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Colors.pink,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(width: 5.0,),
                              Text(
                                "Coin: ${document.id}",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.greenAccent,
                                  ),
                              ),
                              Text(
                                  '\$${getValue(document.id, document["Amount"]).toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.greenAccent,
                                  ),
                              ),
                               IconButton(
                                   onPressed: () async {
                                     await removeCoin(document.id);
                                   },
                                   icon:  Icon(
                                     Icons.close,
                                     color: Colors.green,)
                               ),
                            ],),
                          ),
                        );
                      }).toList(),
                    );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddView(),),
    );
    },
        child: Icon(Icons.add, color: Colors.brown,),
      ),
    );
  }
}

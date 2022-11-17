import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:footix/contants.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../models/database.dart';

class GlobalRanking extends StatefulWidget {
  GlobalRanking({Key? key}) : super(key: key);

  final db = DB();
  final _auth = FirebaseAuth.instance;

  @override
  _GlobalRankingState createState() => _GlobalRankingState();
}

class _GlobalRankingState extends State<GlobalRanking> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.db.getShortGlobalRanking(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return ScrollablePositionedList.builder(
              initialScrollIndex: 1,
              itemCount: snapshot.data!.length,
              itemBuilder: (_, int position) {
                var userID = snapshot.data.keys.toList()[position];
                final rankingItem = snapshot.data![userID];
                return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {},
                    child: Card(
                      child: ListTile(
                        tileColor: userID == widget._auth.currentUser!.uid
                            ? kMainMediumColor
                            : kMainGreyColor,
                        title: FutureBuilder(
                          future: widget.db
                              .getCollectionDataField('users', 'ID', userID),
                          builder:
                              (BuildContext context, AsyncSnapshot userData) {
                            if (userData.connectionState ==
                                    ConnectionState.done &&
                                userData.hasData) {
                              return Text(
                                '${rankingItem['ranking']}. ${userData.data['name']}',
                                style: TextStyle(
                                    color: kMainLightColor,
                                    fontWeight:
                                        userID == widget._auth.currentUser!.uid
                                            ? FontWeight.bold
                                            : FontWeight.normal),
                              );
                            } else {
                              return Container(
                                  width: double.infinity,
                                  child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ),
                    ));
              },
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Text(kTooLittleData);
          }
        });
  }
}

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../contants.dart';
import '../../../models/firebase_service.dart';

class GlobalRanking extends StatelessWidget {
  GlobalRanking({Key? key}) : super(key: key);

  final firebaseService = FirebaseService();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebaseService.getUserRanking(_auth.currentUser!.uid),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          final rankingData = snapshot.data;
          final myUserId = _auth.currentUser!.uid;
          final myRankingMap = rankingData.firstWhere(
            (rankingItem) => rankingItem.keys.first == myUserId,
            orElse: () => null,
          );

          final myRanking = myRankingMap != null
              ? myRankingMap.values.first['position']
              : null;

          final startIndex = (myRanking - 3).clamp(0, rankingData.length - 1);
          final endIndex = (myRanking + 2).clamp(0, rankingData.length - 1);

          return ScrollablePositionedList.builder(
            initialScrollIndex: (myRanking - startIndex).toInt(),
            itemCount: (endIndex - startIndex + 1).toInt(),
            itemBuilder: (_, int position) {
              final rankingIndex = (position + startIndex).toInt();
              if (rankingIndex >= rankingData.length) {
                return SizedBox.shrink();
              }
              final rankingItem = rankingData[rankingIndex];
              final userID = rankingItem.keys.first;
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {},
                child: Card(
                  child: ListTile(
                    tileColor: userID == _auth.currentUser!.uid
                        ? kMainMediumColor
                        : kMainGreyColor,
                    title: FutureBuilder(
                      future: firebaseService.getCollectionDataField(
                          'users', 'ID', userID),
                      builder: (BuildContext context, AsyncSnapshot userData) {
                        if (userData.connectionState == ConnectionState.done &&
                            userData.hasData) {
                          return Text(
                            '${rankingItem.values.first['position'].toInt()}. ${userData.data['name']}',
                            style: TextStyle(
                              color: kMainLightColor,
                              fontWeight: userID == _auth.currentUser!.uid
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          );
                        } else {
                          return Container(
                            width: double.infinity,
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                ),
              );
            },
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Text(kTooLittleData);
        }
      },
    );
  }
}

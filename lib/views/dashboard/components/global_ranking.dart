import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:footix/models/database.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../contants.dart';
import '../profile_screen.dart';

class GlobalRanking extends StatefulWidget {
  int?
      adjacentElemNum; // by default will show one user above and one user below logged user
  GlobalRanking({Key? key, this.adjacentElemNum = 1}) : super(key: key);
  final db = DB();
  final ItemScrollController _scrollController = ItemScrollController();

  @override
  _GlobalRankingState createState() => _GlobalRankingState();
}

class _GlobalRankingState extends State<GlobalRanking> {
  @override
  Widget build(BuildContext context) {
    dynamic getGlobalRanking() async {
      var allUsersSorted = await widget.db.getCollectionData("users");
      allUsersSorted.sort((m1, m2) {
        double totalM1 = 0;
        for (var i = 0; i < m1['exp'].keys.toList().length; i++) {
          totalM1 += m1['exp'].values.toList()[i];
        }
        double totalM2 = 0;
        for (var i = 0; i < m2['exp'].keys.toList().length; i++) {
          totalM2 += m2['exp'].values.toList()[i];
        }
        var r = totalM2.compareTo(totalM1);
        if (r != 0) {
          return r;
        }
        return totalM1.compareTo(totalM2);
      });
      return allUsersSorted;
    }

    dynamic getShortRank(String email) async {
      var fullRank = await getGlobalRanking();
      int userRank = getUserRank(fullRank, email);
      widget.adjacentElemNum = widget.adjacentElemNum! < fullRank.length / 2
          ? widget.adjacentElemNum
          : (fullRank.length / 2).floor();
      if (widget.adjacentElemNum! != -1) {
        int listStartIndex = userRank - widget.adjacentElemNum! < 0
            ? 0
            : userRank - widget.adjacentElemNum!;
        int listEndIndex =
            (userRank + widget.adjacentElemNum!) + 1 > fullRank.length
                ? fullRank.length
                : (userRank + widget.adjacentElemNum!) + 1;
        return fullRank.sublist(listStartIndex, listEndIndex);
      }
      return fullRank;
    }

    final _auth = FirebaseAuth.instance;
    int _myIndex = 1;
    Map otherUser = ModalRoute.of(context)!.settings.arguments as Map;
    var loggedInUser = _auth.currentUser!;
    String userEmail =
        otherUser == null || otherUser['email'] == loggedInUser.email
            ? loggedInUser.email
            : otherUser['email'];

    return FutureBuilder<List>(
      future: Future.wait([getGlobalRanking(), getShortRank(userEmail)]),
      builder: (context, snapshot) {
        var fullRank = snapshot.data?[0] ?? [];
        var shortRank = snapshot.data?[1] ?? [];
        _myIndex = getUserRank(fullRank, userEmail);
        int highlightIndex =
            widget.adjacentElemNum! == -1 ? _myIndex : widget.adjacentElemNum!;
        return snapshot.hasData
            ? ScrollablePositionedList.builder(
                initialScrollIndex:
                    _myIndex - 1, // want to show user in the middle of context
                itemScrollController: widget._scrollController,
                itemCount: shortRank.length,
                itemBuilder: (_, int position) {
                  position = position < 0 ? 0 : position;
                  final item = shortRank[position];

                  TextStyle style = TextStyle(
                      color: kMainLightColor,
                      fontSize: 20,
                      fontWeight: position == highlightIndex
                          ? FontWeight.bold
                          : FontWeight.normal);
                  return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Navigator.pushNamed(context, ProfileScreen.id,
                            arguments: {
                              'email': item['email'],
                              'name': item['name']
                            });
                      },
                      child: FutureBuilder(
                        future: widget.db.getAnswerCorrectnessMap(item['ID']),
                        builder: (context, userAnswerCorrectnessData) {
                          if (userAnswerCorrectnessData.hasData) {
                            Map userAnswerCorrectnessMap =
                                userAnswerCorrectnessData.data as Map;
                            int userAnswerCorrectness =
                                ((userAnswerCorrectnessMap[
                                                'answeredCorrectlyTotal'] /
                                            userAnswerCorrectnessMap[
                                                'askedTimesTotal']) *
                                        100)
                                    .round();
                            return Card(
                              child: ListTile(
                                tileColor: position == highlightIndex
                                    ? kMainMediumColor
                                    : kMainGreyColor,
                                title: Text(
                                  '${getUserRank(fullRank, item['email']) + 1}. ${item['name'].toUpperCase()} | ${getMapSum(item['exp']).toInt()} EXP | Correctness: $userAnswerCorrectness%',
                                  style: TextStyle(
                                      color: kMainLightColor,
                                      fontWeight: position == highlightIndex
                                          ? FontWeight.bold
                                          : FontWeight.normal),
                                ),
                              ),
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ));
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  int getUserRank(var ranking, String email) {
    for (var i = 0; i < ranking.length; i++) {
      if (ranking[i]['email'] == email) return i;
    }
    return 0;
  }
}

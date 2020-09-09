import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dizi_takip/classes/ApiHandlers/InitNewShow.dart';
import 'package:dizi_takip/classes/ApiHandlers/QueryBuilder.dart';
import 'package:dizi_takip/classes/DatabaseClasses/SearchResult.dart';
import 'package:dizi_takip/classes/DatabaseClasses/Show.dart';
import 'package:dizi_takip/classes/DatabaseClasses/User.dart';
import 'package:dizi_takip/classes/ExceptionHandler.dart';
import 'package:dizi_takip/classes/FirebaseCRUD.dart';
import 'package:dizi_takip/classes/Palette.dart';
import 'package:dizi_takip/classes/SizeConfig.dart';
import 'package:dizi_takip/classes/UiOverlayStyle.dart';
import 'package:dizi_takip/components/mainComponents/ShowDetailTapHeader.dart';
import 'package:dizi_takip/components/searchScreen/SearchResultBox.dart';
import 'package:dizi_takip/i18n/strings.g.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchPage extends StatefulWidget {
  static String id = 'searchPage';

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  UserFull userInf;
  List<String> userShowIDs = new List<String>();
  List<SearchResult> showsForQueryResult = new List<SearchResult>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  ScrollController _scrollController;
  int pageMaxItemCount = 15;
  bool _showLoading = false;
  String query = '';
  String username;

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        pageMaxItemCount += 7;
      });
    }

    /*fireStore.doc("/users/$username").get().then((docSnapShot){
       =
    })*/
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
    Firebase.initializeApp();

    username = firebaseAuth.currentUser.displayName;

    UiOverlayStyle()
        .UiOverlayStyleOnlyTop(Palette().colorPrimary, Brightness.light);

    print("after all");
  }

  void _updateUsersShow(BuildContext context, String showID, bool isAdded) {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    print(isAdded);
    if (!isAdded) {
      // first look at user's "myOldShows" to see if the user has it on there,
      // if user has the show on its "myOldShows" it indicates that
      // the user had watched this series, then stopped wathcing and now
      // continues. Remove from "myOldShows" and add to "myShows"
      FirebaseCRUD firebaseCRUD = FirebaseCRUD.init(user: userInf);
      userInf = firebaseCRUD.addShow(showID: showID);
    } else {
      // remove the show from user's "myShows" array and switch it to "myOldShows"
      // since the user can have some of this show's episodes watched,
      // we do not want to lose the data
      FirebaseCRUD firebaseCRUD = FirebaseCRUD.init(user: userInf);
      userInf = firebaseCRUD.removeShow(showID: showID);

      userInf.myOldShows.putIfAbsent(showID, () => userInf.myShows[showID]);
      userInf.myShows.remove(showID);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    print('me here1');
    if (_showLoading) {
      return Container(
        color: Palette().colorPrimary.withOpacity(.8),
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return StreamBuilder(
      stream: fireStore.doc("/users/$username").snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          log("snapshot.data.data()");
          log(snapshot.data.data().toString());
          userInf = UserFull.fromJson(snapshot.data.data());
          return SafeArea(
            child: GestureDetector(
              child: Container(
                color: Palette().colorPrimary,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: CustomScrollView(
                        shrinkWrap: true,
                        slivers: [
                          SliverAppBar(
                            backgroundColor:
                                Palette().colorSecondary.withOpacity(1),
                            title: TextFormField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Palette().colorPrimary,
                                ),
                                hintText: t.searchScreen.searchForAShow,
                                border: InputBorder.none,
                                focusColor: Palette().colorQuaternary,
                              ),
                              onChanged: (str) {
                                setState(() {
                                  showsForQueryResult =
                                      new List<SearchResult>();
                                  this.query = str;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: 57.0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: FutureBuilder(
                        future: QueryBuilder.search(
                                show: this.query,
                                page: 1,
                                limit: pageMaxItemCount,
                                fields: new List<String>.from(["title"]))
                            .getResponse(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            if (showsForQueryResult.length == 0) {
                              return Container(
                                width: SizeConfig.screenWidth,
                                height: 60,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                          }
                          if (snapshot.hasData) {
                            if (snapshot.data.isNotEmpty) {
                              List<dynamic> obj =
                                  jsonDecode(snapshot.data.toString());
                              showsForQueryResult = new List<SearchResult>();
                              obj.forEach((showRes) {
                                showsForQueryResult
                                    .add(SearchResult.fromJson(showRes));
                              });
                            }
                            return CustomScrollView(
                              shrinkWrap: true,
                              controller: _scrollController,
                              slivers: [
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      if (showsForQueryResult.length == 0) {
                                        return Container(
                                          height: SizeConfig.screenHeight - 56,
                                          child: Center(
                                            child: Text(
                                              t.searchScreen.noShowFound,
                                              style: TextStyle(
                                                color: Palette()
                                                    .colorQuaternary
                                                    .withOpacity(.7),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      if (index == showsForQueryResult.length) {
                                        return Container(
                                          height: 80,
                                          width: SizeConfig.screenWidth,
                                          child: Center(
                                            heightFactor: 10,
                                            child: CupertinoActivityIndicator(
                                              animating: true,
                                              radius: 15.0,
                                            ),
                                          ),
                                        );
                                      }
                                      var result = showsForQueryResult[index];

                                      return SearchResultBox(
                                        updateUsersShow: _updateUsersShow,
                                        show: result.show,
                                        isAdded: userInf.myShows.containsKey(
                                                result.show.ids.trakt
                                                    .toString())
                                            ? true
                                            : false,
                                      );
                                    },
                                    childCount: showsForQueryResult.length + 1,
                                  ),
                                )
                              ],
                            );
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}

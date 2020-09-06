import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dizi_takip/classes/ApiHandlers/InitNewShow.dart';
import 'package:dizi_takip/classes/ApiHandlers/QueryBuilder.dart';
import 'package:dizi_takip/classes/DatabaseClasses/SearchResult.dart';
import 'package:dizi_takip/classes/DatabaseClasses/Show.dart';
import 'package:dizi_takip/classes/DatabaseClasses/User.dart';
import 'package:dizi_takip/classes/ExceptionHandler.dart';
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
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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
  }

  Future<void> _updateUsersShow(
      BuildContext context, String showID, bool isAdded) {
    FirebaseFirestore firebaseFirestoretore = FirebaseFirestore.instance;
    print(username);
    if (isAdded) {
      // remove the show from user's "myShows" array and switch it to "myOldShows"
      // since the user can have some of this show's episodes watched,
      // we do not want to lose the data

      firebaseFirestoretore.doc("/users/" + username).get().then((value) {
        var user = UserFull.fromJson(value.data());
        user.myShows.forEach((key, value) {
          print("$key and $value");
        });
        log("jsonEncode(user.toJson())");
        log(jsonEncode(user.toJson()));
      });

      firebaseFirestoretore.doc('/shows/' + showID).get().then((docSnapshot) {
        if (!docSnapshot.exists) {
          setState(() {
            _showLoading = !_showLoading;
          });
          InitNewShow(showTraktID: showID).initShow().then((value) {
            firebaseFirestoretore
                .collection("users")
                .doc(username)
                .get()
                .then((val) {
              try {
                firebaseFirestoretore.collection("users").doc(username).set({
                  "myShows": {showID: new List<String>()}
                }, new SetOptions(merge: true));

                setState(() {
                  _showLoading = !_showLoading;
                });
              } catch (e) {
                ExceptionHandler(
                  context: context,
                  message: e.toString(),
                );
              }
            });
          });
        } else {
          setState(() {
            _showLoading = !_showLoading;
          });
          firebaseFirestoretore.collection("users").doc(username).set({
            "myShows": {showID: new List<String>()}
          }, new SetOptions(merge: true));
          setState(() {
            _showLoading = !_showLoading;
          });
        }
      });
    } else {
      // first look at user's "myOldShows" to see if the user has it on there,
      // if user has the show on its "myOldShows" it indicates that
      // the user had watched this series, then stopped wathcing and now
      // continues. So for the sake of not losing data, we have to do this control.
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
                      backgroundColor: Palette().colorSecondary.withOpacity(1),
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
                            showsForQueryResult = new List<SearchResult>();
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
                      fields: new List<String>.from(["title"])).getResponse(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                                if (index % 2 == 0) {
                                  return SearchResultBox(
                                    updateUsersShow: _updateUsersShow,
                                    show: result.show,
                                    isAdded: true,
                                  );
                                }
                                return SearchResultBox(
                                  updateUsersShow: _updateUsersShow,
                                  show: result.show,
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
}

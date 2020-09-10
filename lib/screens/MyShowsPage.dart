import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dizi_takip/classes/DatabaseClasses/Episode.dart';
import 'package:dizi_takip/classes/DatabaseClasses/InternalQueries.dart';
import 'package:dizi_takip/classes/DatabaseClasses/Show.dart';
import 'package:dizi_takip/classes/DatabaseClasses/User.dart';
import 'package:dizi_takip/classes/FirebaseCRUD.dart';
import 'package:dizi_takip/classes/Palette.dart';
import 'package:dizi_takip/classes/SizeConfig.dart';
import 'package:dizi_takip/classes/UiOverlayStyle.dart';
import 'package:dizi_takip/components/mainComponents/EmptyAppBar.dart';
import 'package:dizi_takip/components/mainComponents/ShowDetailTapHeader.dart';
import 'package:dizi_takip/components/myShowsScreen/EpisodeShowBox.dart';
import 'package:dizi_takip/i18n/strings.g.dart';
import 'package:dizi_takip/screens/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class MyShowsPage extends StatefulWidget {
  static String id = 'myShowsPage';

  MyShowsPage({Key key}) : super(key: key);

  @override
  _MyShowsPageState createState() => _MyShowsPageState();
}

class _MyShowsPageState extends State<MyShowsPage> {
  final items = List<String>.generate(20, (i) => "Item ${i + 1}");
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  UserFull _userFull;
  String _username = FirebaseAuth.instance.currentUser.displayName;
  List<Show> _userShowList = new List<Show>();
  bool _showScrollableSheet = false;
  final double initialSize = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    UiOverlayStyle()
        .UiOverlayStyleOnlyTop(Palette().colorPrimary, Brightness.light);
  }

  Future<bool> _onShowDismiss(
      BuildContext ctx, DismissDirection direction, Show show) {
    if (direction == DismissDirection.endToStart) {
      // user removes the show
      showGeneralDialog(
          barrierColor: Colors.black.withOpacity(0.5),
          barrierDismissible: false,
          context: ctx,
          transitionDuration: Duration(milliseconds: 500),
          pageBuilder: (context, animation1, animation2) {},
          transitionBuilder: (ctx, anim1, anim2, child) {
            final curvedValue =
                Curves.linearToEaseOut.transform(anim1.value) - 1;
            return Transform(
              transform: Matrix4.translationValues(0.0, curvedValue * 800, 0.0),
              child: GestureDetector(
                onTap: () {
                  WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                },
                child: Dialog(
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Container(
                    height: SizeConfig.safeBlockVertical * 25,
                    padding: EdgeInsets.all(
                      20.0,
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          child: Text(
                            t.myShowsScreen.sureToRemoveHeader,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Positioned(
                          top: SizeConfig.safeBlockVertical * 5,
                          child: Container(
                            width: 270,
                            child: Text(t.myShowsScreen.sureToRemove),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              RaisedButton(
                                color: Palette().colorPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(
                                    color: Palette().colorSecondary,
                                  ),
                                ),
                                child: Text(
                                  t.global.yes.toUpperCase(),
                                  style: TextStyle(
                                    color: Palette().colorQuaternary,
                                  ),
                                ),
                                onPressed: () {
                                  FirebaseCRUD.init(user: _userFull).removeShow(
                                      showID: show.ids.trakt.toString());

                                  Navigator.of(ctx, rootNavigator: true)
                                      .pop('dialog');
                                  return true;
                                },
                              ),
                              SizedBox(
                                width: SizeConfig.safeBlockHorizontal * 2,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(ctx, rootNavigator: true)
                                      .pop('dialog');
                                  return false;
                                },
                                child: Container(
                                  child: Text(
                                    t.global.close,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
    } else {
      String episodeNum = _userFull.watchNext[show.ids.trakt.toString()];
      if (episodeNum == "FINISHED") {
        return Future.value(false);
      }

      _userFull =
          FirebaseCRUD.init(user: _userFull).markShowAsWatched(show: show);

      return Future.value(false);
    }
  }

  @override
  Widget build(BuildContext buildContext) {
    SizeConfig().init(buildContext);

    return Scaffold(
      extendBodyBehindAppBar: true,
      primary: true,
      appBar: EmptyAppBar(),
      backgroundColor: Palette().colorPrimary,
      body: SafeArea(
        child: StreamBuilder(
          stream: _fireStore.doc("/users/$_username").snapshots(),
          builder: (streamBuilderContext,
              AsyncSnapshot<DocumentSnapshot> documentSnapshot) {
            if (documentSnapshot.hasData) {
              _userFull = UserFull.fromJson(documentSnapshot.data.data());

              return FutureBuilder(
                future: InternalQueries()
                    .getWatchNextListForUser(userFull: _userFull),
                builder: (context, AsyncSnapshot<List<Show>> showList) {
                  if (showList.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (showList.hasData) {
                    _userShowList = showList.data;

                    return CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          backgroundColor: Colors.black26,
                          floating: false,
                          pinned: true,
                          actions: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  FirebaseAuth.instance.signOut();

                                  Navigator.of(context, rootNavigator: true)
                                      .pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return LoginScreen();
                                      },
                                    ),
                                    (_) => false,
                                  );

                                  /*pushNewScreen(
                                    context,
                                    screen: LoginScreen(),
                                    withNavBar:
                                        false, // OPTIONAL VALUE. True by default.
                                    pageTransitionAnimation:
                                        PageTransitionAnimation.slideUp,
                                  );*/
                                },
                                child: Icon(
                                  Icons.close,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              var show = _userShowList[index];
                              log("this show = ${show.title}");
                              log("this show season count = ${show.seasons.length}");

                              if (_userShowList.length == 0) {
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
                              return EpisodeShowBox(
                                onDismissed: _onShowDismiss,
                                show: show,
                                userFull: _userFull,
                                watchNext: _userFull
                                    .watchNext[show.ids.trakt.toString()],
                              );
                            },
                            childCount: _userShowList.length,
                          ),
                        )
                      ],
                    );
                  }
                  return Center(
                    child: Text(
                      t.searchScreen.noShowFound,
                      style: TextStyle(
                        color: Palette().colorQuaternary,
                      ),
                    ),
                  );
                },
              );
              return Center(child: CircularProgressIndicator());
              /*CustomScrollView(
                primary: false,
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final item = items[index];

                        return EpisodeShowBox(show: null, fullEpisode: null)
                      },
                      childCount: items.length,
                      addAutomaticKeepAlives: true,
                    ),
                  ),
                ],
              );*/
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

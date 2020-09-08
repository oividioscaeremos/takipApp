import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dizi_takip/classes/ApiHandlers/InitNewShow.dart';
import 'package:dizi_takip/classes/DatabaseClasses/Show.dart';
import 'package:dizi_takip/classes/DatabaseClasses/User.dart';
import 'package:flutter/cupertino.dart';

class FirebaseCRUD {
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  UserFull _user;

  FirebaseCRUD.init({UserFull user}) {
    _user = user;
  }

  UserFull addShow({@required String showID}) {
    bool _isInOldList = false;
    if (_user.myOldShows.length != 0) {
      _user.myOldShows.forEach((key, value) {
        if (key == showID) {
          _isInOldList = true;
        }
      });
    }
    if (_isInOldList) {
      print("here motha");
      _fireStore.collection("users").doc(_user.username).update({
        "myOldShows.$showID": FieldValue.delete(),
        "myShows.$showID": _user.myOldShows[showID]
      });
      _user.myShows.putIfAbsent(showID, () => _user.myOldShows[showID]);
      _user.myOldShows.remove(showID);
    } else {
      print("im right hre");
      InitNewShow(showTraktID: showID).initShow().then((value) {
        _fireStore.collection("users").doc(_user.username).update({
          "myShows.$showID": new List<String>(),
          "watchNext.$showID": "Season 1 Episode 1"
        });
        _user.myShows.putIfAbsent(showID, () => new List<String>(0));
      });
    }
    return _user;
  }

  UserFull removeShow({@required String showID}) {
    _fireStore.collection("users").doc(_user.username).update({
      "myShows.$showID": FieldValue.delete(),
      "myOldShows.$showID": _user.myShows[showID]
    });
    _user.myOldShows.putIfAbsent(showID, () => _user.myShows[showID]);
    _user.myShows.remove(showID);
    return _user;
  }
}

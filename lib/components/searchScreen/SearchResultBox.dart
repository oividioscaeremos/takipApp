import 'dart:developer';

import 'package:dizi_takip/classes/DatabaseClasses/Show.dart';
import 'package:dizi_takip/classes/Palette.dart';
import 'package:dizi_takip/classes/SizeConfig.dart';
import 'package:flutter/material.dart';

class SearchResultBox extends StatefulWidget {
  final Show show;
  bool isAdded;
  final Function updateUsersShow;

  SearchResultBox({
    this.show,
    this.updateUsersShow,
    this.isAdded = false,
  });

  @override
  _SearchResultBoxState createState() => _SearchResultBoxState();
}

class _SearchResultBoxState extends State<SearchResultBox> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Material(
      color: Palette().colorPrimary,
      child: InkWell(
        onTap: () => print("Container pressed"), // handle your onTap here
        splashColor: Palette().colorSecondary,
        child: Container(
          height: 70,
          width: SizeConfig.screenWidth,
          decoration: new BoxDecoration(
            border: new Border(
              bottom: new BorderSide(
                color: Palette().colorSecondary.withOpacity(.7),
                width: 2.0,
              ),
            ),
          ),
          padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Text(
                widget.show.title,
                style: TextStyle(
                  fontSize: 15.0,
                  color: Palette().colorQuaternary.withOpacity(.8),
                ),
              ),
              Positioned(
                right: 0,
                child: Container(
                  child: InkWell(
                    onTap: () {
                      widget.updateUsersShow(
                        context,
                        widget.show.ids.trakt.toString(),
                        widget.isAdded != null ? widget.isAdded : false,
                      );
                      setState(() {
                        widget.isAdded = !widget.isAdded;
                      });
                    },
                    child: widget.isAdded
                        ? Icon(
                            Icons.check_box,
                            size: 25.0,
                            color: Palette().colorQuaternary.withOpacity(0.7),
                          )
                        : Icon(
                            Icons.check_box_outline_blank,
                            size: 25.0,
                            color: Palette().colorQuaternary.withOpacity(0.4),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

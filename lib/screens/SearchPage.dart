import 'package:dizi_takip/classes/Palette.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Palette().colorPrimary,
        child: ListView(
          children: [
            Text(
              'SearchPage',
            ),
          ],
        ),
      ),
    );
  }
}

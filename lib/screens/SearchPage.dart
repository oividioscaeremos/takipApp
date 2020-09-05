import 'dart:convert';

import 'package:dizi_takip/classes/ApiHandlers/QueryBuilder.dart';
import 'package:dizi_takip/classes/DatabaseClasses/SearchResult.dart';
import 'package:dizi_takip/classes/DatabaseClasses/Show.dart';
import 'package:dizi_takip/classes/Palette.dart';
import 'package:dizi_takip/classes/SizeConfig.dart';
import 'package:dizi_takip/classes/UiOverlayStyle.dart';
import 'package:dizi_takip/components/mainComponents/ShowDetailTapHeader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final items = List<String>.generate(800, (i) => "Item ${i + 1}");
  String query = '';
  List<SearchResult> showsForQueryResult = new List<SearchResult>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    UiOverlayStyle()
        .UiOverlayStyleOnlyTop(Palette().colorPrimary, Brightness.light);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    print('me here1');
    return SafeArea(
      child: Container(
        color: Palette().colorPrimary,
        height: SizeConfig.screenHeight,
        child: Column(
          verticalDirection: VerticalDirection.down,
          children: [
            CustomScrollView(
              shrinkWrap: true,
              slivers: [
                SliverPersistentHeader(
                  delegate: ShowDetailTapHeader(
                    maxExtent: 65.0,
                    minExtent: 65.0,
                  ),
                  pinned: true,
                ),
                SliverAppBar(
                  title: TextFormField(
                    onChanged: (str) {
                      setState(() {
                        this.query = str;
                      });
                    },
                  ),
                )
              ],
            ),
            FutureBuilder(
              future: QueryBuilder.search(show: this.query, page: 1, limit: 10)
                  .getResponse(),
              builder: (context, snapshot) {
                /*if (snapshot.connectionState == ConnectionState.waiting) {
                  print("beklemek");
                  return Text('Bekliyohhh');
                }*/
                if (snapshot.hasData) {
                  print("patates");
                  print(snapshot.data);
                  if (snapshot.data.isNotEmpty) {
                    List<dynamic> obj = jsonDecode(snapshot.data.toString());
                    showsForQueryResult = new List<SearchResult>();
                    obj.forEach((showRes) {
                      print("showRes.toString()");
                      print(showRes.toString());
                      showsForQueryResult.add(SearchResult.fromJson(showRes));
                    });
                  }
                  return CustomScrollView(
                    shrinkWrap: true,
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            var result = showsForQueryResult[index];
                            return Text(result.show.title);
                          },
                          childCount: showsForQueryResult.length,
                        ),
                      )
                    ],
                  );
                }
                return CircularProgressIndicator();
              },
            )
          ],
        ),
      ),
    );
  }
}

import 'package:dizi_takip/classes/Palette.dart';
import 'package:dizi_takip/classes/SizeConfig.dart';
import 'package:dizi_takip/classes/UiOverlayStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyShowsPage extends StatefulWidget {
  MyShowsPage({Key key}) : super(key: key);

  @override
  _MyShowsPageState createState() => _MyShowsPageState();
}

class _MyShowsPageState extends State<MyShowsPage> {
  final items = List<String>.generate(20, (i) => "Item ${i + 1}");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('mahmut');
    UiOverlayStyle()
        .UiOverlayStyleOnlyBottom(Palette().colorPrimary, Brightness.light);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Palette().colorPrimary,
        body: Container(
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = items[index];

                    return Dismissible(
                      key: Key(item),
                      background: Container(
                        color: Palette().colorTertiary,
                        child: Icon(Icons.delete),
                      ),
                      secondaryBackground: Container(
                        color: Palette().colorQuaternary,
                      ),
                      onDismissed: (direction) {
                        setState(() {
                          print("before:" + items.toString());
                          items.removeAt(index);
                          print("after:" + items.toString());
                        });

                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "${item} dismissed, direction : ${direction.toString()}"),
                            duration: Duration(
                              milliseconds: 600,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: SizeConfig.screenWidth,
                        padding: EdgeInsets.only(
                          top: 4,
                          bottom: 4,
                          left: 8,
                          right: 8,
                        ),
                        height: 80,
                        child: Center(
                          child: Container(
                            child: Text('${item}'),
                            color: Palette().colorPrimary,
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: items.length,
                  addAutomaticKeepAlives: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

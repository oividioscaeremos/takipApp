import 'package:dizi_takip/classes/Palette.dart';
import 'package:dizi_takip/classes/SizeConfig.dart';
import 'package:dizi_takip/classes/UiOverlayStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MyShowsPage extends StatefulWidget {
  MyShowsPage({Key key}) : super(key: key);

  @override
  _MyShowsPageState createState() => _MyShowsPageState();
}

class _MyShowsPageState extends State<MyShowsPage> {
  final items = List<String>.generate(20, (i) => "Item ${i + 1}");
  bool _showScrollableSheet = false;
  final double initialSize = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    UiOverlayStyle()
        .UiOverlayStyleOnlyBottom(Palette().colorPrimary, Brightness.light);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Palette().colorPrimary,
        body: Stack(
          children: [
            Container(
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
                          child: GestureDetector(
                            onTap: () {
                              print('we here ${initialSize.toString()}');
                              showMaterialModalBottomSheet(
                                  context: context,
                                  expand: true,
                                  enableDrag: true,
                                  isDismissible: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context, scrollController) {
                                    return DraggableScrollableSheet(
                                      minChildSize: 0.0,
                                      initialChildSize: 1.0,
                                      maxChildSize: 1.0,
                                      expand: true,
                                      builder: (BuildContext context,
                                          ScrollController scrollController) {
                                        return Container(
                                          height: SizeConfig.screenHeight,
                                          child: CustomScrollView(
                                            slivers: [
                                              SliverAppBar(
                                                title: Text("mahmt"),
                                                backgroundColor: Colors.green,
                                                floating: true,
                                                pinned: true,
                                              ),
                                              SliverList(
                                                delegate:
                                                    SliverChildBuilderDelegate(
                                                  (context, index) {
                                                    final item = items[index];

                                                    return Dismissible(
                                                      key: Key(item),
                                                      background: Container(
                                                        color: Palette()
                                                            .colorTertiary,
                                                        child:
                                                            Icon(Icons.delete),
                                                      ),
                                                      secondaryBackground:
                                                          Container(
                                                        color: Palette()
                                                            .colorQuaternary,
                                                      ),
                                                      onDismissed: (direction) {
                                                        setState(() {
                                                          print("before:" +
                                                              items.toString());
                                                          items.removeAt(index);
                                                          print("after:" +
                                                              items.toString());
                                                        });

                                                        Scaffold.of(context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                                "${item} dismissed, direction : ${direction.toString()}"),
                                                            duration: Duration(
                                                              milliseconds: 600,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          print(
                                                              'we here ${initialSize.toString()}');
                                                        },
                                                        child: Container(
                                                          width: SizeConfig
                                                              .screenWidth,
                                                          height: 80,
                                                          child: Container(
                                                            child:
                                                                Text('${item}'),
                                                            color: Palette()
                                                                .colorPrimary,
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
                                        );
                                      },
                                    );
                                  });
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
          ],
        ),
      ),
    );
  }
}

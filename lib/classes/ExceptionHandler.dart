import 'package:dizi_takip/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'SizeConfig.dart';

Future<void> ExceptionHandler({BuildContext context, String message}) {
  return showGeneralDialog(
    barrierColor: Colors.black.withOpacity(0.5),
    barrierDismissible: false,
    context: context,
    transitionDuration: Duration(milliseconds: 500),
    pageBuilder: (ctx, animation1, animation2) {},
    transitionBuilder: (context, anim1, anim2, child) {
      final curvedValue = Curves.linearToEaseOut.transform(anim1.value) - 1;
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
                      t.global.error,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    top: SizeConfig.safeBlockVertical * 5,
                    child: Container(
                      width: SizeConfig.screenWidth * 0.70,
                      child: Text(
                        message,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true)
                                .pop('dialog');
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
    },
  );
}

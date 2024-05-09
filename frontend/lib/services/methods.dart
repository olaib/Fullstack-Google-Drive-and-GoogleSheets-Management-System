import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/utils/helpers/functions.dart';
import 'package:frontend/utils/styles/fonts.dart';
import 'package:go_router/go_router.dart';



enum MessageType { success, error, warning }

class AppMethods {
  static Future<void> showMessage(
      {required BuildContext context,
      Function? func,
      required String message,
      MessageType type = MessageType.success}) async {
    if (Helpers.isWebPlatform()) {
      displayDialog(
        message: message,
        context: context,
      );
    } else {
      await showToast(
        message: message,
        context: context,
        type: type,
      );
    }
  }

  static Future<void> showToast({
    required String message,
    required BuildContext context,
    MessageType type = MessageType.success,
  }) async =>
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: type == MessageType.error
            ? Colors.red
            : type == MessageType.warning
                ? Colors.orange
                : Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

  static void showSnackbar({
    required String message,
    required BuildContext context,
    MessageType type = MessageType.success,
  }) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: type == MessageType.error
            ? 'שגיאה'
            : type == MessageType.warning
                ? 'אזהרה'
                : 'הצלחה',
        message: message,
        contentType: type == MessageType.error
            ? ContentType.failure
            : type == MessageType.warning
                ? ContentType.warning
                : ContentType.success,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void displayDialog({
    required BuildContext context,
    required String message,
    MessageType type = MessageType.success,
  }) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          content: Text(
            message,
            style: TextStyle(
              fontFamily: SANS_BLACK_FONT,
              color: (type == MessageType.error)
                  ? Colors.red
                  : (type == MessageType.warning)
                      ? Colors.orange
                      : Colors.green,
              fontSize: 16.0,
            ),
          ),
        );
      },
    );
  }

  static showErrorMessage(BuildContext context, String message) async =>
      await showMessage(
          context: context, message: message, type: MessageType.error);

  static goBack(BuildContext context) {
    if (canPop(context)) context.pop();
  }

  static canPop(BuildContext context) => context.canPop();

  
}

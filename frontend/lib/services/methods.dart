import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/utils/helpers/functions.dart';
import 'package:frontend/utils/styles/fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/utils/constants/constants.dart';

enum MessageType { success, error, warning }

class AppMethods {
  static Future<void> showMessage(BuildContext context, String message,
      {Function? func, MessageType type = MessageType.success}) async {
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
            ? 'ERROR'
            : type == MessageType.warning
                ? 'WARNING'
                : 'SUCCESS',
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
      await showMessage(context, message, type: MessageType.error);

  static goBack(BuildContext context) {
    if (canPop(context)) context.pop();
  }

  static bool canPop(BuildContext context) => context.canPop();

  static showConfirmDialog(
      BuildContext context, String confirmMessage, onConfirm) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(confirmMessage),
        content: Text(confirmMessage),
        actions: <Widget>[
          TextButton(
              child: const Text(CANCEL),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          TextButton(
            child: const Text(CONFIRM),
            onPressed: () {
              onConfirm();
              if (canPop(context)) Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
  // await showDialog(
  //       context: context,
  //       builder: (BuildContext context) => AlertDialog(
  //         title: const Text('Delete Row'),
  //         content: const Text('Are you sure you want to delete this row?'),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('Cancel'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           TextButton(
  //             child: const Text('Delete'),
  //             onPressed: () async {
  //               await _httpServices
  //                   .deleteRow(widget.sheetTitle, index + 1)
  //                   .then((value) {
  //                 AppMethods.showMessage(context, 'Row deleted successfully');
  //                 setState(() {
  //                   _rows[_currentPage]!.removeAt(index);
  //                   _isSelected.removeAt(index);
  //                 });
  //                 fetchData();
  //               }).onError((error, stackTrace) {
  //                 AppMethods.showErrorMessage(context, error.toString());
  //               });
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       ),
  //     );
}

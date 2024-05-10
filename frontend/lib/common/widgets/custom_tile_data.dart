import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/services/methods.dart';
import 'package:frontend/utils/constants/colors.dart';
import 'package:frontend/utils/constants/fonts.dart';
import 'package:frontend/utils/constants/sizes.dart';

class CustomTileDataWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Widget subtitle;
  final VoidCallback onEdit;
  final Function(String) onChangeTitle;

  const CustomTileDataWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    required this.subtitle,
    required this.onEdit,
    required this.onChangeTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(
            color: BLUE_COLOR,
            width: 2,
          ),
          color: WHITE_COLOR,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: BLACK_COLOR.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(2, 2))
          ]),
      child: InkWell(
          onTap: onTap,
          child: ListTile(
              leading:
                  const Icon(Icons.description, color: BLUE_COLOR, size: 40),
              title: titleUI(context),
              subtitle: subtitle,
              trailing: const Icon(FontAwesomeIcons.arrowRightToBracket,
                  color: BLUE_COLOR, size: 30))),
    );
  }

  Widget titleUI(BuildContext context) => Row(
        children: [
          Text(title,
              style: TextStyle(
                  color: BLACK_COLOR,
                  fontSize: FONT_LG,
                  fontFamily: Fonts.OPEN_SANS.fontFamily)),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text('Edit title: $title'),
                        content: TextFormField(
                          initialValue: title,
                          onChanged: onChangeTitle,
                        ),
                        actions: [
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              try{
                                onEdit();
                                Navigator.of(context).pop();
                              } catch (e) {
                                AppMethods.showErrorMessage(context, e.toString());
                              }
                            },
                          ),
                        ],
                      ));
            },
          ),
        ],
      );
}

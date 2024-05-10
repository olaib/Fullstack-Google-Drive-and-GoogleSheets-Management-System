import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/common/widgets/custom_loading_indicator.dart';
import 'package:frontend/common/widgets/custom_tile_data.dart';
import 'package:frontend/common/widgets/title_text.dart';
import 'package:frontend/injection_container.dart';
import 'package:frontend/services/http_services.dart';
import 'package:frontend/services/methods.dart';
import 'package:frontend/services/navigation_service.dart';
import 'package:frontend/utils/constants/constants.dart';
import 'package:frontend/utils/constants/fonts.dart';
import 'package:frontend/utils/constants/sizes.dart';
// ignore: unused_import
import 'package:go_router/go_router.dart';


class Sheet {
  String title;
  final int sheetId;
  final int index;

  set setTitle(String value) => title = value;
  Sheet({
    required this.title,
    required this.sheetId,
    required this.index,
  });

  factory Sheet.fromMap(Map<String, dynamic> map) {
    return Sheet(
      sheetId: map['sheetId'] as int,
      title: map['title'] as String,
      index: map['index'] as int,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static final HttpServices _httpServices = getIt<HttpServices>();
  List<Sheet> _titles = [];
  bool isLoading = false;
  String title = '';

  @override
  void initState() {
    loadTitles();
    super.initState();
  }

  Future<void> loadTitles() async {
    setState(() => isLoading = true);
    try {
      final titles = await _httpServices.getSheetsTitles();
      setState(() {
        _titles = titles.map<Sheet>((e) => Sheet.fromMap(e)).toList();
      });
    } catch (e) {
      AppMethods.showErrorMessage(context, e.toString());
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: HOME_PAGE_PADDING),
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          const Center(child: TitleText(MANAGE_SHEETS)),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
            IconButton(
              icon: const Icon(
                FontAwesomeIcons.arrowsRotate,
                color: Colors.blue,
              ),
              onPressed: loadTitles,
            )
          ]),
          const SizedBox(height: 20),
          isLoading
              ? const Center(child: CustomLoadingIndicator())
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    shrinkWrap: true,
                    itemCount: _titles.length,
                    itemBuilder: (context, index) =>
                        buildTitleSheet(_titles[index]),
                  ))
        ],
      ),
    ));
  }

  Widget buildTitleSheet(Sheet sheet) => CustomTileDataWidget(
      title: sheet.title,
      onEdit: () async => onEditTitle(sheet.sheetId),
      onChangeTitle: (value) => setState(() => title = value),
      icon: Icons.description,
      onTap: () => NavigationService.navigateTo(context, Routes.sheetScreen,
              params: {
                SHEET_ID_PARAM: sheet.sheetId.toString(),
                SHEET_TITLE_PARAM: sheet.title
              }),
      subtitle: Text(sheet.sheetId.toString(),
          style: TextStyle(
            fontFamily: Fonts.OPEN_SANS.fontFamily,
          )));

  Future<void> onEditTitle(int sheetId) async {
    try {
      await _httpServices.updateSheetTitle(sheetId, title);
      await loadTitles();
    } catch (e) {
      AppMethods.showErrorMessage(context, e.toString());
    }
  }
}

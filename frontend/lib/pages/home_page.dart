import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/common/widgets/custom_loading_indicator.dart';
import 'package:frontend/common/widgets/title_text.dart';
import 'package:frontend/injection_container.dart';
import 'package:frontend/services/HttpServices.dart';
import 'package:frontend/services/navigation_service.dart';
import 'package:frontend/utils/logger/logger.dart';
import 'package:frontend/utils/routes/app_routes.dart';
import 'package:frontend/utils/constants/sizes.dart';
import 'package:frontend/utils/constants/constants.dart';
import 'package:go_router/go_router.dart';
//todo: lazy load instead of loading all at once

class SheetTitle {
  final String title;
  final int sheetId;
  final int index;
  SheetTitle({
    required this.title,
    required this.sheetId,
    required this.index,
  });

  factory SheetTitle.fromMap(Map<String, dynamic> map) {
    return SheetTitle(
      title: map['title'],
      sheetId: map['sheetId'],
      index: map['index'],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // static final HttpServer _server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8000);
  static final HttpServices _httpServices = getIt<HttpServices>();
  List<SheetTitle> _titles = [];
  static final NavigationService _navService = getIt<NavigationService>();
  bool isLoading = false;

  @override
  void initState() {
    loadTitles();
    super.initState();
  }

  void loadTitles() async {
    setState(() => isLoading = true);
    try {
      final titles = await _httpServices.getSheetsTitles();
      Log.debug(titles);
      setState(() {
        _titles = titles.map<SheetTitle>((e) => SheetTitle.fromMap(e)).toList();
      });
      Log.debug("done");
    } catch (e) {
      Log.error(e.toString());
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          const Center(
              child: TitleText(align: TextAlign.center, label: MANAGE_SHEETS)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.arrowsRotate,
                    color: Colors.blue,
                  ),
                  onPressed: loadTitles),
            ],
          ),
          const SizedBox(height: 20),
          isLoading
              ? const Center(child: CustomLoadingIndicator())
              : ListView.separated(
                  separatorBuilder: (context, index) =>
                      const Divider(thickness: 2),
                  shrinkWrap: true,
                  itemCount: _titles.length,
                  itemBuilder: (context, index) =>
                      buildTitleSheet(_titles[index]),
                )
        ],
      ),
    ));
  }

  Widget buildTitleSheet(SheetTitle sheet) {
    return InkWell(
      // onTap: () => _navService.navigateTo(context, Routes.sheetScreen,
      //     queryParams: {
      //       SHEET_ID_PARAM: sheet.sheetId.toString(),
      //       SHEET_TITLE_PARAM: sheet.title
      //     }),
      onTap: () => context.go('/sheet&sheetId=${sheet.sheetId}&title=${sheet.title}'),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromRGBO(20, 71, 173, 0.75),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
            leading:
                const Icon(Icons.description, color: Colors.blue, size: 40),
            title: SelectableText(sheet.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: FONT_LG,
                )),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SelectableText('index: ${sheet.index.toString()}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: FONT_MD,
                    )),
                SelectableText('id: ${sheet.sheetId.toString()}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: FONT_MD,
                    )),
              ],
            ),
            trailing: const Icon(Icons.arrow_right_outlined,
                color: Colors.blue, size: 30)),
      ),
    );
  }
}

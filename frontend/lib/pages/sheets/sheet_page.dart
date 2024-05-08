import 'package:flutter/material.dart';
import 'package:frontend/injection_container.dart';
import 'package:frontend/services/HttpServices.dart';
import 'package:frontend/utils/logger/logger.dart';

class SheetPage extends StatefulWidget {
  const SheetPage({super.key, required this.sheetId, required this.sheetTitle});

  final String? sheetTitle;
  final String? sheetId;

  @override
  State<SheetPage> createState() => _SheetPageState();
}

class _SheetPageState extends State<SheetPage> {
  static final HttpServices _httpServices = getIt<HttpServices>();
<<<<<<< Updated upstream
  List<List<String>> sheetContent = [];
=======
  List<dynamic> sheetContent = [];
>>>>>>> Stashed changes
  bool isLoading = false;

  void loadSheetContent() async {
    try {
      setState(() => isLoading = true);
      Log.debug(
          'Loading sheet content for ${widget.sheetId} and ${widget.sheetTitle}');
      final sheetContent = await _httpServices.getSheetContent(
<<<<<<< Updated upstream
          widget.sheetId!, widget.sheetTitle!);
      setState(() {
        this.sheetContent = sheetContent;
      });
      print(sheetContent);
=======
          sheetId: widget.sheetId!, title: widget.sheetTitle!);
      setState(() {
        this.sheetContent = sheetContent;
      });
      Log.debug(sheetContent);
>>>>>>> Stashed changes
    } catch (e) {
      Log.error('Failed to load sheet content');
    }
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    if (widget.sheetId == null || widget.sheetTitle == null) {
      throw Exception("Sheet ID is required");
    }
    loadSheetContent();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SelectableText(widget.sheetTitle!),
            const Divider(),
            ListView.builder(
              itemCount: sheetContent.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: SelectableText(sheetContent[index].join(", ")),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

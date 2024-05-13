import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/common/widgets/custom_loading_indicator.dart';
import 'package:frontend/common/widgets/custom_tile_data.dart';
import 'package:frontend/common/widgets/title_text.dart';
import 'package:frontend/features/google_drive/presentation/index.dart';
import 'package:frontend/injection_container.dart';
import 'package:frontend/services/http_services.dart';
import 'package:frontend/services/methods.dart';
import 'package:frontend/services/navigation_service.dart';
import 'package:frontend/utils/constants/constants.dart';
import 'package:frontend/utils/constants/fonts.dart';
import 'package:frontend/utils/constants/sizes.dart';
import 'package:frontend/utils/logger/logger.dart';
// ignore: unused_import
import 'package:go_router/go_router.dart';

class GoogleDriveHomePage extends StatefulWidget {
  const GoogleDriveHomePage({super.key, required this.fileId});

  final String? fileId;

  @override
  State<GoogleDriveHomePage> createState() => _GoogleDriveHomePageState();
}

class _GoogleDriveHomePageState extends State<GoogleDriveHomePage>
    with WidgetsBindingObserver {
  static final HttpServices _httpServices = getIt<HttpServices>();
  FileObj? _root;
  String? _folderId;
  List<FileObj> _files = [];
  bool _isLoading = false;

  @override
  void initState() {
    if (widget.fileId == null) {
      AppMethods.showErrorMessage(context, 'Folder id is null');
      return;
    }
    setState(() => _folderId = widget.fileId);
    Log.info('fileId: ${widget.fileId}');
    _fetchFiles();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _fetchFiles();
    }
  }

  Future<void> _fetchFiles() async {
    setState(() => _isLoading = true);
    try {
      final root = await _httpServices.getFileInfo(_folderId!);
      Log.info('root: $root');

      final files = await _httpServices.getFiles(_folderId!);
      Log.info('files: $files');

      setState(() {
        _root = FileObj.fromMap(root);
        Log.info('root: $_root');
        _files = files.map(FileObj.fromMap).toList();
        Log.info('files: $_files');
      });
    } catch (e) {
      AppMethods.showErrorMessage(context, e.toString());
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: HOME_PAGE_PADDING),
      child: _isLoading
          ? const CustomLoadingIndicator()
          : ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                const Icon(
                  Icons.cloud,
                  size: 50,
                  color: Colors.blue,
                ),
                Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const TitleText("Manage Google Drive Files"),
                          const SizedBox(height: 10),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                const TitleText("Root Folder: "),
                                const SizedBox(width: 10),
                                if (hasParentFolder(_root!.parrentId))
                                  IconButton(
                                      icon: const Icon(Icons.arrow_back),
                                      color: Colors.blue,
                                      onPressed: () =>
                                          _navigateTo(_root!, isBack: true)),
                                IconButton(
                                  icon: const Icon(
                                    FontAwesomeIcons.arrowsRotate,
                                    color: Colors.blue,
                                  ),
                                  onPressed: _fetchFiles,
                                ),
                              ]),
                          const SizedBox(width: 10),
                          CustomTileDataWidget(
                              title: _root!.name,
                              icon: Icons.folder,
                              onTap: () => {},
                              subtitle: Text(_root!.id,
                                  style: TextStyle(
                                    fontFamily: Fonts.OPEN_SANS.fontFamily,
                                  ))),
                        ],
                      ),
                    )),
                const Divider(),
                const Center(child: SecondaryText('Files and Folders:')),
                const SizedBox(height: 10),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: ListView.separated(
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
                          shrinkWrap: true,
                          itemCount: _files.length,
                          itemBuilder: (context, index) =>
                              buildFolder(_files[index]),
                        )))
              ],
            ),
    ));
  }

  Widget buildFolder(FileObj file) => CustomTileDataWidget(
        title: file.name,
        icon: getIcon(file.type),
        onTap: () => _navigateTo(file),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(file.lastModified,
                style: TextStyle(
                  fontFamily: Fonts.OPEN_SANS.fontFamily,
                )),
            Text('${file.size} bytes',
                style: TextStyle(
                  fontFamily: Fonts.OPEN_SANS.fontFamily,
                )),
          ],
        ),
      );

  void _navigateTo(FileObj file, {bool isBack = false}) {
    final hasChild = file.type == FOLDER_TYPE;
    if (!hasChild || isBack) return;
    NavigationService.navigateTo(context, Routes.googleDrive, params: {
      ROOT_ID_PARAM: isBack ? getBackFolder() : file.id,
    });
    setState(() => _folderId = isBack ? getBackFolder() : file.id);
    _fetchFiles();
  }

  IconData getIcon(String type) {
    if (type.startsWith('image')) type = 'image';
    return switch (type) {
      (FOLDER_TYPE) => Icons.folder,
      (FILE_TYPE) => Icons.insert_drive_file,
      ('image') => Icons.image,
      (_) => Icons.insert_drive_file
    };
  }

  String getBackFolder() =>
      _root!.parrentId == null ? _root!.id : _root!.parrentId!;

  bool hasParentFolder(String? parentId) => parentId != null;
}

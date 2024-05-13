import 'package:flutter/material.dart';
import 'package:frontend/common/widgets/custom_loading_indicator.dart';
import 'package:frontend/common/widgets/title_text.dart';
import 'package:frontend/injection_container.dart';
import 'package:frontend/services/http_services.dart';
import 'package:frontend/services/methods.dart';
import 'package:frontend/utils/constants/constants.dart';

class FileObj {
  final String name;
  final String id;
  final String type;
  final String size;
  final String lastModified;
  final String? parrentId;

  FileObj({
    required this.name,
    required this.id,
    required this.type,
    this.size = '__',
    required this.lastModified,
    this.parrentId,
  });

  factory FileObj.fromMap(Map<String, dynamic> map) {
    return FileObj(
      name: map['name'],
      id: map['id'],
      type: map['mimeType'],
      size: map['size'] ?? '__',
      lastModified: map['modifiedTime'],
      parrentId: map['parents']?.first,
    );
  }
  @override
  String toString() {
    return 'FileObj(name: $name, id: $id, type: $type, size: $size, lastModified: $lastModified, parrentId: $parrentId)';
  }
}

class FilesListPage extends StatefulWidget {
  const FilesListPage({super.key, required this.folderId});
  final String? folderId;
  @override
  State<FilesListPage> createState() => _FilesListPageState();
}

class _FilesListPageState extends State<FilesListPage> {
  List<FileObj> _files = [];
  static final HttpServices _httpServices = getIt<HttpServices>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.folderId == null) {
      AppMethods.showErrorMessage(context, 'Folder id is null');
      return;
    }
    _fetchFiles();
  }

  Future<void> _fetchFiles() async {
    setState(() => isLoading = true);
    try {
      final files = await _httpServices.getFiles(widget.folderId!);
      setState(() => _files = files.map(FileObj.fromMap).toList());
    } catch (e) {
      AppMethods.showErrorMessage(context, e.toString());
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CustomLoadingIndicator())
        : SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ListView.builder(
              itemCount: _files.length,
              itemBuilder: (context, index) {
                final file = _files[index];
                return ListTile(
                  trailing: getIcon(file.type),
                  leading: Text('${file.size}'),
                  title: TitleText(file.name),
                  subtitle: Text(file.lastModified),
                  onTap: () => AppMethods.showErrorMessage(
                      context, 'File id: ${file.id}'),
                );
              },
            ),
          );
  }

  Icon getIcon(String type) {
    if (type.startsWith('image')) type = 'image';
    return switch (type) {
      FOLDER_TYPE => const Icon(IconData(0xf77e, fontFamily: 'MaterialIcons')),
      FILE_TYPE => const Icon(Icons.insert_drive_file),
      'image' => const Icon(Icons.image),
      (_) => const Icon(Icons.insert_drive_file)
    };
  }
}

import 'package:flutter/material.dart';
import 'package:frontend/common/widgets/extended_floating_action_button.dart';
import 'package:frontend/common/widgets/title_text.dart';
import 'package:frontend/services/methods.dart';
import 'package:frontend/services/navigation_service.dart';
import 'package:frontend/utils/constants/constants.dart';
import 'package:frontend/utils/storage/preference_utils.dart';

enum ControllersType { spreadsheetId, googleDriveId }

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final TextEditingController _spreadsheetIdController =
          TextEditingController(),
      _googleDriveIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _spreadsheetIdController.text =
        PreferenceUtils.getString(SPREADSHEET_ID_KEY, "");

    _googleDriveIdController.text =
        PreferenceUtils.getString(GOOGLE_DRIVE_ID_KEY, "");
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 50.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(child: TitleText("Welcome to $APP_NAME", fontSize: 24)),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: buttonsUI(),
          ),
          const SizedBox(height: 16.0),
          fieldIdForm(ControllersType.spreadsheetId),
          const SizedBox(height: 16.0),
          fieldIdForm(ControllersType.googleDriveId),
        ],
      ),
    );
  }

  Widget fieldIdForm(ControllersType controllersType) {
    final type = controllersType == ControllersType.spreadsheetId
        ? "Spreadsheet ID"
        : "Google Drive ID";
    final controller = controllersType == ControllersType.spreadsheetId
        ? _spreadsheetIdController
        : _googleDriveIdController;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "$type ${controllersType == ControllersType.spreadsheetId ? _spreadsheetIdController.text : _googleDriveIdController.text}",
        ),
        Text("Please enter your $type",
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8.0),
        Text(
          "You can find the $type in the URL of your ${controllersType == ControllersType.spreadsheetId ? "Google Sheet" : "Google Drive"}",
          style: const TextStyle(color: Colors.grey),
        ),
        Text(
          controllersType == ControllersType.spreadsheetId
              ? EXAMPLE_SPREADSHEET_ID
              : EXAMPLE_DRIVE_ID,
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 8.0),
        formUI(
            controller: controller,
            label: type,
            key: type,
            onPressed: () => save(
                controller: controller,
                key: type == "Spreadsheet ID"
                    ? SPREADSHEET_ID_KEY
                    : GOOGLE_DRIVE_ID_KEY)),
      ],
    );
  }

  Widget buttonsUI() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => NavigationService.navigateTo(context, Routes.home),
            child: const Row(
              children: [Icon(Icons.home), SizedBox(width: 4.0), Text("Home")],
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed("/register");
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person),
                SizedBox(width: 4.0),
                Text("Register"),
              ],
            ),
          ),
        ],
      );

  Widget formUI(
          {required TextEditingController controller,
          required String label,
          required String key,
          required void Function() onPressed}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: label,
                hintText: "Enter your $label"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter a valid $label";
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          Center(child: CustomExtendedFloatingActionButton(
            onPressed: onPressed,
            label: const Text("Save"),
            icon: Icons.save,
            tag: key,

            // child: const Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              // children: [
              //   Icon(Icons.save),
              //   SizedBox(width: 4.0),
              // ],
            )),
          
        ],
      );

  void save({required TextEditingController controller, required String key}) {
    try {
      PreferenceUtils.setString(key, controller.text);
      AppMethods.showMessage(context, SAVE_SUCCESSFULLY);
    } catch (e) {
      AppMethods.showErrorMessage(context, e.toString());
    }
  }
}

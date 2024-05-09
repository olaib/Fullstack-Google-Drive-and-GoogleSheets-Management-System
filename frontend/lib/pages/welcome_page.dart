import 'package:flutter/material.dart';
import 'package:frontend/services/methods.dart';
import 'package:frontend/services/navigation_service.dart';
import 'package:frontend/utils/constants/constants.dart';
import 'package:frontend/utils/storage/preference_utils.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final TextEditingController _spreadsheetIdController =
      TextEditingController();
  String _spreadsheetId = "";

  @override
  void initState() {
    super.initState();
    _spreadsheetIdController.text =
        PreferenceUtils.getString(SPREADSHEET_ID_KEY, "");
    _spreadsheetId = _spreadsheetIdController.text;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Spreadsheet ID $_spreadsheetId"),
          Text("Please enter your spreadsheet ID",
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8.0),
          const Text(
            "You can find the spreadsheet ID in the URL of your Google Sheet",
            style: TextStyle(color: Colors.grey),
          ),
          const Text(
            EXAMPLE_SPREADSHEET_ID,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 8.0),
          formUI(),
          const SizedBox(height: 16.0),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: buttonsUI(),
          ),
        ],
      ),
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

  Widget formUI() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _spreadsheetIdController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Spreadsheet ID",
                hintText: "Enter your spreadsheet ID"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter a valid spreadsheet ID";
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: save,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.save),
                SizedBox(width: 4.0),
              ],
            ),
          ),
        ],
      );

  void save() {
    try {
      PreferenceUtils.setString(
          SPREADSHEET_ID_KEY, _spreadsheetIdController.text);
      // PreferenceUtils.setString(
      //     SPREADSHEET_ID_KEY, _spreadsheetIdController.text);
      AppMethods.showMessage(context: context, message: "Spreadsheet ID saved");
    } catch (e) {
      AppMethods.showErrorMessage(context, e.toString());
    }
  }
}

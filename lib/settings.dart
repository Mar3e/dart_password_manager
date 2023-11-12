import 'dart:convert';
import 'dart:io';

import 'package:dart_password_manager/file_manager.dart';

class Settings {
  // ignore: unused_field
  Map<String, dynamic> _settings = {};

  Map<String, dynamic> get settings {
    final fileMan = FileManager();
    File settingsFile = fileMan.findFile(".settings.json");
    String fileContent = fileMan.readFile(settingsFile);
    return _settings = json.decode(fileContent);
  }

  void addToSettings(String key, dynamic value) {
    final fileMan = FileManager();
    File settingsFile = fileMan.findFile(".settings.json");
    String settingsData = fileMan.readFile(settingsFile);
    Map<String, dynamic> settingJson = json.decode(settingsData);
    settingJson[key] = value;
    settingsData = json.encode(settingJson);
    fileMan.writeOnFile(settingsFile, settingsData);
  }
}

import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:dart_password_manager/utils/file_management.dart';

class ShowCommand extends Command {
  @override
  String get name => "show";
  @override
  String get description => "print out all your passWord name in dpassman";
  @override
  FutureOr? run() {
    FileManager.showAllFiles();
  }
}

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dart_password_manager/Init_command.dart';
import 'package:dart_password_manager/get_command.dart';
import 'package:dart_password_manager/set_command.dart';

void main(List<String> arguments) {
  // ignore: unused_local_variable
  final runner = CommandRunner(
      "dpassman", "A password manager that uses the dart language")
    ..addCommand(InitCommand())
    ..addCommand(SetCommand())
    ..addCommand(GetCommand())
    ..run(arguments).catchError((error) {
      if (error is ArgumentError) {
        stdout.write("You did't specify a password name");
        exit(64);
      }
    });
}

import 'package:args/command_runner.dart';
import 'package:dart_password_manager/Init_command.dart';
import 'package:dart_password_manager/get_command.dart';
import 'package:dart_password_manager/remove_command.dart';
import 'package:dart_password_manager/set_command.dart';
import 'package:dart_password_manager/show_command.dart';

void main(List<String> arguments) {
  // ignore: unused_local_variable
  final runner = CommandRunner("dpassman", "A password manager written in Dart")
    ..addCommand(InitCommand())
    ..addCommand(SetCommand())
    ..addCommand(GetCommand())
    ..addCommand(RemoveCommand())
    ..addCommand(ShowCommand())
    ..run(arguments);
}

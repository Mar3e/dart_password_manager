import 'package:args/command_runner.dart';
import 'package:dart_password_manager/Init_command.dart';
import 'package:dart_password_manager/aes_algorithm.dart';

void main(List<String> arguments) {
  // ignore: unused_local_variable
  final runner = CommandRunner(
      "dpassman", "A password manager that uses the dart language")
    // ..addCommand(AesAlgorithm())
    ..addCommand(InitCommand())
    ..run(arguments);
}

import 'package:args/command_runner.dart';
import 'package:dart_password_manager/encryption.dart';

void main(List<String> arguments) {
  // ignore: unused_local_variable
  final runner = CommandRunner(
      "dpassman", "A password manager that uses the dart language")
    ..addCommand(Encryption())
    ..run(arguments);
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

class Clipboard {
  factory Clipboard() {
    switch (Platform.operatingSystem) {
      case "macos":
        return MacClipboard();

      case "linux":
        return LinuxClipboard();
      case "windows":
        return WindowsClipboard();
      default:
        throw Exception("not Supported OS");
    }
  }
  Future<bool> write(covariant String input) {
    exit(2);
  }

  Future<String> read() {
    exit(2);
  }
}

class MacClipboard implements Clipboard {
  @override
  Future<bool> write(covariant String input) async {
    final process = await Process.start('pbcopy', [], runInShell: true);
    process.stderr.transform(utf8.decoder).listen(print);
    process.stdin.write(input);

    try {
      await process.stdin.close();
    } catch (e) {
      return false;
    }

    return await process.exitCode == 0;
  }

  @override
  Future<String> read() async {
    final process = await Process.start('pbpaste', [], runInShell: true);
    process.stderr.transform(utf8.decoder).listen(print);

    final stdout = process.stdout.transform(utf8.decoder);

    try {
      return await stdout.first;
    } catch (_) {
      return '';
    }
  }
}

final winCopyPath =
    path.join(path.current, 'lib/src/backends/windows/copy.exe');
final winPastePath =
    path.join(path.current, 'lib/src/backends/windows/paste.exe');

class WindowsClipboard implements Clipboard {
  @override
  Future<bool> write(covariant String input) async {
    final process = await Process.start(winCopyPath, [], runInShell: true);
    process.stderr.transform(utf8.decoder).listen(print);
    process.stdin.write(input);

    try {
      await process.stdin.close();
    } catch (e) {
      return false;
    }

    return await process.exitCode == 0;
  }

  @override
  Future<String> read() async {
    final process = await Process.start(winPastePath, [], runInShell: true);
    process.stderr.transform(utf8.decoder).listen(print);

    final stdout = process.stdout.transform(utf8.decoder);

    try {
      return await stdout.first;
    } catch (_) {
      return '';
    }
  }
}

class LinuxClipboard implements Clipboard {
  @override
  Future<bool> write(covariant String input) async {
    final process = await Process.start('xsel', ['--clipboard', '--input'],
        runInShell: true);
    process.stderr.transform(utf8.decoder).listen(print);
    process.stdin.write(input);

    try {
      await process.stdin.close();
    } catch (e) {
      print(
          'Cli_clipBoard needs [xsel] in Linux, please install it. Nothing was written to clipboard');
      return false;
    }

    return await process.exitCode == 0;
  }

  @override
  Future<String> read() async {
    final process = await Process.start('xsel', ['--clipboard', '--output'],
        runInShell: true);
    process.stderr.transform(utf8.decoder).listen(print);

    final stdout = process.stdout.transform(utf8.decoder);

    try {
      return await stdout.first;
    } catch (_) {
      return '';
    }
  }
}

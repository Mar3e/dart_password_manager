import 'dart:convert';
import 'dart:typed_data';

const int algorithmKeySize = 256;
const String pbkdf2Name = 'SHA-256/HMAC/PBKDF2';
const int pbkdf2Iterations = 32767;
Uint8List salt = Uint8List.fromList(
    utf8.encode("This is the salt and it's is in plain text"));

import 'dart:io';

void main() {
  Process.run('docker', ['--version']);
}
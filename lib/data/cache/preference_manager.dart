import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class PreferenceManager {
  static final PreferenceManager _instance = new PreferenceManager._internal();

  factory PreferenceManager() {
    return _instance;
  }

  PreferenceManager._internal();

  Future<File> getFile(String fileName) async {
    // get the path to the document directory.
    String dir = (await getApplicationDocumentsDirectory()).path;
    final File file = new File('$dir/$fileName');
//    print("file: ${file.path}");
    return file;
  }

  Future<bool> writeToFile(File file, String data) async {
    try {
      await file.writeAsString(data);
      return true;
    } catch(e) {
      print("write with ex: ${e.toString()}");
    }
    return false;
  }

  Future<bool> write(String fileName, String data) async {
    return await writeToFile(await getFile(fileName), data);
  }

  Future<String> read(String fileName) async {
    return await readFromFile(await getFile(fileName));
  }

  Future<String> readFromFile(File file) async {
    try {
      return await file.readAsString();
    } on FileSystemException {
      return null;
    } catch (e) {
      print("read with error: ${e.toString()}");
    }
    return null;
  }

  Future<bool> delete(String fileName) async {
    try {
      await (await getFile(fileName)).delete();
      return true;
    } on FileSystemException {
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> fileExist(String fileName) async {
    return await (await getFile(fileName)).exists();
  }

}
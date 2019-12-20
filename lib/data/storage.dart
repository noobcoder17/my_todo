import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class StoreData {
  Future<String> storageDirPath() async {
    Directory directory = await getExternalStorageDirectory();
    return directory.path;
  }

  Future<File> getFile() async {
    String path = await storageDirPath();
    return File('$path/data.json');
  }

  Future<bool> fileExits() async {
    File file = await getFile();
    return file.exists();
  }

  Future<File> createNewUserFile(Map<String,dynamic> newUserData) async {
    File file = await getFile();
    bool isFileExits = await fileExits();
    if(isFileExits){
      print("User file already exists");
      return file;
    }
    return file.writeAsString(jsonEncode(newUserData));
  }

  Future<String> getData() async{
    File file = await getFile();
    return file.readAsString();
  }

  Future<File> addType(String newType) async {
    File dataFile = await getFile();
    print("Storing in existing file");
    String prevJsonData = await getData();
    Map<String,dynamic> data = jsonDecode(prevJsonData);
    data["types"].add(newType.toLowerCase());
    data["tasks"].addAll({newType.toLowerCase():{}});
    return dataFile.writeAsString(jsonEncode(data));
  }

  Future<File> addTask(String type,Map<String,dynamic> newJsonData) async {
    File dataFile = await getFile();
    print("Storing in existing file");
    String prevJsonData = await getData();
    Map<String,dynamic> data = jsonDecode(prevJsonData);
    data["tasks"][type].addAll(newJsonData);
    return dataFile.writeAsString(jsonEncode(data));
  }
  
  Future<File> updateTask(String key,Map<String,dynamic> newJsonData) async {
    File dataFile = await getFile();
    String prevJsonData = await getData();
    Map<String,dynamic> data = jsonDecode(prevJsonData);
    data.update(key,(dynamic value){return newJsonData[key];},ifAbsent: (){return newJsonData[key];});
    //data[key] = newJsonData[key];
    return dataFile.writeAsString(jsonEncode(data));
  }

  Future<File> deleteTask(String key) async{
    File dataFile = await getFile();
    String prevJsonData = await getData();
    Map<String,dynamic> data = jsonDecode(prevJsonData);
    data.remove(key);
    return dataFile.writeAsString(jsonEncode(data));
  }
}
import 'package:flutter/foundation.dart';
import '../data/storage.dart';

class UserProvider extends ChangeNotifier{
  StoreData _storeData = new StoreData();
  bool _isNewUser;

  bool get isNewUser {
    return _isNewUser!=null;
  }

  Future<bool> tryToGetData() async {
    bool doesUserExists = await _storeData.fileExits();
    if(doesUserExists==false){
      return false;
    }
    _isNewUser = true;
    notifyListeners();
    return true;
  }
}
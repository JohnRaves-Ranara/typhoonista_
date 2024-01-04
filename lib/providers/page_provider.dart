import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class page_provider with ChangeNotifier{
  int _page = 1;
  
  int get page => _page;

  void changePage(int pageNum){
    _page = pageNum;
    notifyListeners();
  }
}
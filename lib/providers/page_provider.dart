import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:typhoonista_thesis/entities/Typhoon.dart';
import 'package:typhoonista_thesis/entities/Location.dart';

class page_provider with ChangeNotifier{
  int _page = 1;
  
  int get page => _page;

  List<Location>? _locations;

  void changePage(int pageNum){
    _page = pageNum;
    notifyListeners();
  }

  int _documentsPage = 1;

  int get documentsPage => _documentsPage;

  Typhoon? _selectedTyphoon;

  Typhoon? get selectedTyphoon => _selectedTyphoon;

  List<Location>? get locations => _locations;

  void changeSelectedLocations(List<Location> locations){
    _locations = locations;
    notifyListeners();
  }

  void changeSelectedTyphoon(Typhoon newSelectedTyphoon){
    _selectedTyphoon = newSelectedTyphoon;
    notifyListeners();
  }

  void changeDocumentsPage(int pageNum){
    _documentsPage = pageNum;
    notifyListeners();
  }
}
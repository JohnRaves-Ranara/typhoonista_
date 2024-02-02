import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:typhoonista_thesis/entities/DamageCostBar.dart';
import 'package:typhoonista_thesis/entities/Location_.dart';
import 'package:typhoonista_thesis/entities/Typhoon.dart';

class page_provider with ChangeNotifier{
  int _page = 1;
  
  int get page => _page;

  List<Location_>? _locations;

  int _mainpage = 0;
  
  int? _recordedTyphoonsSelectedYear;

  void changePage(int pageNum){
    _page = pageNum;
    notifyListeners();
  }

  int get mainpage => _mainpage;

  int _documentsPage = 1;

  int get documentsPage => _documentsPage;

  Typhoon? _selectedTyphoon;

  Typhoon? get selectedTyphoon => _selectedTyphoon;

  List<Location_>? get locations => _locations;


  void changeMainPage(int pageNum){
    _mainpage = pageNum;
    notifyListeners();
  }

  int? get recordedTyphoonsSelectedYear => _recordedTyphoonsSelectedYear;

  void changeSelectedYear(int year){
    _recordedTyphoonsSelectedYear = year;
    notifyListeners();
  }



  void changeSelectedLocations(List<Location_> locations){
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
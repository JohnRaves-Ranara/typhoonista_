import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'Text.dart';
import 'textDataService.dart';

class TextDataProvider with ChangeNotifier{
  List<Text> _textList = [];
  final TextDataService textDataService = TextDataService();

  List<Text> get textList => _textList;

   Future<void> getTextData() async{
    _textList = await textDataService.getTexts();
    notifyListeners();
  }

  Future<void> addText(String text) async{
    await textDataService.addText(text);
    await getTextData();
  }
}
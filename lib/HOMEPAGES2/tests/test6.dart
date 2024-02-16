import 'package:uuid/uuid.dart';
void main(){
  List ids = ['368c3ad0-8d60-1ebe-a888-571b2bb40c77', '380b87d0-8d60-1ebe-a888-571b2bb40c77', 
  '380b87d1-8d60-1ebe-a888-571b2bb40c77', 
  '380b87d2-8d60-1ebe-a888-571b2bb40c77',
   '380b87d3-8d60-1ebe-a888-571b2bb40c77',
  '380b87d4-8d60-1ebe-a888-571b2bb40c77'];

  List d = ['380b87d2-8d60-1ebe-a888-571b2bb40c77',
  '380b87d0-8d60-1ebe-a888-571b2bb40c77', 
  '380b87d1-8d60-1ebe-a888-571b2bb40c77', 
   '380b87d3-8d60-1ebe-a888-571b2bb40c77',
  '380b87d4-8d60-1ebe-a888-571b2bb40c77',
  '368c3ad0-8d60-1ebe-a888-571b2bb40c77'
  ];

  print(d);

  d.sort();
  print("");
  print(d);
}
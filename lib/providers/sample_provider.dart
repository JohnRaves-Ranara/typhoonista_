import 'dart:async';

import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/entities2/new/Owner.dart';
import 'dart:math';

import '../entities/DamageCostBar.dart';

class SampleProvider with ChangeNotifier {
  Set<Owner> _selectedOwners = Set<Owner>();

  Set<Owner> get selectedOwners => _selectedOwners;

  void addSelectedOwner(Owner owner) {
    _selectedOwners.add(owner);
    notifyListeners();
    // isSelectedMap[owner.id] = true;
  }

  void removeSelectedOwner(Owner owner) {
    _selectedOwners.remove(owner);
    notifyListeners();
    // isSelectedMap[owner.id] = false;
  }
}

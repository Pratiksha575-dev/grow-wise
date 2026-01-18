import 'package:flutter/material.dart';
import '../models/parent.dart';
import '../models/child.dart';
import '../models/user_role.dart';
import '../services/data_service.dart';

class AppState extends ChangeNotifier {
  final DataService dataService;

  AppState(this.dataService);

  UserRole? _role;
  bool _isLoggedIn = false;

  Parent? _currentParent;
  Child? _currentChild;

  UserRole? get role => _role;
  bool get isLoggedIn => _isLoggedIn;
  Parent? get parent => _currentParent;
  Child? get child => _currentChild;

  // -------- LOGIN --------
  void markLoggedIn() {
    _isLoggedIn = true;
    notifyListeners();
  }

  // -------- ROLE --------
  void chooseRole(UserRole role) {
    _role = role;
    notifyListeners();
  }

  // -------- PARENT PIN --------
  bool verifyParentPin(String pin) {
    final parent = dataService.validateParentPin(pin);
    if (parent == null) return false;

    _currentParent = parent;
    notifyListeners();
    return true;
  }
// -------- SET CURRENT PARENT --------
  void setCurrentParent(Parent parent) {
    _currentParent = parent;
    notifyListeners();
  }

  // -------- CHILD SELECTION --------
  void selectChild(Child child) {
    _currentChild = child;
    notifyListeners();
  }

  // -------- CHILDREN OF PARENT --------
  List<Child> get childrenOfParent {
    if (_currentParent == null) return [];
    return dataService.getChildrenOfParent(_currentParent!.id);
  }

  // -------- LOGOUT --------
  void logout() {
    _isLoggedIn = false;
    _role = null;
    _currentParent = null;
    _currentChild = null;
    notifyListeners();
  }
}

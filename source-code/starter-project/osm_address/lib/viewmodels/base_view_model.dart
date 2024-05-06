import 'package:flutter/material.dart';

abstract class BaseViewModel extends ChangeNotifier{
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value){
    _isLoading = value;
    notifyListeners();
  }
}
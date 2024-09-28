import 'package:flutter/material.dart';

class ProductDataProvider with ChangeNotifier {
  List<Map<String, String>> _dataGroups = [];
  bool _isUploading = false;
  bool _isUploadSuccessful = false;

  List<Map<String, String>> get dataGroups => _dataGroups;
  bool get isUploading => _isUploading;
  bool get isUploadSuccessful => _isUploadSuccessful;

  void setDataGroups(List<Map<String, String>> data) {
    _dataGroups = data;
    _isUploadSuccessful = true;
    notifyListeners();
  }

  void setUploading(bool uploading) {
    _isUploading = uploading;
    notifyListeners();
  }

  void reset() {
    _dataGroups.clear();
    _isUploadSuccessful = false;
    notifyListeners();
  }
}

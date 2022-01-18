import 'package:flutter/material.dart';

class FormModel extends ChangeNotifier{
  List formList = [1];
  bool isOne = true;


  addFormNumberInList(){
    formList.add(formList.length + 1);
    print('count is: ${formList.length}');
    print('list is: $formList');
    formList.length>1?isOne=false:isOne=true;

    print('count is: ${formList.length}');
    print('list is: $formList');
    notifyListeners();
    //code to do
  }

  removeFormNumberFromList(){
    if (formList.length > 1) {
      formList.removeLast();
      print('new formList after deletion is: $formList');
    }
    formList.length>1?isOne=false:isOne=true;
    // count>0 ? count-- : count = count;
    notifyListeners();
    //code to do
  }

}
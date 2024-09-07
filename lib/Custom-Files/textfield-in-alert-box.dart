import 'package:flutter/material.dart';
import 'package:inventory_management/Api/products-provider.dart';
import 'package:inventory_management/Custom-Files/custom-textfield.dart';
import 'package:provider/provider.dart';

class CustomAlertBox{
   
   static void showKeyValueDialog(BuildContext context) {
    final TextEditingController keyController = TextEditingController();
    final TextEditingController valueController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        var productPageProvider=Provider.of<ProductProvider>(context,listen:true);
        return AlertDialog(
          title:const Text('Enter Key and Value'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for(int i=0;i<productPageProvider.alertBoxFieldCount;i++)
              Row(
                children: [
                  CustomTextField(controller:productPageProvider.alertBoxKeyEditingController[i],width:150,label:'Key',),
                   CustomTextField(controller:productPageProvider.alertBoxPairEditingController[i],width:150,label:'value',),
                   InkWell(
                    child:const Icon(Icons.add),
                    onTap:(){
                      productPageProvider.addNewTextEditingControllerInAlertBox();
                    },
                   )
                ],
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle the submission of the form here
                String key = keyController.text;
                String value = valueController.text;
                print('Key: $key, Value: $value');
                Navigator.of(context).pop();
              },
              child:const Text('Submit'),
            ),
          ],
        );
      },
    );
  }


  static void diaglogWithOneTextField(BuildContext context) {
    final TextEditingController keyController = TextEditingController();
    
   showDialog(
      context: context,
      builder: (context) {
        // var productPageProvider=Provider.of<ProductProvider>(context,listen:true);
        return AlertDialog(
          title:const Text('Add Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // for(int i=0;i<productPageProvider.alertBoxFieldCount;i++)
              Row(
                children: [
                  CustomTextField(controller:keyController,width:150,label:'Category',),
                  
                  
                ],
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle the submission of the form here
                String key = keyController.text;
                // String value = valueController.text;
                // print('Key: $key, Value: $value');
                Navigator.of(context).pop();
              },
              child:const Text('Submit'),
            ),
           
          ],
        );
      },
    );
  }
}
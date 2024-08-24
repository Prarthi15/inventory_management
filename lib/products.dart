import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:inventory_management/Custom-Files/custom-dropdown.dart';
import 'package:inventory_management/Custom-Files/custom-textfield.dart';
// import 'package:inventory_management/Custom-Files/cutom-textfieild.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  String _selectedProductCategory = "Create Simple Product";

  // Controllers for each text field
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productIdentifierController =
      TextEditingController();
  final TextEditingController _productBrandController = TextEditingController();
  final TextEditingController _modelNameController = TextEditingController();
  final TextEditingController _modelNumberController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _accountingItemNameController =
      TextEditingController();
  final TextEditingController _accountingItemUnitController =
      TextEditingController();
  final TextEditingController _materialTypeController = TextEditingController();
  final TextEditingController _predefinedTaxRuleController =
      TextEditingController();
  final TextEditingController _productTaxCodeController =
      TextEditingController();
  final TextEditingController _productSpecificationController =
      TextEditingController();
  final TextEditingController _mrpController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _depthController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();

  final TextEditingController _skuController = TextEditingController();
  final TextEditingController _eanUpcController = TextEditingController();

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Add a form key

  @override
  void dispose() {
    _productNameController.dispose();
    _productIdentifierController.dispose();
    _productBrandController.dispose();
    _modelNameController.dispose();
    _modelNumberController.dispose();
    _descriptionController.dispose();
    _accountingItemNameController.dispose();
    _accountingItemUnitController.dispose();
    _materialTypeController.dispose();
    _predefinedTaxRuleController.dispose();
    _productTaxCodeController.dispose();
    _productSpecificationController.dispose();
    _mrpController.dispose();
    _costController.dispose();
    _weightController.dispose();
    _lengthController.dispose();
    _widthController.dispose();
    _depthController.dispose();
    super.dispose();
  }

  void clear() {
    _productNameController.clear();
    _productIdentifierController.clear();
    _productBrandController.clear();
    _modelNameController.clear();
    _modelNumberController.clear();
    _descriptionController.clear();
    _accountingItemNameController.clear();
    _accountingItemUnitController.clear();
    _materialTypeController.clear();
    _predefinedTaxRuleController.clear();
    _productTaxCodeController.clear();
    _productSpecificationController.clear();
    _mrpController.clear();
    _costController.clear();
    _weightController.clear();
    _lengthController.clear();
    _widthController.clear();
    _depthController.clear();
    _sizeController.clear();
    _eanUpcController.clear();
    _colorController.clear();
    _skuController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth=MediaQuery.of(context).size;
          return Scaffold(
            backgroundColor: Colors.white,
            body:MediaQuery.of(context).size.width>1200?webLayout(context):mobileLayout(context),
          );
        
      
    
  }
//mobile layout
Widget mobileLayout(BuildContext context) {
    return Expanded(
      child: Padding(
          padding: 
                EdgeInsets.only(top: 40.0, left:MediaQuery.of(context).size.width>450?70:0),
          child: Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width * 0.9,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          fieldTitle('Product Category', height: 50),
                          SizedBox(
                            child: Column(
                              children: [
                                radioCheck('Create Simple Product', (val) {
                                  setState(() {
                                    _selectedProductCategory = val!;
                                  });
                                }),
                                radioCheck('Variant Product Creation', (val) {
                                  setState(() {
                                    _selectedProductCategory = val!;
                                  });
                                }),
                                radioCheck('Create Virtual Combo Products',
                                    (val) {
                                  setState(() {
                                    _selectedProductCategory = val!;
                                  });
                                }),
                                radioCheck('Create Kit Products', (val) {
                                  setState(() {
                                    _selectedProductCategory = val!;
                                  });
                                }),
                              ],
                            ),
                          ),
                          // const SizedBox(height: 5.0),
                          fieldTitle('Product Name', height: 50),
                          SizedBox(
                            child: CustomTextField(
                                controller: _productNameController,
                                height: 51,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Product Name is required';
                                  }
                                  return null;
                                }),
                          ),
                         
                          fieldTitle('Product identifier', height: 50),
                          Container(
                            height: 250,
                            width: 550,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blue.shade200,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    fieldTitle(
                                      'SKU',
                                      height: 51,
                                    ),
                                    const SizedBox(height: 8.0),
                                    fieldTitle('EAM/UPC',
                                        show: false, height: 51),
                                  ],
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomTextField(
                                        controller: _skuController,
                                        height: 51,
                                        width: 150,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'SKU is required';
                                          }
                                          return null;
                                        }),
                                    const SizedBox(height: 8.0),
                                    CustomTextField(
                                      controller: _eanUpcController,
                                      height: 51,
                                      width: 150,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          
                          fieldTitle('Product Brand', height: 50),
                          SizedBox(
                            child: CustomTextField(
                                controller: _productBrandController,
                                height: 51,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Product Brand is required';
                                  }
                                  return null;
                                }),
                          ),
                        
                          fieldTitle('Category', show: false, height: 50),
                          SizedBox(
                            child:MediaQuery.of(context).size.width>450? Row(
                              children: [
                                const SizedBox(
                                  height: 51,
                                  width: 260,
                                  child: CustomDropdown(
                                    key: null,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    // errorStyle:'',
                                    border:
                                        Border.all(color: Colors.blue.shade50),
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.blue.shade50,
                                  ),
                                  height: 51,
                                  width: 70,
                                  child: const Center(
                                      child: Text(
                                    '+ New',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                                )
                              ],
                            ):Column(
                              crossAxisAlignment:CrossAxisAlignment.start,
                              children: [
                                 const SizedBox(
                                  height: 51,
                                  width: 260,
                                  child: CustomDropdown(
                                    key: null,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                const SizedBox(height:3,),
                                Container(
                                  decoration: BoxDecoration(
                                    // errorStyle:'',
                                    border:
                                        Border.all(color: Colors.blue.shade50),
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.blue.shade50,
                                  ),
                                  height: 51,
                                  width: 70,
                                  child: const Center(
                                      child: Text(
                                    '+ New',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                                )
                              ],
                            ),
                          ),
                          
                          fieldTitle('Model Name', show: false, height: 50),
                          SizedBox(
                            child: CustomTextField(
                              controller: _modelNameController,
                              height: 51,
                            ),
                          ),
                          
                          fieldTitle('Model Number', height: 50),
                          CustomTextField(
                                      controller: _modelNumberController,
                                      height: 51,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Model Number is required';
                                        }
                                        return null;
                                      }),
                        
                          fieldTitle('Description', show: false, height: 70),
                          SizedBox(
                            child: CustomTextField(
                              controller: _descriptionController,
                              maxLines: 10,
                              height: 70,
                            ),
                          ),
                         
                          fieldTitle('Accounting Item Name',
                              show: false, height: 50),
                          SizedBox(
                            child: CustomTextField(
                              controller: _accountingItemNameController,
                              height: 51,
                            ),
                          ),
                         
                          fieldTitle('Accounting Item Unit',
                              show: false, height: 50),
                          SizedBox(
                            child: CustomTextField(
                              controller: _accountingItemUnitController,
                              height: 51,
                            ),
                          ),
                         
                          fieldTitle('Material Type', height: 50),
                          const SizedBox(
                            height: 51,
                            width: 550,
                            child: CustomDropdown(
                              key: null,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          fieldTitle('Predefined Tax Rule',show: false, height: 50),
                          const SizedBox(
                            height: 51,
                            width: 550,
                            child: CustomDropdown(
                              key: null,
                            ),
                          ),
                         
                          fieldTitle('Product Tax Code',show: false, height: 50),
                          SizedBox(
                            child: CustomTextField(
                              controller: _productTaxCodeController,
                              height: 51,
                            ),
                          ),
                         
                          fieldTitle('Product Specification',
                              show: false, height: 50),
                          Container(
                            height: 250,
                            width: 550,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blue.shade200,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      fieldTitle(
                                        'Size',
                                        show: false,
                                        height: 30,
                                      ),
                                      const SizedBox(height: 33.0),
                                      fieldTitle('Color',
                                          show: false, height: 30),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomTextField(
                                        controller: _sizeController,
                                        height: 51,
                                        width: 150,
                                        keyboardType: TextInputType.number,
                                      ),
                                      const SizedBox(height:15.0),
                                      CustomTextField(
                                        controller: _colorController,
                                        height: 51,
                                        width: 150,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          fieldTitle('MRP', show: false, height: 50),
                          SizedBox(
                            child: CustomTextField(
                              controller: _mrpController,
                              height: 51,
                              icon: Icons.currency_rupee_rounded,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          
                          fieldTitle('Cost', height: 50),
                          SizedBox(
                            child: CustomTextField(
                              controller: _costController,
                              height: 51,
                              icon: Icons.currency_rupee_rounded,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Cost is required';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          
                          fieldTitle('Weight', show: false, height: 50),
                          SizedBox(
                            child: CustomTextField(
                              controller: _weightController,
                              height: 51,
                              unit: '(in gram)',
                              icon: Icons.currency_rupee_rounded,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                       
                          fieldTitle('Package Dimension',
                              show: false, height: 50),
                          SizedBox(
                            width: 550,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    controller: _lengthController,
                                    prefix: 'L',
                                    // width: 150,
                                    unit: 'cm',
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const Text('x'),
                                Expanded(
                                  child: CustomTextField(
                                    controller: _widthController,
                                    // width: 150,
                                    prefix: 'W',
                                    unit: 'cm',
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const Text('x'),
                                Expanded(
                                  child: CustomTextField(
                                    controller: _depthController,
                                    // width: 150,
                                    prefix: 'D',
                                    unit: 'cm',
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          fieldTitle('Custom', show: false, height: 50),
                          const SizedBox(
                            height: 51,
                            width: 550,
                            child: CustomDropdown(
                              key: null,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          _selectedProductCategory == 'Create Simple Product'
                              ? const Text(
                                  '* please select all mandantotry field',
                                  style: TextStyle(color: Colors.red),
                                )
                              : const Text(''),
                          _selectedProductCategory == 'Create Simple Product'
                              ? const SizedBox(height: 10.0)
                              : const SizedBox(
                                  height: 0,
                                ),
                          SizedBox(
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 50,
                                  width: 200,
                                  child: ElevatedButton(
                                    onPressed: _selectedProductCategory !=
                                            'Create Simple Product'
                                        ? () {
                                            if (_formKey.currentState!
                                                    .validate() &&
                                                _selectedProductCategory !=
                                                    'Create Simple Product') {
                                              print("Product saved");
                                            }
                                          }
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor:
                                          const Color.fromRGBO(6, 90, 216, 1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(2.0),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0),
                                    ),
                                    child: const Text("Save Product",),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                SizedBox(
                                  height: 50,
                                  width: 80,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      print("Reset called");
                                      clear();
                                      setState(() {});
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.blue.shade500,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(2.0),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0),
                                    ),
                                    child: const Text("Reset"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                         const SizedBox(
                            height:70,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
    );
  }


  //for web layout

  Padding webLayout(BuildContext context) {
    return Padding(
            padding:MediaQuery.of(context).size.width>900?const EdgeInsets.only(top: 40.0, left: 70):const EdgeInsets.all(0),
            child: Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width * 0.9,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                fieldTitle('Product Category', height: 50),
                               
                                fieldTitle('Product Name', height: 50),
                                // const SizedBox(height: 5.0),
                                SizedBox(
                                  height: 250,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      fieldTitle('Product identifier', height: 50),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                fieldTitle('Product Brand', height: 50),
                                const SizedBox(height: 8.0),
                                fieldTitle('Category', show: false, height: 50),
                                const SizedBox(height: 8.0),
                                fieldTitle('Model Name', show: false, height: 50),
                                const SizedBox(height: 8.0),
                                fieldTitle('Model Number', height: 50),
                                const SizedBox(height: 8.0),
                                fieldTitle('Description', show: false, height: 70),
                                const SizedBox(height: 8.0),
                                fieldTitle('Accounting Item Name',
                                    show: false, height: 50),
                                const SizedBox(height: 8.0),
                                fieldTitle('Accounting Item Unit',
                                    show: false, height: 50),
                                const SizedBox(height: 8.0),
                                fieldTitle('Material Type', height: 50),
                                const SizedBox(height: 8.0),
                                fieldTitle('Predefined Tax Rule', height: 50),
                                const SizedBox(height: 8.0),
                                fieldTitle('Product Tax Code', height: 50),
                                const SizedBox(height: 8.0),
                                SizedBox(
                                  height: 250,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      fieldTitle('Product Specification',
                                          show: false, height: 50),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                fieldTitle('MRP', show: false, height: 50),
                                const SizedBox(height: 8.0),
                                fieldTitle('Cost', height: 50),
                                const SizedBox(height: 8.0),
                                fieldTitle('Weight', show: false, height: 50),
                                const SizedBox(height: 8.0),
                                fieldTitle('Package Dimension',
                                    show: false, height: 50),
                                const SizedBox(height: 8.0),
                                fieldTitle('Custom', show: false, height: 50),
                                const SizedBox(height: 240),
                              ],
                            ),
                            const SizedBox(width: 30),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height:MediaQuery.of(context).size.width>1200 && MediaQuery.of(context).size.width<1400?90:50,
                                  child: Column(
                                    children: [
                                       const SizedBox(height: 9.0),
                                      Row(
                                        children: [
                                          radioCheck('Create Simple Product', (val) {
                                            setState(() {
                                              _selectedProductCategory = val!;
                                            });
                                          }),
                                          radioCheck('Variant Product Creation', (val) {
                                            setState(() {
                                              _selectedProductCategory = val!;
                                            });
                                          }),
                                          MediaQuery.of(context).size.width>1400?
                                          radioCheck('Create Virtual Combo Products',
                                              (val) {
                                            setState(() {
                                              _selectedProductCategory = val!;
                                            });
                                          }):const SizedBox(),
                                          MediaQuery.of(context).size.width>1400?
                                          radioCheck('Create Kit Products', (val) {
                                            setState(() {
                                              _selectedProductCategory = val!;
                                            });
                                          }):const SizedBox(),
                                        ],
                                      ),
                                      MediaQuery.of(context).size.width>1200 && MediaQuery.of(context).size.width<1400?Padding(
                                        padding: const EdgeInsets.only(left:20),
                                        child: Row(
                                          
                                          children: [ 
                                            radioCheck('Create Virtual Combo Products',
                                                (val) {
                                              setState(() {
                                                _selectedProductCategory = val!;
                                              });
                                            }),
                                           
                                            radioCheck('Create Kit Products', (val) {
                                              setState(() {
                                                _selectedProductCategory = val!;
                                              });
                                            }),
                                          ],
                                        ),
                                      ):const SizedBox(),
                                        
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                CustomTextField(
                                    controller: _productNameController,
                                    height: 51,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Product Name is required';
                                      }
                                      return null;
                                    }),
                                const SizedBox(height: 8.0),
                                Container(
                                  height: 250,
                                  width: 550,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.blue.shade200,
                                    ),
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          fieldTitle(
                                            'SKU',
                                            height: 51,
                                          ),
                                          const SizedBox(height: 8.0),
                                          fieldTitle('EAM/UPC',
                                              show: false, height: 51),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CustomTextField(
                                              controller: _skuController,
                                              height: 51,
                                              width: 150,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'SKU is required';
                                                }
                                                return null;
                                              }),
                                          const SizedBox(height: 8.0),
                                          CustomTextField(
                                            controller: _eanUpcController,
                                            height: 51,
                                            width: 150,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                CustomTextField(
                                    controller: _productBrandController,
                                    height: 51,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Product Brand is required';
                                      }
                                      return null;
                                    }),
                                const SizedBox(height: 8.0),
                                Row(
                                  children: [
                                    const SizedBox(
                                      height: 51,
                                      width: 260,
                                      child: CustomDropdown(
                                        key: null,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        // errorStyle:'',
                                        border:
                                            Border.all(color: Colors.blue.shade50),
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.blue.shade50,
                                      ),
                                      height: 51,
                                      width: 70,
                                      child: const Center(
                                          child: Text(
                                        '+ New',
                                        style:
                                            TextStyle(fontWeight: FontWeight.bold),
                                      )),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                CustomTextField(
                                  controller: _modelNameController,
                                  height: 51,
                                ),
                                const SizedBox(height: 8.0),
                                CustomTextField(
                                    controller: _modelNumberController,
                                    height: 51,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Model Number is required';
                                      }
                                      return null;
                                    }),
                                const SizedBox(height: 8.0),
                                CustomTextField(
                                  controller: _descriptionController,
                                  maxLines: 10,
                                  height: 70,
                                ),
                                const SizedBox(height: 8.0),
                                CustomTextField(
                                  controller: _accountingItemNameController,
                                  height: 51,
                                ),
                                const SizedBox(height: 8.0),
                                CustomTextField(
                                  controller: _accountingItemUnitController,
                                  height: 51,
                                ),
                                const SizedBox(height: 8.0),
                                const SizedBox(
                                  height: 51,
                                  width: 550,
                                  child: CustomDropdown(
                                    key: null,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                const SizedBox(
                                  height: 51,
                                  width: 550,
                                  child: CustomDropdown(
                                    key: null,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                CustomTextField(
                                  controller: _productTaxCodeController,
                                  height: 51,
                                ),
                                const SizedBox(height: 8.0),
                                Container(
                                  height: 250,
                                  width: 550,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.blue.shade200,
                                    ),
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            fieldTitle(
                                              'Size',
                                              show: false,
                                              height: 30,
                                            ),
                                            const SizedBox(height: 33.0),
                                            fieldTitle('Color',
                                                show: false, height: 30),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CustomTextField(
                                              controller: _sizeController,
                                              height: 51,
                                              width: 150,
                                              keyboardType: TextInputType.number,
                                            ),
                                            const SizedBox(height: 8.0),
                                            CustomTextField(
                                              controller: _colorController,
                                              height: 51,
                                              width: 150,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                CustomTextField(
                                  controller: _mrpController,
                                  height: 51,
                                  icon: Icons.currency_rupee_rounded,
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(height: 8.0),
                                CustomTextField(
                                  controller: _costController,
                                  height: 51,
                                  icon: Icons.currency_rupee_rounded,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Cost is required';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(height: 8.0),
                                CustomTextField(
                                  controller: _weightController,
                                  height: 51,
                                  unit: '(in gram)',
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(height: 8.0),
                                SizedBox(
                                  width: 550,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomTextField(
                                        controller: _lengthController,
                                        prefix: 'L',
                                        width: 150,
                                        unit: 'cm',
                                        keyboardType: TextInputType.number,
                                      ),
                                      const Text('x'),
                                      CustomTextField(
                                        controller: _widthController,
                                        width: 150,
                                        prefix: 'W',
                                        unit: 'cm',
                                        keyboardType: TextInputType.number,
                                      ),
                                      const Text('x'),
                                      CustomTextField(
                                        controller: _depthController,
                                        width: 150,
                                        prefix: 'D',
                                        unit: 'cm',
                                        keyboardType: TextInputType.number,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                const SizedBox(
                                  height: 51,
                                  width: 550,
                                  child: CustomDropdown(
                                    key: null,
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                _selectedProductCategory == 'Create Simple Product'
                                    ? const Text(
                                        '* please select all mandantotry field',
                                        style: TextStyle(color: Colors.red),
                                      )
                                    : const Text(''),
                                _selectedProductCategory == 'Create Simple Product'
                                    ? const SizedBox(height: 10.0)
                                    : const SizedBox(
                                        height: 0,
                                      ),
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 35,
                                      width: 200,
                                      child: ElevatedButton(
                                        onPressed: _selectedProductCategory !=
                                                'Create Simple Product'
                                            ? () {
                                                if (_formKey.currentState!
                                                        .validate() &&
                                                    _selectedProductCategory !=
                                                        'Create Simple Product') {
                                                  print("Product saved");
                                                }
                                              }
                                            : null,
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor:
                                              const Color.fromRGBO(6, 90, 216, 1),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(2.0),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16.0),
                                        ),
                                        child: const Text("Save Product"),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    SizedBox(
                                      height: 35,
                                      width: 70,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          print("Reset called");
                                          clear();
                                          setState(() {});
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.blue.shade500,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(2.0),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16.0),
                                        ),
                                        child: const Text("Reset"),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 200),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  Widget fieldTitle(String filTitle, {double height = 51, bool show = true}) {
    return SizedBox(
      height: height,
      child: Row(
        children: [
          Text(filTitle, style: const TextStyle(fontSize: 15)),
          show
              ? const Text(
                  ' *',
                  style: TextStyle(color: Colors.red),
                )
              : const Text('  '),
        ],
      ),
    );
  }

  Widget radioCheck(
    String title,
    Function(String?) onTap,
  ) {
    return Row(
      children: [
        Radio<String>(
          value: title,
          groupValue: _selectedProductCategory,
          onChanged: onTap,
        ),
        Text(title),
      ],
    );
  }
}

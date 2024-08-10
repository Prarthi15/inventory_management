import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management/Custom-Files/custom-dropdown.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  String _selectedProductCategory = "Create Simple Product";
  
  // Controllers for each text field
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productIdentifierController = TextEditingController();
  final TextEditingController _productBrandController = TextEditingController();
  final TextEditingController _modelNameController = TextEditingController();
  final TextEditingController _modelNumberController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _accountingItemNameController = TextEditingController();
  final TextEditingController _accountingItemUnitController = TextEditingController();
  final TextEditingController _materialTypeController = TextEditingController();
  final TextEditingController _predefinedTaxRuleController = TextEditingController();
  final TextEditingController _productTaxCodeController = TextEditingController();
  final TextEditingController _productSpecificationController = TextEditingController();
  final TextEditingController _mrpController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _depthController = TextEditingController();

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
    // super.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 40.0, left: 70),
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width * 0.9,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          fieldTitle('Product Category', height:50),
                          const SizedBox(height: 8.0),
                          fieldTitle('Product Name', height:50),
                          const SizedBox(height: 8.0),
                          SizedBox(
                            height: 250,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                fieldTitle('Product identifier', height:50),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          fieldTitle('Product Brand', height:50),
                          const SizedBox(height: 8.0),
                          fieldTitle('Category', height:50),
                          const SizedBox(height: 8.0),
                          fieldTitle('Model Name', height:50),
                          const SizedBox(height: 8.0),
                          fieldTitle('Model Number', height:50),
                          const SizedBox(height: 8.0),
                          fieldTitle('Description', height: 70),
                          const SizedBox(height: 8.0),
                          fieldTitle('Accounting Item Name', height:50),
                          const SizedBox(height: 8.0),
                          fieldTitle('Accounting Item Unit', height:50),
                          const SizedBox(height: 8.0),
                          fieldTitle('Material Type', height:50),
                          const SizedBox(height: 8.0),
                          fieldTitle('Predefined Tax Rule', height:50),
                          const SizedBox(height: 8.0),
                          fieldTitle('Product Tax Code', height:50),
                          const SizedBox(height: 8.0),
                          SizedBox(
                            height: 250,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                fieldTitle('Product Specification', height:50),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          fieldTitle('MRP', height:50),
                          const SizedBox(height: 8.0),
                          fieldTitle('Cost', height:50),
                          const SizedBox(height: 8.0),
                          fieldTitle('Weight', height:50),
                          const SizedBox(height: 8.0),
                          fieldTitle('Package Dimension', height:50),
                          const SizedBox(height: 8.0),
                          fieldTitle('Custom', height:50),
                          const SizedBox(height: 240),
                        ],
                      ),
                      const SizedBox(width: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height:50,
                            child: Row(
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
                                radioCheck('Create Virtual Combo Products', (val) {
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
                          const SizedBox(height: 8.0),
                          textFiled(controller: _productNameController, height: 50),
                          const SizedBox(height: 8.0),
                          Container(
                            height: 250,
                            width: 550,
                            decoration: BoxDecoration(border: Border.all()),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      fieldTitle('   Dipu', height: 51),
                                      const SizedBox(height: 8.0),
                                      fieldTitle('Patidar', height: 51),
                                    ],
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        textFiled(controller: _productIdentifierController),
                                        const SizedBox(height: 8.0),
                                        textFiled(controller: _productIdentifierController),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          textFiled(controller: _productBrandController),
                          const SizedBox(height: 8.0),
                          const SizedBox(
                            height: 51,
                            width: 550,
                            child: CustomDropdown(
                              key: null,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          textFiled(controller: _modelNameController, height: 51),
                          const SizedBox(height: 8.0),
                          textFiled(controller: _modelNumberController, height: 51),
                          const SizedBox(height: 8.0),
                          textFiled(controller: _descriptionController, maxLine: 10, height:51),
                          const SizedBox(height: 8.0),
                          textFiled(controller: _accountingItemNameController, height: 51),
                          const SizedBox(height: 8.0),
                          textFiled(controller: _accountingItemUnitController, height: 51),
                          const SizedBox(height: 8.0),
                          textFiled(controller: _materialTypeController, height: 51),
                          const SizedBox(height: 8.0),
                          textFiled(controller:_predefinedTaxRuleController,height: 51),
                          const SizedBox(height: 8.0),
                          textFiled(controller: _productTaxCodeController, height: 51,),
                          const SizedBox(height: 8.0),
                          Container(
                            height: 250,
                            width: 550,
                            decoration: BoxDecoration(border: Border.all()),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      fieldTitle('   Dipu', height: 30),
                                      const SizedBox(height: 8.0),
                                      fieldTitle('Patidar', height: 30),
                                    ],
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        textFiled(controller: _productSpecificationController, height:51),
                                        const SizedBox(height: 8.0),
                                        textFiled(controller: _productSpecificationController, height:51),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          textFiled(controller: _mrpController, height: 51, icons: Icons.currency_rupee_rounded),
                          const SizedBox(height: 8.0),
                          textFiled(controller: _costController, height: 51,icons: Icons.currency_rupee_rounded),
                          const SizedBox(height: 8.0),
                          textFiled(controller: _weightController, height: 51, unit: '(in gram)'),
                          const SizedBox(height: 8.0),
                          SizedBox(
                            width: 550,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                textFiled(controller: _lengthController,prefix:'L',width: 150,unit: 'cm'),
                                const Text('x'),
                                textFiled(controller: _widthController, width: 150,prefix:'W', unit: 'cm'),
                                const Text('x'),
                                textFiled(controller: _depthController, width: 150,prefix:'D', unit: 'cm'),
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
                          const SizedBox(height: 8.0),
                          Row(
                            children: [
                              SizedBox(
                                height: 35,
                                width: 200,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Navigator.pushNamed(context, '/dashboard');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: const Color.fromRGBO(6, 90, 216, 1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                                    print("i am called \n");
                                    clear();
                                    setState(() {
                                      
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: const Color.fromRGBO(255, 255, 255, 255),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 16.0),
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

  Widget fieldTitle(String filTitle, {double height = 0, bool show = true}) {
    return SizedBox(
      height: height,
      child: Row(
        children: [
          Text(filTitle,style:const TextStyle(fontSize:17),),
          show
              ? const Text(
                  ' *',
                  style: TextStyle(color: Colors.red),
                )
              : const Text(''),
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
        Text(title)
      ],
    );
  }

  Widget textFiled({
    int maxLine = 1,
    double height = 51,
    double width = 550,
    IconData? icons,
    String? unit,
    String? prefix,
    required TextEditingController controller,
  }) {
    return SizedBox(
      height: height,
      width: width,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 0.0, top: 0),
        child: TextField(
          cursorWidth: 2.0,
          controller: controller,
          maxLines: maxLine,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            prefixIcon: icons != null && prefix == null ? Icon(icons) : prefix != null ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(prefix),
            ) : null,
            suffix: unit != null ? Text(unit) : const Text(''),
            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
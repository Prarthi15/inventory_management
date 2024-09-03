import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inventory_management/Api/auth_provider.dart';
import 'package:inventory_management/Api/products-provider.dart';
import 'package:inventory_management/Custom-Files/colors.dart';
import 'package:inventory_management/Custom-Files/custom-button.dart';
import 'package:inventory_management/Custom-Files/custom-dropdown.dart';
import 'package:inventory_management/Custom-Files/custom-textfield.dart';
import 'package:inventory_management/Custom-Files/multi-image-picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  // String productProvider!.selectedProductCategory = "Create Simple Product";
  List<String>? webImages;
  // int variationCount = 1;
  
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
  String ?token;
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Add a form key
   List<Map<String, dynamic>>?cat;
   List<Map<String, dynamic>>?brand;

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
  
ProductProvider? productProvider;

@override
void initState() {
  super.initState();
  getCategories();
 
}

  void getCategories()async{
      // print("amazing with new concept ${await AuthProvider().getAllCategories()}");
       cat = 
    (await AuthProvider().getAllCategories())['data'].cast<Map<String, dynamic>>();
      // print("dataa is sheree eeee  ${cat![0]["name"]}");
      // AuthProvider().parseJsonToList(await AuthProvider().getAllCategories()['data']);

       
      brand=(await AuthProvider().getAllBrandName())['data'].cast<Map<String, dynamic>>();
      setState(() {
        print("heelo i am here ");
      });
  }
  @override
  Widget build(BuildContext context) {
    productProvider = Provider.of<ProductProvider>(context, listen:true);
    // final productProvider=[];
    final screenWidth = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body:cat!=null?(MediaQuery.of(context).size.width > 1200
          ? webLayout(context,)
          : mobileLayout(context,)):CircularProgressIndicator()
    );
  }

//mobile layout
  Widget mobileLayout(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(
            top: 40.0, left: MediaQuery.of(context).size.width > 450 ? 70 : 0),
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
                        fieldTitle('Product Category', height: 50, width: 140),
                        SizedBox(
                          child: Column(
                            children: [
                              radioCheck('Create Simple Product', (val) {
                                productProvider!.updateSelectedProductCategory(val!);
                              }),
                              radioCheck('Variant Product Creation', (val) {
                                productProvider!.updateSelectedProductCategory(val!);
                              }),
                              radioCheck('Create Virtual Combo Products',
                                  (val) {
                                productProvider!.updateSelectedProductCategory(val!);
                              }),
                              radioCheck('Create Kit Products', (val) {
                                productProvider!.updateSelectedProductCategory(val!);
                              }),
                            ],
                          ),
                        ),
                        // const SizedBox(height: 5.0),
                        fieldTitle('Product Name', height: 50, width: 110),
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

                        fieldTitle('Product identifier',
                            height: 50, width: 130),
                        Container(
                          height: 250,
                          width: 550,
                          
                          decoration: BoxDecoration(
                            
                            border: Border.all(
                              color: Colors.black.withOpacity(0.2),
                              
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
                                    // width:51
                                  ),
                                  const SizedBox(height: 8.0),
                                  fieldTitle('EAM/UPC',
                                      // width:,
                                      show: false,
                                      height: 51),
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

                        fieldTitle('Product Brand', height: 50, width: 110),
                        SizedBox(
                          height: 51,
                          width: 150,
                          child: CustomDropdown(option:brand!,)),

                        fieldTitle('Category',
                            show: false, height: 50, width: 70),
                        SizedBox(
                          child: MediaQuery.of(context).size.width > 450
                              ? Row(
                                  children: [
                                     SizedBox(
                                      height: 51,
                                      width: 260,
                                      child: CustomDropdown(
                                        key: null,
                                        option:cat!,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        // errorStyle:'',
                                        border: Border.all(
                                            color: Colors.blue.shade50),
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.blue.shade50,
                                      ),
                                      height: 51,
                                      width: 70,
                                      child: const Center(
                                          child: Text(
                                        '+ New',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                    )
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                     SizedBox(
                                      height: 51,
                                      width: 260,
                                      child: CustomDropdown(
                                        key: null,
                                        option:cat!,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        // errorStyle:'',
                                        border: Border.all(
                                            color: Colors.blue.shade50),
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.blue.shade50,
                                      ),
                                      height: 51,
                                      width: 70,
                                      child: const Center(
                                          child: Text(
                                        '+ New',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                    )
                                  ],
                                ),
                        ),
                     productProvider!.selectedProductCategory=='Variant Product Creation'?fieldTitle('Variations', width: 80):const SizedBox(),
                      productProvider!.selectedProductCategory=='Variant Product Creation'?   variantProductCreation(context):const SizedBox(),

                        fieldTitle('Technical Name',
                            show: false, height: 50, width: 95.5),
                        SizedBox(
                          child: CustomTextField(
                            controller: _modelNameController,
                            height: 51,
                          ),
                        ),

                        fieldTitle('Model Number', height: 50, width: 112),
                        CustomTextField(
                            controller: _modelNumberController,
                            height: 51,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Model Number is required';
                              }
                              return null;
                            }),

                        fieldTitle('Description',
                            show: false, height: 70, width: 89.5),
                        SizedBox(
                          child: CustomTextField(
                            controller: _descriptionController,
                            maxLines: 10,
                            height: 70,
                          ),
                        ),

                        fieldTitle('Accounting Item Name',
                            show: false, height: 50, width: 166),
                        SizedBox(
                          child: CustomTextField(
                            controller: _accountingItemNameController,
                            height: 51,
                          ),
                        ),

                        fieldTitle('Accounting Item Unit',
                            show: false, height: 50, width: 152.295),
                        SizedBox(
                          child: CustomTextField(
                            controller: _accountingItemUnitController,
                            height: 51,
                          ),
                        ),

                        fieldTitle('Material Type', height: 50, width: 103.2),
                         SizedBox(
                          height: 51,
                          width: 550,
                          child: CustomDropdown(
                            key: null,
                            option:cat!,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        fieldTitle('Predefined Tax Rule',
                            show: false, height: 50, width: 144.5),
                         SizedBox(
                          height: 51,
                          width: 550,
                          child: CustomDropdown(
                            key: null,
                            option:cat!,
                          ),
                        ),

                        fieldTitle('Product Tax Code',
                            show: false, height: 50, width: 130),
                        SizedBox(
                          child: CustomTextField(
                            controller: _productTaxCodeController,
                            height: 51,
                          ),
                        ),

                        fieldTitle('Product Specification',
                            show: false, height: 50, width: 156),
                        Container(
                          height: 250,
                          width: 550,
                          decoration: BoxDecoration(
                             border: Border.all(
                      color:Colors.black.withOpacity(0.2)
                    ),
                    borderRadius:BorderRadius.circular(10),
                    color: Colors.white30,
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
                                    const SizedBox(height: 15.0),
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

                        fieldTitle('MRP', show: false, height: 50, width: 40),
                        SizedBox(
                          child: CustomTextField(
                            controller: _mrpController,
                            height: 51,
                            icon: Icons.currency_rupee_rounded,
                            keyboardType: TextInputType.number,
                          ),
                        ),

                        fieldTitle('Cost', height: 50, width: 42),
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

                        fieldTitle('Weight',
                            show: false, height: 50, width: 55.2),
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
                            show: false, height: 50, width: 144),
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

                        fieldTitle('Custom', show: false, height: 50, width: 1),
                         SizedBox(
                          height: 51,
                          width: 550,
                          child: CustomDropdown(
                            key: null,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        productProvider!.selectedProductCategory == 'Create Simple Product' ||
                                productProvider!.selectedProductCategory ==
                                    'Variant Product Creation'
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Select Image'),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  InkWell(
                                    child: Row(
                                      children: [
                                        const Icon(Icons.add_a_photo),
                                        webImages != null
                                            ? SizedBox(
                                                height: 100,
                                                width: 300,
                                                child:
                                                    CustomHorizontalImageScroller(
                                                  webImageUrls: webImages,
                                                ))
                                            : const SizedBox(),
                                      ],
                                    ),
                                    onTap: () async {
                                      webImages =
                                          await MultiImagePicker().pickImages();
                                      setState(() {});
                                    },
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        const SizedBox(height: 10.0),
                        productProvider!.selectedProductCategory == 'Create Simple Product'
                            ? const Text(
                                '* please select all mandantotry field',
                                style: TextStyle(color: Colors.red),
                              )
                            : const Text(''),
                        productProvider!.selectedProductCategory == 'Create Simple Product'
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
                                  onPressed: productProvider!.selectedProductCategory !=
                                          'Create Simple Product'
                                      ? () {
                                          if (_formKey.currentState!
                                                  .validate() &&
                                              productProvider!.selectedProductCategory !=
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
                                      borderRadius: BorderRadius.circular(2.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                  ),
                                  child: const Text(
                                    "Save Product",
                                  ),
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
                                      borderRadius: BorderRadius.circular(2.0),
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
                          height: 70,
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
  Widget webLayout(
    BuildContext context,
  ) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              formLayout(
                fieldTitle('Product Category'),
                customRadioButtonLayout(context),
              ),
             
              const SizedBox(
                height: 8,
              ),
              formLayout(
                fieldTitle('Product Name'),
                CustomTextField(
                    controller: _productNameController,
                    height: 51,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Product Name is required';
                      }
                      return null;
                    }),
              ),
              const SizedBox(
                height: 12,
              ),
              formLayout(
                fieldTitle('Product Identifier'),
                Container(
                  width: 550,
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:Colors.black.withOpacity(0.2)
                    ),
                    borderRadius:BorderRadius.circular(10),
                    color: Colors.white30,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      formLayout(
                          fieldTitle(
                            'SKU',
                            height: 51,
                          ),
                          CustomTextField(
                            controller: _skuController,
                            width: 150,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'SKU is required';
                              }
                              return null;
                            },
                          ),
                          mainAxisAlignment: MainAxisAlignment.center),
                      const SizedBox(height: 8.0),
                      formLayout(
                          fieldTitle(
                            'EAM/UPC',
                            height: 51,
                          ),
                          Container(
                            // color: Colors.blueAccent,
                            width: 150,
                            height: 51,
                            child: CustomTextField(
                              controller: _eanUpcController,
                              width: 150,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'EAM/UPC is required';
                                }
                                return null;
                              },
                            ),
                          ),
                          mainAxisAlignment: MainAxisAlignment.center),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              formLayout(
                  fieldTitle('Brand'),
                  SizedBox(
                    height: 51,
                                    width: 150,
                    child: CustomDropdown(option:brand!,)),
                  ),
              const SizedBox(height: 12),
              formLayout(
                  fieldTitle('Category'),
                  Row(
                    children: [
                      SizedBox(width: 150, height: 51, child: CustomDropdown(option:cat!,)),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue.shade50),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.blue.shade50,
                        ),
                        height: 51,
                        width: 70,
                        child: const Center(
                            child: Text(
                          '+ New',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                      ),
                    ],
                  )),
                  const SizedBox(height: 12),
               
                 productProvider!.selectedProductCategory=='Variant Product Creation'?formLayout(
                fieldTitle('Variations'),
                variantProductCreation(context),
              ):const SizedBox(),
            productProvider!.selectedProductCategory=='Variant Product Creation'?  const SizedBox(height: 12):const SizedBox(),
              formLayout(
                fieldTitle('Technical Name'),
                CustomTextField(
                    controller: _modelNameController,
                    height: 51,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Model Name is required';
                      }
                      return null;
                    }),
              ),
              const SizedBox(height: 12),
              formLayout(
                fieldTitle('Model Number'),
                CustomTextField(
                    controller: _modelNumberController,
                    height: 51,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Model Number is required';
                      }
                      return null;
                    }),
              ),
              const SizedBox(height: 12),
              formLayout(
                fieldTitle('Description'),
                CustomTextField(
                    controller: _descriptionController,
                    height: 100,
                    maxLines: 150,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Description is required';
                      }
                      return null;
                    }),
              ),
              const SizedBox(height: 12),
              formLayout(
                fieldTitle('Accounting Item Name'),
                CustomTextField(
                    controller: _accountingItemNameController,
                    height: 51,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Accounting Item Name is required';
                      }
                      return null;
                    }),
              ),
              const SizedBox(height: 12),
              formLayout(
                fieldTitle('Accounting Item Unit'),
                CustomTextField(
                    controller: _accountingItemUnitController,
                    height: 51,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Accounting Item Unit is required';
                      }
                      return null;
                    }),
              ),
              const SizedBox(height: 12),
              formLayout(
                fieldTitle('Specifications'),
                Container(
                  width: 550,
                  height: 250,
                  decoration: BoxDecoration(
                     border: Border.all(
                      color:Colors.black.withOpacity(0.2)
                    ),
                    borderRadius:BorderRadius.circular(10),
                    color: Colors.white30,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      formLayout(
                          fieldTitle(
                            'Size',
                            height: 51,
                          ),
                          CustomTextField(
                            controller: _sizeController,
                            width: 150,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Size is required';
                              }
                              return null;
                            },
                          ),
                          mainAxisAlignment: MainAxisAlignment.center),
                      const SizedBox(height: 8.0),
                      formLayout(
                          fieldTitle(
                            'Color',
                            height: 51,
                          ),
                          SizedBox(
                            // color: Colors.blueAccent,
                            width: 150,
                            height: 51,
                            child: CustomTextField(
                              controller: _colorController,
                              width: 150,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Color is required';
                                }
                                return null;
                              },
                            ),
                          ),
                          mainAxisAlignment: MainAxisAlignment.center),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              formLayout(
                fieldTitle('MRP'),
                CustomTextField(
                    controller: _mrpController,
                    height: 51,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'MRP is required';
                      }
                      return null;
                    }),
              ),
              const SizedBox(height: 12),
              formLayout(
                fieldTitle('Cost'),
                CustomTextField(
                    controller: _costController,
                    height: 51,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Cost is required';
                      }
                      return null;
                    }),
              ),
              const SizedBox(height: 12),
              formLayout(
                fieldTitle('Weight'),
                CustomTextField(
                    controller: _weightController,
                    height: 51,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Weight is required';
                      }
                      return null;
                    }),
              ),
              const SizedBox(height: 12),
              formLayout(
                Text('Package Dimensions'),
                SizedBox(
                  width: 550,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextField(
                        controller: _lengthController,
                        prefix: 'L',
                        width: 150,
                        unit: 'cm',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Length is required';
                          }
                          return null;
                        },
                      ),
                      const Text('x'),
                      CustomTextField(
                        controller: _widthController,
                        width: 150,
                        prefix: 'W',
                        unit: 'cm',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Width is required';
                          }
                          return null;
                        },
                      ),
                      const Text('x'),
                      CustomTextField(
                        controller: _depthController,
                        width: 150,
                        prefix: 'D',
                        unit: 'cm',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Depth is required';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              formLayout(
                  const Text('Custom Field'),
                  Container(
                    height: 100,
                    width: 550,
                    decoration: BoxDecoration(
                         border: Border.all(
                      color:Colors.black.withOpacity(0.2)
                    ),
                    borderRadius:BorderRadius.circular(10),
                    color: Colors.white30,
                        ),
                    child:  Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding:const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 51,
                          width: 150,
                          child: CustomDropdown(),
                        ),
                      ),
                    ),
                  )),
              const SizedBox(height: 12),
              formLayout(
                const Text('Select Image'),
                InkWell(
                  child: Row(
                    children: [
                      const Icon(Icons.add_a_photo),
                      webImages != null
                          ? SizedBox(
                              height: 100,
                              width: 550,
                              child: CustomHorizontalImageScroller(
                                webImageUrls: webImages,
                              ))
                          : const SizedBox(),
                    ],
                  ),
                  onTap: () async {
                    webImages = await MultiImagePicker().pickImages();
                    setState(() {});
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              formLayout(
                  fieldTitle(''),
                  Row(
                    children: [
                      CustomButton(
                          width: 150,
                          height: 40,
                          onTap: () {
                            print("heeeli  i amm called ");
                            if (_formKey.currentState!.validate()) {}
                          },
                          color: AppColors.primaryBlue,
                          textColor: AppColors.white,
                          fontSize: 15,
                          text: 'Save Product'),
                      const SizedBox(width: 4),
                      CustomButton(
                          width: 150,
                          height: 40,
                          onTap: () {},
                          color: AppColors.primaryBlue,
                          textColor: AppColors.white,
                          fontSize: 15,
                          text: 'Reset')
                    ],
                  )),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget formLayout(Widget title, Widget anyWidget,
      {MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
      double width = 1200}) {
    return Container(
      // color:Colors.black,
      width: width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: mainAxisAlignment,
        children: [
          // Spacer(),
          Container(
              width: 200,
              // color: Colors.red,
              alignment: Alignment.topRight,
              child: title),
          const SizedBox(
            width: 5,
          ),
          anyWidget
        ],
      ),
    );
  }

  SizedBox customRadioButtonLayout(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width > 1200 &&
              MediaQuery.of(context).size.width < 1400
          ? 90
          : 50,
      child: Column(
        children: [
          const SizedBox(height: 9.0),
          Row(
            children: [
              radioCheck('Create Simple Product', (val) {
                productProvider!.updateSelectedProductCategory(val!);
              }),
              radioCheck('Variant Product Creation', (val) {
                productProvider!.updateSelectedProductCategory(val!);
              }),
              MediaQuery.of(context).size.width > 1400
                  ? radioCheck('Create Virtual Combo Products', (val) {
                      productProvider!.updateSelectedProductCategory(val!);
                    })
                  : const SizedBox(),
              MediaQuery.of(context).size.width > 1400
                  ? radioCheck('Create Kit Products', (val) {
                      productProvider!.updateSelectedProductCategory(val!);
                    })
                  : const SizedBox(),
            ],
          ),
          MediaQuery.of(context).size.width > 1200 &&
                  MediaQuery.of(context).size.width < 1400
              ? Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    children: [
                      radioCheck('Create Virtual Combo Products', (val) {
                        productProvider!.updateSelectedProductCategory(val!);
                      }),
                      radioCheck('Create Kit Products', (val) {
                        productProvider!.updateSelectedProductCategory(val!);
                      }),
                    ],
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget variantProductCreation(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.64,
      // color:Colors.amber,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height:50 + ((MediaQuery.of(context).size.width>940?51.0:102+40.0) *productProvider!.countVariationFields),
            child: ListView.builder(
              itemBuilder: (context, index) {
                
                return MediaQuery.of(context).size.width > 940
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              index == 0
                                  ? const Text('Colors')
                                  : const SizedBox(),
                              SizedBox(
                                width: 130,
                                // color:Colors.brown,
                                child: CustomTextField(
                                  controller:productProvider!.color[index],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              index == 0
                                  ? const Text('Size')
                                  : const SizedBox(),
                              SizedBox(
                                width: 130,
                                child: CustomTextField(
                                    controller:productProvider!.size[index],
                                    height: 51,
                                    width: 130),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              index == 0
                                  ? const Text('EAN/UPC')
                                  : const SizedBox(),
                              SizedBox(
                                width: 130,
                                child: CustomTextField(
                                    controller:productProvider!.eanUpc[index],
                                    height: 51,
                                    width: 130),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              index == 0
                                  ? const Text('SKU')
                                  : const SizedBox(),
                              SizedBox(
                                width: 130,
                                child: CustomTextField(
                                    controller: productProvider!.sku[index],
                                    height: 51,
                                    width: 130),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              child: Container(
                                width: 55,
                                decoration: BoxDecoration(border: Border.all()),
                                alignment: Alignment.bottomCenter,
                                child: const FaIcon(FontAwesomeIcons.minus),
                              ),
                              onTap: () {
                                productProvider!.deleteTextEditingController();
                                // variationCount = variationCount - 1;
                                // setState(() {});
                              },
                            ),
                          ),
                        ],
                      )
                    : Column(
                      // mainAxisAlignment:MainAxisAlignment.start,
                      crossAxisAlignment:CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                  width: 150,
                                  child: Column(
                                    children: [
                                      const Text('Colors'),
                                      CustomTextField(
                                          controller: productProvider!.color[index]),
                                    ],
                                  )),
                              const SizedBox(
                                width: 2,
                              ),
                              SizedBox(
                                  width: 150,
                                  child: Column(
                                    children: [
                                      const Text('Size'),
                                      CustomTextField(
                                          controller:productProvider!.size[index]),
                                    ],
                                  ))
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                  width: 150,
                                  child: Column(
                                    children: [
                                     const Text('EAN/UPC'),
                                      CustomTextField(
                                          controller:productProvider!.eanUpc[index]),
                                    ],
                                  )),
                              const SizedBox(
                                width: 2,
                              ),
                              SizedBox(
                                  width: 150,
                                  child: Column(
                                    children: [
                                      const Text('SKU'),
                                      CustomTextField(
                                          controller: productProvider!.sku[index]),
                                    ],
                                  ))
                            ],
                          ),
                           CustomButton(width:40, height:40, onTap: () {
                            productProvider!.deleteTextEditingController();
                                // variationCount = variationCount - 1;
                                // setState(() {});
                              }, color:AppColors.cardsgreen, textColor:AppColors.black, fontSize:25, text:'--')
                        ],
                      );
              },
              itemCount: productProvider!.countVariationFields,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue.shade50),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.blue.shade50,
                ),
                height: 51,
                width: 70,
                child: const Center(
                    child: Text(
                  'Add New',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
              ),
              onTap: () {
                // print("i am clii");
                // variationCount = variationCount + 1;
                productProvider!.addNewTextEditingController();
                // print("i product page ${productProvider!.countVariationFields}");
                // setState(() {
                  
                // });
                // setState(() {
                //   print("variation count is here $variationCount");
                // });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget fieldTitle(String filTitle,
      {double height = 51, double width = 168.3, bool show = true}) {
    return SizedBox(
      height: height,
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
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
          groupValue: productProvider!.selectedProductCategory,
          onChanged: onTap,
        ),
        Text(title),
      ],
    );
  }
}

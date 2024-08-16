import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inventory_management/Custom-Files/colors.dart';
import 'package:inventory_management/Custom-Files/custom-textfield.dart';

class ManageInventory extends StatefulWidget {
  const ManageInventory({super.key});

  @override
  State<ManageInventory> createState() => _ManageInventoryState();
}

class _ManageInventoryState extends State<ManageInventory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Expanded(

      child: SingleChildScrollView(
        child: Container(
            color: AppColors.greyBackground,
            child: Column(
              children: [
                Container(
                  height:150,
                  color:Colors.red.withOpacity(0.1),
                ),
                 Container(
                  height:30,
                  color:Colors.white,
                ),
                
                Row(
                  mainAxisAlignment:MainAxisAlignment.end,
                  children: [
                    CustomTextField(controller:TextEditingController(text:'Hello'),width:150,label:'Search',icon:Icons.search,),
                  ],
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection:Axis.horizontal,
                    child: Column(
                      children: [
                              DataTable(
                                showBottomBorder:true,
                                
                                dataRowMaxHeight: 100,
                                columns: [
                     DataColumn(label: Text('COMPANY NAME',style:AppColors().headerStyle,)),
                     DataColumn(label: Text('CATEGORY',style:AppColors().headerStyle,)),
                     DataColumn(label: Text('IMAGE',style:AppColors().headerStyle,)),
                     DataColumn(label: Text('BRAND',style:AppColors().headerStyle,)),
                     DataColumn(label: Text('SKU',style:AppColors().headerStyle,)),
                     DataColumn(label: Text('PRODUCT NAME',style:AppColors().headerStyle,)),
                     DataColumn(label: Text('MODEL NO',style:AppColors().headerStyle,)),
                     DataColumn(label: Text('MRP',style:AppColors().headerStyle,)),
                     DataColumn(label: Text('QUANTITY',style:AppColors().headerStyle,)),
                    DataColumn(
                        label: ElevatedButton(
                      onPressed: () {
                        // Save action
                      },
                      child: const Text('Save All'),
                    )),
                     DataColumn(label: Text('FLIPKART',style:AppColors().headerStyle,)),
                     DataColumn(label: Text('SNAPDEAL',style:AppColors().headerStyle,)),
                     DataColumn(label: Text('AMAZON.IN',style:AppColors().headerStyle,)),
                                ],
                                rows: List<DataRow>.generate(
                    5, // Example number of rows
                    (index) => DataRow(
                      // height:50
                      cells: [
                        DataCell(IntrinsicHeight(
                          child: Container(
                            constraints:const BoxConstraints(
                              maxWidth: 200, // Fixed width for content
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Text(
                                'Company $index Company $index Company $index Company $index Company $index Company $index Company $index Company $index',
                                overflow: TextOverflow.visible, // Allow text to wrap
                                softWrap: true,
                              ),
                            ),
                          ),
                        )),
                        DataCell(Container(
                          constraints: const BoxConstraints(
                            maxWidth: 150,
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Text('Category $index'),
                          ),
                        )),
                        DataCell(Image.network(
                            'https://th.bing.com/th/id/OIP.9TuzCIe_xvRYWHU7gziJvQHaEK?w=1920&h=1080&rs=1&pid=ImgDetMain',
                            width: 100,
                            height: 400)),
                        DataCell(IntrinsicHeight(
                          child: Container(
                            constraints: const BoxConstraints(
                              maxWidth: 150,
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Text('Brand $index'),
                            ),
                          ),
                        )),
                        DataCell(IntrinsicHeight(
                          child: Container(
                            constraints: const BoxConstraints(
                              maxWidth: 100,
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Text('SKU$index'),
                            ),
                          ),
                        )),
                        DataCell(Container(
                          constraints: const BoxConstraints(
                            maxWidth: 150,
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Text('Product Name $index'),
                          ),
                        )),
                        DataCell(Container(
                          constraints: const BoxConstraints(
                            maxWidth: 100,
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Text('Model No $index'),
                          ),
                        )),
                        DataCell(Container(
                          constraints: const BoxConstraints(
                            maxWidth: 100,
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Text('MRP $index'),
                          ),
                        )),
                        DataCell(Container(
                          constraints: const BoxConstraints(
                            maxWidth: 200,
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              // mainAxisAlignment:MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment:CrossAxisAlignment.start,
                                  children: [
                                   Column(
                                    children: [
                                       Container(
                                      height: 30,
                                      width: 130,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: AppColors.black)),
                                      child: Center(child: Text("Quantity $index")),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    ElevatedButton(
                                      style: const ButtonStyle(
                                          fixedSize:
                                              MaterialStatePropertyAll(Size(130, 7))),
                                      onPressed: () {
                                        // Save action
                                      },
                                      child: const Text('View Details'),
                                    ),
                                    ],
                                   ),
                                  const SizedBox(width:4,),
                                  const InkWell(
                                    child:Icon(Icons.cloud,color:AppColors.cardsgreen,),
                                   ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(DateTime.now().toString()),
                                )
                              ],
                            ),
                          ),
                        )),
                        DataCell(ElevatedButton(
                          onPressed: () {
                            // Save action
                          },
                          child: const Text('Save All'),
                        )),
                        DataCell(Container(
                          constraints: const BoxConstraints(
                            maxWidth: 100,
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Text('Flipkart $index'),
                          ),
                        )),
                        DataCell(Container(
                          constraints: const BoxConstraints(
                            maxWidth: 100,
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Text('Snapdeal $index'),
                          ),
                        )),
                        DataCell(Container(
                          constraints: const BoxConstraints(
                            maxWidth: 100,
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Text('Amzazon $index'),
                          ),
                        )),
                      ],
                    ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ),
    ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/retry.dart';
import 'package:inventory_management/Custom-Files/colors.dart';
import 'package:inventory_management/Custom-Files/custom-dropdown.dart';
import 'package:inventory_management/Custom-Files/custom-textfield.dart';
import 'package:inventory_management/provider/manage-inventory-provider.dart';
import 'package:pagination_flutter/pagination.dart';
import 'package:provider/provider.dart';

class ManageInventory extends StatefulWidget {
  const ManageInventory({super.key});

  @override
  State<ManageInventory> createState() => _ManageInventoryState();
}

class _ManageInventoryState extends State<ManageInventory> {
  int firstval = 0, lastval = 10;
  int selectedPage = 1;
  int size = 40, currentPage = 0, jump = 5;

  @override
  Widget build(BuildContext context) {
    var manageInventoryProvider=Provider.of<ManagementProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: AppColors.greyBackground,
          child: Column(
            children: [
              Container(
                color: AppColors.greyBackground,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    screenWidth > 1415
                        ? Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Stock Level',
                                      style: AppColors().simpleHeadingStyle),
                                  Row(
                                    children: [
                                      CustomTextField(
                                        controller: TextEditingController(),
                                        width: screenWidth * 0.12,
                                      ),
                                      const SizedBox(width: 10),
                                      CustomTextField(
                                        controller: TextEditingController(),
                                        width: screenWidth * 0.12,
                                      ),
                                      const SizedBox(width: 20),
                                      buttonForThisPage(
                                          width: 70,
                                          height: 50,
                                          buttonTitle: 'GO'),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                width: screenWidth * 0.5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Search',
                                        style: AppColors().simpleHeadingStyle),
                                    Row(
                                      children: [
                                         SizedBox(
                                          width: 100,
                                          child: CustomDropdown(),
                                        ),
                                        const SizedBox(width: 10),
                                        CustomTextField(
                                          controller: TextEditingController(),
                                          width: screenWidth * 0.12,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text('Search Exact SKU',
                                            style:
                                                AppColors().simpleHeadingStyle),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        buttonForThisPage(
                                            buttonTitle: 'Search',
                                            height: 50,
                                            width: 100),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        buttonForThisPage(
                                            buttonTitle: 'Download Inventory',
                                            height: 50,
                                            width: 175),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Stock Level',
                                  style: AppColors().simpleHeadingStyle),
                              Row(
                                children: [
                                  CustomTextField(
                                    controller: TextEditingController(),
                                    width: 145,
                                  ),
                                  const SizedBox(width: 10),
                                  CustomTextField(
                                    controller: TextEditingController(),
                                    width: 145,
                                  ),
                                  const SizedBox(width: 10),
                                  screenWidth > 450
                                      ? buttonForThisPage(
                                          width: 70,
                                          height: 50,
                                          buttonTitle: 'GO')
                                      : const SizedBox(),
                                ],
                              ),
                              screenWidth < 450
                                  ? buttonForThisPage(
                                      width: 70, height: 50, buttonTitle: 'GO')
                                  : const SizedBox(),
                              Text('Search',
                                  style: AppColors().simpleHeadingStyle),
                              Row(
                                children: [
                                   SizedBox(
                                    width: 100,
                                    child: CustomDropdown(),
                                  ),
                                  const SizedBox(width: 10),
                                  CustomTextField(
                                    controller: TextEditingController(),
                                    width: screenWidth * 0.15,
                                    label: 'Search Exact SKU',
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  screenWidth > 450
                                      ? Text('Search Exact SKU',
                                          style: AppColors().simpleHeadingStyle)
                                      : const SizedBox(),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  buttonForThisPage(
                                      buttonTitle: 'Search',
                                      height: 50,
                                      width: 100),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              buttonForThisPage(
                                  buttonTitle: 'Download Inventory',
                                  height: 50,
                                  width: 175),
                            ],
                          ),
                    const SizedBox(height: 10),
                    Text('Filters', style: AppColors().simpleHeadingStyle),
                    Container(
                      height: 80,
                      // width: 300,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.black.withOpacity(0.2)),
                        borderRadius:BorderRadius.circular(10)
                        // color:Colors.amber
                        // color: Colors.amberAccent,
                      ),
                      child:  Align(
                        alignment: Alignment.topLeft,
                        child: SizedBox(
                          width: 150,
                          height:51,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomDropdown(),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 30,
                color: AppColors.white,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextField(
                      controller: TextEditingController(text: 'Hello'),
                      width: 150,
                      label: 'Search',
                      icon: Icons.search,
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      DataTable(
                        showBottomBorder: true,
                        dataRowMaxHeight: 100,
                        columns: [
                          DataColumn(
                              label: Text('COMPANY NAME',
                                  style: AppColors().headerStyle)),
                          DataColumn(
                              label: Text('CATEGORY',
                                  style: AppColors().headerStyle)),
                          DataColumn(
                              label: Text('IMAGE',
                                  style: AppColors().headerStyle)),
                          DataColumn(
                              label: Text('BRAND',
                                  style: AppColors().headerStyle)),
                          DataColumn(
                              label:
                                  Text('SKU', style: AppColors().headerStyle)),
                          DataColumn(
                              label: Text('PRODUCT NAME',
                                  style: AppColors().headerStyle)),
                          DataColumn(
                              label: Text('MODEL NO',
                                  style: AppColors().headerStyle)),
                          DataColumn(
                              label:
                                  Text('MRP', style: AppColors().headerStyle)),
                          DataColumn(
                              label: Text('QUANTITY',
                                  style: AppColors().headerStyle)),
                          DataColumn(
                            label: ElevatedButton(
                              onPressed: () {
                                // Save action
                              },
                              child: const Text('Save All'),
                            ),
                          ),
                          DataColumn(
                              label: Text('FLIPKART',
                                  style: AppColors().headerStyle)),
                          DataColumn(
                              label: Text('SNAPDEAL',
                                  style: AppColors().headerStyle)),
                          DataColumn(
                              label: Text('AMAZON.IN',
                                  style: AppColors().headerStyle)),
                        ],
                        rows: List<DataRow>.generate(
                          5, // Example number of rows
                          (index) => DataRow(
                            cells: [
                              DataCell(Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 200,
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Text(
                                    'Company ${firstval + index + 1}',
                                    overflow: TextOverflow.visible,
                                    softWrap: true,
                                  ),
                                ),
                              )),
                              DataCell(Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 150,
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child:
                                      Text('Category ${firstval + index + 1}'),
                                ),
                              )),
                              DataCell(Image.network(
                                'https://sharmellday.com/wp-content/uploads/2022/12/032_Canva-Text-to-Image-Generator-min-1.jpg',
                                width: 100,
                                height: 400,
                              )),
                              DataCell(IntrinsicHeight(
                                child: Container(
                                  constraints: const BoxConstraints(
                                    maxWidth: 150,
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child:
                                        Text('Brand ${firstval + index + 1}'),
                                  ),
                                ),
                              )),
                              DataCell(Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 100,
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Text('SKU${firstval + index + 1}'),
                                ),
                              )),
                              DataCell(Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 150,
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Text(
                                      'Product Name ${firstval + index + 1}'),
                                ),
                              )),
                              DataCell(Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 100,
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child:
                                      Text('Model No ${firstval + index + 1}'),
                                ),
                              )),
                              DataCell(Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 100,
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Text('MRP ${firstval + index + 1}'),
                                ),
                              )),
                              DataCell(Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 200,
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            children: [
                                              Container(
                                                height: 30,
                                                width: 130,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color:
                                                            AppColors.black)),
                                                child: Center(
                                                    child: Text(
                                                        "Quantity ${firstval + index + 1}")),
                                              ),
                                              const SizedBox(height: 3),
                                              buttonForThisPage(),
                                            ],
                                          ),
                                          const SizedBox(width: 4),
                                          const InkWell(
                                            child: Icon(Icons.cloud,
                                                color: AppColors.cardsgreen),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(DateTime.now().toString()),
                                      ),
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
                                  child:
                                      Text('Flipkart ${firstval + index + 1}'),
                                ),
                              )),
                              DataCell(Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 100,
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child:
                                      Text('Snapdeal ${firstval + index + 1}'),
                                ),
                              )),
                              DataCell(Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 100,
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Text('Amazon ${firstval + index + 1}'),
                                ),
                              )),
                            ],
                          ),
                          // ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  InkWell(
                    child: const FaIcon(
                      FontAwesomeIcons.chevronLeft,
                    ),
                    onTap: () {
                      // selectedPage = 1;
                      manageInventoryProvider.upDateSelectedPage(1);
                      // setState(() {});
                    },
                  ),
                  Pagination(
                    numOfPages: manageInventoryProvider.numberofPages,
                    selectedPage:manageInventoryProvider.selectedPage,
                    pagesVisible: 5,
                    spacing: 10,
                    onPageChanged: (page) {
                      print("page is here $page");
                      // setState(() {
                        // firstval = (page - 1) * 5;
                        // lastval = firstval + 5;
                        manageInventoryProvider.upDateSelectedPage(page);
                        // selectedPage = page;
                      // });
                      // setState(() {
                        
                      // });
                    },
                    nextIcon: const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.primaryBlue,
                      size: 20,
                    ),
                    previousIcon: const Icon(
                      Icons.chevron_left_rounded,
                      color: AppColors.primaryBlue,
                      size: 20,
                    ),
                    activeTextStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    activeBtnStyle: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(AppColors.primaryBlue),
                      shape: MaterialStateProperty.all(const CircleBorder(
                        side: BorderSide(
                          color: AppColors.primaryBlue,
                          width: 1,
                        ),
                      )),
                    ),
                    inactiveBtnStyle: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(const CircleBorder(
                        side: BorderSide(
                          color: AppColors.primaryBlue,
                          width: 1,
                        ),
                      )),
                    ),
                    inactiveTextStyle: const TextStyle(
                      fontSize: 14,
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  InkWell(
                    child: const FaIcon(
                      FontAwesomeIcons.chevronRight,
                    ),
                    onTap: () {
                      // selectedPage = 10;
                      manageInventoryProvider.upDateSelectedPage(manageInventoryProvider.numberofPages);
                      // setState(() {});
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height:30,
                      width:50,
                      decoration:BoxDecoration(
                        border:Border.all(
                          color:AppColors.lightBlue
                        ),
                        
                      ),
                      child:Center(child: Text('${manageInventoryProvider.selectedPage}/${manageInventoryProvider.numberofPages}')),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class buttonForThisPage extends StatelessWidget {
  final double width;
  final double height;
  final String buttonTitle;

  buttonForThisPage({
    super.key,
    this.width = 150,
    this.height = 30,
    this.buttonTitle = 'View Details',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: const ButtonStyle(
            fixedSize: MaterialStatePropertyAll(Size(130, 7))),
        onPressed: () {
          // Save action
        },
        child: Text(buttonTitle),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inventory_management/Api/order-page-checkbox-provider.dart';
import 'package:inventory_management/Custom-Files/colors.dart';
import 'package:inventory_management/Custom-Files/custom-button.dart';
import 'package:inventory_management/Custom-Files/custom-dropdown.dart';
import 'package:inventory_management/Custom-Files/custom-textfield.dart';
import 'package:provider/provider.dart';
import 'package:textfields/textfields.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // bool mainCheckBox = false;
  // List<bool> _checkboxStates = List.generate(5, (index) => false);
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var checkBoxProvider = Provider.of<CheckBoxProvider>(context);
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          tabAlignment: TabAlignment.start,
          isScrollable: true,
          indicatorSize: TabBarIndicatorSize.tab,
          controller: _tabController,
          tabs: const [
            Tab(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Ready To Confirm',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Tab(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Failed Orders',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: TabBarView(
        physics:const NeverScrollableScrollPhysics(),
        controller: _tabController,
      
        children: [
          Row(
            children: [
              if (AppColors().getWidth(context)>450) _buildReadyToConfirmTab(),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection:Axis.horizontal,
                  child: SizedBox(
                    // color:Colors.green,
                    width:AppColors().getWidth(context)>900?AppColors().getWidth(context)*0.68:900,
                    // height:500,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox.adaptive(
                                    value: checkBoxProvider.mainCheckBox,
                                    onChanged: (val) {
                                      checkBoxProvider.upDateMainCheckBox(val!);
                                    }),
                                CustomButton(
                                  width: 130,
                                  height: 20,
                                  onTap: () {},
                                  color: AppColors.primaryBlue,
                                  text: 'Print Picklist',
                                  textColor: AppColors.white,
                                  fontSize: 10,
                                  prefixIcon: const Icon(
                                    Icons.print,
                                    size: 15,
                                    color: AppColors.white,
                                  ),
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                CustomButton(
                                  width: 130,
                                  height: 20,
                                  onTap: () {},
                                  color: AppColors.primaryBlue,
                                  text: 'Print Packing Slip',
                                  textColor: AppColors.white,
                                  fontSize: 10,
                                  prefixIcon: const Icon(
                                    Icons.print,
                                    size: 15,
                                    color: AppColors.white,
                                  ),
                                )
                              ],
                            ),
                              Row(
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.cloudArrowDown,
                                    color:AppColors.grey,
                                  ),
                                const  SizedBox(
                                    width: 2,
                                  ),
                                  Container(width:30, 
                                  height:20,
                                  color:Colors.black,
                                  alignment:Alignment.centerLeft,
                                  child: CustomDropdown(fontSize:12))
                                ],
                              ),
                          ],
                        ),
                        Expanded(
                          // width:300,
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return layoutOfOrderItem(checkBoxProvider, index);
                            },
                            itemCount: 5,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          Row(
            children: [
             if (AppColors().getWidth(context)>450) _buildReadyToConfirmTab(),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection:Axis.horizontal,
                  child: SizedBox(
                    width:AppColors().getWidth(context)>900?AppColors().getWidth(context)*0.68:900,
                    child: Column(
                      children: [
                        Container(
                          color:Colors.amber,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox.adaptive(
                                      value: checkBoxProvider.mainCheckBox,
                                      onChanged: (val) {
                                        checkBoxProvider.upDateMainCheckBox(val!);
                                      }),
                                  CustomButton(
                                    width: 130,
                                    height: 20,
                                    onTap: () {},
                                    color: AppColors.primaryBlue,
                                    text: 'Print Picklist',
                                    textColor: AppColors.white,
                                    fontSize: 10,
                                    prefixIcon: const Icon(
                                      Icons.print,
                                      size: 15,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  CustomButton(
                                    width: 130,
                                    height: 20,
                                    onTap: () {},
                                    color: AppColors.primaryBlue,
                                    text: 'Print Packing Slip',
                                    textColor: AppColors.white,
                                    fontSize: 10,
                                    prefixIcon: const Icon(
                                      Icons.print,
                                      size: 15,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  CustomButton(
                                    width: 130,
                                    height: 20,
                                    onTap: () {},
                                    color: AppColors.primaryBlue,
                                    text: 'Print Packing Slip',
                                    textColor: AppColors.white,
                                    fontSize: 10,
                                    prefixIcon: const FaIcon(
                                      FontAwesomeIcons.circleCheck,
                                      size: 14,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  CustomButton(
                                    width: 130,
                                    height: 20,
                                    onTap: () {},
                                    color: AppColors.primaryBlue,
                                    text: 'Print Packing Slip',
                                    textColor: AppColors.white,
                                    fontSize: 10,
                                    prefixIcon: const FaIcon(
                                      FontAwesomeIcons.circleCheck,
                                      size: 14,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ],
                              ),
                              
                               Row(
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.cloudArrowDown,
                                    color:AppColors.white,
                                  ),
                                const  SizedBox(
                                    width: 2,
                                  ),
                                  Container(width:30, 
                                  height:20,
                                  color:Colors.black,
                                  alignment:Alignment.centerLeft,
                                  child: CustomDropdown(fontSize:12))
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          // width:300,
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return layoutOfOrderItem(checkBoxProvider, index);
                            },
                            itemCount: 5,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Column layoutOfOrderItem(CheckBoxProvider checkBoxProvider, int index) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Checkbox.adaptive(
                value: checkBoxProvider.checkboxStates[index],
                onChanged: (val) {
                  checkBoxProvider.updateListCheckBox(val!, index);
                }),
            customColumn("Easy Id", "222559741"),
            customColumn("Order Id", "ORD/mxmd2/6884"),
            customColumn("Time Remainig", "SLA Breached"),
            customColumn("Total Order Amount(in rs)", "1,860.00"),
            Container(
              color: AppColors.cardsgreen,
              child: const Text('Katy'),
            ),
            const Icon(Icons.menu),
            const Column(
              children: [
                FaIcon(
                  FontAwesomeIcons.triangleExclamation,
                  color: AppColors.cardsred,
                ),
                Text(
                  "* SLA Breached",
                  style: TextStyle(color: AppColors.cardsred),
                )
              ],
            ),
          ],
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
            child: Column(
              children: [
                Column(
                  children: List.generate(
                    index % 2 == 0 ? 1 : 2,
                    (i) 
                    {
                      
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 150,
                              width: 100,
                              child: Column(
                                children: [
                                  Image.network(
                                    'https://sharmellday.com/wp-content/uploads/2022/12/032_Canva-Text-to-Image-Generator-min-1.jpg',
                                    width: 100,
                                    height: 80,
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  const Text(
                                    "Daaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              child: Column(
                                children: [
                                  _buildRow('SKU', '123456'),
                                  const SizedBox(height: 8.0),
                                  _buildRow('Quantity', '10'),
                                  const SizedBox(height: 8.0),
                                  _buildRow('Brand', 'BrandName'),
                                  const SizedBox(height: 8.0),
                                  _buildRow('Order Item Id', 'ABC123'),
                                  const SizedBox(height: 8.0),
                                ],
                              ),
                            ),
                            SizedBox(
                              child: Column(children: [
                                _buildRow('Total MRP', '\$100.00'),
                                const SizedBox(height: 8.0),
                                _buildRow('Selling Price', '\$90.00'),
                                const SizedBox(height: 8.0),
                                customRowWIthTextField(checkBoxProvider, index,i,'Payment Mode',1),
                                const SizedBox(height: 8.0),
                                _buildRow(
                                    'Shipping Method', 'Standard Shipping'),
                                const SizedBox(height: 8.0),
                                _buildRow('Shipping Mode', 'Ground'),
                                const SizedBox(height: 8.0),
                                customRowWIthTextField(checkBoxProvider,index,i,'Payment Status',2),
                              ]),
                            ),
                            SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  _buildRow('Order Date', '2024-08-22'),
                                  const SizedBox(height: 8.0),
                                  _buildRow('Import Date', '2024-08-20'),
                                  const SizedBox(height: 8.0),
                                  _buildRow('TAT', '3 Days'),
                                  const SizedBox(height: 8.0),
                                  _buildRow(
                                      'QC Confirmation Date', '2024-08-21'),
                                  const SizedBox(height: 8.0),
                                  _buildRow('Inventory Assigned', '✔️',
                                      isCheckmark: true),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const Divider(
                  height: 12,
                  color: Colors.amber,
                ),
              ],
            ),
          )
        ]),
      ],
    );
  }

  Row customRowWIthTextField(CheckBoxProvider checkBoxProvider, int rindex,int cindex,String title,int textFilednum) {
    return Row(
      children: [
        Text('$title :'),
        SizedBox(
          height: 20,
          width: 50,
          child: TextField(
            controller: TextEditingController(
              text: '12',
            ),
            style: const TextStyle(fontSize: 16, height: 1.6),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(0),
              enabled:textFilednum==1?checkBoxProvider.getSubTextField1[rindex][cindex]:checkBoxProvider.getSubTextField2[rindex][cindex],
            ),
          ),
        ),
        InkWell(
          child:const Icon(Icons.edit),
          onTap: () {
            // print("u[dated]  ${checkBoxProvider.textFieldEnabler1[index]}");
            // checkBoxProvider.updatetextFieldEnabler1(
            //     !checkBoxProvider.textFieldEnabler1[index], index);
                textFilednum==1?checkBoxProvider.updateSubTextFieldEnabler1(!checkBoxProvider.getSubTextField1[rindex][cindex],rindex, cindex):checkBoxProvider.updateSubTextFieldEnabler2(!checkBoxProvider.getSubTextField2[rindex][cindex],rindex, cindex);
          },
        )
      ],
    );
  }

  Column customColumn(String title, String value) {
    return Column(
      children: [
        Text(title),
        Text(value),
      ],
    );
  }

  Widget _buildRow(String label, String value, {bool isCheckmark = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          '$label:',
        ),
        if (isCheckmark)
          Text(
            value,
            style: TextStyle(color: AppColors.cardsgreen),
          )
        else
          Text(
            value,
            // style: TextStyle(fontSize: 16.0),
          ),
      ],
    );
  }
}

Widget _buildReadyToConfirmTab() {
  return SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child: Row(
      children: [
        Container(
          width: 250,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              CustomTextField(
                controller: TextEditingController(),
                label: 'Search',
                icon: Icons.search,
              ),

              const SizedBox(height: 16),

              // Total Orders and Upcoming Orders
              Row(
                children: [
                  const Text('Total Orders', style: TextStyle(fontSize: 16)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    color: AppColors.cardsgreen,
                    child: const Text('4448',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  const SizedBox(
                      width: 130,
                      height: 32,
                      child: CustomDropdown(
                        fontSize: 12.5,
                      )),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    color: Colors.amber.shade300,
                    child:
                        const Text('2', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Divider(
                height: 1,
                color: AppColors.black.withOpacity(0.5),
              ),

              const SizedBox(height: 16),

              // Sort by dropdown
              Container(
                height: 30,
                width: double.infinity,
                color: AppColors.black.withOpacity(0.2),
                alignment: Alignment.centerLeft,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('Sort By:'),
                ),
              ),

              const SizedBox(height: 8),

              const Row(
                children: [
                  SizedBox(
                    height: 34,
                    width: 160,
                    child: CustomDropdown(fontSize: 12.5),
                  ),
                  Spacer(),
                  Icon(Icons.arrow_upward, size: 18),
                  Icon(Icons.arrow_downward, size: 18),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Filters",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  InkWell(
                    child: const Text('Clear',
                        style: TextStyle(color: Colors.blue)),
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Order Date Filter
              Container(
                height: 30,
                width: double.infinity,
                color: AppColors.black.withOpacity(0.2),
                alignment: Alignment.centerLeft,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('Order Date'),
                ),
              ),

              const SizedBox(height: 8),

              const SizedBox(
                height: 34,
                width: 160,
                child: CustomDropdown(fontSize: 12.5),
              ),

              const SizedBox(height: 16),

              // Marketplace Filter
              Container(
                height: 30,
                width: double.infinity,
                color: AppColors.black.withOpacity(0.2),
                alignment: Alignment.centerLeft,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('Market Place'),
                ),
              ),

              const SizedBox(height: 8),

              const SizedBox(
                height: 120,
                width: 250,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Katyayani'),
                      Text('Shopify'),
                      Text('Woocommerce'),
                      Text('Shopify2'),
                      Text('Offline'),
                      Text('Katyayani'),
                      Text('Shopify'),
                      Text('Woocommerce'),
                      Text('Shopify2'),
                      Text('Offline'),
                      Text('Katyayani'),
                      Text('Shopify'),
                      Text('Woocommerce'),
                      Text('Shopify2'),
                      Text('Offline'),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),

        // Expanded(flex: 7, child: Container()), // Placeholder for the right-side content
      ],
    ),
  );
}

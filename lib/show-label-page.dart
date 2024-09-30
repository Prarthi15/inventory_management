import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_management/Api/label-api.dart';
import 'package:inventory_management/Custom-Files/colors.dart';
import 'package:pagination_flutter/pagination.dart';
import 'package:provider/provider.dart';

class LabelPage extends StatefulWidget {
  const LabelPage({super.key});

  @override
  State<LabelPage> createState() => _LabelPageState();
}

class _LabelPageState extends State<LabelPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  TextEditingController searchController=TextEditingController();

  void getData() async {
    LabelApi po = Provider.of<LabelApi>(context, listen: false);
    await po.getLabel();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LabelApi>(
      builder: (context, l, child) => Scaffold(
        body: l.labelInformation.isNotEmpty&&l.loading
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 300,
                          child: TextField(
                            controller:searchController,
                            decoration: InputDecoration(
                              hintText: 'Search...',
                              prefixIcon: Icon(Icons.search, color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none, // No border line
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 20.0),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                  color: AppColors
                                      .primaryBlue, // Border color when focused
                                  width: 2.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(
                                      0.5), // Border color when enabled
                                  width: 1.0,
                                ),
                              ),
                            ),
                            onChanged: (value) async{
                            l.searchByLabel(value);
                             
                            },
                          ),
                        ),
                      ),

                      InkWell(
                        child:const Icon(Icons.restart_alt),
                        onTap:(){
                          l.cancel();
                        },
                        )
                    ],
                  ),
                  if(searchController.text.isEmpty && l.labelInformation.isEmpty)
                 const Padding(
                    padding:  EdgeInsets.all(8.0),
                    child:  Text("hit reload",style:TextStyle(color:Colors.red),),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: 1,
                          child: Card(
                            margin: const EdgeInsets.all(8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 10,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white,
                                    Colors.white.withOpacity(0.6),
                                    Colors.lightBlueAccent.withOpacity(0.1)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(15.0),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Container(
                                        width: 200,
                                        decoration: BoxDecoration(
                                          color: Colors.blueAccent
                                              .withOpacity(0.5),
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 10,
                                              offset: Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          child: Image.network(
                                            l.labelInformation[index]["images"]
                                                    .isNotEmpty
                                                ? l.labelInformation[index]
                                                    ["images"][0]
                                                : "https://cdn.pixabay.com/photo/2024/05/26/10/15/bird-8788491_1280.jpg",
                                            width: 200,
                                            height:
                                                150, // Fixed height for consistent sizing
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                          width: 16.0), // Increased spacing
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            fieldTitle(
                                                "Name",
                                                l.labelInformation[index]
                                                        ["name"] ??
                                                    'null'),
                                            fieldTitle(
                                                "Label SKU",
                                                l.labelInformation[index]
                                                        ["labelSku"] ??
                                                    'null'),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Product Details ",
                                                  style:
                                                      GoogleFonts.daiBannaSil(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                const Text(": ",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Column(
                                                 children: [
                                                   for(int i=0;i<5;i++)
                                                  const Column(
                                                    children:[
                                                       Text("hee;p00"),
                                                        Text("hee;p01"),
                                                      Text("hee;p02"),
                                                    ],
                                                   )
                                                 ],
                                                ),
                                              ],
                                            ),
                                            fieldTitle(
                                                "quantity",
                                                l.labelInformation[index]
                                                        ["quantity"]
                                                    .toString()),
                                            fieldTitle(
                                                "Description ${index}",
                                                l.labelInformation[index]
                                                        ["description"] ??
                                                    'null'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount:l.labelInformation.length,
                    ),
                  ),
                  // const Spacer(),
                   Row(
                children: [
                  InkWell(
                    child: const FaIcon(FontAwesomeIcons.chevronLeft),
                    onTap: () async{
                       l.updateCurrentPage(l.totalPage);
                        await l.getLabel();
                    },
                  ),
                  Pagination(
                    numOfPages:l.totalPage,
                    selectedPage:l.currentPage,
                    pagesVisible: 5,
                    spacing: 10,
                    onPageChanged: (page)async {
                      l.updateCurrentPage(page);
                       await l.getLabel();
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
                        side:
                            BorderSide(color: AppColors.primaryBlue, width: 1),
                      )),
                    ),
                    inactiveBtnStyle: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(const CircleBorder(
                        side:
                            BorderSide(color: AppColors.primaryBlue, width: 1),
                      )),
                    ),
                    inactiveTextStyle: const TextStyle(
                      fontSize: 14,
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  InkWell(
                    child: const FaIcon(FontAwesomeIcons.chevronRight),
                    onTap: ()async {
                        l.updateCurrentPage(l.totalPage);
                        await l.getLabel();
                        
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 30,
                      width: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.lightBlue),
                      ),
                      child: Center(
                        child: Text(
                            '${l.currentPage}/${l.totalPage}'),
                      ),
                    ),
                  ),
                ]
              )
            
            
                ],
              )
            : const Center(
                child: Text("Loading"),
              ),
      ),
    );
  }

  Widget fieldTitle(String filTitle, String value,
      {bool show = true,
      double width = 133,
      var fontWeight = FontWeight.bold}) {
    return Container(
      alignment: Alignment.topRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: width,
            child: Align(
                alignment: Alignment.topLeft,
                child: Text(filTitle,
                    style: GoogleFonts.daiBannaSil(
                        fontSize: 20, fontWeight: fontWeight))),
          ),
          const Text(":",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'googlefont')),
          show
              ? Expanded(
                  child: Text(
                    value,
                    style: GoogleFonts.daiBannaSil(
                        fontSize: 20, fontWeight: FontWeight.normal),
                  ),
                )
              : const Text('  '),
        ],
      ),
    );
  }
}

/*
 "labels": [
      {
        "_id": "66e410d5e6ef61bf9fb396bc",
        "name": "label",
        "labelSku": "LB-100",
        "images": [
          "https://yash-private31.s3.eu-north-1.amazonaws.com/label/66e410d5e6ef61bf9fb396bc/1f1054b1-e9c0-4686-9eb9-51dbd169aa67-images.png.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAX5ILZSMN5LZ73PNF%2F20240916%2Feu-north-1%2Fs3%2Faws4_request&X-Amz-Date=20240916T150904Z&X-Amz-Expires=900&X-Amz-Signature=01e4b41ae2b48ddf901133b31a1039337e7902c28f2f1882dd2afb48eac3579d&X-Amz-SignedHeaders=host&x-id=GetObject"
        ],
        "description": "this is a description",
        "product_id": {
          "dimensions": {},
          "_id": "66e3eae439f6c97a6e31fe70",
          "displayName": "Product name",
          "parentSku": "K-tech",
          "sku": "k-tech",
          "ean": "1234567890123",
          "description": "This is a test product description.",
          "brand": "66c0a09dba2bb6d30be80f10",
          "category": "66c0a1a8cbe12342b3849e93",
          "technicalName": "some name",
          
        },
        "quantity": 9,
        "createdAt": "2024-09-13T10:15:49.471Z",
        "updatedAt": "2024-09-16T05:49:13.434Z",
        "__v": 1
      },
*/
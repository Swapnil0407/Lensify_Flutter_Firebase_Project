import"package:flutter/material.dart";

import '../ShapeProductsScreen.dart';
import '../shared/screen_entrance.dart';

class SunglassWomen extends StatefulWidget{
  const SunglassWomen({super.key});

  @override
  State<SunglassWomen> createState()=> _SunglassWomenState();
}
class _SunglassWomenState extends State<SunglassWomen>{
  void _openShape(String shape) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ShapeProductsScreen(
          categoryTitle: "Women Sunglasses",
          imageAsset: "assets/images/WomenSun.jpg",
          shape: shape,
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context){
    return ScreenEntrance(
      child: Scaffold(
        backgroundColor: Color(0xFFFFF7ED),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFF7ED),
          title: const Text("Women's Sunglasses"),
        ),
        body:Column(
        mainAxisAlignment:MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment:MainAxisAlignment.spaceEvenly,
            children:[
              InkWell(
                onTap: () => _openShape("Square"),
                child: Container(
                  height:150,
                  width:150,
                  decoration:BoxDecoration(
                    border:Border.all(color:Colors.grey),
                    borderRadius:BorderRadius.circular(10),
                    boxShadow:[
                      BoxShadow(
                        color:Colors.grey.withOpacity(0.5),
                        spreadRadius:2,
                        blurRadius:5,
                        offset:Offset(0,3)
                      )
                    ],
                    image:DecorationImage(image:  AssetImage("assets/images/Frame/SunWomenSquare.jpg"),fit:BoxFit.cover,alignment:Alignment.bottomCenter)
                  ),
                  child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          color: const Color.fromARGB(120, 236, 236, 237),
                          child: const Text(
                            "Square",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                ),
              ),
              InkWell(
                onTap: () => _openShape("Rectangle"),
                child: Container(
                  height:150,
                  width:150,
                  decoration:BoxDecoration(
                    border:Border.all(color:Colors.grey),
                    borderRadius:BorderRadius.circular(10),
                    boxShadow:[
                      BoxShadow(
                        color:Colors.grey.withOpacity(0.5),
                        spreadRadius:2,
                        blurRadius:5,
                        offset:Offset(0,3)
                      )
                    ],
                    image:DecorationImage(image:  AssetImage("assets/images/Frame/SunWomenRectangle.jpg"),fit:BoxFit.cover,alignment:Alignment.bottomCenter,)
                  ),
                  child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          color: const Color.fromARGB(120, 236, 236, 237),
                          child: const Text(
                            "Rectangle",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                ),
              )
            ]
          ),
          Row(
            mainAxisAlignment:MainAxisAlignment.spaceEvenly,
            children:[
              InkWell(
                onTap: () => _openShape("Aviator"),
                child: Container(
                  height:150,
                  width:150,
                  decoration:BoxDecoration(
                    border:Border.all(color:Colors.grey),
                    borderRadius:BorderRadius.circular(10),
                    boxShadow:[
                      BoxShadow(
                        color:Colors.grey.withOpacity(0.5),
                        spreadRadius:2,
                        blurRadius:5,
                        offset:Offset(0,3)
                      )
                    ],
                    image:DecorationImage(image:  AssetImage("assets/images/Frame/SunWomenAviator.jpg"),fit:BoxFit.cover,alignment:Alignment.bottomCenter,)
                  ),
                  child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          color: const Color.fromARGB(120, 236, 236, 237),
                          child: const Text(
                            "Aviator",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                ),
              ),
              InkWell(
                onTap: () => _openShape("Geometric"),
                child: Container(
                  height:150,
                  width:150,
                  decoration:BoxDecoration(
                    border:Border.all(color:Colors.grey),
                    borderRadius:BorderRadius.circular(10),
                    boxShadow:[
                      BoxShadow(
                        color:Colors.grey.withOpacity(0.5),
                        spreadRadius:2,
                        blurRadius:5,
                        offset:Offset(0,3)
                      )
                    ],
                    image:DecorationImage(image:  AssetImage("assets/images/Frame/SunWomenGeo.jpg"),fit:BoxFit.cover,alignment:Alignment.bottomCenter,)
                  ),
                  child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          color: const Color.fromARGB(120, 236, 236, 237),
                          child: const Text(
                            "Geometric",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                ),
              )
            ]
          ),
          
        ],
      )

      ),
    );
  }
}

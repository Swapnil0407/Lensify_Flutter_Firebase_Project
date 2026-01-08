import"package:flutter/material.dart";

import '../ShapeProductsScreen.dart';

class EyeglassKids extends StatefulWidget{
  const EyeglassKids({super.key});

  @override
  State<EyeglassKids> createState()=> _EyeglassKidsState();
}
class _EyeglassKidsState extends State<EyeglassKids>{
  void _openShape(String shape) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ShapeProductsScreen(
          categoryTitle: "Kids Eyeglasses",
          imageAsset: "assets/images/eyeKids.jpg",
          shape: shape,
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xFFFFF7ED),
      body:Column(
        mainAxisAlignment:MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment:MainAxisAlignment.center,
            children:[
              Text("Kid's Eyeglasses",style:TextStyle(fontSize:24,fontWeight:FontWeight.bold),)
            ]
          ),
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
                    image:DecorationImage(image:  AssetImage("assets/images/Frame/SunKidsSquare.jpg"),fit:BoxFit.cover,alignment:Alignment.bottomCenter)
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
                    image:DecorationImage(image:  AssetImage("assets/images/Frame/SunKidsRectangle.jpg"),fit:BoxFit.cover,alignment:Alignment.bottomCenter,)
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
                    image:DecorationImage(image:  AssetImage("assets/images/Frame/SunKidsAviator.jpg"),fit:BoxFit.cover,alignment:Alignment.bottomCenter,)
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
                    image:DecorationImage(image:  AssetImage("assets/images/Frame/SunKidsGeometric.jpg"),fit:BoxFit.cover,alignment:Alignment.bottomCenter,)
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

    );
  }
}

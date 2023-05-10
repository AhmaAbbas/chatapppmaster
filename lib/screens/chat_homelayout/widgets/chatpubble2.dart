
import 'package:flutter/material.dart';

import '../../../models/messegmodel.dart';

Align chatbuble2({required MessageModel massege}) {
  return Align(
    alignment: Alignment.centerRight,
    child: Container(
      padding: EdgeInsets.only(left: 10,top: 32,bottom: 32,right: 16),
      margin: EdgeInsets.symmetric(vertical: 8,horizontal: 16),
      decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.only(
            topLeft:Radius.circular(25),
            topRight:Radius.circular(25),
            bottomLeft:Radius.circular(25),
          )
      ),
      child: Text('${massege.content.toString()}',style: TextStyle(fontSize: 15,color: Colors.white,),),
    ),
  );
}
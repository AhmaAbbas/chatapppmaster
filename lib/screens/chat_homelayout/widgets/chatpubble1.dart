


import 'package:flutter/material.dart';

import '../../../models/messegmodel.dart';
import '../../../shared/constants.dart';

Align chatbuble({required MessageModel massege}) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Container(
      padding: const EdgeInsets.only(left: 10,top: 32,bottom: 32,right: 16),
      margin:const EdgeInsets.symmetric(vertical: 8,horizontal: 16),
      decoration: BoxDecoration(
          color: Constants.kprimarycolor,
          borderRadius: const BorderRadius.only(
            topLeft:Radius.circular(25),
            topRight:Radius.circular(25),
            bottomRight:Radius.circular(25),
          )
      ),
      child: Text('${massege.content.toString()}',style: const TextStyle(fontSize: 15,color: Colors.white,),),
    ),
  );
}
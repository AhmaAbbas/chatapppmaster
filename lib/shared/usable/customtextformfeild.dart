




import 'package:flutter/material.dart';

class CustomTextFormFeild extends StatelessWidget {
  CustomTextFormFeild({Key? key,this.label_text,this.icon ,this.onchaged,this.obsecure=false}) ;
  String? label_text;
  IconData? icon;
  Function(String)? onchaged;
  bool? obsecure;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        textAlign: TextAlign.left,
        obscureText: obsecure!,
        onChanged: onchaged,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(20.0,),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.black),
            ),
            labelText: label_text,
            labelStyle: const TextStyle(
              color: Colors.black,
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.grey)),
            prefixIcon: IconButton(
              icon: Icon(icon),
              color: Colors.black,onPressed: (){},
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.grey))),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'widgets/canvas_view.dart';


void main(){

runApp(
const FamilyDesigner()
);

}



class FamilyDesigner extends StatelessWidget{


const FamilyDesigner({super.key});


@override
Widget build(BuildContext context){

return MaterialApp(

debugShowCheckedModeBanner:false,

theme:ThemeData(
useMaterial3:true
),

home:CanvasView(),

);


}

}

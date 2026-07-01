import 'package:flutter/material.dart';

import '../models/canvas_element.dart';



class PropertiesPanel extends StatelessWidget{


final CanvasElement element;


final VoidCallback duplicate;

final VoidCallback delete;



const PropertiesPanel({

super.key,

required this.element,

required this.duplicate,

required this.delete

});





@override
Widget build(BuildContext context){


return Positioned(


right:20,

top:50,



child:

Container(


width:260,


padding:
const EdgeInsets.all(15),


decoration:

BoxDecoration(

color:Colors.white,

borderRadius:
BorderRadius.circular(20)

),



child:

Column(

mainAxisSize:
MainAxisSize.min,



children:[


const Text(

"Properties",

style:

TextStyle(

fontSize:20,

fontWeight:
FontWeight.bold

)

),



Slider(

value:element.width,

min:40,

max:300,


onChanged:(v){


element.width=v;


},


),



Slider(

value:element.height,

min:40,

max:300,


onChanged:(v){


element.height=v;


},


),



SwitchListTile(

title:
const Text("Lock"),

value:
element.locked,


onChanged:(v){


element.locked=v;


},


),



ElevatedButton(

onPressed:duplicate,

child:
const Text("Duplicate"),

),



ElevatedButton(

onPressed:delete,

child:
const Text("Delete"),

),



]

)


)


);


}


}

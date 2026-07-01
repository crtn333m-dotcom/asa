import 'package:flutter/material.dart';

import '../models/canvas_element.dart';

import '../painters/tree_painter.dart';



class CanvasView extends StatefulWidget{


@override
State<CanvasView> createState()=>_CanvasViewState();


}



class _CanvasViewState extends State<CanvasView>{



List<CanvasElement> elements=[];



CanvasElement? selected;




void add(ElementType type){


setState((){


elements.add(

CanvasElement(

id:DateTime.now()
.toString(),


type:type,


position:

const Offset(200,200)

)


);


});


}




@override
Widget build(BuildContext context){



return Scaffold(



floatingActionButton:

PopupMenuButton(

child:

FloatingActionButton(

child:

const Icon(Icons.add),

onPressed:null,

),



itemBuilder:(context)=>[


PopupMenuItem(

child:

const Text("Trunk"),

onTap:()=>add(ElementType.trunk)

),



PopupMenuItem(

child:

const Text("Branch"),

onTap:()=>add(ElementType.branch)

),



PopupMenuItem(

child:

const Text("Leaf"),

onTap:()=>add(ElementType.leaf)

),


],


),




body:

GestureDetector(



onPanUpdate:(d){



if(selected!=null && 
!selected!.locked){


setState((){


selected!.position += d.delta;


});


}



},




child:

CustomPaint(


size:

Size.infinite,


painter:

TreePainter(

elements,

selected

),


),



),


);



}


}

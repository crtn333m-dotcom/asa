import 'package:flutter/material.dart';

import '../models/canvas_element.dart';
import '../painters/tree_painter.dart';
import 'properties_panel.dart';



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




void delete(){

if(selected!=null){

setState((){

elements.remove(selected);

selected=null;

});

}

}




void duplicate(){


if(selected!=null){


setState((){


elements.add(

CanvasElement(

id:DateTime.now()
.toString(),


type:selected!.type,


position:
selected!.position +
const Offset(40,40),


color:selected!.color,


text:selected!.text


)

);


});


}


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



itemBuilder:(c)=>[



PopupMenuItem(

child:
const Text("Trunk"),

onTap:()=>add(ElementType.trunk),

),



PopupMenuItem(

child:
const Text("Branch"),

onTap:()=>add(ElementType.branch),

),



PopupMenuItem(

child:
const Text("Leaf"),

onTap:()=>add(ElementType.leaf),

),



],



),





body:

Stack(



children:[



GestureDetector(


onTapDown:(details){


for(var e in elements.reversed){


if(Rect.fromLTWH(

e.position.dx,

e.position.dy,

e.width,

e.height


).contains(details.localPosition)){


setState(()=>selected=e);


break;


}


}


},



onPanUpdate:(d){


if(selected!=null && !selected!.locked){


setState((){


selected!.position+=d.delta;


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




if(selected!=null)


PropertiesPanel(

element:selected!,


duplicate:duplicate,


delete:delete,


),



],



),



);



}


}

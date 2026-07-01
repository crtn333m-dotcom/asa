import 'package:flutter/material.dart';

import '../models/canvas_element.dart';



class TreePainter extends CustomPainter{


List<CanvasElement> elements;


CanvasElement? selected;



TreePainter(
this.elements,
this.selected
);



@override

void paint(Canvas canvas,Size size){



for(var e in elements){


Paint p=Paint()

..color=e.color;



canvas.save();



canvas.translate(

e.position.dx,

e.position.dy

);



canvas.rotate(e.rotation);



if(e.type==ElementType.leaf){


canvas.drawOval(

Rect.fromLTWH(

0,

0,

e.width,

e.height

),

p

);


}

else{


canvas.drawRRect(

RRect.fromRectAndRadius(

Rect.fromLTWH(

0,

0,

e.width,

e.height

),

const Radius.circular(20)

),

p

);


}




if(e.text.isNotEmpty){


TextPainter t=TextPainter(

text:

TextSpan(

text:e.text,

style:

const TextStyle(

color:Colors.white

)

),


textDirection:
TextDirection.rtl

);



t.layout();



t.paint(

canvas,

Offset(

20,

40

)

);


}




canvas.restore();



}



}



@override

bool shouldRepaint(oldDelegate)=>true;


}

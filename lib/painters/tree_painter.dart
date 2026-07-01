import 'package:flutter/material.dart';

import '../models/canvas_element.dart';



class TreePainter extends CustomPainter {


final List<CanvasElement> elements;

final CanvasElement? selected;



TreePainter(
this.elements,
this.selected
);



@override
void paint(Canvas canvas, Size size){



for(var e in elements){



canvas.save();



canvas.translate(
e.position.dx,
e.position.dy
);



canvas.rotate(
e.rotation
);



Paint paint = Paint()
..color = e.color;



if(e.type == ElementType.leaf){


canvas.drawOval(

Rect.fromLTWH(

0,

0,

e.width,

e.height

),

paint

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

const Radius.circular(25)

),

paint

);


}




// كتابة داخل الشكل

if(e.text.isNotEmpty){



TextPainter textPainter = TextPainter(

text:

TextSpan(

text:e.text,

style:

const TextStyle(

color:Colors.white,

fontSize:16

)

),


textDirection:
TextDirection.rtl


);



textPainter.layout();



textPainter.paint(

canvas,

Offset(

20,

e.height/2

)

);



}



canvas.restore();





// إطار التحديد

if(e == selected){


Paint border = Paint()

..color = Colors.blue

..style = PaintingStyle.stroke

..strokeWidth=3;



canvas.drawRect(

Rect.fromLTWH(

e.position.dx,

e.position.dy,

e.width,

e.height

),

border

);



}



}



}




@override

bool shouldRepaint(
covariant CustomPainter oldDelegate
){

return true;

}



}

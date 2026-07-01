import 'package:flutter/material.dart';



enum ElementType {

  trunk,

  branch,

  leaf

}




class CanvasElement {



String id;



ElementType type;



Offset position;



double width;



double height;



double rotation;



Color color;



bool locked;



String text;



int layer;




CanvasElement({

required this.id,

required this.type,

required this.position,


this.width = 100,


this.height = 120,


this.rotation = 0,


this.color = Colors.brown,


this.locked = false,


this.text = "",


this.layer = 0,


});





Map<String,dynamic> toJson(){


return {


"id":id,


"type":type.name,


"x":position.dx,


"y":position.dy,


"width":width,


"height":height,


"rotation":rotation,


"text":text,


"color":color.value,


"locked":locked,


"layer":layer


};


}



}

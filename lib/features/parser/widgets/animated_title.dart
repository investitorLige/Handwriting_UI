import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';


class AnimatedTitle extends StatefulWidget {
  const AnimatedTitle({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AnimatedTitleState createState() => _AnimatedTitleState();
}

class _AnimatedTitleState extends State<AnimatedTitle> with SingleTickerProviderStateMixin{

  late AnimationController _titlecontroller;

  @override
  void initState(){
    super.initState();
    

    _titlecontroller = AnimationController(vsync: this, duration: Duration(seconds: 3));
    _titlecontroller.repeat();
  }

  @override
  void dispose(){
    _titlecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[
        Align(
          alignment: Alignment(-0.35, 0),
          child: Image.asset(
            'images/emoji/eyes-inverted.png',
            width: 94,
            height: 94,
        ),

        ),
        
        
       // SizedBox(width: 30),

        Align(
          alignment: Alignment.center,
          child: Text(
            "yaya"
             , style: TextStyle(fontSize: 34),)
        .animate(
          onPlay: (controller) => controller.repeat(reverse: true),
        )
        .scaleXY(
          begin: 0.8,
          end: 1.4,
          duration: Duration(seconds: 2)
        ),
        )

      ]
  
    );
    
  }
  
  
}

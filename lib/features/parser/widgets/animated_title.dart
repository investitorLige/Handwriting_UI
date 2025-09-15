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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children:[

        Image.asset('images/emoji/eyes-inverted.png',
        width: 24,
        height: 24,
        ),
        
        SizedBox(width: 20),

        Text("yaya" , style: TextStyle(fontSize: 24),)
        .animate(
          onPlay: (controller) => controller.repeat(reverse: true),
        )
        .scaleXY(
          begin: 0.8,
          end: 1.4,
          duration: Duration(seconds: 2)
        )
      ]
  
    );
    
  }
  
  
}

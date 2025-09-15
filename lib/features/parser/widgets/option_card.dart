import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;

class EnhancedOptionCard extends StatefulWidget {
  final String title;
  final String description;
  final dynamic icon;
  final String lottieAsset;
  final Color primaryColor;
  final Color secondaryColor;
  final VoidCallback onTap;
  final String actionText;

  const EnhancedOptionCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.lottieAsset,
    required this.primaryColor,
    required this.secondaryColor,
    required this.onTap,
    required this.actionText,
  });

  @override
  _EnhancedOptionCardState createState() => _EnhancedOptionCardState();
}

class _EnhancedOptionCardState extends State<EnhancedOptionCard>
    with TickerProviderStateMixin {
  
  late AnimationController _hoverController;
  late AnimationController _borderController;
  late AnimationController _pulseController;
  late AnimationController _glowController;
  
  late Animation<double> _hoverAnimation;
  late Animation<double> _borderRotation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;
  
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    
    _hoverController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );
    
    _borderController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat();
    
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _glowController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _hoverAnimation = CurvedAnimation(
      parent: _hoverController,
      curve: Curves.elasticOut,
    );
    
    _borderRotation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(_borderController);
    
    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _glowAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _borderController.dispose();
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    HapticFeedback.lightImpact();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    HapticFeedback.mediumImpact();
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _hoverController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _hoverAnimation,
            _pulseAnimation,
            _glowAnimation,
          ]),
          builder: (context, child) {
            final double scale = _isPressed ? 0.95 : (1.0 + 0.02 * _hoverAnimation.value);
            final double elevation = 8 + (15 * _hoverAnimation.value);
            
            return Transform.scale(
              scale: scale * _pulseAnimation.value,
              child: Transform.translate(
                offset: Offset(0, -8 * _hoverAnimation.value),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: widget.primaryColor.withValues(alpha: 0.3 * _hoverAnimation.value),
                        blurRadius: elevation,
                        spreadRadius: 2 * _hoverAnimation.value,
                        offset: Offset(0, elevation / 2),
                      ),
                      BoxShadow(
                        color: widget.primaryColor.withValues(alpha: 0.1 * _glowAnimation.value),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: GlassmorphicContainer(
                    width: double.infinity,
                    height: double.infinity,
                    borderRadius: 24,
                    blur: 20 + (10 * _hoverAnimation.value),
                    alignment: Alignment.center,
                    border: 1 + _hoverAnimation.value,
                    linearGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.1 + 0.05 * _hoverAnimation.value),
                        Colors.white.withValues(alpha: 0.05 + 0.03 * _hoverAnimation.value),
                      ],
                    ),
                    borderGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        widget.primaryColor.withValues(alpha: 0.3 + 0.4 * _hoverAnimation.value),
                        widget.secondaryColor.withValues(alpha: 0.3 + 0.4 * _hoverAnimation.value),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Stack(
                        children: [
                          // Shimmer effect
                          if (_isHovered)
                            Positioned.fill(
                              child: Shimmer.fromColors(
                                baseColor: Colors.transparent,
                                highlightColor: Colors.white.withValues(alpha: 0.05),
                                direction: ShimmerDirection.ltr,
                                period: Duration(seconds: 2),
                                child: Container(color: Colors.white),
                              ),
                            ),
                          
                          // Floating light orbs
                          ...List.generate(3, (index) {
                            return AnimatedBuilder(
                              animation: _borderRotation,
                              builder: (context, child) {
                                double angle = _borderRotation.value + (index * 2 * math.pi / 3);
                                double x = 0.5 + 0.3 * math.cos(angle);
                                double y = 0.5 + 0.3 * math.sin(angle);
                                
                                return Positioned(
                                  left: MediaQuery.of(context).size.width * 0.15 * x,
                                  top: MediaQuery.of(context).size.width * 0.15 * y,
                                  child: Container(
                                    width: 4,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: widget.primaryColor.withValues(alpha: 0.3),
                                      borderRadius: BorderRadius.circular(2),
                                      boxShadow: [
                                        BoxShadow(
                                          color: widget.primaryColor.withValues(alpha: 0.2),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                          
                          // Main content - Made responsive
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Enhanced icon with rotating border - Made smaller
                                Flexible(
                                  flex: 2,
                                  child: SizedBox(
                                    width: 70,
                                    height: 70,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        // Rotating border with gradient
                                        AnimatedBuilder(
                                          animation: _borderRotation,
                                          builder: (context, child) {
                                            return Transform.rotate(
                                              angle: _borderRotation.value,
                                              child: Container(
                                                width: 74,
                                                height: 74,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(18),
                                                  gradient: SweepGradient(
                                                    colors: [
                                                      Colors.transparent,
                                                      widget.primaryColor.withValues(alpha: 0.5),
                                                      Colors.transparent,
                                                    ],
                                                    stops: [0.0, 0.5, 1.0],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        
                                        // Icon container with Lottie animation
                                        Container(
                                          width: 70,
                                          height: 70,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(16),
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                widget.primaryColor,
                                                widget.secondaryColor,
                                              ],
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: widget.primaryColor.withValues(alpha: 0.4),
                                                blurRadius: 10,
                                                offset: Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              // Fallback emoji
                                              if(widget.icon is String)
                                                Text(
                                                  widget.icon,
                                                  style: TextStyle(fontSize: 30),
                                                )      
                                              else if(widget.icon is Widget)
                                                SizedBox(
                                                  width: 30,
                                                  height: 30,
                                                  child: widget.icon,
                                                ),

                                              // Lottie animation overlay
                                              if (_isHovered)
                                                Lottie.asset(
                                                  widget.lottieAsset,
                                                  width: 40,
                                                  height: 40,
                                                  fit: BoxFit.contain,
                                                ),
                                            ],
                                          ),
                                        ).animate(target: _isHovered ? 1 : 0)
                                            .scale(
                                              begin: Offset(1, 1),
                                              end: Offset(1.1, 1.1),
                                              duration: 300.ms,
                                            )
                                            .rotate(
                                              begin: 0,
                                              end: 0.05,
                                              duration: 300.ms,
                                            ),
                                      ],
                                    ),
                                  ),
                                ),
                                
                                SizedBox(height: 12),
                                
                                // Enhanced title with shimmer - Made responsive
                                Flexible(
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.white,
                                    highlightColor: _isHovered ? widget.primaryColor : Colors.white,
                                    child: Text(
                                      widget.title,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Inter',
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                
                                SizedBox(height: 8),
                                
                                // Description - Made responsive
                                Flexible(
                                  flex: 2,
                                  child: Text(
                                    widget.description,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withValues(alpha: 0.7),
                                      height: 1.4,
                                      fontFamily: 'Inter',
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                
                                SizedBox(height: 12),
                                
                                // Enhanced action zone - Made smaller
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: _isHovered 
                                        ? widget.primaryColor.withValues(alpha: 0.8)
                                        : Colors.white.withValues(alpha: 0.2),
                                      width: 1.5,
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: _isHovered
                                        ? [
                                            widget.primaryColor.withValues(alpha: 0.1),
                                            widget.secondaryColor.withValues(alpha: 0.05),
                                          ]
                                        : [
                                            Colors.white.withValues(alpha: 0.03),
                                            Colors.white.withValues(alpha: 0.01),
                                          ],
                                    ),
                                    boxShadow: _isHovered
                                      ? [
                                          BoxShadow(
                                            color: widget.primaryColor.withValues(alpha: 0.2),
                                            blurRadius: 6,
                                          ),
                                        ]
                                      : [],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (_isHovered)
                                        Icon(
                                          Icons.touch_app,
                                          color: widget.primaryColor,
                                          size: 16,
                                        ).animate()
                                            .fadeIn(duration: 200.ms)
                                            .scale(begin: Offset(0.5, 0.5)),
                                      
                                      if (_isHovered) SizedBox(width: 6),
                                      
                                      Flexible(
                                        child: Text(
                                          widget.actionText,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: _isHovered 
                                              ? Colors.white.withValues(alpha: 0.9)
                                              : Colors.white.withValues(alpha: 0.5),
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Inter',
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ).animate(target: _isHovered ? 1 : 0)
                                    .shimmer(
                                      duration: 1000.ms,
                                      color: widget.primaryColor.withValues(alpha: 0.3),
                                    ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
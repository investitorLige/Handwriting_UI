import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vibration/vibration.dart';
import 'dart:math' as math;
import 'dart:async';

import '../../../data/services/audio/background_service.dart';
import '../../../data/services/gallery_service.dart';
import '../../../data/services/camera_service.dart';
import '../widgets/animated_title.dart';
import '../widgets/option_card.dart';
// import '../widgets/mouse_trail.dart';
import '../../../core/constants/parser_constants.dart';

class ParserScreen extends StatefulWidget {
  const ParserScreen({super.key});

  @override
  ParserScreenState createState() => ParserScreenState();
}

class ParserScreenState extends State<ParserScreen>
    with TickerProviderStateMixin , WidgetsBindingObserver{
  
  final GalleryService _galleryService = GalleryService();
  final CameraService _cameraService = CameraService();
  
  late AnimationController _mainController;
  late AnimationController _particleController;
  
  List<Particle> particles = [];
  Timer? _particleTimer;

  late bool _isPlaying;
  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    
    _mainController = AnimationController(
      duration: Duration(seconds: 20),
      vsync: this,
    )..repeat();
    
    _particleController = AnimationController(
      duration: Duration(seconds: 15),
      vsync: this,
    )..repeat();

    //BackgroundMusicService.play();
    
    _initializeParticles();
    _startParticleAnimation();
    _isPlaying = false;
    _isLoading = false;
  }

  @override
  void dispose() {
    _mainController.dispose();
    _particleController.dispose();
    _particleTimer?.cancel();
    super.dispose();
    BackgroundMusicService.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        BackgroundMusicService.pause();
        _isPlaying = false;
        break;
      case AppLifecycleState.resumed:
        BackgroundMusicService.play();
        _isPlaying = true;
        break;
      default:
        break;
    }
  }

 Future<void> _toggleMusic() async {
    if (_isLoading) return; // Prevent multiple taps

    setState(() {
      _isLoading = true;
    });

    try {
      if (!_isPlaying) {
        await BackgroundMusicService.play();
        if (mounted) {
          setState(() {
            _isPlaying = true;
            _isLoading = false;
          });
        }
      } else {
        await BackgroundMusicService.pause();
        if (mounted) {
          setState(() {
            _isPlaying = false;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      // Handle errors (network issues, permissions, etc.)
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to ${_isPlaying ? 'pause' : 'play'} music'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }



  void _initializeParticles() {
    particles = List.generate(12, (index) {
      return Particle(
        x: math.Random().nextDouble(),
        y: math.Random().nextDouble(),
        speed: 0.5 + math.Random().nextDouble() * 0.5,
        size: 15 + math.Random().nextDouble() * 15,
        opacity: 0.1 + math.Random().nextDouble() * 0.2,
      );
    });
  }

  void _startParticleAnimation() {
    _particleTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      setState(() {
        for (var particle in particles) {
          particle.update();
        }
      });
    });
  }

  Future<void> _handleImageUpload() async {
    await _triggerHaptic();
    
    try {
      final images = await _galleryService.pickImages();
      if (images != null && images.isEmpty) {
        _showEnhancedDialog(
          _galleryService.getRandomCaptureMessage(),
          AppColors.uploadPrimary,
        );
      }
    } catch (e) {
      _showEnhancedDialog(
        'Oops! File selection encountered an issue.',
        Colors.redAccent,
      );
    }
  }

  Future<void> _handleCameraCapture() async {
    await _triggerHaptic();
    
    try {
      final image = await _cameraService.captureImage();
      if (image != null) {
        _showEnhancedDialog(
          _cameraService.getRandomCaptureMessage(),
          AppColors.cameraPrimary,
        );
      }
    } catch (e) {
      _showEnhancedDialog(
        'Camera not available on this device.',
        Colors.orangeAccent,
      );
    }
  }

  Future<void> _triggerHaptic() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 50);
    } else {
      HapticFeedback.mediumImpact();
    }
  }

  void _showEnhancedDialog(String message, Color accentColor) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GlassmorphicContainer(
            width: 320,
            height: 400,
            borderRadius: 24,
            blur: 20,
            alignment: Alignment.center,
            border: 2,
            linearGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.1),
                Colors.white.withValues(alpha: 0.05)
              ],
            ),
            borderGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                accentColor.withValues(alpha: 0.5),
                accentColor.withValues(alpha: 0.2),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Animate(
                    effects: [ScaleEffect(duration: 300.ms, curve: Curves.elasticOut)],
                    child: Lottie.asset(
                      'assets/animations/thumbs_up.json',
                      width: 60,
                      height: 60,
                      repeat: false,
                    ),
                  ),

                  SizedBox(height: 16),
                  
                  Shimmer.fromColors(
                    baseColor: Colors.white,
                    highlightColor: accentColor,
                    child: Text(
                      'Success!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 8),
                  
                  Text(
                    message,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 14,
                      fontFamily: 'Inter',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  SizedBox(height: 20),
                  
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [accentColor, accentColor.withValues(alpha: 0.8)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Awesome!',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ).animate().scale(
                      delay: 200.ms,
                      duration: 200.ms,
                      curve: Curves.easeOut,
                    ),
                  ),
                ],
              ),
            ),
            
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //Background
          Positioned.fill(
            child: Lottie.asset(
              '/animations/background_better_res.json',
              repeat: true,
              fit: BoxFit.cover
            )
          ),
          
          // Floating particles
          AnimatedBackground(
            behaviour: RandomParticleBehaviour(
              options: ParticleOptions(
                baseColor: AppColors.particleBase,
                spawnOpacity: 0.1,
                opacityChangeRate: 0.25,
                minOpacity: 0.05,
                maxOpacity: 0.3,
                particleCount: 15,
                spawnMaxRadius: 20,
                spawnMaxSpeed: 50,
                spawnMinSpeed: 10,
              ),
            ),
            vsync: this,
            child: Container(),
          ),
          
          
          // Custom floating particles
          ...particles.map((particle) => Positioned(
            left: particle.x * MediaQuery.of(context).size.width,
            top: particle.y * MediaQuery.of(context).size.height,
            child: Image.asset(
            'images/emoji/c_thumbs_up.png',
             fit: BoxFit.cover,
             width: particle.size * 3,
             height: particle.size * 3,
              ).animate(onPlay: (controller) => controller.repeat())
                .shimmer(duration: 3000.ms)
                .scale(
                  begin: Offset(0.8, 0.8),
                  end: Offset(1.2, 1.2),
                  duration: 2000.ms,
                  curve: Curves.easeInOut,
                ),
          )),
          
          
          // Mouse trail effect
         // MouseTrailWidget(),
          
          // Main content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Animated header section
                  AnimationLimiter(
                    child: Column(
                      children: AnimationConfiguration.toStaggeredList(
                        duration: Duration(milliseconds: 600),
                        childAnimationBuilder: (widget) => SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(child: widget),
                        ),
                        children: [
                          SizedBox(height: 30),
                          
                          // Enhanced animated title
                          AnimatedTitle(),
                          
                          SizedBox(height: 16),
                          
                          Text(
                            'Parse your Chinese, 政府正在关注 ',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withValues(alpha: 0.7),
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Inter',
                            ),
                            textAlign: TextAlign.center,
                          ).animate()
                              .fadeIn(delay: 200.ms, duration: 800.ms)
                              .slideY(begin: 0.3, end: 0),
                          
                          SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                  
                  // Enhanced options grid - Outside of staggered animations
                  Expanded(
                    child: Row(
                      children: [
                        // Upload card
                        Expanded(
                          child: EnhancedOptionCard(
                            title: 'Upload Files',
                            description: 'Drag and drop your documents or browse from your device. Supports PDF, Word, and text files.',
                            icon: Image.asset('/images/emoji/thumbs_up.jpg'),
                            lottieAsset: 'assets/animations/thumbs_up.json',
                            primaryColor: AppColors.uploadPrimary,
                            secondaryColor: AppColors.uploadSecondary,
                            onTap: _handleImageUpload,
                            actionText: 'Click or drop files here',
                          ).animate()
                              .fadeIn(delay: 400.ms, duration: 800.ms)
                              .slideX(begin: -0.3, end: 0)
                              .scale(begin: Offset(0.8, 0.8), end: Offset(1, 1)),
                        ),
                        
                        SizedBox(width: 48),
                        
                        // Camera card
                        Expanded(
                          child: EnhancedOptionCard(
                            title: 'Capture Photo',
                            description: 'Use your device camera to capture documents in real-time',
                            icon: '📸',
                            lottieAsset: 'assets/animations/thumbs_up.json',
                            primaryColor: AppColors.cameraPrimary,
                            secondaryColor: AppColors.cameraSecondary,
                            onTap: _handleCameraCapture,
                            actionText: 'Tap to open camera',
                          ).animate()
                              .fadeIn(delay: 600.ms, duration: 800.ms)
                              .slideX(begin: 0.3, end: 0)
                              .scale(begin: Offset(0.8, 0.8), end: Offset(1, 1)),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 20),

                  Align(
                    alignment: Alignment.centerRight,
                    child: FloatingActionButton(
                      onPressed: () async => await _toggleMusic(),
                      child: Icon( _isPlaying ? Icons.volume_off : Icons.volume_up),
                    ),
                  ),

                  SizedBox(height: 10),
                  
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Particle {
  double x;
  double y;
  final double speed;
  final double size;
  final double opacity;
  double _direction;

  Particle({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.opacity,
  }) : _direction = math.Random().nextDouble() * 2 * math.pi;

  void update() {
    y -= speed * 0.01;
    x += math.sin(_direction) * 0.005;
    
    if (y < -0.1) {
      y = 1.1;
      x = math.Random().nextDouble();
      _direction = math.Random().nextDouble() * 2 * math.pi;
    }
    
    if (x < -0.1) x = 1.1;
    if (x > 1.1) x = -0.1;
  }
}
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class LiquidButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onClick;
  final ui.FragmentShader shader;

  const LiquidButton({
    super.key,
    required this.child,
    required this.onClick,
    required this.shader,
  });

  @override
  State<LiquidButton> createState() => _LiquidButtonState();
}

class _LiquidButtonState extends State<LiquidButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  
  // This animation will drive the offset when the user releases their finger
  Animation<Offset>? _offsetAnimation;
  
  // This offset tracks the raw drag position during a pan gesture
  Offset _dragOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    // Stop any existing animations and reset the state
    _controller.stop();
    setState(() {
      _offsetAnimation = null;
      _dragOffset = Offset.zero;
    });
    // Start the "press down" scale animation
    _controller.forward();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    // Update the drag offset based on the user's finger movement
    setState(() {
      _dragOffset += details.delta;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    // Animate the scale back to 1.0 using a spring simulation
    final spring = SpringDescription(mass: 0.8, stiffness: 120.0, damping: 8.0);
    final scaleSimulation = SpringSimulation(spring, _controller.value, 0.0, 0.0);
    
    // Check if the gesture was more of a tap than a drag
    final isTap = _dragOffset.distance < 5.0;
    if (isTap) {
      widget.onClick();
    }

    // Create a new animation to animate the offset back to zero
    setState(() {
      _offsetAnimation = Tween<Offset>(begin: _dragOffset, end: Offset.zero).animate(
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut)
      );
    });

    // Run the animation
    _controller.animateWith(scaleSimulation);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      onPanCancel: () => _onPanEnd(DragEndDetails()),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // If _offsetAnimation is active, use its value. Otherwise, use the live drag offset.
          final offset = _offsetAnimation?.value ?? _dragOffset;
          return Transform.translate(
            offset: offset,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // This container is a placeholder for the BackdropFilter to work on.
              // It doesn't need to be visible.
              Container(), 
              BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              ShaderMask(
                shaderCallback: (bounds) {
                  // Set the uniforms for the shader
                  // widget.shader
                  //   ..setFloat(0, bounds.width)
                  //   ..setFloat(1, bounds.height)
                  //   ..setFloat(2, 0.5) // u_lens_radius
                  //   ..setFloat(3, 0.25); // u_refraction

                  return widget.shader;
                },
                blendMode: BlendMode.srcOver,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: widget.child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


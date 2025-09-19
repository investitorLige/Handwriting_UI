import 'package:flutter/material.dart';

class EnhancedOptionCard extends StatefulWidget {
  final String title;
  final String description;
  final dynamic icon; // Can be String (emoji) or Widget (Icon)
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
  State<EnhancedOptionCard> createState() => _EnhancedOptionCardState();
}

class _EnhancedOptionCardState extends State<EnhancedOptionCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: const Color.fromARGB(57, 100, 36, 109),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered 
                ? widget.primaryColor.withValues(alpha: 0.3)
                : Colors.grey.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered 
                  ? widget.primaryColor.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.05),
                blurRadius: _isHovered ? 8 : 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon Section
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: widget.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: widget.icon is String
                      ? Text(
                          widget.icon,
                          style: const TextStyle(fontSize: 24),
                        )
                      : widget.icon is Widget
                        ? widget.icon
                        : Icon(
                            Icons.help_outline,
                            size: 24,
                            color: widget.primaryColor,
                          ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Title
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 8),
                
                // Description
                Text(
                  widget.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 16),
                
                // Action Text
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _isHovered 
                      ? widget.primaryColor.withValues(alpha: 0.1)
                      : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.actionText,
                    style: TextStyle(
                      fontSize: 12,
                      color: _isHovered 
                        ? widget.primaryColor
                        : Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
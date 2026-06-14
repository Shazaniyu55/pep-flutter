import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/theme/app_theme.dart';

class BottomRectangularBtn extends StatelessWidget {
  const BottomRectangularBtn({
    super.key,
    required this.onTapFunc,
    required this.btnTitle,
    this.isDisabled = false,
    this.isFilled = false,
    this.isLoading = false,
    this.loadingText = '',
    this.onlyBorder = false,
    this.color,
    this.buttonTextColor,
    this.hasIcon,
    this.svgName,
    this.svgColor,
    this.iconSize = 20,
    this.hasDoubleBorder,
  });

  final VoidCallback onTapFunc;
  final String btnTitle;
  final bool isDisabled;
  final bool isFilled;
  final bool isLoading;
  final String loadingText;
  final Color? color;
  final Color? buttonTextColor;
  final bool? onlyBorder;
  final bool? hasIcon;
  final bool? hasDoubleBorder;
  final String? svgName;
  final Color? svgColor;
  final double iconSize;

  bool get _isOutlined => onlyBorder == true;

  // Show the icon whenever a name is supplied. (hasIcon kept only so old
  // call sites still compile -- it's no longer required.)
  bool get _showIcon => svgName != null && svgName!.isNotEmpty;

  Color get _textColor {
    if (isDisabled) {
      return isLoading ? Colors.white70 : const Color(0xFF9E9B9B);
    }
    if (buttonTextColor != null) return buttonTextColor!;
    return _isOutlined ? AppTheme.primary : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: (isDisabled || isLoading) ? null : onTapFunc,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: _isOutlined
            ? BoxDecoration(
                border: Border.all(color: AppTheme.primary),
                borderRadius: BorderRadius.circular(10),
              )
            : BoxDecoration(
                color: color ?? AppTheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isLoading ? loadingText : btnTitle,
                style: TextStyle(
                  color: _textColor,
                  fontSize: 16,
                ),
              ),
              if (isLoading) ...[
                SizedBox(
                  height: 28,
                  width: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: _isOutlined ? AppTheme.primary : Colors.white,
                    backgroundColor: Colors.transparent,
                  ),
                ),
                const SizedBox(width: 14),
              ],
              if (!isLoading && _showIcon) ...[
                SvgPicture.asset(
                  'images/svgs/$svgName.svg',
                  width: iconSize,
                  height: iconSize,
                  colorFilter: svgColor != null
                      ? ColorFilter.mode(svgColor!, BlendMode.srcIn)
                      : null,
                  // If the asset is missing/broken, show a fallback instead of
                  // a blank gap so you can SEE that something's wrong.
                  placeholderBuilder: (_) => Icon(
                    Icons.broken_image_outlined,
                    size: iconSize,
                    color: svgColor ?? Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              
            ],
          ),
        ),
      ),
    );
  }
}
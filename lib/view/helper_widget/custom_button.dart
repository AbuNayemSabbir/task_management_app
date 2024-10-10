import 'package:flutter/material.dart';
import 'package:todo_app/utills/app_color.dart';

class CustomElevatedButton extends StatelessWidget {
  final String title;
  final bool isLoading;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final double width;

  const CustomElevatedButton({super.key,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
    this.color = AppColors.primaryColor,
    this.textColor = Colors.black,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),),
        onPressed: isLoading ? null : onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            Text(title,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18))
          ],
        ),
      ),
    );
  }
}

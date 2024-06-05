import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../values/colors.dart';

class CustomAlertDialog extends StatelessWidget {
  final String? title;
  final String? content;
  final String? buttonText;
  final Color? backgroundColor;
  final VoidCallback? onPressed;
  final bool showTextField;
  final TextEditingController? textController;

  CustomAlertDialog({
    this.title,
    this.content,
    this.buttonText,
    this.onPressed,
    this.backgroundColor,
    this.showTextField = false,
    this.textController,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.dialogColor,
      child: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            title != null
                ? Column(
                    children: [
                      SizedBox(height: 16.0.h),
                      Text(
                        title!,
                        style: TextStyle(
                          fontSize: 20.0.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.0.h),
                    ],
                  )
                : SizedBox(),
            showTextField
                ? TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: 'Enter text',
                    ),
                  )
                : Text(
                    content ?? '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0.sp,
                      color: AppColors.primaryText.withOpacity(0.8),
                    ),
                  ),
            Divider(
              height: 20.0.h,
              thickness: 1.0.h,
              color: Colors.grey[400],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        backgroundColor ?? AppColors.primaryElement,
                    foregroundColor: AppColors.surfaceWhite,
                    minimumSize: Size(100.0, 40.0),
                  ),
                  child: Text(buttonText ?? ''),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

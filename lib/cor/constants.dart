import 'package:flutter/material.dart';

class Constants {
  static SizedBox sizedBox({double? width, double? higth}) {
    return SizedBox(
      width: width,
      height: higth,
    );
  }

  static ButtonStyle elevatedButton() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.purple, // لون الزر
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30), // حواف مستديرة
      ),
      minimumSize: const Size(double.infinity, 60), // عرض كامل وارتفاع ثابت
      padding: const EdgeInsets.symmetric(vertical: 15), // مسافة داخلية
    );
  }
}

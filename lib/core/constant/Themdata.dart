import 'package:flutter/material.dart';

import 'Colorapp.dart';

ThemeData themeEn = ThemeData(
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: Colors.black,
    secondary: Colors.black,
  ),

  fontFamily: "Wittgenstein",
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: AppColor.black,
      fontWeight: FontWeight.bold,
      fontFamily: "Wittgenstein",
      fontSize: 24, // كان 25
    ),
    iconTheme: IconThemeData(color: AppColor.black),
    backgroundColor: const Color(0xFFF8F9FA),
    elevation: 0,
  ),
  textTheme: const TextTheme(
    headlineMedium: TextStyle(
      // خاص بي البتن
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: AppColor.white,
    ),
    headlineSmall: TextStyle(
      //  خاص بي الفقرات
      fontWeight: FontWeight.bold,
      fontSize: 14,
      color: Color.fromARGB(255, 97, 97, 97),
    ),
    headlineLarge: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20, // كان 20
      color: AppColor.black,
    ),
    bodyMedium: TextStyle(
      // خاصة بي النصوص العادية
      height: 1.6,
      color: AppColor.grey,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
    bodySmall: TextStyle(
      // خاصة بي النصوص المتوسطة
      height: 1.6,
      color: AppColor.brand,
      fontWeight: FontWeight.bold,
      fontSize: 24,
    ),
    bodyLarge: TextStyle(
      // خاصة بي النصوص الخشينة
      height: 1.6,
      color: Color.fromARGB(255, 97, 97, 97),
      fontWeight: FontWeight.bold,
      fontSize: 32,
    ),
  ),
);

ThemeData themeAr = ThemeData(
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: Colors.black,
    secondary: Colors.black,
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: const Color(0xFFF8F9FA),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  ),
  fontFamily: "Almiri",
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: AppColor.black,
      fontWeight: FontWeight.bold,
      fontFamily: "Almiri",
      fontSize: 24, // كان 25
    ),
    iconTheme: IconThemeData(color: AppColor.black),
    backgroundColor: AppColor.white,
    elevation: 0,
  ),
  textTheme: const TextTheme(
    headlineMedium: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: AppColor.white,
    ),
    headlineSmall: TextStyle(
      //  خاص بي الفقرات
      fontWeight: FontWeight.bold,
      fontSize: 14,
      color: Color.fromARGB(255, 97, 97, 97),
    ),
    headlineLarge: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20, // كان 20
      color: AppColor.black,
    ),
    bodyMedium: TextStyle(
      // خاصة بي النصوص العادية
      height: 1.6,
      color: AppColor.grey,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
    bodySmall: TextStyle(
      // خاصة بي النصوص المتوسطة
      height: 1.6,
      color: AppColor.brand,
      fontWeight: FontWeight.bold,
      fontSize: 24,
    ),
    bodyLarge: TextStyle(
      height: 1.6,
      color: Color.fromARGB(255, 97, 97, 97),

      fontWeight: FontWeight.bold,
      fontSize: 32,
    ),
  ),
);

// ignore_for_file: use_full_hex_values_for_flutter_colors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

double defaultMargin = Dimenssions.height10;

Color textColor = const Color(0xffccc7c5);
Color mainColor = const Color(0xff82dad0);
//Color mainColor  =const Color ( 0xFFfa7552 );
Color iconColor1 = const Color(0xffffd28d);
Color iconColor = const Color(0xFFfcab88);
Color paraColor = const Color(0xff8f837f);
Color buttonBackgroundColor = const Color(0xFFf7f6f4);
Color signColor = const Color(0xffa9a29f);
Color titlecoler = const Color(0xff5c524f);
Color mainBlackColor = const Color(0xff332d2b);
//  Color yellowColor = =const Color ( 0xFFfa7552 ) ;
Color yellowColor = const Color(0xffffd379);

Color primaryColor = const Color(0xff38ABBE);
Color secondaryColor = const Color(0xff38ABBE);
Color alertColor = const Color(0xffED6363);
Color priceColor = const Color(0xff2C96F1);
Color backgroundColor1 = const Color(0xFFFFFFFF);
Color backgroundColor2 = const Color(0xFFFEFEFF);
Color backgroundColor3 = const Color(0xFFDDDDDD);
Color backgroundColor4 = const Color(0xff252836);
Color backgroundColor5 = const Color(0xFFD4D1D1);
Color backgroundColor6 = const Color(0xFF000000);
Color backgroundColor7 = const Color(0xFF000000);
Color backgroundColor8 = const Color(0XFFf3f5f4);
Color primaryTextColor = const Color(0xFF0C0C0C);
Color secondaryTextColor = const Color(0xFF585858);
Color subtitleColor = const Color(0xFF8E8E97);
Color transparentColor = Colors.transparent;
Color blackColor = const Color(0xff2E2E2E);
Color logoColor = const Color(0xff020238);
Color logoColorSecondary = const Color(0xfffffff6600);
const MaterialColor primarySwatch = MaterialColor(
  0xFFFF6600,
  <int, Color>{
    50: Color(0xFFFFECE0),
    100: Color(0xFFFFD4B3),
    200: Color(0xFFFFB980),
    300: Color(0xFFFF9D4D),
    400: Color(0xFFFF8726),
    500: Color(0xFFFF6600), // warna utama
    600: Color(0xFFFF5E00),
    700: Color(0xFFFF5300),
    800: Color(0xFFFF4900),
    900: Color(0xFFFF3600),
  },
);
TextStyle primaryTextStyle = GoogleFonts.palanquinDark(
  color: primaryTextColor,
);

TextStyle secondaryTextStyle = GoogleFonts.palanquinDark(
  color: secondaryTextColor,
);

TextStyle subtitleTextStyle = GoogleFonts.palanquinDark(
  color: subtitleColor,
);

TextStyle priceTextStyle = GoogleFonts.palanquinDark(
  color: logoColor,
);

TextStyle purpleTextStyle = GoogleFonts.palanquinDark(
  color: primaryColor,
);

TextStyle blackTextStyle = GoogleFonts.palanquinDark(
  color: blackColor,
);

TextStyle alertTextStyle = GoogleFonts.palanquinDark(
  color: alertColor,
);
TextStyle textwhite = GoogleFonts.palanquinDark(
  color: backgroundColor1,
);
TextStyle primaryTextOrange = GoogleFonts.palanquinDark(
  color: logoColorSecondary,
);

FontWeight light = FontWeight.w300;
FontWeight regular = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semiBold = FontWeight.w600;
FontWeight bold = FontWeight.w700;

class Dimenssions {
  static double screenHeight =
      // ignore: duplicate_ignore
      // ignore: deprecated_member_use
      MediaQueryData.fromView(WidgetsBinding.instance.window).size.height;
  static double screenWidth =
      MediaQueryData.fromView(WidgetsBinding.instance.window).size.width;

  static double pageView = screenHeight / 2.64;

  static double pageViewContainer = screenHeight / 3.84;
  static double pageTextContainer = screenHeight / 7.03;
  //dynamic height padding and margin
  static double height5 = screenHeight / 168.8;
  static double height10 = screenHeight / 84.4;
  static double height15 = screenHeight / 56.27;
  static double height20 = screenHeight / 42.2;
  static double height22 = screenHeight / 38.45;
  static double height25 = screenHeight / 33.76;
  static double height30 = screenHeight / 28.13;
  static double height35 = screenHeight / 24.38;
  static double height40 = screenHeight / 21.1;
  static double height45 = screenHeight / 18.76;
  static double height50 = screenHeight / 16.42;
  static double height55 = screenHeight / 14.78;
  static double height60 = screenHeight / 13.14;
  static double height65 = screenHeight / 11.5;
  static double height70 = screenHeight / 10.21;
  static double height75 = screenHeight / 9.09;
  static double height80 = screenHeight / 8.13;
  static double height85 = screenHeight / 7.3;
  static double height90 = screenHeight / 6.58;
  static double height95 = screenHeight / 6;
  static double height100 = screenHeight / 5.53;
  static double height105 = screenHeight / 5.14;

  static double height150 = screenHeight / 5.6;
  static double height180 = screenHeight / 4.44;
  static double height200 = screenHeight / 3.84;
  static double height210 = screenHeight / 3.57;

  static double height220 = screenHeight / 3.33;
  static double height230 = screenHeight / 3.13;
  static double height240 = screenHeight / 2.95;
  static double height250 = screenHeight / 2.8;
  static double height255 = screenHeight / 2.7;

  //dynamic width padding and margin
  static double width5 = screenHeight / 168.8;
  static double width10 = screenHeight / 84.4;
  static double width15 = screenHeight / 56.27;
  static double width20 = screenHeight / 42.2;
  static double width25 = screenHeight / 33.64;
  static double width30 = screenHeight / 28.13;
  static double width35 = screenHeight / 23.88;
  static double width40 = screenHeight / 21.1;
  static double width45 = screenHeight / 18.76;
  static double width50 = screenHeight / 16.88;
  static double width55 = screenHeight / 15.27;
  static double width60 = screenHeight / 13.14;
  static double width65 = screenHeight / 11.5;
  static double width70 = screenHeight / 10.21;
  static double width80 = screenHeight / 10.52;
  static double width85 = screenHeight / 7.3;
  static double width90 = screenHeight / 6.58;
  static double width95 = screenHeight / 6;
  static double width100 = screenHeight / 5.53;
  static double width105 = screenHeight / 5.14;
  static double width110 = screenHeight / 4.76;
  static double width120 = screenHeight / 4.44;
  static double width125 = screenHeight / 4.24;
  static double width130 = screenHeight / 3.97;
  static double width135 = screenHeight / 3.77;
  static double width140 = screenHeight / 3.59;

  static double width150 = screenHeight / 5.64;

  static double font10 = screenHeight / 85.33;
  static double font12 = screenHeight / 70.28;
  static double font14 = screenHeight / 62;
  static double font16 = screenHeight / 53.75;
  static double font18 = screenHeight / 47.78;
  static double font20 = screenHeight / 42.2;
  static double font22 = screenHeight / 37.78;
  static double font24 = screenHeight / 34.29;
  static double font26 = screenHeight / 32.46;

  //radius
  static double radius15 = screenHeight / 52.75;
  static double radius20 = screenHeight / 42.2;
  static double radius30 = screenHeight / 28.13;

  //iconSIze

  static double iconSize20 = screenHeight / 42.2;
  static double iconSize24 = screenHeight / 35.16;
  static double iconSize16 = screenHeight / 52.75;
  //list view size
  static double listViewImgSize = screenWidth / 3.25;
  static double listViewTextContSize = screenWidth / 3.9;

  //popular food detail
  static double popularFoodDetailImgSize = screenHeight / 2.5;

  //bottom heightbar
  static double boottomHeightBar = screenHeight / 7.03;

  // ignore: recursive_getters
  static BuildContext get context => context;
}
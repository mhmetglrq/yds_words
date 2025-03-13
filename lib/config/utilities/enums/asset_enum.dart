import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AssetEnum {
  appleLogo('apple_logo'),
  googleLogo('google_logo'),
  category('category'),
  notifications('notifications'),
  timeSquare('time_square'),
  tickSquare('tick_square'),
  bus('bus'),
  student('student'),
  users('users'),
  ;

  final String value;
  const AssetEnum(this.value);

  String get toPng => 'assets/images/$value.png';
  String get toSvg => 'assets/svg/$value.svg';
  String get toJson => 'assets/json/$value.json';

  Image get toPngImage => Image.asset(toPng);
  SvgPicture get toSvgImage => SvgPicture.asset(toSvg);
}

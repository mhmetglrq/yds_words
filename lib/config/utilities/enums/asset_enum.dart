import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AssetEnum {
  ydsWords("yds_yokdil_words");

  final String value;
  const AssetEnum(this.value);

  String get toPng => 'assets/images/$value.png';
  String get toSvg => 'assets/svg/$value.svg';
  String get toJson => 'assets/json/$value.json';

  Image get toPngImage => Image.asset(toPng);
  SvgPicture get toSvgImage => SvgPicture.asset(toSvg);
}

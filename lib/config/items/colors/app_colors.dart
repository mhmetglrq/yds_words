import 'package:flutter/material.dart';

/// Renklerin derleme zamanında sabit (compile-time constant) olabilmesi için
/// index operatörü [ ] kullanılmadan, doğrudan Color(...) ile tanımlıyoruz.
///
/// #756EF3 (mor) baz alınmış bir palette örneği.
class AppColors {
  // ---------------------------------------------------------------------------
  //  Ana (Primary) renk (#756EF3) ve türetilmiş sabit renk değerleri
  // ---------------------------------------------------------------------------
  static const Color kPrimaryColor = Color(0xFF756EF3);
  static const Color kSecondaryColor = Color(0xFFAAA6FB);

  // Açık ton (background, scaffold)
  static const Color kBackgroundColor = Color(0xFFF2F1FE);
  static const Color kScaffoldColor = Color(0xFFF2F1FE);

  // Yazı ve başlık renkleri
  static const Color kTitleColor = Color(0xFF3A36A8);
  static const Color kTextColor = Color(0xFF4D49C1);

  // Koyu gri ya da siyah ton (projede varsa)
  static const Color kDarkGreyColor = Color(0xFF333333);

  // Beyaz renk (genelde sabit)
  static const Color kWhiteColor = Color(0xFFFFFFFF);

  // Semantic renklere örnek (mor tonlu error isterseniz bu şekilde tanımlanabilir)
  // İsterseniz buraları kırmızı/yeşil gibi klasik error-success renklerine çevirebilirsiniz.
  static const Color kErrorColor = Color(0xFF5C56D2);
  static const Color kSuccessColor = Color(0xFFAAA6FB);
  static const Color kWarningColor = Color(0xFF928EF9);
  static const Color kInfoColor = Color(0xFFC5C2FC);

  // Ek örnekler (size göre renklendirme)
  static const Color kStrokeColor = Color(0xFFC5C2FC);
  static const Color kLightGreyColor = Color(0xFFF2F1FE);
  static const Color kIconColor = Color(0xFF3A36A8);
  static const Color kShadowColor = Color(0xFF4D49C1);
  static const Color kBlackColor = Color(0xFF000000);

  // ---------------------------------------------------------------------------
  //  Koyu & Açık mod için alt sınıflar (final - runtime values).
  //  İsterseniz bunları da doğrudan "const" yapabilirsiniz ama
  //  index operatörü kullanmadığımız için problem çıkmayacaktır.
  // ---------------------------------------------------------------------------
  static final _DarkColors dark = _DarkColors();
  static final _LightColors light = _LightColors();
}

// Dark Mode renklerini tanımlayan alt sınıf
class _DarkColors {
  final Color background = const Color(0xFF3A36A8);
  final Color text = const Color(0xFFF2F1FE);
  final Color primary = const Color(0xFF928EF9);
  final Color secondary = const Color(0xFFC5C2FC);
  final Color error = const Color(0xFF5C56D2);
  final Color success = const Color(0xFFAAA6FB);
}

// Light Mode renklerini tanımlayan alt sınıf
class _LightColors {
  final Color background = AppColors.kBackgroundColor;
  final Color text = AppColors.kTextColor;
  final Color primary = AppColors.kPrimaryColor;
  final Color secondary = AppColors.kSecondaryColor;
  final Color error = AppColors.kErrorColor;
  final Color success = AppColors.kSuccessColor;
}

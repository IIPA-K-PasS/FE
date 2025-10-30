class TipImageResolver {
  static String? assetForTitle(String title) {
    final t = title.toLowerCase();

    if (t.contains('전기') || t.contains('전기세') || t.contains('electric')) {
      return 'assets/images/tips/electricity.jpg';
    }
    if (t.contains('수도') || t.contains('수도세') || t.contains('water')) {
      return 'assets/images/tips/water.jpg';
    }
    if (t.contains('가스') || t.contains('난방') || t.contains('gas')) {
      return 'assets/images/tips/gas.jpg';
    }
    if (t.contains('장보기') || t.contains('1인 가구') || t.contains('1인가구') || t.contains('shopping')) {
      return 'assets/images/tips/shopping.jpg';
    }
    if (t.contains('청소') || t.contains('clean')) {
      return 'assets/images/tips/cleaning.jpg';
    }

    return null;
  }
}



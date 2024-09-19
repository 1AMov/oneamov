String formatNumber(double number) {
  // Use RegExp to format numbers with commas as thousand separators and two decimal places
  String formattedNumber = number.toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match match) => '${match[1]},',
      );

  return formattedNumber;
}

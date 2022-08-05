String replaceAccents(String string) {
  string.replaceAll(RegExp(r'á'), 'a');
  string.replaceAll(RegExp(r'é'), 'e');
  string.replaceAll(RegExp(r'í'), 'i');
  string.replaceAll(RegExp(r'ó'), 'o');
  string.replaceAll(RegExp(r'ú'), 'u');
  string.replaceAll(RegExp(r'ü'), 'u');
  string.replaceAll(RegExp(r'ñ'), 'n');
  return string;
}

String? replaceNumbers(String number) {
  Map<String, String> dict = {
    '1': 'uno',
    '2': 'dos',
    '3': 'tres',
    '4': 'quatro',
    '5': 'cinco',
    '6': 'seis',
    '7': 'siete',
    '8': 'ocho',
    '9': 'nueve',
    '10': 'diez',
    '100': 'cien',
  };
  return dict[number];
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

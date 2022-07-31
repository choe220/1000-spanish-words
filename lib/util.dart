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

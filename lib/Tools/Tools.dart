class Tools {
  static String getLastSplitValue(String text) {
    return "${text.toString().substring(text.toString().indexOf('.') + 1)}";
  }
}

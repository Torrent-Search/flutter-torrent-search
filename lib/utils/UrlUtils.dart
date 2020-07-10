String getFileName(String str) {
  if (str == "") {
    return "";
  }
  return str.replaceAll(" ", "_") + ".mp3";
}

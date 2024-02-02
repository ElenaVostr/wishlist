abstract final class UrlUtil {
  static String getFileNameFromUrl(String url) {
    String decodedUrl = Uri.decodeFull(url);
    List<String> parts = decodedUrl.split('/');
    String fileNameWithParams = parts.last;
    String fileName = fileNameWithParams.split('?')[0];
    return fileName;
  }

  static bool isUrl(String str) {
    RegExp pattern = RegExp('^(https?:\\/\\/)');
    return pattern.hasMatch(str);
  }
}

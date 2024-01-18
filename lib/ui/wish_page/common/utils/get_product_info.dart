// import 'package:http/http.dart' as http;
// import 'package:html/parser.dart' as parser show parse;
// import 'package:html/dom.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
//
//
// Future<Map<String, String>> fetchPageMetadata(String url) async {
//
//   final response = await http.get(Uri.parse(url));
//   if (response.statusCode == 200) {
//     final document = parser.parse(response.body);
//     Element? titleElement = document.head!.querySelector('title');
//     String title = titleElement?.text ?? 'No title found';
//     Element? imageElement = document.head!.querySelector('meta[property="og:image"]');
//     String imageUrl = imageElement?.attributes['content'] ?? 'No image found';
//     return {'title': title, 'imageUrl': imageUrl};
//   } else {
//     throw Exception('Failed to load page');
//   }
// }
//
// void getProductInfo(String url) async {
//   final webView = FlutterWebviewPlugin();
//
//   await webView.launch(url);
//   final htmlContent =
//   await webView.evalJavascript('document.documentElement.outerHTML');
//   final document = parser.parse(htmlContent);
//
//   // Выполните поиск необходимых данных в документе
//   final productId = document.querySelector('[data-product-id]')?.text;
//   if (productId != null) {
//     print('ID продукта: $productId');
//   } else {
//     print('ID продукта не найден');
//   }
// }

// import 'package:http/http.dart' as http;
// import 'package:html/parser.dart' as parser;
//
// void getProductInfo(String url) async {
//   try{
//     var link = Uri.parse(url);
//     var response = await http.get(link);
//     var document = parser.parse(response.body);
//
//     var title = document.querySelector('title')?.text;
//     var description = document.querySelector('meta[name="description"]')?.attributes['content'];
//     var image = document.querySelector('meta[property="og:image"]')?.attributes['content'];
//
//     print('Title: $title');
//     print('Description: $description');
//     print('Image: $image');
//   } catch (error) {
//     print('Это не ссылка');
//   }
// }
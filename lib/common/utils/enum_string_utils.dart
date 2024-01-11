import 'package:wishlist/common/utils/list_extensions.dart';

abstract final class EnumStringUtils {
  static T? enumFromString<T>(String? string, List<T> values) {
    return values.firstWhereOrNull((value) {
      return enumToClearString(value) == string || value.toString() == string;
    });
  }

  static String enumToClearString<T>(T value) {
    return value.toString().split('.').last;
  }
}

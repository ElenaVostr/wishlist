import 'enum_index_converter.dart';
import 'enum_string_utils.dart';

abstract final class JsonExt {
  static bool? getBool(dynamic value) {
    if (value is bool) {
      return value;
    } else if (value is int && (value == 0 || value == 1)) {
      return value == 1;
    } else if (value is String) {
      return bool.tryParse(value);
    } else {
      return null;
    }
  }

  static String? getString(dynamic value) {
    if (value is String) {
      return value;
    } else if (value is List<String>) {
      return value.join(', ');
    } else if (value != null) {
      return value.toString();
    } else {
      return null;
    }
  }

  static int? getInt(dynamic value) {
    if (value is String) {
      return int.tryParse(value);
    } else if (value is num) {
      return value.toInt();
    } else if (value is bool) {
      return value ? 1 : 0;
    } else {
      return null;
    }
  }

  static double? getDouble(dynamic value) {
    if (value is String) {
      return double.tryParse(value);
    } else if (value is num) {
      return value.toDouble();
    } else {
      return null;
    }
  }

  static (double, double?)? getPairedDouble(dynamic value) {
    if (value is String) {
      final first = double.tryParse(value);
      return first == null ? null : (first, null);
    } else if (value is num) {
      final first = value.toDouble();
      return (first, null);
    } else if (value is Iterable) {
      if (value.isEmpty) {
        return null;
      } else if (value.length == 1) {
        final first = getDouble(value.first);
        return first == null
            ? null
            : (
                first,
                null,
              );
      } else {
        final first = getDouble(value.first);
        final second = getDouble(value.toList()[1]);
        return first == null
            ? null
            : (
                first,
                second,
              );
      }
    } else {
      return null;
    }
  }

  static DateTime? getDateTime(dynamic value) {
    if (value is String) {
      return DateTime.tryParse(value);
    } else if (value is num) {
      return DateTime.fromMillisecondsSinceEpoch(value.toInt());
    } else if (value is DateTime) {
      return value;
    } else {
      return null;
    }
  }

  static T? getEnum<T extends Enum>(dynamic value, {required List<T> values}) {
    if (value is String) {
      return EnumStringUtils.enumFromString(value, values);
    } else if (value is num) {
      return EnumIndexConverter.enumFromIndex<T>(value.toInt(), values);
    } else if (value is T) {
      return value;
    } else {
      return null;
    }
  }

  static List<T> getList<T>(dynamic value,
      {required T Function(dynamic e) converter}) {
    if (value is List) {
      return value.map((e) => converter(e)).toList();
    } else if (value is Map) {
      return value.values.map((e) => converter(e)).toList();
    } else {
      return <T>[];
    }
  }
}

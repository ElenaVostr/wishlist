typedef WhereCondition<T> = bool Function(T element);

extension WhereOrNullExt<T> on Iterable<T> {
  T? firstWhereOrNull(WhereCondition<T> condition) {
    for (T element in this) {
      if (condition.call(element)) {
        return element;
      }
    }
    return null;
  }

  T? lastWhereOrNull(WhereCondition<T> condition) {
    T? match;

    for (T element in this) {
      if (condition.call(element)) {
        match = element;
      }
    }
    return match;
  }

  Iterable<T> whereNotNull() {
    return where((e) => e != null).cast<T>();
  }
}

extension ListExtensions<T> on List<T> {
  /// Конвертирует каждый элемент [T] и его индекс в значение [R]
  Iterable<R> mapIndexed<R>(R Function(int index, T element) convert) sync* {
    for (var index = 0; index < length; index++) {
      yield convert(index, this[index]);
    }
  }

  int? indexWhereOrNull(WhereCondition<T> condition) {
    final result = indexWhere(condition);
    if (result == -1) {
      return null;
    }
    return result;
  }
}

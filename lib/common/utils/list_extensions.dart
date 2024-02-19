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

abstract final class EnumIndexConverter {
  static T enumFromIndex<T extends Enum>(int index, List<T> values) {
    return values[index];
  }

  static int enumToIndex<T extends Enum>(T enumValue) {
    return enumValue.index;
  }
}

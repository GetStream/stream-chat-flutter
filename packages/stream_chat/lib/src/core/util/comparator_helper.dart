class ComparatorHelper {
  static int compareWithNull<T>(T? a, T? b, int direction) {
    return switch ((a != null, b != null)) {
      (true, false) => direction,
      (false, true) => 0 - direction,
      (false, false) => 0,
      (true, true) => direction > 0 ? compare(a, b) : 0 - compare(a, b),
    };
  }

  static int compare<T>(T a, T b) {
    if (a is Comparable<T>) return a.compareTo(b);
    if (a is DateTime && b is DateTime) {
      if (a.isBefore(b)) return -1;
      if (a.isAfter(b)) return 1;
      return 0;
    }

    return 0;
  }
}

// ignore_for_file: constant_identifier_names

enum TypeTransaction {
  PAIEMENT,
  SERVICE,
}

extension TypeTransactionExtension on TypeTransaction {
  static TypeTransaction? fromString(String? type) {
    for (final e in TypeTransaction.values) {
      if (e.toString().split('.').last == type) return e;
    }
    return null;
  }
}

extension SubstringGenerator on String {
  /// Generates all substrings of `this` string with a minimum length of 3.
  List<String> generateSubstringsWithMinLength3() {
    List<String> substrings = [];
    String input =
        this.toLowerCase(); // Convert to lowercase for case-insensitive search

    for (int i = 0; i < input.length; i++) {
      for (int j = i + 3; j <= input.length; j++) {
        // Start `j` from `i + 3` for min length of 3
        substrings.add(input.substring(i, j));
      }
    }

    return substrings.toSet().toList(); // Remove duplicates with Set
  }
}

typedef Validator = String? Function(String? value);

class Validators {
  /// Ensures the field isn’t empty.
  static Validator requiredField({String errorMessage = 'This field is required'}) {
    return (value) {
      if (value?.trim().isEmpty ?? true) {
        return errorMessage;
      }
      return null;
    };
  }

  /// Ensures the value is a positive integer.
  static Validator positiveInt({String errorMessage = 'Please enter a valid number'}) {
    return (value) {
      final n = int.tryParse(value?.trim() ?? '');
      if (n == null || n <= 0) {
        return errorMessage;
      }
      return null;
    };
  }
}

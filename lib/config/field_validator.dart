class Validator {
  static String? validateTitle({required String title}) {
    if (title.isEmpty) {
      return "Title cannot be empty";
    }
    return null;
  }

  static String? validateDescription({required String description}) {
    if (description.isEmpty) {
      return "Description cannot be empty";
    }
    return null;
  }
}

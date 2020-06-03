
enum FormType { login, register }

class Validators {
  static String notEmptyText(String value, {customMessage}) {
    if (value == null || value.trim().isEmpty) {
      return customMessage ?? 'هذا الحقل مطلوب';
    }
    return null;
  }

  static String notEmptyItemSelection(item, {customMessage}) {
    if (item == null) {
      return customMessage ?? 'حدد هذا الاختيار من فضلك';
    }
    return null;
  }

  static String notNullValue(value, {customMessage}) {
    if (value == null) {
      return customMessage ?? 'هذا الحقل مطلوب';
    }
    return null;
  }

  static String isValidEmail(String input) {
    final RegExp regex = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    if (!regex.hasMatch(input)) {
      return 'من فضلك أدخل البريد الإلكتروني بشكل صحيح';
    }

    return null;
  }

  static String valueNotLessZero(value) {
    if (value == null || value.toString().trim().isEmpty) {
      return 'هذا الحقل مطلوب';
    }
    if (double.parse(value) < 0) {
      return 'لا يجوز أن تكون بالسالب ';
    }
    return null;
  }
}

class EmailValidator {
  static String validate(String value) {
    return value.isEmpty ? "أدخل الإيميل بشكل صحيح" : null;
  }
}

class PasswordValidator {
  static String validate(String value) {
    return value.isEmpty ? "أدخل كلمة المرور" : null;
  }
}

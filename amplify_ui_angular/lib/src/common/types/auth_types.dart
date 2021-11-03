import 'package:meta/meta.dart';

/// TODO: This should be typed from core
class AuthState {
  final String value;

  const AuthState._(this.value);

  static const signIn = AuthState._('signIn');
  static const signOut = AuthState._('signOut');
  static const signedIn = AuthState._('signedIn');
}

class UsernameAlias {
  final String value;

  const UsernameAlias._(this.value);

  static const username = UsernameAlias._('username');
  static const email = UsernameAlias._('email');
  static const phoneNumber = UsernameAlias._('phone_number');
}

class AuthInputNames {
  final String value;

  const AuthInputNames._(this.value);

  static const username = AuthInputNames._('username');
  static const email = AuthInputNames._('email');
  static const phoneNumber = AuthInputNames._('phone_number');
  static const confirmationCode = AuthInputNames._('confirmation_code');
  static const password = AuthInputNames._('password');
}

@immutable
class InputAttributes {
  final String label;
  final String type;
  final String placeholder;

  const InputAttributes({
    required this.label,
    required this.type,
    required this.placeholder,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InputAttributes &&
          label == other.label &&
          type == other.type &&
          placeholder == other.placeholder;

  @override
  int get hashCode => Object.hash(label, type, placeholder);
}

typedef AuthInputAttributes = Map<AuthInputNames, InputAttributes>;

/// maps auth attribute to its respective labels and placeholder
typedef AttributeInfoProvider = AuthInputAttributes Function();

import 'package:angular/angular.dart';

/// Maps custom components from customer to the name of the component it's overriding.
typedef CustomComponents = Map<String, TemplateRef>;

typedef AuthFormData = Map<String, String>;

/// Contains properties to be passed to each auth subcomponents.
class PropContext {
  final SignInContext? signIn;
  final SignUpContext? signUp;
  final ConfirmSignUpContext? confirmSignUp;

  const PropContext({
    this.signIn,
    this.signUp,
    this.confirmSignUp,
  });

  PropContext copyWith({
    SignInContext? signIn,
    SignUpContext? signUp,
    ConfirmSignUpContext? confirmSignUp,
  }) {
    return PropContext(
      signIn: signIn ?? this.signIn,
      signUp: signUp ?? this.signUp,
      confirmSignUp: confirmSignUp ?? this.confirmSignUp,
    );
  }
}

class SignInContext {
  final Stream<AuthFormData> onSignInInput;
  final Stream<AuthFormData> onSignInSubmit;

  const SignInContext({
    required this.onSignInInput,
    required this.onSignInSubmit,
  });
}

class SignUpContext {
  final Stream<AuthFormData> onSignUpInput;
  final Stream<AuthFormData> onSignUpSubmit;

  const SignUpContext({
    required this.onSignUpInput,
    required this.onSignUpSubmit,
  });
}

class ConfirmSignUpContext {
  final Stream<AuthFormData> onConfirmSignUpInput;
  final Stream<AuthFormData> onConfirmSignUpSubmit;

  const ConfirmSignUpContext({
    required this.onConfirmSignUpInput,
    required this.onConfirmSignUpSubmit,
  });
}

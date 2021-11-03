import 'types/auth_types.dart';

final AuthInputAttributes authInputAttributes = {
  AuthInputNames.username: InputAttributes(
    label: 'Username',
    type: 'text',
    placeholder: 'Username',
  ),
  AuthInputNames.email: InputAttributes(
    label: 'Email',
    type: 'email',
    placeholder: 'Email',
  ),
  AuthInputNames.phoneNumber: InputAttributes(
    label: 'Phone Number',
    type: 'tel',
    placeholder: 'Phone',
  ),
  AuthInputNames.confirmationCode: InputAttributes(
    label: 'Confirmation Code',
    placeholder: 'Code',
    type: 'number',
  ),
  AuthInputNames.password: InputAttributes(
    label: 'Password',
    placeholder: 'Password',
    type: 'password',
  ),
};

AuthInputAttributes getAttributeMap() => authInputAttributes;

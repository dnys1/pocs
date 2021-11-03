import 'package:amplify_ui_angular/src/common/types/component_types.dart';
import 'package:angular/angular.dart';

@Injectable()
class AuthPropService {
  final CustomComponents _customComponents = {};
  CustomComponents get customComponents => _customComponents;
  set customComponents(CustomComponents customComponents) {
    _customComponents.addAll(customComponents);
  }

  PropContext _props = const PropContext();
  PropContext get props => _props;
  set props(PropContext propContext) {
    _props = _props.copyWith(
      signIn: propContext.signIn,
      signUp: propContext.signUp,
      confirmSignUp: propContext.confirmSignUp,
    );
  }
}

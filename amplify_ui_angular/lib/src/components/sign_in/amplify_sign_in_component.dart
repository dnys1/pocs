import 'dart:html';

import 'package:amplify_ui_angular/src/common/types/component_types.dart';
import 'package:amplify_ui_angular/src/services/authenticator_context.dart';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

@Component(
  selector: 'amplify-sign-in',
  templateUrl: 'amplify_sign_in_component.html',
  encapsulation: ViewEncapsulation.None,
  directives: [
    coreDirectives,
    formDirectives,
  ],
)
class AmplifySignInComponent implements AfterContentInit, OnInit, OnDestroy {
  @HostBinding('attr.data-amplify-authenticator-signin')
  String dataAttr = '';

  @Input()
  String headerText = 'Sign in to your account';

  CustomComponents customComponents = {};
  String remoteError = '';
  bool isPending = false;

  final String forgotPasswordText = 'Forgot your password? ';
  final String signInButtonText = 'Sign in';
  final String noAccountText = 'No account? ';

  final AuthPropService contextService;

  AmplifySignInComponent(
    this.contextService,
  );

  @override
  void ngAfterContentInit() {
    customComponents = contextService.customComponents;
  }

  @override
  void ngOnDestroy() {
    // TODO: implement ngOnDestroy
  }

  @override
  void ngOnInit() {
    // TODO: implement ngOnInit
  }

  void onInput(Event event) {
    event.preventDefault();
    var target = event.target as InputElement;
    var name = target.name;
    var value = target.value;
    // TODO
  }

  Future<void> onSubmit(Event event) async {
    event.preventDefault();
    // TODO
  }
}

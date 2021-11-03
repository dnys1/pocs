import 'package:angular/angular.dart';

@Directive(
  selector: '[amplifySlot]',
)
class AmplifySlotDirective {
  AmplifySlotDirective(this.template);

  final TemplateRef template;
  late String name;

  @Input()
  set amplifySlot(String component) {
    name = component;
  }
}

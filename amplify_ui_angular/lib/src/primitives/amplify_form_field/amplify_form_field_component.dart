import 'package:angular/angular.dart';

@Component(
  selector: 'amplify-form-field',
  templateUrl: 'amplify_form_field_component.html',
)
class AmplifyFormFieldComponent implements OnInit {
  @Input()
  late String name;

  @Input()
  late String type;

  @Input()
  bool required = true;

  @Input()
  String placeholder = '';

  @Input()
  String label = '';

  @Input()
  String initialValue = '';

  @Input()
  bool disabled = false;

  @Input()
  String autoComplete = '';

  String? defaultCountryCode;
  // TODO: List<String> countryDialCodes;

  @override
  void ngOnInit() {
    // TODO: implement ngOnInit
  }
}

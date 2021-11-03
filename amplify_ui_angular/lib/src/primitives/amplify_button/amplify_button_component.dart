import 'package:amplify_ui_angular/src/common/types/button_types.dart';
import 'package:angular/angular.dart';

@Component(
  selector: 'button[amplify-button]',
  templateUrl: 'amplify_button_component.html',
)
class AmplifyButtonComponent implements OnInit {
  AmplifyButtonType _type = AmplifyButtonType.button;
  String get type => _type.name;

  @Input()
  set type(String type) {
    _type = AmplifyButtonType.valueOf(type);
  }

  @Input()
  bool fullWidth = false;

  AmplifyButtonSize _size = AmplifyButtonSize.medium;
  String get size => _size.name;

  @Input()
  set size(String size) {
    _size = AmplifyButtonSize.valueOf(size);
  }

  AmplifyButtonVariation _variation = AmplifyButtonVariation.default$;
  String get variation => _variation.name;

  @Input()
  set variation(String variation) {
    _variation = AmplifyButtonVariation.valueOf(variation);
  }

  AmplifyButtonFontWeight _fontWeight = AmplifyButtonFontWeight.normal;
  String get fontWeight => _fontWeight.name;

  @Input()
  set fontWeight(String fontWeight) {
    _fontWeight = AmplifyButtonFontWeight.valueOf(fontWeight);
  }

  @HostBinding('type')
  late String typeAttr;

  @HostBinding('attr.data-fullwidth')
  late bool fullWidthAttr;

  @HostBinding('attr.data-size')
  late String sizeAttr;

  @HostBinding('attr.data-variation')
  late String variationAttr;

  @HostBinding('class.amplify-button')
  bool defaultClass = true;

  @HostBinding('style.font-weight')
  late String fontWeightAttr;

  @override
  void ngOnInit() {
    typeAttr = type;
    fullWidthAttr = fullWidth;
    sizeAttr = size;
    variationAttr = variation;
    fontWeightAttr = fontWeight;
  }
}

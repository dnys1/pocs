@TestOn('browser')

import 'package:amplify_ui_angular/src/primitives/amplify_button/amplify_button_component.dart';
import 'package:amplify_ui_angular/src/primitives/amplify_button/amplify_button_component.template.dart'
    as ng;
import 'package:angular/angular.dart';
import 'package:angular_test/angular_test.dart';
import 'package:pageloader/html.dart';
import 'package:test/test.dart';

import 'amplify_button_po.dart';

void main() {
  final testBed =
      NgTestBed<AmplifyButtonComponent>(ng.AmplifyButtonComponentNgFactory);
  late NgTestFixture<AmplifyButtonComponent> fixture;
  late AmplifyButtonPO po;

  setUp(() async {
    fixture = await testBed.create();
    final context =
        HtmlPageLoaderElement.createFromElement(fixture.rootElement);
    po = AmplifyButtonPO.create(context);
  });

  tearDown(disposeAnyRunningTest);

  test('Shows text', () {
    expect(fixture.text, '');
  });
}

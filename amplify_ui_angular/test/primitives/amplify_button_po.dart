import 'package:pageloader/pageloader.dart';

part 'amplify_button_po.g.dart';

@PageObject()
abstract class AmplifyButtonPO {
  const AmplifyButtonPO();
  factory AmplifyButtonPO.create(PageLoaderElement element) =
      $AmplifyButtonPO.create;
}

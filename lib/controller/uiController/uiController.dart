import 'package:get/get.dart';

class UiController extends GetxController {
  final _loginScreenTab = 0.obs;
  set loginScreenTab(value) => this._loginScreenTab.value = value;
  get loginScreenTab => this._loginScreenTab.value;
}

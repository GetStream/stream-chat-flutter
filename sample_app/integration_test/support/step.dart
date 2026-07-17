import '../allure/allure.dart';

/// Records a BDD step marker in the Allure report. Call it on its own line; the
/// statements that follow (up to the next [step]) are the step's body:
///
/// ```dart
/// step('GIVEN user opens the channel');
/// await env.userRobot.login().openChannel();
/// ```
void step(String description) => Allure.instance.beginStep(description);

import '../allure/allure.dart';

/// Records a BDD step marker in the Allure report.
void step(String description) => Allure.instance.beginStep(description);

import '../allure/allure.dart';

Future<T> step<T>(String description, Future<T> Function() body) => Allure.instance.step(description, body);

import 'package:md_framework/md_framework.dart';

class DoTransactionHandler {
  static MDResponse handle(MDResponse res) {
    switch (res.status) {
      case "200":
        return res;
      case "203":
        res.devError = res.message;
        res.message = "dsd";
        res.arError = "dss";
        return res;
      default:
        return res;
    }
  }
}

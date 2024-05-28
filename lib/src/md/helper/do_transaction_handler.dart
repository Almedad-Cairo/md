import 'package:md_framework/md_framework.dart';

class DoTransactionHandler {
  static MDResponse handle(
    MDResponse res, ) {
    switch (res.status) {
      case "200":
        return res;
      case "201":
        res.devError = res.message;
        res.message = "something went wrong please Try again later";
        res.arError = "حدث خطأ ما حاول مرة اخرى";
        return res;
      case "203":
        res.devError = res.message;
        res.message = "something went wrong please try again";
        res.arError = "حدث خطأ ما حاول مرة اخرى";
        return res;
      case "204":
        res.devError = res.message;
        res.message = "something went wrong please try again";
        res.arError = "حدث خطأ ما حاول مرة اخرى";
        return res;
      case "205":
        res.devError = res.message;
        res.message =res.devError!.split("for Table users")[0];
        res.arError = " اكبر من شروط متفق عليها${res.devError!.split("for Table users")[0]}هذا";
        return res;
      case "206":
        res.devError = res.message;
        res.message ="something went wrong please try again";
        res.arError = "حدث خطأ ما حاول مرة اخرى";
        return res;
      case "221":
        res.devError = res.message;
        res.message =
            "something went wrong please try again";
        res.arError = "حدث خطأ ما حاول مرة اخرى";
        return res;
      case "207":
        res.devError = res.message;
        res.message =
            res.devError!.split("For Table users , Column email")[0];
        res.arError = "  موجود من قبل${res.devError!.split("The Value")[1].split("Is Repeated")[0]}";
        return res;
      case "208":
        res.devError = res.message;
        res.message =res.devError!.split("the column ")[0];
        res.arError = "لا تتوافق مع الشروط${res.devError!.split("the column ")[0]}هذا";
        return res;
      case "209":
        res.devError = res.message;
        res.message =res.devError!.split("the column ")[0];
        res.arError = "لا تتوافق مع الشروط${res.devError!.split("the column ")[0]}هذا";
        return res;
      case "210":
        res.devError = res.message;
        res.message =res.devError!.split("the column ")[0];
        res.arError = "لا تتوافق مع القيمة${res.devError!.split("the column ")[0]}هذا";
        return res;
      case "217":
        res.devError = res.message;
        res.message = "something went wrong please try again";
        res.arError = "حدث خطأ حاول مرة اخرى";
        return res;
      case "214":
        res.devError = res.message;
        res.message = "something went wrong please try again";
        res.arError = "حدث خطأ حاول مرة اخرى";
        return res;
      default:
        return res;
    }
  }
}
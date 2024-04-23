class ApiConstants {
  ApiConstants();

  initialize(
      {required String apiToken,
      required String dataToken,
      required String encryptKey}) {
    this.apiToken = apiToken;
    this.dataToken = dataToken;
    this.encryptKey = encryptKey;
  }

  late final String apiToken;

  late final String dataToken;

  late String encryptKey;

  static const String apiBaseUrl =
      "https://framework.md-license.com:8093/emsserver.dll/ERPDatabaseWorkFunctions/";
  static const String sendNotificationUrl = "https://fcm.googleapis.com/fcm/";
  static const String sendNotification = "send";

  static const String doTransaction = "DoTransaction";
  static const String executeProcedure = "ExecuteProcedure";
  static const String doMultiTransaction = "DoMultiTransaction";
  static const String files = "UploadFileNew";
  static const String getFiles = "DownloadFileNew";
  static const String sendOtp = "RequireAuthentication";
  static const String verifyOtp = "ExecuteAuthentication";
}

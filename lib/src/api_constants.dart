class ApiConstants {
  ApiConstants();

  initialize(
      {required String apiToken,
      required String dataToken,
      required String encryptKey}) {
    apiToken = apiToken;
    dataToken = dataToken;
    encryptKey = encryptKey;
  }

  // get one instance of the class

  late final String apiToken;
  // "TTRreifoi&kah@hd\$ghrd24";
  late final String dataToken;
  // "Tasks";
  late String encryptKey;
  // = "RH@P\$%ss1966\$@ss";
  static const String fcmServerKey =
      "AAAAkzwIpuU:APA91bHVV5-_7ELs_t2DWxwajkCugP5j1_VlaXN8bWgHml4tPO5AMQEhF08uG-hRy3WcAYHywHETACY_V_cphZU9JKp8HoWny98COnh0kDndNXrcmFsR0vYMlRk78FrkBjbXo22MeAY5";

  static const String apiBaseUrl =
      "https://framework.md-license.com:8093/emsserver.dll/ERPDatabaseWorkFunctions/";
  static const String sendNotificationUrl = "https://fcm.googleapis.com/fcm/";
  static const String sendNotification = "send";

  static const String doTransaction = "DoTransaction";
  static const String executeProcedure = "ExecuteProcedure";
  static const String doMultiTransaction = "DoMultiTransaction";
  static const String files = "UploadFileNew";
  static const String getFiles = "DownloadFileNew";

  static const String login = "";
  static const String signup = "";

  ///Tables
  static const String userTable = "Ofp+k7AS7U9S9YaX81d0ng==";
  static const String companyStructure = "BgvDCp8zIGtP1IBQ7GoP6Q==";
  static const String employeeTable = "JpzjWnAp8WjlK4QK760mBw==";
  static const String addTasksProject = "GwDFesmn61OVq/APNbtKIw==";
  static const String addMissionProject = "U0VGoumERDWs/pl4CDUcDg==";
  static const String addEmployeeProject =
      "ZwITIRFZDKjIMMUtBsaVaCYQwoqThTWmH4tEbSfpr/U=";

  ///Procedures
  static const String loginUser = "9EKz+ckfFzCAT1iZ0GFG/A==";
  static const String payUser = "xPf6+3B/qCBzAWhkWL2EQw==";
  static const String playUser = "NTPpmGtwoKN3xy7OXS5MJmyIuEKvlAOg0ZcJIbPbw/A=";
  static const String getPermission = "xytEtidqnbOfnhzPZGnUBA==";
  static const String getCompanyStructure =
      "nNi2vCOgWmB+pQhp7o0kdbyMC6XCTTYT91MwVgontHo=";
  static const String getProjectDetails = "+QHo/8G/774tO70SnX0xKA==";
  static const String getProject = "umcO/93GYTH1eW1IBNpnJQ==";
  static const String getMission = "ePzdA8rI7mA8Wze6S/WrWQ==";
  static const String getUserInfo = "ySdolipMytG0eBZHNhCi1A==";
  static const String chatManger = "7fshA8FHKwC9UxkLKqVQ2g==";
  static const String changePass = "X/xoZyIRYe7z2OkRpVXoyg==";
  static const String getMessage = "MB+gfwIT8fOaUnEkcoJBmA==";
  static const String getAllEmployess = "FMK9APDItfWWF603Y31vSw==";
  static const String getEmployeeData = "c7xYM5+2uXMZApC9e1wV3A==";
}

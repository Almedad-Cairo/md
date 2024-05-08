import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../api_constants.dart';
import '../md/data/models/request/md_request_model.dart';
import '../md/data/models/response/md_response_model.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
  abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST(ApiConstants.executeProcedure)
  Future<MDResponse> executeProcedure(
    @Body() MDRequest mdRequest,
  );

  @POST(ApiConstants.doTransaction)
  Future<MDResponse> doTransaction(
    @Body() MDRequest mdRequest,
  );

  @POST(ApiConstants.doMultiTransaction)
  Future<MDResponse> doMultiTransaction(
    @Body() MDRequest mdRequest,
  );

  @POST(ApiConstants.files)
  Future<MDResponse> uploadFile(
    @Body() MDRequest mdRequest,
  );

  @POST(ApiConstants.getFiles)
  Future<MDResponse> downloadFile(
    @Body() MDRequest mdRequest,
  );
  @POST(ApiConstants.sendOtp)
  Future<MDResponse> sendOTP(
    @Body() MDRequest mdRequest,
  );

  @POST(ApiConstants.verifyOtp)
  Future<MDResponse> verifyOTP(
    @Body() MDRequest mdRequest,
  );

  @POST(ApiConstants.sendNotification)
  Future sendNotification(
      @Body() Map<String, dynamic> data,
      @Header('Authorization') String token,
      @Header('Content-Type') String contentType);
}

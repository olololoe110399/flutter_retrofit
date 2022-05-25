import 'package:provider_sample/models/user.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: 'https://626960fbaa65b5d23e83e7a8.mockapi.io/api/1')
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("/users")
  Future<List<User>> getUsers();

  @POST("/users")
  Future<User> addUser(@Body() User user);

  @PUT("/users/{id}")
  Future<User> updateUser(
    @Path() String id,
    @Body() User user,
  );

  @GET("/users/{id}")
  Future<User> getUserDetail(@Path() String id);
}

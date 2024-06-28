import 'dart:convert';
import 'dart:io';

import 'package:flexivity/data/globals.dart';
import 'package:flexivity/data/models/credentials.dart';
import 'package:flexivity/data/models/errors/api_authentication_exception.dart';
import 'package:flexivity/data/models/errors/api_disconnected_exception.dart';
import 'package:flexivity/data/models/errors/http_api_exception.dart';
import 'package:flexivity/data/models/responses/error_response.dart';
import 'package:flexivity/data/remote/base/web_api.dart';
import 'package:http/http.dart';

const _httpString = 'http';
const socketExceptionText =
    'An issue occurred while connecting. Please check your connection!';

class HttpApi extends WebApi {
  final Client _client;
  Credentials? credentials;

  HttpApi(this._client, this.credentials);

  /// Sends a get request to the back-end
  Future<Response> get(
    String path, {
    Map<String, String>? headers,
  }) async {
    headers ??= {};
    final request = Request('get', this.getUri(path));

    // Finalize and send the request
    this._addDefaultHeaders(request.headers);
    this._addCredentialsIfPresent(headers);
    request.headers.addAll(headers);
    return this._handleResponse(await this.sendRequest(request));
  }

  /// Sends a post request to the back-end
  Future<Response> post(
    String path, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    headers ??= {};
    final request = Request('post', this.getUri(path));

    if (body != null) {
      this._addContentTypeJsonIfAbsent(headers);
      request.body = jsonEncode(body);
    }

    // Finalize and send the request
    this._addDefaultHeaders(request.headers);
    this._addCredentialsIfPresent(headers);
    request.headers.addAll(headers);
    return this._handleResponse(await this.sendRequest(request));
  }

  /// Sends a put request to the back-end
  Future<Response> put(
    String path, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    headers ??= {};
    final request = Request('put', this.getUri(path));

    if (body != null) {
      this._addContentTypeJsonIfAbsent(headers);
      request.body = jsonEncode(body);
    }

    // Finalize and send the request
    this._addDefaultHeaders(request.headers);
    this._addCredentialsIfPresent(headers);
    request.headers.addAll(headers);
    return this._handleResponse(await this.sendRequest(request));
  }

  /// Sends a put request to the back-end
  Future<Response> patch(
    String path, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    headers ??= {};
    final request = Request('patch', this.getUri(path));

    if (body != null) {
      this._addContentTypeJsonIfAbsent(headers);
      request.body = jsonEncode(body);
    }

    // Finalize and send the request
    this._addDefaultHeaders(request.headers);
    this._addCredentialsIfPresent(headers);
    request.headers.addAll(headers);
    return this._handleResponse(await this.sendRequest(request));
  }

  /// Sends a delete request to the back-end
  Future<Response> delete(
    String path, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    headers ??= {};
    final request = Request('delete', this.getUri(path));

    if (body != null) {
      this._addContentTypeJsonIfAbsent(headers);
      request.body = jsonEncode(body);
    }

    // Finalize and send the request
    this._addDefaultHeaders(request.headers);
    this._addCredentialsIfPresent(headers);
    request.headers.addAll(headers);
    return this._handleResponse(await this.sendRequest(request));
  }

  Future<Response> sendRequest(Request request) async {
    try {
      return Response.fromStream(await this._client.send(request));
    } on SocketException {
      return Future.error(
        const ApiDisconnectedException(socketExceptionText),
      );
    }
  }

  /// Refreshed the token
  Future<Credentials> refreshToken() async {
    final request = Request('post', this.getUri('api/v1/auth/refresh'));

    this._addContentTypeJsonIfAbsent(request.headers);
    request.body = jsonEncode({'token': credentials!.refreshToken});

    final response = await this.sendRequest(request);

    // If the request has failed throw an authentication exception
    if (response.statusCode != HttpStatus.ok) {
      return Future.error(const ApiAuthenticationException(
        'Something went wrong refreshing the token',
      ));
    }

    // Return a new credentials object
    dynamic json = jsonDecode(response.body);
    return Credentials(
      this.credentials!.userId,
      json['accessToken'],
      json['refreshToken'],
    );
  }

  /// Adds the credentials header to the
  void _addCredentialsIfPresent(Map<String, String> headers) {
    if (this.credentials != null) {
      headers.putIfAbsent(
        HttpHeaders.authorizationHeader,
        () => 'Bearer ${this.credentials!.accessToken}',
      );
    }
  }

  /// Sets the Content-Type header to application/json when
  /// no Content-Type header is given
  void _addContentTypeJsonIfAbsent(Map<String, String> headers) {
    headers.putIfAbsent(
      HttpHeaders.contentTypeHeader,
      () => ContentType.json.value,
    );
  }

  /// Sets the default request headers
  void _addDefaultHeaders(Map<String, String> headers) {
    headers.putIfAbsent(
      HttpHeaders.acceptHeader,
      () => ContentType.json.value,
    );
  }

  /// Copies the given request
  Request _copyRequest(Request frozenRequest) {
    final newRequest = Request(frozenRequest.method, frozenRequest.url);
    newRequest.headers.addAll(frozenRequest.headers);
    newRequest.followRedirects = frozenRequest.followRedirects;
    newRequest.maxRedirects = frozenRequest.maxRedirects;
    newRequest.persistentConnection = frozenRequest.persistentConnection;
    newRequest.body = frozenRequest.body;
    return newRequest;
  }

  /// Generic response handler
  Future<Response> _handleResponse(Response response) async {
    if (response.statusCode == HttpStatus.unauthorized) {
      if (jsonDecode(response.body)['message'] == 'Token expired') {
        this.credentials = await this.refreshToken();
        Globals.credentials = this.credentials;

        return this._handleResponse(
          await this.sendRequest(
            this._copyRequest(response.request as Request),
          ),
        );
      } else {
        return Future.error(
          const ApiAuthenticationException('Invalid session'),
        );
      }
    }

    if (response.statusCode == HttpStatus.forbidden) {
      return Future.error(
        this.createHttpException(response, 'The request was forbidden'),
      );
    }

    return response;
  }

  /// Creates a new HTTP exception
  HttpApiException createHttpException(Response response, String defaultError) {
    if (response.body.isEmpty) {
      return HttpApiException(defaultError, response.statusCode);
    }
    // Decode and show error response
    try {
      final error = ErrorResponse.fromJson(jsonDecode(response.body));
      return HttpApiException(error.message, response.statusCode);
    } catch (e) {
      return HttpApiException(defaultError, response.statusCode);
    }
  }

  /// Creates a URI based on the given path
  Uri getUri(String path) {
    return Uri.parse('$_httpString://${super.getUrl()}/$path');
  }
}

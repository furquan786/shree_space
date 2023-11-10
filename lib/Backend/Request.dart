import 'package:http/http.dart' as http;

class Request {
  final String url;
  final dynamic body;
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  Request({this.url = "", this.body});

  Future<http.Response> post() {
    print(url);
    print(body);
    print(headers);
    return http
        .post(Uri.parse(url), headers: headers, body: body)
        .timeout(Duration(minutes: 2));
  }

  Future<http.Response> put() {
    print(url);
    print(body);
    print(headers);
    return http
        .put(Uri.parse(url), headers: headers, body: body)
        .timeout(Duration(minutes: 2));
  }

  Future<http.Response> get() {
    print(url);
    print(body);
    print(headers);
    return http
        .get(Uri.parse(url), headers: headers)
        .timeout(Duration(minutes: 2));
  }

  Future<http.Response> data() {
    print(url);
    print(body);
    Map<String, String> headersData = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    return http
        .get(Uri.parse(url), headers: headersData)
        .timeout(Duration(minutes: 2));
  }

  Future<http.Response> getData() {
    print("::::::::::::::::::::::::::::::::::::::::::::::::");

    Map<String, String> headerData = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    print(url);
    print(headerData);
    print("::::::::::::::::::::::::::::::::::::::::::::::::");
    return http
        .get(Uri.parse(url), headers: headerData)
        .timeout(Duration(minutes: 2));
  }
}

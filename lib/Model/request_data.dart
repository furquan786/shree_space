class RequestData {
  int status;
  var result;
  String msg;

  RequestData(
      {this.msg = "Somthing went wrong Please try again",
      this.status = 0,
      this.result});

  factory RequestData.fromJson(var json) {
    return RequestData(
      status: json["status"],
      result: json["result"],
      msg: json["msg"],
    );
  }
}

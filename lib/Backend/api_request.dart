import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shreegraphic/Backend/urls.dart';

import '../Model/request_data.dart';

class API {
  static var dio = Dio();
  static var url =
      Uri.parse('http://ramcashncarry.co.uk/webservices/api/category');

  static Future<RequestData> signUpApi(
    String gender,
    String name,
    // String second_name,
    String nick_name,
    String mobile,
    String alt_mobile,
    String dob,
    String work_profile,
    String address,
    String state,
    String city,
    // String area,
    String village,
    String city_pin,
    String email,
  ) async {
    try {
      print({
        "gender": gender,
        "name": name,
        // "second_name": second_name,
        "nick_name": nick_name,
        "mobile": mobile,
        "alt_mobile": alt_mobile,
        "dob": dob,
        "work_profile": work_profile,
        "address": address,
        "state": state,
        "city": city,
        //   "area": area,
        "village": village,
        "city_pin": city_pin,
        "email": email
      });
      final response = await dio.post(add_member,
          data: json.encode({
            "gender": gender,
            "name": name,
            //  "second_name": second_name,
            "nick_name": nick_name,
            "mobile": mobile,
            "alt_mobile": alt_mobile,
            "dob": dob,
            "work_profile": work_profile,
            "address": address,
            "state": state,
            "city": city,
            // "area": area,
            "village": village,
            "city_pin": city_pin,
            "email": email
          }));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else
        return RequestData();
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> custmersignUpApi(
    String name,
    String last_name,
    String mobile,
    String address,
    String state,
    String city,
    String city_pin,
    String email,
    String password,
  ) async {
    try {
      print({
        "name": name,
        "last_name": last_name,
        "mobile": mobile,
        "address": address,
        "state": state,
        "city": city,
        "city_pin": city_pin,
        "email": email,
        "password": password
      });
      final response = await dio.post(add_customere,
          data: json.encode({
            "name": name,
            "last_name": last_name,
            "mobile": mobile,
            "address": address,
            "state": state,
            "city": city,
            "city_pin": city_pin,
            "email": email,
            "password": password
          }));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else
        return RequestData();
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> demoApi(
    String gender,
    String name,
    //String second_name,
    String mobile,
    String password,
    String stud_name,
    String state,
    String city,
    //  String area,
    String village,
    String city_pin,
  ) async {
    try {
      print({
        "gender": gender,
        "name": name,
        // "second_name": second_name,
        "mobile": mobile,
        "password": password,
        "stud_name": stud_name,
        "state": state,
        "city": city,
        // "area": area,
        "village": village,
        "city_pin": city_pin,
      });
      final response = await dio.post(demo_apply,
          data: json.encode({
            "gender": gender,
            "name": name,
            // "second_name": second_name,
            "mobile": mobile,
            "password": password,
            "stud_name": stud_name,
            "state": state,
            "city": city,
            // "area": area,
            "village": village,
            "city_pin": city_pin,
          }));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else
        return RequestData();
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> verifyApi(String mo) async {
    try {
      print({"mo": mo});
      final response = await dio.post(m_verifyw, data: json.encode({"mo": mo}));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else
        return RequestData();
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> customerverifyApi(String mo) async {
    try {
      print({"mo": mo});
      final response =
          await dio.post(customre_otp_verifyw, data: json.encode({"mo": mo}));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else
        return RequestData();
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> getSubscriptionDateApi(String id) async {
    try {
      print({"id": id});
      final response =
          await dio.post(memb_sub_end, data: json.encode({"id": id}));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else
        return RequestData();
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> getInvoiceList(String mem_id) async {
    try {
      print({"mem_id": mem_id});
      final response =
          await dio.post(invoice_list, data: json.encode({"mem_id": mem_id}));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else
        return RequestData();
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> getPaymentReceiptList(String mem_id) async {
    try {
      print({"mem_id": mem_id});
      final response =
          await dio.post(receipt_list, data: json.encode({"mem_id": mem_id}));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else
        return RequestData();
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> forgotPasswordApi(String mno) async {
    try {
      print({"mobile": mno});
      final response =
          await dio.post(forget_pass, data: json.encode({"mobile": mno}));
      print(response.data);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else
        return RequestData();
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> demoverifyApi(String mo) async {
    try {
      print({"mo": mo});
      final response =
          await dio.post(demo_otp_verifyw, data: json.encode({"mo": mo}));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else
        return RequestData();
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> updateTokenApi(String mobile, String token) async {
    try {
      print({"mobile": mobile, "token": token});
      final response = await dio.post(m_update_token,
          data: json.encode({"mobile": mobile, "token": token}));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else
        return RequestData();
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> bankdetailApi(
    String ac_type,
    String ac_no,
    String ifsc,
    String mobile,
  ) async {
    try {
      print({
        "ac_type": ac_type,
        "ac_no": ac_no,
        "ifsc": ifsc,
        "mobile": mobile,
      });
      final response = await dio.post(add_bankdetail,
          data: json.encode({
            "ac_type": ac_type,
            "ac_no": ac_no,
            "ifsc": ifsc,
            "mobile": mobile,
          }));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else
        return RequestData();
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> addpasswordApi(
    String mobile,
    String password,
  ) async {
    try {
      print({
        "mobile": mobile,
        "password": password,
      });
      final response = await dio.post(add_password,
          data: json.encode({
            "mobile": mobile,
            "password": password,
          }));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else
        return RequestData();
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> addplanApi(
    String mobile,
    String plan,
  ) async {
    try {
      print({
        "mobile": mobile,
        "plan": plan,
      });
      final response = await dio.post(add_my_plan,
          data: json.encode({
            "mobile": mobile,
            "plan": plan,
          }));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else
        return RequestData();
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> loginApi(String mobile, String password) async {
    try {
      print({
        "mobile": mobile,
        "password": password,
      });
      final response = await dio.post(m_login,
          data: json.encode({"mobile": mobile, "password": password}));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else
        return RequestData();
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> customerloginApi(
      String mobile, String password) async {
    try {
      print({
        "mobile": mobile,
        "password": password,
      });
      final response = await dio.post(new_login_cust,
          data: json.encode({"mobile": mobile, "password": password}));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else
        return RequestData();
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> labloginApi(String mobile, String password) async {
    try {
      print({
        "mobile": mobile,
        "password": password,
      });
      final response = await dio.post(lab_login,
          data: json.encode({"mobile": mobile, "password": password}));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else
        return RequestData();
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> buttoncolorList() async {
    try {
      var response = await dio.get(button_color_get);
      print(response);
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> buttontextcolorList() async {
    try {
      var response = await dio.get(button_tcolor_get);
      print(response);
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> termsList() async {
    try {
      var response = await dio.get(team_contion);
      print(response);
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> categorySelectListAPI() async {
    try {
      var response = await dio.get(Buysell_category);
      print(response);
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> unitListListAPI() async {
    try {
      var response = await dio.get(unit_list);
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> phoneBookStateListAPI() async {
    try {
      var response = await dio.get(Phonebook_state);
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> phoneBookDistrictListAPI(String id) async {
    try {
      print(id);
      var response = await dio.post(Phonebook_district,
          data: json.encode({"state_id": id}));

      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> phoneBookTalukaListAPI(String id) async {
    try {
      print(id);
      var response = await dio.post(Phonebook_taluka,
          data: json.encode({"district_id": id}));

      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> buysellpopupmsgList(String lang) async {
    try {
      final response = await dio.post(buysell_message_popup,
          data: json.encode({"lang": lang}));
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> addSellAPI(Map<String, dynamic> map) async {
    try {
      FormData formData = FormData.fromMap(map);
      var response = await dio.post(Sell_product, data: formData);
      print("response $response");
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> addharpanAPI(Map<String, dynamic> map) async {
    try {
      FormData formData = new FormData.fromMap(map);
      var response = await dio.post(adhar_pan_add, data: formData);
      print("response $response");
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> profileupdateAPI(Map<String, dynamic> map) async {
    try {
      FormData formData = new FormData.fromMap(map);
      var response = await dio.post(full_profile_update, data: formData);
      print("response $response");
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> instruaddAPI(Map<String, dynamic> map) async {
    try {
      FormData formData = new FormData.fromMap(map);
      var response = await dio.post(instru_add, data: formData);
      print("response $response");
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> itraddAPI(Map<String, dynamic> map) async {
    try {
      FormData formData = new FormData.fromMap(map);
      var response = await dio.post(add_itr, data: formData);
      print("response $response");
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> customerIMGUploadAPI(
      Map<String, dynamic> map) async {
    try {
      FormData formData = new FormData.fromMap(map);
      var response = await dio.post(customer_image_upload, data: formData);
      print("response $response");
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> addlocationforshootAPI(
      Map<String, dynamic> map) async {
    try {
      FormData formData = new FormData.fromMap(map);
      var response = await dio.post(add_location, data: formData);
      print("response $response");
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> updatelocationforshootAPI(
      Map<String, dynamic> map) async {
    try {
      FormData formData = new FormData.fromMap(map);
      var response = await dio.post(edit_location, data: formData);
      print("response $response");
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> propicAPI(Map<String, dynamic> map) async {
    try {
      FormData formData = new FormData.fromMap(map);
      var response = await dio.post(update_propic_m, data: formData);
      print("response $response");
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> qutationaddAPI(Map<String, dynamic> map) async {
    try {
      FormData formData = new FormData.fromMap(map);
      var response = await dio.post(quotation_new, data: formData);
      print("response $response");
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> qutationeditAPI(Map<String, dynamic> map) async {
    try {
      FormData formData = new FormData.fromMap(map);
      var response = await dio.post(quotation_new_edit, data: formData);
      print("response $response");
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> invoiceDetailApi(String id) async {
    try {
      print({"id": id});
      final response =
          await dio.post(get_inv_detail, data: json.encode({"id": id}));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else
        return RequestData();
    } catch (e) {
      print(e);
      if (e is DioError) {
        print(e);
        return RequestData();
      } else {
        print(e);
        return RequestData();
      }
    }
  }

  static Future<RequestData> qutationinvoiceAPI(
      Map<String, dynamic> map) async {
    try {
      FormData formData = new FormData.fromMap(map);
      var response = await dio.post(invoice_add, data: formData);
      print("response $response");
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> getPaymentTotal(String id) async {
    try {
      print({"id": id});

      var response =
          await dio.post(get_payment_total, data: json.encode({"id": id}));
      print(response);
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      if (e is DioError) {
        print(e);
        return RequestData();
      } else {
        print(e);
        return RequestData();
      }
    }
  }

  static Future<RequestData> getInoiceTotal(String id) async {
    try {
      print({"id": id});

      var response =
          await dio.post(get_invoice_total, data: json.encode({"id": id}));
      print(response);
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      if (e is DioError) {
        print(e);
        return RequestData();
      } else {
        print(e);
        return RequestData();
      }
    }
  }

  static Future<RequestData> addInvoiceDirectAPI(
      Map<String, dynamic> map) async {
    try {
      FormData formData = new FormData.fromMap(map);
      var response = await dio.post(invoice_add_direct, data: formData);
      print("response $response");
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> getTermsAndCondt(String id) async {
    try {
      var response =
          await dio.post(terms_cond_memb, data: json.encode({"id": id}));
      print(response);

      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> updateTermsAndCondt(
      String id, String terms) async {
    print({"id": id, "terms": terms});
    try {
      var response = await dio.post(add_terms_acount,
          data: json.encode({"id": id, "terms": terms}));
      print(response);

      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> paymentReceiptApi(Map<String, dynamic> map) async {
    try {
      FormData formData = new FormData.fromMap(map);
      var response = await dio.post(receipt_add, data: formData);
      print("response $response");
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> buysellList() async {
    try {
      var response = await dio.get(sell_list);
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> rentbuysellList() async {
    try {
      var response = await dio.get(rent_list);
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> notificationList(String mobile) async {
    try {
      var response = await dio.post(get_my_notification_list,
          data: json.encode({"mobile": mobile}));
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> scheduleList(String member_id) async {
    try {
      final response = await dio.post(schedule_list,
          data: json.encode({"member_id": member_id}));
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> scheduleHomeList(String member_id) async {
    try {
      final response = await dio.post(schedule_list_hm,
          data: json.encode({"member_id": member_id}));
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> workprofileimageList(
      String mem_id, String mobile) async {
    try {
      final response = await dio.post(work_profile_image_list,
          data: json.encode({"mem_id": mem_id, "mobile": mobile}));
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> workprofilevideoList(
      String mem_id, String mobile) async {
    try {
      final response = await dio.post(work_profile_video_list,
          data: json.encode({"mem_id": mem_id, "mobile": mobile}));
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> storageCount(String user_id) async {
    try {
      final response =
          await dio.post(my_count, data: json.encode({"user_id": user_id}));
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> buysellCategorySearchList(String search) async {
    try {
      final response = await dio.post(buysell_catsearch,
          data: json.encode({"search": search}));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else {
        return RequestData();
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> mybuysellList(String user_id) async {
    print({"user_id": user_id});
    try {
      final response =
          await dio.post(my_sell, data: json.encode({"user_id": user_id}));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else {
        return RequestData();
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> buysellSearchList(String search) async {
    try {
      final response =
          await dio.post(buysell_search, data: json.encode({"search": search}));

      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else {
        return RequestData();
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> rentbuysellSearchList(String search) async {
    try {
      final response = await dio.post(buysell_search_rent,
          data: json.encode({"search": search}));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else {
        return RequestData();
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> buysellCategoryDetailList(String id) async {
    try {
      final response = await dio.post(category_listbuysell,
          data: json.encode({"cat_id": id}));

      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else {
        return RequestData();
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> rentbuysellCategoryDetailList(String id) async {
    try {
      final response = await dio.post(rent_category_listbuysell,
          data: json.encode({"cat_id": id}));

      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else {
        return RequestData();
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> buysellwhatsappmsgList(String lang) async {
    try {
      final response = await dio.post(buysell_message_get,
          data: json.encode({"lang": lang}));
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> buysellDetail(String id) async {
    print({"id": id});
    try {
      final response =
          await dio.post(sell_detail, data: json.encode({"id": id}));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else {
        return RequestData();
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> buysharecount(String id) async {
    print({"id": id});
    try {
      final response =
          await dio.post(buy_share_count, data: json.encode({"id": id}));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else {
        return RequestData();
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> buysellinstructmsgList(String lang) async {
    try {
      final response = await dio.post(buysell_message_instru,
          data: json.encode({"lang": lang}));
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> sellout(
    String user_id,
    String post_id,
    String sold,
    String avail,
  ) async {
    print({
      "user_id": user_id,
      "post_id": post_id,
      "sold": sold,
      "avail": avail,
    });
    try {
      final response = await dio.post(sell_out,
          data: json.encode({
            "user_id": user_id,
            "post_id": post_id,
            "sold": sold,
            "avail": avail,
          }));

      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else {
        return RequestData();
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> addMOrderApi(
    String sell_id,
    String buy_id,
    String product_id,
    String product_name,
    String price,
    String qty,
    String total,
    String ship_add,
    String pincode,
    String status,
  ) async {
    print({
      "sell_id": sell_id,
      "buy_id": buy_id,
      "product_id": product_id,
      "product_name": product_name,
      "price": price,
      "qty": qty,
      "total": total,
      "ship_add": ship_add,
      "pincode": pincode,
      "status": status,
    });
    try {
      final response = await dio.post(add_m_order,
          data: json.encode({
            "sell_id": sell_id,
            "buy_id": buy_id,
            "product_id": product_id,
            "product_name": product_name,
            "price": price,
            "qty": qty,
            "total": total,
            "ship_add": ship_add,
            "pincode": pincode,
            "status": status,
          }));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else {
        return RequestData();
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> addMRentOrderApi(
    String sell_id,
    String buy_id,
    String product_id,
    String product_name,
    String from_date,
    String to_date,
    String price,
    String qty,
    String total,
    String ship_add,
    String pincode,
  ) async {
    print({
      "sell_id": sell_id,
      "buy_id": buy_id,
      "product_id": product_id,
      "product_name": product_name,
      "from_date": from_date,
      "to_date": to_date,
      "price": price,
      "qty": qty,
      "total": total,
      "ship_add": ship_add,
      "pincode": pincode,
    });
    try {
      final response = await dio.post(add_m_rent_order,
          data: json.encode({
            "sell_id": sell_id,
            "buy_id": buy_id,
            "product_id": product_id,
            "product_name": product_name,
            "from_date": from_date,
            "to_date": to_date,
            "price": price,
            "qty": qty,
            "total": total,
            "ship_add": ship_add,
            "pincode": pincode,
          }));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else {
        return RequestData();
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> addEditSellAPI(Map<String, dynamic> map) async {
    try {
      FormData formData = new FormData.fromMap(map);
      var response = await dio.post(my_post_edit, data: formData);
      print("response $response");
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> buysellCategoryList() async {
    try {
      var response = await dio.get(buysell_category);
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> rentbuysellCategoryList() async {
    try {
      var response = await dio.get(rent_buysell_category);
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> myorderHistoryList(String buy_id) async {
    try {
      final response =
          await dio.post(my_m_buy_order, data: json.encode({"buy_id": buy_id}));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else {
        return RequestData();
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> myorderRentHistoryList(String buy_id) async {
    try {
      final response = await dio.post(my_m_buy_order_rent,
          data: json.encode({"buy_id": buy_id}));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else {
        return RequestData();
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> myordersellHistoryList(String sell_id) async {
    try {
      final response = await dio.post(my_m_sell_order,
          data: json.encode({"sell_id": sell_id}));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else {
        return RequestData();
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> myordersellHistoryDetailList(
      String order_id) async {
    try {
      final response = await dio.post(my_m_order_detail,
          data: json.encode({"order_id": order_id}));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else {
        return RequestData();
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> myorderRentHistoryDetailList(
      String order_id) async {
    try {
      final response = await dio.post(my_m_order_detail_rent,
          data: json.encode({"order_id": order_id}));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else {
        return RequestData();
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> annuoncementHistoryDetailList(
      String anno_id) async {
    try {
      final response = await dio.post(announcement_detail,
          data: json.encode({"anno_id": anno_id}));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else {
        return RequestData();
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  /*static Future<RequestData> quotationHistoryDetailList(
      String q_id) async {
    try {
      final response = await dio.post(membar_quatation_detail,
          data: json.encode({"q_id": q_id}));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else {
        return RequestData();
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }*/
  static Future<RequestData> quotationHistoryDetailList(String id) async {
    try {
      final response =
          await dio.post(get_qot_detail, data: json.encode({"id": id}));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else {
        return RequestData();
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> quotationItemDetailList(String id) async {
    try {
      final response =
          await dio.post(get_qot_itemlist, data: json.encode({"id": id}));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else {
        return RequestData();
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> billingHistoryDetailList(String b_id) async {
    try {
      final response =
          await dio.post(bill_detail, data: json.encode({"b_id": b_id}));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else {
        return RequestData();
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> transactionList(String bill_id) async {
    try {
      final response = await dio.post(transection_list,
          data: json.encode({"bill_id": bill_id}));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else {
        return RequestData();
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> locationDetailList(String location_id) async {
    try {
      final response = await dio.post(get_mylocatoin_detail,
          data: json.encode({"location_id": location_id}));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else {
        return RequestData();
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> paidlocationDetailList(String location_id) async {
    try {
      final response = await dio.post(get_locatoin_paid_detail,
          data: json.encode({"location_id": location_id}));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else {
        return RequestData();
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> itrList(String mem_id) async {
    try {
      final response = await dio.post(get_my_itr_list,
          data: json.encode({"mem_id": mem_id}));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else {
        return RequestData();
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> bookingsList(String user_id) async {
    try {
      final response = await dio.post(my_booking_list,
          data: json.encode({"user_id": user_id}));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else {
        return RequestData();
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> bookingsHomeList(String user_id) async {
    try {
      final response = await dio.post(my_booking_list_hm,
          data: json.encode({"user_id": user_id}));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else {
        return RequestData();
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> quotationList(String mem_id) async {
    try {
      final response = await dio.post(membar_quatation_list,
          data: json.encode({"mem_id": mem_id}));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else {
        return RequestData();
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> custbillingList(String cust_uniq_code) async {
    try {
      final response = await dio.post(cust_history_bill_list,
          data: json.encode({"cust_uniq_code": cust_uniq_code}));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else {
        return RequestData();
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> billingList(String mem_id) async {
    try {
      final response = await dio.post(membar_history_bill_list,
          data: json.encode({"mem_id": mem_id}));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else {
        return RequestData();
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> ongoningBillingList(String mem_id) async {
    try {
      final response = await dio.post(membar_ongoing_bill_list,
          data: json.encode({"mem_id": mem_id}));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else {
        return RequestData();
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> custongoningBillingList(
      String cust_uniq_code) async {
    try {
      final response = await dio.post(cust_ongoing_bill_list,
          data: json.encode({"cust_uniq_code": cust_uniq_code}));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else {
        return RequestData();
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> custoquotationList(String cust_uniq_code) async {
    try {
      final response = await dio.post(cust_quatation_list,
          data: json.encode({"cust_uniq_code": cust_uniq_code}));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else {
        return RequestData();
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> labcountList(String lab_id) async {
    try {
      final response =
          await dio.post(my_lab_cout, data: json.encode({"lab_id": lab_id}));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else {
        return RequestData();
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> elearningVideoList(String cat_id) async {
    try {
      final response = await dio.post(video_list_of_category,
          data: json.encode({"cat_id": cat_id}));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else {
        return RequestData();
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> myordersellRentHistoryList(String sell_id) async {
    try {
      final response = await dio.post(my_m_sell_order_rent,
          data: json.encode({"sell_id": sell_id}));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else {
        return RequestData();
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> announcementList(String work_profile) async {
    try {
      final response = await dio.post(announcement_list,
          data: json.encode({"work_profile": work_profile}));
      print(response);
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> bookingdetailList(String id) async {
    try {
      final response =
          await dio.post(booking_detail, data: json.encode({"id": id}));
      print(response);
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> exposingRequestList(String id) async {
    try {
      final response =
          await dio.post(exposing_req, data: json.encode({"id": id}));
      print(response);
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> acceptExposingRequest(String id) async {
    try {
      final response =
          await dio.post(exposing_accept, data: json.encode({"id": id}));
      print(response);
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> rejectExposingRequest(String id) async {
    try {
      final response =
          await dio.post(exposing_reject, data: json.encode({"id": id}));
      print(response);
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> addscheduleApi(
      String member_id,
      String member_name,
      String title,
      String anno_desc,
      String date_time,
      String end_date_time,
      String location) async {
    try {
      print({
        "member_id": member_id,
        "member_name": member_name,
        "title": title,
        "anno_desc": anno_desc,
        "date_time": date_time,
        "end_date_time": end_date_time,
        "location": location,
      });
      final response = await dio.post(add_schedule,
          data: json.encode({
            "member_id": member_id,
            "member_name": member_name,
            "title": title,
            "anno_desc": anno_desc,
            "date_time": date_time,
            "end_date_time": end_date_time,
            "location": location,
          }));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else
        return RequestData();
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> stateListAPI() async {
    try {
      var response = await dio.get(get_state_list);
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> planListAPI() async {
    try {
      var response = await dio.get(get_plan_list);
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> workprofileListAPI() async {
    try {
      var response = await dio.get(get_working_profile);
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> alllocationshootListAPI() async {
    try {
      var response = await dio.get(get_alllocatoin_list);
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> paidlocationshootListAPI() async {
    try {
      var response = await dio.get(get_alllocatoin_paid_list);
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> elearningcatListAPI() async {
    try {
      var response = await dio.get(get_elearning_cat_list);
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> labListAPI() async {
    try {
      var response = await dio.get(lab_list);
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> cityListAPI(String state_id) async {
    try {
      var response = await dio.post(get_city_list,
          data: json.encode({"state_id": state_id}));
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> propicdetailAPI(String mobile) async {
    try {
      var response =
          await dio.post(get_propic_m, data: json.encode({"mobile": mobile}));
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> profiledetailAPI(String mobile) async {
    try {
      var response =
          await dio.post(get_fulldata_m, data: json.encode({"mobile": mobile}));
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> customerprofiledetailAPI(String mobile) async {
    try {
      var response =
          await dio.post(get_fulldata_c, data: json.encode({"mobile": mobile}));
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> getdeleteotpdetailAPI(String mobile) async {
    try {
      var response = await dio.post(delete_otp_store,
          data: json.encode({"mobile": mobile}));
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> getdeleteotpverifydetailAPI(
      String mobile, String otp) async {
    try {
      var response = await dio.post(delete_otp_verify,
          data: json.encode({"mobile": mobile, "otp": otp}));
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> getdemodetailAPI(String mobile) async {
    try {
      var response = await dio.post(get_full_demo_data,
          data: json.encode({"mobile": mobile}));
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> areaListAPI(String city_id) async {
    try {
      print(city_id);
      var response = await dio.post(get_area_list,
          data: json.encode({"city_id": city_id}));

      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> addAnnouncementApi(
    String member_name,
    String member_mobile,
    String mem_id,
    String an_type,
    String occasion,
    String side,
    String camera,
    String anno_desc,
    String work_profile,
    String state,
    String city,
    /*String area,*/
    String time,
    String start_date,
    String end_date,
    String days,
    String occ_loc,
    String custom_location,
    String cast,
  ) async {
    try {
      print({
        "member_name": member_name,
        "member_mobile": member_mobile,
        "mem_id": mem_id,
        "an_type": an_type,
        "occasion": occasion,
        "side": side,
        "camera": camera,
        "anno_desc": anno_desc,
        "work_profile": work_profile,
        "state": state,
        "city": city,
        /* "area": area,*/
        "time": time,
        "start_date": start_date,
        "end_date": end_date,
        "days": days,
        "occ_loc": occ_loc,
        "custom_location": custom_location,
        "cast": cast,
      });
      final response = await dio.post(add_anno,
          data: json.encode({
            "member_name": member_name,
            "member_mobile": member_mobile,
            "mem_id": mem_id,
            "an_type": an_type,
            "occasion": occasion,
            "side": side,
            "camera": camera,
            "anno_desc": anno_desc,
            "work_profile": work_profile,
            "state": state,
            "city": city,
            /* "area": area,*/
            "time": time,
            "start_date": start_date,
            "end_date": end_date,
            "days": days,
            "occ_loc": occ_loc,
            "custom_location": custom_location,
            "cast": cast,
          }));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else
        return RequestData();
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> addBookingApi(
      String user_id,
      String ocasion,
      String side,
      String requirement,
      String start,
      String end,
      String location,
      String cust_name,
      String cust_uniq,
      List<String> mobile) async {
    try {
      print({
        "user_id": user_id,
        "ocasion": ocasion,
        "side": side,
        "requirement": requirement,
        "start": start,
        "end": end,
        "location": location,
        "cust_name": cust_name,
        "cust_uniq": cust_uniq,
        "mobile": mobile
      });
      final response = await dio.post(add_booking,
          data: json.encode({
            "user_id": user_id,
            "ocasion": ocasion,
            "side": side,
            "requirement": requirement,
            "start": start,
            "end": end,
            "location": location,
            "cust_name": cust_name,
            "cust_uniq": cust_uniq,
            "mobile": mobile
          }));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else
        return RequestData();
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> editBookingApi(
    String id,
    String user_id,
    String ocasion,
    String side,
    String requirement,
    String start,
    String end,
    String location,
    String cust_name,
    String cust_uniq,
    List<String> mobile,
  ) async {
    try {
      print({
        "id": id,
        "user_id": user_id,
        "ocasion": ocasion,
        "side": side,
        "requirement": requirement,
        "start": start,
        "end": end,
        "location": location,
        "cust_name": cust_name,
        "cust_uniq": cust_uniq,
      });
      final response = await dio.post(edit_booking,
          data: json.encode({
            "id": id,
            "user_id": user_id,
            "ocasion": ocasion,
            "side": side,
            "requirement": requirement,
            "start": start,
            "end": end,
            "location": location,
            "cust_name": cust_name,
            "cust_uniq": cust_uniq,
            "mobile": mobile,
          }));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else
        return RequestData();
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> addQuatationApi(
    String mem_id,
    String cust_name,
    String cust_uniq_code,
    String start_date,
    String end_date,
    String ocation,
    String side,
    String state,
    String city,
    String area,
    String city_pin,
    String address,
    String amount,
    String requiremet,
    String remark,
  ) async {
    try {
      print({
        "mem_id": mem_id,
        "cust_name": cust_name,
        "cust_uniq_code": cust_uniq_code,
        "start_date": start_date,
        "end_date": end_date,
        "ocation": ocation,
        "side": side,
        "state": state,
        "city": city,
        "area": area,
        "city_pin": city_pin,
        "address": address,
        "amount": amount,
        "requiremet": requiremet,
        "remark": remark,
      });
      final response = await dio.post(create_quatation,
          data: json.encode({
            "mem_id": mem_id,
            "cust_name": cust_name,
            "cust_uniq_code": cust_uniq_code,
            "start_date": start_date,
            "end_date": end_date,
            "ocation": ocation,
            "side": side,
            "state": state,
            "city": city,
            "area": area,
            "city_pin": city_pin,
            "address": address,
            "amount": amount,
            "requiremet": requiremet,
            "remark": remark,
          }));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else
        return RequestData();
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> addBillingApi(
    String mem_id,
    String cust_name,
    String cust_uniq_code,
    String start_date,
    String end_date,
    String ocation,
    String side,
    String state,
    String city,
    String area,
    String city_pin,
    String address,
    String amount,
    String requiremet,
    String remark,
  ) async {
    try {
      print({
        "mem_id": mem_id,
        "cust_name": cust_name,
        "cust_uniq_code": cust_uniq_code,
        "start_date": start_date,
        "end_date": end_date,
        "ocation": ocation,
        "side": side,
        "state": state,
        "city": city,
        "area": area,
        "city_pin": city_pin,
        "address": address,
        "amount": amount,
        "requiremet": requiremet,
        "remark": remark,
      });
      final response = await dio.post(create_bill,
          data: json.encode({
            "mem_id": mem_id,
            "cust_name": cust_name,
            "cust_uniq_code": cust_uniq_code,
            "start_date": start_date,
            "end_date": end_date,
            "ocation": ocation,
            "side": side,
            "state": state,
            "city": city,
            "area": area,
            "city_pin": city_pin,
            "address": address,
            "amount": amount,
            "requiremet": requiremet,
            "remark": remark,
          }));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else
        return RequestData();
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> manualPaymentApi(
    String bill_id,
    String type,
    String amount,
    String note,
  ) async {
    try {
      print({
        "bill_id": bill_id,
        "type": type,
        "amount": amount,
        "note": note,
      });
      final response = await dio.post(add_transection,
          data: json.encode({
            "bill_id": bill_id,
            "type": type,
            "amount": amount,
            "note": note,
          }));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else
        return RequestData();
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> editAnnouncementApi(
    String id,
    String member_name,
    String member_mobile,
    String occasion,
    String side,
    String camera,
    String anno_desc,
    String work_profile,
    String state,
    String city,
    String area,
    String time,
    String start_date,
    String end_date,
    String days,
    String occ_loc,
    String custom_location,
    String cast,
  ) async {
    try {
      print({
        "id": id,
        "member_name": member_name,
        "member_mobile": member_mobile,
        "occasion": occasion,
        "side": side,
        "camera": camera,
        "anno_desc": anno_desc,
        "work_profile": work_profile,
        "state": state,
        "city": city,
        "area": area,
        "time": time,
        "start_date": start_date,
        "end_date": end_date,
        "days": days,
        "occ_loc": occ_loc,
        "custom_location": custom_location,
        "cast": cast,
      });
      final response = await dio.post(edit_anno,
          data: json.encode({
            "id": id,
            "member_name": member_name,
            "member_mobile": member_mobile,
            "occasion": occasion,
            "side": side,
            "camera": camera,
            "anno_desc": anno_desc,
            "work_profile": work_profile,
            "state": state,
            "city": city,
            "area": area,
            "time": time,
            "start_date": start_date,
            "end_date": end_date,
            "days": days,
            "occ_loc": occ_loc,
            "custom_location": custom_location,
            "cast": cast,
          }));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else
        return RequestData();
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> annnoListAPI(
      String city, String work_profile) async {
    try {
      print(city);
      var response = await dio.post(anno_list_are,
          data: json.encode({"city": city, "work_profile": work_profile}));

      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> myannoListAPI(String mobile) async {
    try {
      print(mobile);
      var response =
          await dio.post(my_anno_list, data: json.encode({"mobile": mobile}));

      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> locationListAPI(String member_id) async {
    try {
      print(member_id);
      var response = await dio.post(get_mylocatoin_list,
          data: json.encode({"member_id": member_id}));

      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> quotationconfirmAPI(String q_id) async {
    try {
      var response =
          await dio.post(quatation_confirm, data: json.encode({"q_id": q_id}));

      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> transreceiveAPI(String t_id) async {
    try {
      var response = await dio.post(transection_form_by_member,
          data: json.encode({"t_id": t_id}));

      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> closebillAPI(String bill_id) async {
    try {
      var response = await dio.post(bill_close_by_member,
          data: json.encode({"bill_id": bill_id}));

      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> cancelbillAPI(
      String order_id, String why_cancel) async {
    try {
      var response = await dio.post(order_cancel_by_sell,
          data: json.encode({"order_id": order_id, "why_cancel": why_cancel}));

      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> getPlansListApi() async {
    try {
      var response = await dio.get(get_plan_list);
      print("response is = $response");
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print(e);
      return RequestData();
    }
  }

  static Future<RequestData> deleteInvoiceAPI(String id) async {
    try {
      var response =
          await dio.post(delete_invoice, data: json.encode({"id": id}));

      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> getBookingMemberAPI(String id) async {
    try {
      var response =
          await dio.post(get_booking_memb, data: json.encode({"id": id}));

      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> deleteBookingMemberAPI(
      String id, String bkid) async {
    try {
      var response = await dio.post(delete_memb_bkng,
          data: json.encode({"id": id, "bk_id": bkid}));

      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> editBookingMemberAPI(String oldMobile,
      String mobile, String bkId, String userId, String id) async {
    try {
      var response = await dio.post(edit_memb_booking,
          data: json.encode({
            "old_mobile": oldMobile,
            "mobile": mobile,
            "bk_id": bkId,
            "user_id": userId,
            "id": id
          }));

      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> custcancelbillAPI(
      String order_id, String why_cancel) async {
    try {
      var response = await dio.post(order_cancel_by_buy,
          data: json.encode({"order_id": order_id, "why_cancel": why_cancel}));

      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> removeaccmemAPI(String id) async {
    try {
      var response =
          await dio.post(delete_my_acount_mem, data: json.encode({"id": id}));

      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> removeacccustAPI(String id) async {
    try {
      var response =
          await dio.post(delete_my_acount_cust, data: json.encode({"id": id}));

      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> getMemberbyMobileAPI(String mno) async {
    try {
      var response = await dio.post(get_memb_by_mobile,
          data: json.encode({"mobile": mno}));

      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> addfolderAPI(
      String user_id, String folder_name, String parent) async {
    print({"user_id": user_id, "folder_name": folder_name, "parent": parent});
    try {
      var response = await dio.post(create_folder,
          data: json.encode({
            "user_id": user_id,
            "folder_name": folder_name,
            "parent": parent
          }));
      print(response);
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> addfolderSelecationAPI(
      String user_id, String folder_name, String parent) async {
    print({"user_id": user_id, "folder_name": folder_name, "parent": parent});
    try {
      var response = await dio.post(create_folder_sel,
          data: json.encode({
            "user_id": user_id,
            "folder_name": folder_name,
            "parent": parent
          }));
      print(response);
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> renamefolderAPI(String user_id, String folder_name,
      String fold_id, String new_name) async {
    try {
      print({
        "user_id": user_id,
        "fold_name": folder_name,
        "fold_id": fold_id,
        "new_name": new_name,
      });
      var response = await dio.post(folder_change,
          data: json.encode({
            "user_id": user_id,
            "fold_name": folder_name,
            "fold_id": fold_id,
            "new_name": new_name
          }));
      print(response);
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> deleteannoAPI(String id) async {
    try {
      var response = await dio.post(delete_anno, data: json.encode({"id": id}));

      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> canclebookingAPI(String id) async {
    try {
      var response =
          await dio.post(cancel_booking, data: json.encode({"id": id}));

      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> deactivateannoAPI(String id) async {
    try {
      var response =
          await dio.post(deactive_anno, data: json.encode({"id": id}));

      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> postannoAPI(String id) async {
    try {
      var response = await dio.post(post_anno, data: json.encode({"id": id}));

      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> downloadquotationAPI(String id) async {
    try {
      var response =
          await dio.post(download_quot, data: json.encode({"id": id}));

      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> folderListAPI(String user_id) async {
    try {
      print(user_id);
      var response = await dio.post(my_folder_list,
          data: json.encode({"user_id": user_id}));
      // print(response);
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> custfolderListAPI(String uniq_code) async {
    try {
      //print(uniq_code);
      var response = await dio.post(my_cat_folder_list_uniq_code,
          data: json.encode({"uniq_code": uniq_code}));
      // print(response);
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> mycatfolderListAPI(
      String user_id, String cat_id) async {
    try {
      print(user_id + " " + cat_id);
      var response = await dio.post(my_cat_folder_list,
          data: json.encode({"user_id": user_id, "cat_id": cat_id}));
      print(response);
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> myallimagesListAPI(String user_id) async {
    try {
      print(user_id);
      var response = await dio.post(my_all_image_list,
          data: json.encode({"user_id": user_id}));

      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> mymoveimagesListAPI(String user_id) async {
    try {
      print(user_id);
      var response = await dio.post(my_move_image_list,
          data: json.encode({"user_id": user_id}));

      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> mydeleteimagesListAPI(String user_id) async {
    try {
      print(user_id);
      var response = await dio.post(my_all_delete_image_list,
          data: json.encode({"user_id": user_id}));

      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> myshareimagesListAPI(String user_id) async {
    try {
      print(user_id);
      var response = await dio.post(my_share_image_list,
          data: json.encode({"user_id": user_id}));

      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> mycatimageListAPI(
      String user_id, String cat_id, String cat_name) async {
    try {
      // print(user_id + "    " + cat_id);
      var response = await dio.post(my_cat_image_list,
          data: json.encode(
              {"user_id": user_id, "cat_id": cat_id, "cat_name": cat_name}));
      print(response);
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> deleteImageAPI(
      List<String> imgs, String div_id) async {
    try {
      var response = await dio.post(delete_img,
          data: json.encode({"imgs": imgs, "div_id": div_id}));

      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> tempdeleteImageAPI(List<String> imgs) async {
    print({"imgs": imgs});
    try {
      var response =
          await dio.post(delete_img_temp, data: json.encode({"imgs": imgs}));
      print(response);
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> selectedImageAPI(List<String> imgs) async {
    print({"imgs": imgs});
    try {
      var response = await dio.post(selected_img_custore,
          data: json.encode({"imgs": imgs}));
      print(response);
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> unselectedImageAPI(List<String> imgs) async {
    print({"imgs": imgs});
    try {
      var response = await dio.post(unselected_img_custore,
          data: json.encode({"imgs": imgs}));
      print(response);
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> memberListAPI(String user_id) async {
    try {
      //print(user_id);
      var response =
          await dio.post(member_list, data: json.encode({"user_id": user_id}));

      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> dateannoList(String member_id, String date) async {
    try {
      //print(user_id);
      var response = await dio.post(date_anno_list,
          data: json.encode({"member_id": member_id, "date": date}));

      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> datebookingList(
      String user_id, String date) async {
    try {
      //print(user_id);
      var response = await dio.post(date_booking_list,
          data: json.encode({"user_id": user_id, "date": date}));

      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> dateScheduleList(
      String member_id, String date) async {
    try {
      //print(user_id);
      var response = await dio.post(date_sched_list,
          data: json.encode({"member_id": member_id, "date": date}));

      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> moveImageAPI(
      List<String> imgs, String div_id, String cdiv_id) async {
    print({"imgs": imgs, "div_id": div_id, "cdiv_id": cdiv_id});
    try {
      var response = await dio.post(move_img,
          data: json
              .encode({"imgs": imgs, "div_id": div_id, "cdiv_id": cdiv_id}));

      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> shareforselectionImageAPI(
      List<String> imgs, String div_id, String cat_name) async {
    print({"imgs": imgs, "div_id": div_id, "cat_name": cat_name});
    try {
      var response = await dio.post(share_for_selection,
          data: json
              .encode({"imgs": imgs, "div_id": div_id, "cat_name": cat_name}));

      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> shareImageAPI(
      List<String> imgs, String div_id) async {
    print({"imgs": imgs, "div_id": div_id});
    try {
      var response = await dio.post(share_img,
          data: json.encode({"imgs": imgs, "div_id": div_id}));

      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> labaddworkAPI(String lab_id, String lab_name,
      String lan_number, String mem_id, String mem_name, String count) async {
    try {
      print({
        "lab_id": lab_id,
        "lab_name": lab_name,
        "lan_number": lan_number,
        "mem_id": mem_id,
        "mem_name": mem_name,
        "count": count,
      });
      var response = await dio.post(add_lab_work_for_admin,
          data: json.encode({
            "lab_id": lab_id,
            "lab_name": lab_name,
            "lan_number": lan_number,
            "mem_id": mem_id,
            "mem_name": mem_name,
            "count": count,
          }));
      print(response);
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> memphotoUploadAPI(Map<String, dynamic> map) async {
    try {
      FormData formData = new FormData.fromMap(map);
      var response = await dio.post(work_profile_image_upload, data: formData);
      print("response $response");
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> memvideoUploadAPI(Map<String, dynamic> map) async {
    try {
      FormData formData = new FormData.fromMap(map);
      var response = await dio.post(work_profile_video_upload, data: formData);
      print("response $response");
      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> photosRemoveApi(
    String id,
  ) async {
    try {
      print({
        "id": id,
      });
      final response = await dio.post(work_profile_image_delete,
          data: json.encode({
            "id": id,
          }));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else
        return RequestData();
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> videoRemoveApi(
    String id,
  ) async {
    try {
      print({
        "id": id,
      });
      final response = await dio.post(work_profile_video_delete,
          data: json.encode({
            "id": id,
          }));
      print(response);
      if (response.statusCode == 200) {
        return RequestData.fromJson(response.data);
      } else
        return RequestData();
    } catch (e) {
      print(e);
      if (e is DioError) {
        return RequestData();
      } else {
        return RequestData();
      }
    }
  }

  static Future<RequestData> deletequotationAPI(String id, String qid) async {
    try {
      var response = await dio.post(qot_item_delete,
          data: json.encode({"id": id, "qid": qid}));

      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }

  static Future<RequestData> editquotationitemAPI(String id, String qid,
      String requirement, String amount, String remark) async {
    try {
      print({
        "id": id,
        "qid": qid,
        "requirement": requirement,
        "amount": amount,
        "remark": remark
      });
      var response = await dio.post(qot_item_edit,
          data: json.encode({
            "id": id,
            "qid": qid,
            "requirement": requirement,
            "amount": amount,
            "remark": remark
          }));

      if (response.statusCode == 200)
        return RequestData.fromJson(response.data);
      else
        return RequestData();
    } catch (e) {
      print("error $e");
      return RequestData();
    }
  }
}

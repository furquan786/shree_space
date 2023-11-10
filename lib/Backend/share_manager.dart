import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Config/enums.dart';

class ShareManager {
  static setLogintype(UserType type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("type", EnumToString.convertToString(type));
  }

  static Future<UserType?> getLogintype() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final key = prefs.getString("type");
      print("key is coming = ${key}");

      return EnumToString.fromString(UserType.values, key!);
    } catch (e) {
      print("some exception occured $e");
    }
  }

  static Future setID(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("id", id);
  }

  static Future getID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString("id"));
    return prefs.getString("id");
  }

  static Future setDeviceID(String device_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("device_id ", device_id);
  }

  static Future getDeviceID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString("device_id "));
    return prefs.getString("device_id ");
  }

  static Future setUserID(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("userID", id);
  }

  static Future getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString("userID"));
    return prefs.getString("userID");
  }

  static Future setUniqueID(String uniq_code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("uniq_code", uniq_code);
  }

  static Future getUniqueID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString("uniq_code"));
    return prefs.getString("uniq_code");
  }

  static Future setName(String user_name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        "user_name", user_name == null || user_name == "" ? "" : user_name);
  }

  static Future getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("user_name");
  }

  static Future setWorkProfile(String work_profile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("work_profile",
        work_profile == null || work_profile == "" ? "" : work_profile);
  }

  static Future getWorkProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("work_profile");
  }

  static Future setFirmName(String firm_name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        "firm_name", firm_name == null || firm_name == "" ? "" : firm_name);
  }

  static Future getFirmName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("firm_name");
  }

  static Future setLastName(String last_name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        "last_name", last_name == null || last_name == "" ? "" : last_name);
  }

  static Future getLastName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("last_name");
  }

  static Future setEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("email", email == null || email == "" ? "" : email);
  }

  static Future getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("email");
  }

  static Future setAc_type(String ac_type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        "ac_type", ac_type == null || ac_type == "" ? "" : ac_type);
  }

  static Future getAc_type() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("ac_type");
  }

  static Future setAc_no(String ac_no) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("ac_no", ac_no == null || ac_no == "" ? "" : ac_no);
  }

  static Future getAc_no() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("ac_no");
  }

  static Future setAdhar_no(String adhar_no) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        "adhar_no", adhar_no == null || adhar_no == "" ? "" : adhar_no);
  }

  static Future getAdhar_no() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("adhar_no");
  }

  static Future setPan_no(String pan_no) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        "pan_no", pan_no == null || pan_no == "" ? "" : pan_no);
  }

  static Future getPan_no() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("pan_no");
  }

  static Future setPlan(String plan) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("plan", plan == null || plan == "" ? "" : plan);
  }

  static Future getPlan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("plan");
  }

  static Future setIfsc(String ifsc) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("ifsc", ifsc == null || ifsc == "" ? "" : ifsc);
  }

  static Future getIfsc() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("ifsc");
  }

  static Future setMobile(String u_phone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        "u_phone", u_phone == null || u_phone == "" ? "" : u_phone);
  }

  static Future getMobile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("u_phone");
  }

  static Future setProfile(String u_img) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("u_img", u_img == null || u_img == "" ? "" : u_img);
  }

  static Future getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("u_img");
  }

  static Future setCountry_code(String u_country_code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("u_country_code",
        u_country_code == null || u_country_code == "" ? "" : u_country_code);
  }

  static Future getCountry_code() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("u_country_code");
  }

  static Future setCountry_name(String u_country_name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("u_country_name",
        u_country_name == null || u_country_name == "" ? "" : u_country_name);
  }

  static Future getCountry_name() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("u_country_name");
  }

  static Future setHomeAddress(String home_address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("home_address",
        home_address == null || home_address == "" ? "" : home_address);
  }

  static Future getHomeAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("home_address");
  }

  static Future setState(String state) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("state", state == null || state == "" ? "" : state);
  }

  static Future getState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("state");
  }

  static Future setCity(String city) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("city", city == null || city == "" ? "" : city);
  }

  static Future getCity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("city");
  }

  static Future setArea(String area) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("area", area == null || area == "" ? "" : area);
  }

  static Future getArea() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("area");
  }

  static Future setVillage(String village) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        "village", village == null || village == "" ? "" : village);
  }

  static Future getVillage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("village");
  }

  static Future setCity_pin(String city_pin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        "city_pin", city_pin == null || city_pin == "" ? "" : city_pin);
  }

  static Future getCity_pin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("city_pin");
  }

  static Future setDOB(String u_dob) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("u_dob", u_dob == null || u_dob == "" ? "" : u_dob);
  }

  static Future getDOB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("u_dob");
  }

  static Future setPOB(String u_pob) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("u_pob", u_pob == null || u_pob == "" ? "" : u_pob);
  }

  static Future getPOB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("u_pob");
  }

  static Future setPOBTime(String u_pob_time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        "u_pob_time", u_pob_time == null || u_pob_time == "" ? "" : u_pob_time);
  }

  static Future getPOBTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("u_pob_time");
  }

  static Future setBirthTime(String u_birth_time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("u_birth_time",
        u_birth_time == null || u_birth_time == "" ? "" : u_birth_time);
  }

  static Future getBirthTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("u_birth_time");
  }

  static Future setAuth(String u_auth) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        "u_auth", u_auth == null || u_auth == "" ? "" : u_auth);
  }

  static Future getAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("u_auth");
  }

  static Future setUnique(String u_unique) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        "u_unique", u_unique == null || u_unique == "" ? "" : u_unique);
  }

  static Future getUnique() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("u_unique");
  }

  static Future setGridorList(String gridlist) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("gridlist", gridlist);
  }

  static Future getGridorList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString("gridlist"));
    return prefs.getString("gridlist");
  }

  static Future<bool> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }
}

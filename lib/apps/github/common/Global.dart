import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:helloworld/apps/github/common/Git.dart';
import 'package:helloworld/apps/github/common/NetCache.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:helloworld/apps/github/models/index.dart';

// 提供五套可选主题色
const _themes = <MaterialColor>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red,
];

class Global {
  static SharedPreferences _prefs;
  static Profile profile = Profile();
  static NetCache netCache = NetCache(); // 网络缓存对象
  static List<MaterialColor> get themes => _themes; // 可选的主题列表
  static bool get isRelease => true; //////bool.fromEnvironment("dart.vm.product"); // 是否为release版

  // 初始化全局信息，会在APP启动时执行
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
    var _profile = _prefs.getString("profile");
    if (_profile != null) {
      try {
        profile = Profile.fromJson(jsonDecode(_profile));
      } catch (e) {
        print(e);
      }
    }

    // 如果没有缓存策略，设置默认缓存策略
    profile.cache = profile.cache ?? CacheConfig()
      ..enable = true
      ..maxAge = 3600
      ..maxCount = 100;

    //初始化网络请求相关配置
    Git.init();
  }

  // 持久化Profile信息
  static saveProfile() =>
      _prefs.setString("profile", jsonEncode(profile.toJson()));
}

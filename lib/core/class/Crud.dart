import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import '../functions/CheckInternat.dart';
import '../services/Services.dart';
import 'Statusrequest.dart';

class Crud {
  /// آخر رسالة خطأ مقروءة من السيرفر (لعرضها للمستخدم إن احتجنا)
  static String? lastError;

  /// يحوّل رد السيرفر الفاشل إلى رسالة قصيرة مقروءة:
  /// JSON -> حقل message (أو أول خطأ تحقق)، HTML -> العنوان والفقرة بدون وسوم
  static String describeError(http.Response response) {
    final body = response.body.trim();
    String detail = '';

    try {
      final json = jsonDecode(body);
      if (json is Map) {
        final errors = json['errors'];
        if (errors is Map && errors.isNotEmpty) {
          final first = errors.values.first;
          detail = first is List && first.isNotEmpty
              ? first.first.toString()
              : first.toString();
        } else if (json['message'] != null) {
          detail = json['message'].toString();
        }
      }
    } catch (_) {
      if (body.startsWith('<')) {
        String? tag(String name) {
          final m = RegExp('<$name[^>]*>([\\s\\S]*?)</$name>',
                  caseSensitive: false)
              .firstMatch(body);
          if (m == null) return null;
          final text = m
              .group(1)!
              .replaceAll(RegExp(r'<[^>]+>'), ' ')
              .replaceAll(RegExp(r'\s+'), ' ')
              .trim();
          return text.isEmpty ? null : text;
        }

        detail = [tag('title') ?? tag('h1'), tag('p')]
            .whereType<String>()
            .toSet()
            .join(' - ');
      } else {
        detail = body.length > 200 ? '${body.substring(0, 200)}...' : body;
      }
    }

    final reason = response.reasonPhrase ?? '';
    return detail.isEmpty
        ? '${response.statusCode} $reason'.trim()
        : '${response.statusCode}: $detail';
  }

  /// حماية الاستضافة (WAF) ترفض بـ 403 أي ملف في اسمه ' أو ; أو = (مثل l'impot.pdf)
  /// لذلك نبقي فقط الحروف والأرقام والمسافة و . _ - ( ). الباك اند يعطي
  /// الملف اسماً عشوائياً عند التخزين، فالاسم الأصلي لا يهم.
  static String safeFileName(String name) {
    final cleaned = name
        .replaceAll(RegExp(r'[^\p{L}\p{N}\s._()-]', unicode: true), '_')
        .replaceAll(RegExp(r'_+'), '_');
    return cleaned.trim().isEmpty ? 'file' : cleaned.trim();
  }

  void _logError(String label, String url, http.Response response) {
    lastError = describeError(response);
    print("❌ $label: $url\n   -> $lastError");
  }

  // =========================
  // Helpers (TOKEN + HEADERS)
  // =========================

  String? _getToken() {
    return Get.find<Myservices>().sharedPreferences?.getString("token");
  }

  Map<String, String> _jsonHeadersWithToken() {
    final token = _getToken();
    return {
      "Accept": "application/json",
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  Map<String, String> _headersWithToken() {
    final token = _getToken();
    return {
      "Accept": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  // =========================
  // POST JSON WITH TOKEN
  // =========================

  Future<Either<Statusrequest, Map>> postWithheaders(
    String linkurl,
    Map data,
  ) async {
    try {
      if (!await checkInternet()) {
        return const Left(Statusrequest.serverfailure);
      }

      final request = http.Request("POST", Uri.parse(linkurl));

      request.headers.addAll(_jsonHeadersWithToken());
      request.body = jsonEncode(data);

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(jsonDecode(response.body));
      }

      _logError("API Error", linkurl, response);
      return const Left(Statusrequest.failure);
    } catch (e) {
      print("❌ Exception postDataheaders: $e");
      return const Left(Statusrequest.failure);
    }
  }

  // =========================
  // POST LOGOUT (TOKEN ONLY)
  // =========================

  Future<Either<Statusrequest, Map>> postWithheadersLogout(
    String linkurl,
  ) async {
    try {
      if (!await checkInternet()) {
        return const Left(Statusrequest.serverfailure);
      }

      final request = http.Request("POST", Uri.parse(linkurl));

      request.headers.addAll(_headersWithToken());

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(jsonDecode(response.body));
      }

      _logError("Logout Error", linkurl, response);
      return const Left(Statusrequest.failure);
    } catch (e) {
      print("❌ Exception postDataheadersLogout: $e");
      return const Left(Statusrequest.failure);
    }
  }

  // =========================
  // POST WITHOUT TOKEN
  // =========================

  Future<Either<Statusrequest, Map>> postWithout(
    String linkurl,
    Map data,
  ) async {
    try {
      if (!await checkInternet()) {
        return const Left(Statusrequest.serverfailure);
      }

      final response = await http.post(
        Uri.parse(linkurl),
        headers: {"Accept": "application/json"},
        body: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(jsonDecode(response.body));
      }

      _logError("API Error", linkurl, response);
      return const Left(Statusrequest.failure);
    } catch (e, s) {
      print("❌ Exception postData: $e");
      print("🔍 $s");
      return const Left(Statusrequest.failure);
    }
  }

  // =========================
  // GET WITH TOKEN
  // =========================

  Future<Either<Statusrequest, Map>> getWithheaders(String linkurl) async {
    try {
      if (!await checkInternet()) {
        return const Left(Statusrequest.serverfailure);
      }

      final request = http.Request("GET", Uri.parse(linkurl));

      request.headers.addAll(_headersWithToken());

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(jsonDecode(response.body));
      }

      _logError("GET Error", linkurl, response);
      return const Left(Statusrequest.failure);
    } catch (e) {
      print("❌ Exception getData: $e");
      return const Left(Statusrequest.failure);
    }
  }

  // =========================
  // POST MULTIPART WITH TOKEN
  // =========================

  Future<Either<Statusrequest, Map>> addRequestWithImageOne(
    String url,
    Map data,
    int type,
    File? image, [
    String? namerequest,
  ]) async {
    type == 1 ? namerequest ??= "pdf" : namerequest ??= "image";

    try {
      if (!await checkInternet()) {
        return const Left(Statusrequest.serverfailure);
      }

      final request = http.MultipartRequest("POST", Uri.parse(url));

      request.headers.addAll(_headersWithToken());

      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            namerequest,
            image.path,
            filename: safeFileName(basename(image.path)),
          ),
        );
      }

      data.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(jsonDecode(response.body));
      }

      _logError("Multipart Error", url, response);
      return const Left(Statusrequest.failure);
    } catch (e) {
      print("❌ Exception addRequestWithImageOne: $e");
      return const Left(Statusrequest.failure);
    }
  }
}

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:icooker/config/Config.dart';

class HttpManager {
  static HttpManager _instance;
  Dio _dio;
  BaseOptions _options;

  CancelToken cancelToken = CancelToken();

  static HttpManager getInstance() {
    if (null == _instance) _instance = HttpManager();
    return _instance;
  }

  /// config it and create

  HttpManager() {
    //BaseOptions、Options、RequestOptions都可以在这里配置参数，优先级别依次递增且根据优先级别覆盖参数
    _options = BaseOptions(
      //请求基地址,可以包含子路径
      baseUrl: Config.BASE_URL,
      //连接服务器超时时间，单位毫秒
      connectTimeout: Config.CONNECT_TIMEOUT,
      //响应流接收数据间隔
      receiveTimeout: Config.RECIVE_TIMEOUT,
      //http请求头
      headers: {"version": "1.0.0"},
      //请求的Content-Type，默认值是"application/json; charset=utf-8",Headers.formUrlEncodedContentType会自动编码请求体.
      contentType: Headers.formUrlEncodedContentType,
      //表示期望以那种格式(方式)接受响应数据。接受四种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
      responseType: ResponseType.json,
    );

    _dio = Dio(_options);

    //cookie管理
    _dio.interceptors.add(CookieManager(CookieJar()));
    //添加拦截器
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      print('请求之前....');
      return options;
    }, onResponse: (Response response) {
      print('响应之前');
      return response;
    }, onError: (DioError e) {
      print('错误之前');
      return e;
    }));
  }

  /// get 请求

  get(url, {data, options, cancelToken}) async {
    Response response;
    try {
      response = await _dio.get(url,
          queryParameters: data, options: options, cancelToken: cancelToken);
      print('get success---------${response.statusCode}');
      print('get success---------${response.data}');

      //  response.data; 响应体
      //  response.headers; 响应头
      //  response.request; 请求体
      //  response.statusCode; 状态码
    } on DioError catch (e) {
      print('get error---------$e');
      formatError(e);
    }
    return response;
  }

  /// POST请求

  post(url, {data, options, cancelToken}) async {
    Response response;
    try {
      response = await _dio.post(url,
          queryParameters: data, options: options, cancelToken: cancelToken);
      print('post success---------${response.data}');
    } on DioError catch (e) {
      print('post error---------$e');
      formatError(e);
    }
    return response;
  }

  /*
   * 下载文件
   */
  downloadFile(urlPath, savePath) async {
    Response response;
    try {
      response = await _dio.download(urlPath, savePath,
          onReceiveProgress: (int count, int total) {
        //进度
        print("$count $total");
      });
      print('downloadFile success---------${response.data}');
    } on DioError catch (e) {
      print('downloadFile error---------$e');
      formatError(e);
    }
    return response.data;
  }

  /*
   * 取消请求
   *
   * 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。
   * 所以参数可选
   */
  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }

  /*
   * error统一处理
   */
  void formatError(DioError e) {
    if (e.type == DioErrorType.CONNECT_TIMEOUT) {
      // It occurs when url is opened timeout.
      print("连接超时");
    } else if (e.type == DioErrorType.SEND_TIMEOUT) {
      // It occurs when url is sent timeout.
      print("请求超时");
    } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
      //It occurs when receiving timeout
      print("响应超时");
    } else if (e.type == DioErrorType.RESPONSE) {
      // When the server response, but with a incorrect status, such as 404, 503...
      print("出现异常");
    } else if (e.type == DioErrorType.CANCEL) {
      // When the request is cancelled, dio will throw a error with this type.
      print("请求取消");
    } else {
      //DEFAULT Default error type, Some other Error. In this case, you can read the DioError.error if it is not null.
      print("未知错误");
    }
  }
}

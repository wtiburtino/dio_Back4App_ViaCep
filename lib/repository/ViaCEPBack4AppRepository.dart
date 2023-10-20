import 'package:dio/dio.dart';
import 'package:dio_back4app_viacep/model/ViaCEPBack4AppModel.dart';

class ViaCepBack4AppRepository {
  var _dio = Dio();

  ViaCepBack4AppRepository() {
    _dio.options.headers["X-Parse-Application-Id"] =
        "dJVOz4L5EgnHvWmZ58lIhSouTV7dNH1g4V9D6cO4";
    _dio.options.headers["X-Parse-REST-API-Key"] =
        "F3ZM98W70LYgn0s5UOewTlfeWJdM2uxkfpsK8AmH";
    _dio.options.headers["Content-Type"] = "application/json";
    _dio.options.baseUrl = "https://parseapi.back4app.com/classes";
  }

  Future<ViaCEPBack4AppModel> obterCEPs() async {
    var url = "/viacep";
    var response = await _dio.get(url);
    if (response.statusCode == 200) {
      return ViaCEPBack4AppModel.fromJson(response.data);
    }
    return ViaCEPBack4AppModel.criar();
  }

  Future<void> criar(ResultsCEPBack4App resultsCEPBack4App) async {
    await _dio.post("/viacep", data: resultsCEPBack4App.toJsonEndpoint());
  }

  Future<void> atualiza(ResultsCEPBack4App resultsCEPBack4App) async {
    await _dio.put("/viacep/${resultsCEPBack4App.objectId}",
        data: resultsCEPBack4App.toJsonEndpoint());
  }

  Future<void> remover(String objectId) async {
    await _dio.delete("/viacep/$objectId");
  }
}

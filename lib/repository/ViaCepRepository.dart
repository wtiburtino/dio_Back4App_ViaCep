import 'package:dio_back4app_viacep/model/ViaCepModel.dart';
import 'package:dio/dio.dart';

class ViaCepRepository {
  Future<ViaCEPModel> consultarCEP(String cep) async {
    var dio = Dio();
    var response = await dio.get("https://viacep.com.br/ws/$cep/json/");
    if (response.statusCode == 200) {
      return ViaCEPModel.fromJson(response.data);
    }
    return ViaCEPModel();
  }
}

class ViaCEPBack4AppModel {
  List<ResultsCEPBack4App> results = [];

  ViaCEPBack4AppModel(this.results);

  ViaCEPBack4AppModel.criar();

  ViaCEPBack4AppModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <ResultsCEPBack4App>[];
      json['results'].forEach((v) {
        results.add(ResultsCEPBack4App.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['results'] = results.map((v) => v.toJson()).toList();
    return data;
  }
}

class ResultsCEPBack4App {
  String objectId = "";
  String rua = "";
  String cep = "";
  String createdAt = "";
  String updatedAt = "";
  String cidade = "";
  String estado = "";

  ResultsCEPBack4App(this.objectId, this.rua, this.cep, this.createdAt,
      this.updatedAt, this.cidade, this.estado);

  ResultsCEPBack4App.criar(this.rua, this.cep, this.cidade, this.estado);

  ResultsCEPBack4App.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    rua = json['rua'];
    cep = json['cep'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    cidade = json['cidade'];
    estado = json['estado'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectId'] = objectId;
    data['rua'] = rua;
    data['cep'] = cep;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['cidade'] = cidade;
    data['estado'] = estado;
    return data;
  }

  Map<String, dynamic> toJsonEndpoint() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rua'] = rua;
    data['cep'] = cep;
    data['cidade'] = cidade;
    data['estado'] = estado;
    return data;
  }
}

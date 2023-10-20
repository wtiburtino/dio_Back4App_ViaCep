import 'dart:convert';

import 'package:dio_back4app_viacep/model/ViaCEPBack4AppModel.dart';
import 'package:dio_back4app_viacep/model/ViaCepModel.dart';
import 'package:dio_back4app_viacep/repository/ViaCEPBack4AppRepository.dart';
import 'package:dio_back4app_viacep/repository/ViaCepRepository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CEP no Back4App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amberAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'CEP no Back4App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var cepController = TextEditingController(text: "");
  final _focusNode = FocusNode();
  bool carregando = false;
  bool modoEdicao = false;
  var objectIdModoEdicao = "";
  var viacepback4appmodel = ViaCEPBack4AppModel.criar();
  var viacepmodel = ViaCEPModel();
  late ViaCepBack4AppRepository viacepback4apprepository;
  late ViaCepRepository viaceprepository;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  void carregarDados() async {
    viaceprepository = ViaCepRepository();
    viacepback4apprepository = ViaCepBack4AppRepository();
    viacepback4appmodel = await viacepback4apprepository.obterCEPs();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: cepController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(top: 15),
                hintText: "Informe o CEP",
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: FaIcon(FontAwesomeIcons.locationDot,
                      color: Color.fromARGB(255, 16, 88, 38)),
                ),
              ),
              keyboardType: TextInputType.number,
              maxLength: 8,
              focusNode: _focusNode,
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                  onPressed: () async {
                    if (cepController.text.trim().length == 8) {
                      _focusNode.unfocus();
                      setState(() {
                        carregando = true;
                      });
                      var cep = cepController.text.trim();
                      viacepmodel = await viaceprepository.consultarCEP(cep);
                      setState(() {
                        carregando = false;
                      });
                      if (viacepmodel.cep == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("CEP não encontrado!")));
                        return;
                      }
                      // ignore: use_build_context_synchronously
                      showDialog(
                          context: context,
                          builder: (BuildContext bc) {
                            return AlertDialog(
                              title: const Text("Salvar Endereço ?"),
                              content: Wrap(
                                children: [
                                  Text("Rua: ${viacepmodel.logradouro}"),
                                  Text(
                                      "Cidade: ${viacepmodel.localidade} - Estado: ${viacepmodel.uf}"),
                                  Text("CEP: ${viacepmodel.cep}"),
                                ],
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      if (modoEdicao == false) {
                                        var resultsCEPBack4App =
                                            ResultsCEPBack4App.criar(
                                                viacepmodel.logradouro
                                                    .toString(),
                                                viacepmodel.cep.toString(),
                                                viacepmodel.localidade
                                                    .toString(),
                                                viacepmodel.uf.toString());
                                        await viacepback4apprepository
                                            .criar(resultsCEPBack4App);
                                      } else {
                                        var resultsCEPBack4App =
                                            ResultsCEPBack4App(
                                                objectIdModoEdicao,
                                                viacepmodel.logradouro
                                                    .toString(),
                                                viacepmodel.cep.toString(),
                                                "",
                                                "",
                                                viacepmodel.localidade
                                                    .toString(),
                                                viacepmodel.uf.toString());
                                        await viacepback4apprepository
                                            .atualiza(resultsCEPBack4App);
                                        modoEdicao = false;
                                      }
                                      carregarDados();
                                    },
                                    child: const Text("Sim")),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Não"))
                              ],
                            );
                          });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("CEP inválido!")));
                      return;
                    }
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 16, 88, 38))),
                  child: const Text(
                    "Salvar",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            Visibility(
                visible: carregando, child: const CircularProgressIndicator()),
            Expanded(
                child: ListView.builder(
                    itemCount: (viacepback4appmodel.results.length),
                    itemBuilder: (BuildContext bc, int index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        width: double.infinity,
                        child: Card(
                          elevation: 8,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Endereço:",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            viacepback4appmodel
                                                .results[index].rua,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            "CEP: ${viacepback4appmodel.results[index].cep}",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            "${viacepback4appmodel.results[index].cidade} - Estado: ${viacepback4appmodel.results[index].estado}",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () async {
                                          cepController.text =
                                              viacepback4appmodel
                                                  .results[index].cep
                                                  .replaceAll("-", "");
                                          modoEdicao = true;
                                          objectIdModoEdicao =
                                              viacepback4appmodel
                                                  .results[index].objectId;
                                        },
                                        icon: const FaIcon(
                                          FontAwesomeIcons.pencil,
                                          color:
                                              Color.fromARGB(255, 16, 88, 38),
                                        )),
                                    IconButton(
                                        onPressed: () async {
                                          await viacepback4apprepository
                                              .remover(viacepback4appmodel
                                                  .results[index].objectId);
                                          carregarDados();
                                        },
                                        icon: const FaIcon(
                                            FontAwesomeIcons.trash,
                                            color: Color.fromARGB(
                                                255, 16, 88, 38)))
                                  ],
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    })),
          ],
        ),
      ),
    );
  }
}

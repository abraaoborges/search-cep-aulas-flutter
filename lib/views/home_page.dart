import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:search_cep/models/result_cep.dart';
import 'package:search_cep/services/via_cep_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _searchCepController = TextEditingController();
  bool _loading = false;
  bool _enableField = true;
  ResultCep _resultObj;
  bool _isSwitched = false;

  @override
  void dispose() {
    super.dispose();
    _searchCepController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultar CEP'),
        actions: <Widget>[
          Switch(
            onChanged: (val) => setState(() => _changeColor(val)),
            value: _isSwitched,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildSearchCepTextField(),
            _buildSearchCepButton(),
            _buildResultForm()
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCepTextField() {
    return TextField(
      autofocus: true,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(labelText: 'Cep'),
      controller: _searchCepController,
      enabled: _enableField,
    );
  }

  Widget _buildSearchCepButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: RaisedButton(
        onPressed: _searchCep,
        child: _loading ? _circularLoading() : Text('Consultar'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  void _searching(bool enable) {
    setState(() {
      _resultObj = enable ? null : _resultObj;
      _loading = enable;
      _enableField = !enable;
    });
  }

  Widget _circularLoading() {
    return Container(
      height: 15.0,
      width: 15.0,
      child: CircularProgressIndicator(),
    );
  }

  Future _searchCep() async {
    _searching(true);

    final cep = _searchCepController.text;

    try{
      _resultObj = await ViaCepService.fetchCep(cep: cep);
    }
    catch(e){
     print("ERRO: $e");
      _buildFlushbar();
      _searching(false);
      return;
    }
    
    _resultObj.updateControllers();

    _searching(false);
  }

  Flushbar _buildFlushbar(){
  
    return Flushbar(
      title: "Erro",
      message: "Erro ao procurar o cep",
      margin: EdgeInsets.all(8),
      borderRadius: 8,
      duration: Duration(seconds: 5),
    )..show(context);
  }

  Widget _buildResultForm() {
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        children: _buildTextFormFieldList()
      ),
    );
  }

   void _changeColor(bool val) {
    
    setState(() =>_isSwitched = _isSwitched ? false : true);
    DynamicTheme.of(context).setBrightness(
      Theme.of(context).brightness == Brightness.dark? Brightness.light: Brightness.dark
    );
  }

  List<Widget> _buildTextFormFieldList(){
    return
      <Widget>[
        _buildTextFormField( label: "Cep", controller: _resultObj == null ? null: _resultObj.cepController),
        _buildTextFormField( label: "Logadouro", controller: _resultObj == null ? null: _resultObj.logadouroController),
        _buildTextFormField( label: "Complemento", controller: _resultObj == null ? null: _resultObj.complementoController),
        _buildTextFormField( label: "Bairro", controller: _resultObj == null ? null: _resultObj.bairroController),
        _buildTextFormField( label: "Localidade", controller: _resultObj == null ? null: _resultObj.localidadeController),
        _buildTextFormField( label: "Uf", controller: _resultObj == null ? null: _resultObj.ufController),
        _buildTextFormField( label: "Unidade", controller: _resultObj == null ? null: _resultObj.unidadeController),
        _buildTextFormField( label: "gia", controller: _resultObj == null ? null: _resultObj.giaController),
        _buildTextFormField( label: "Ibge", controller: _resultObj == null ? null: _resultObj.ibgeController),
      ];
  }

  Widget _buildTextFormField({String label, TextEditingController controller}){
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(labelText: label),
      controller: controller,
/*      validator: (text) {
        return text.isEmpty ? validatorMessage : null;
      },*/
    );
  }
}

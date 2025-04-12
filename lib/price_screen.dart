import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String SelectedCurrency = 'AUD';
  DropdownButton<String> andriodDropdown(){
    List<DropdownMenuItem<String>> dropDownitems = [];
    for(String currency in currenciesList){
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropDownitems.add(newItem);
    }
    return DropdownButton(
        items: dropDownitems,
        value: SelectedCurrency,
        onChanged: (value){
          setState(() {
            SelectedCurrency = value!;
            getData();
          });
        });
  }

  CupertinoPicker IOSPicker(){
    List<Text> pickerItems = [];
    for(String currency in currenciesList){
      pickerItems.add(Text(currency));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
        itemExtent: 32.0,
        onSelectedItemChanged: (selectedIndex){
        setState(() {
          SelectedCurrency = currenciesList[selectedIndex];
          getData();
        });
        },
        children: pickerItems);
  }
  Widget getPicker(){
    if(kIsWeb){
      return andriodDropdown();
    }
    else if (Platform.isIOS){
      return IOSPicker();
    }
    else if (Platform.isAndroid){
      return andriodDropdown();
    }
    else{
      return andriodDropdown();
    }
  }

  Map<String, String> coinValues = {};
  bool isWaiting = false;


  void getData() async {
    setState(() {
      isWaiting = true;
    });
    try {
      var data = await CoinData().getCoinData(SelectedCurrency);
      setState(() {
        isWaiting = false;
        coinValues = data as Map<String, String>;
      });
    } catch (e) {
      print(e);
      setState(() {
        isWaiting = false;
      });
    }
  }

  void initstate(){
    super.initState();
    getData();
  }

  Column makeCards() {
    List<CryptoCard> cryptoCards = [];
    for (String crypto in cryptoList) {
      cryptoCards.add(
        CryptoCard(
          value: isWaiting ? '?' : (coinValues[crypto] ?? '?'),
          selectedCurrency: SelectedCurrency,
          cryptoCurrency: crypto,
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          makeCards(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getPicker(),
          ),
        ],
      ),
    );
  }

}

class CryptoCard extends StatelessWidget {
  const CryptoCard({required this.value,required this.selectedCurrency, required this.cryptoCurrency});

  final String value;
  final String selectedCurrency;
  final String cryptoCurrency;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child:  Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

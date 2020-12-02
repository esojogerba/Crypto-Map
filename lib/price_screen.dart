import 'package:crypto_map/models/coin_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  //AUD is selected as the currency by default.
  String selectedCurrency = 'AUD';

  var imageUrls = [
    "https://cryptologos.cc/logos/bitcoin-btc-logo.png?v=008",
    "https://cryptologos.cc/logos/ethereum-eth-logo.png?v=008",
    "https://cryptologos.cc/logos/litecoin-ltc-logo.png?v=008",
    "https://cryptologos.cc/logos/xrp-xrp-logo.png?v=008",
    "https://cryptologos.cc/logos/tether-usdt-logo.png?v=008",
    "https://cryptologos.cc/logos/chainlink-link-logo.png?v=008",
    "https://cryptologos.cc/logos/polkadot-new-dot-logo.png?v=008",
    "https://cryptologos.cc/logos/cardano-ada-logo.png?v=008",
    "https://cryptologos.cc/logos/binance-coin-bnb-logo.png?v=008",
    "https://cryptologos.cc/logos/stellar-xlm-logo.png?v=008",
  ];

  //Builds android drop down menu for currency selection.
  //Retrieves currencies from currenciesList.
  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    //Returns the drop down menu with the list of currencies.
    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      //When the selected currency is changed, the new values are loaded.
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData();
        });
      },
    );
  }

  //Builds ios drop down menu for currency selection.
  //Retrieces currencies from currenciesList.
  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    //Returns the drop down menu with the list of currencies.
    return CupertinoPicker(
      backgroundColor: Color(0xFFFFFFFF),
      itemExtent: 32.0,
      //When the selected currency is changed, the new values are loaded.
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getData();
        });
      },
      children: pickerItems,
    );
  }

  //Holds the current values of the cryptocurrencies.
  Map<String, String> coinValues = {};
  //Used to show wether the app is loading data atm.
  bool isWaiting = false;

  //Retrieves the current prices of the cryptocurrencies.
  void getData() async {
    isWaiting = true;
    //If no error occurs, passes the information into coinValues.
    try {
      var data = await CoinData().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        coinValues = data;
      });
      //If an error occurs, prints error code to terminal.
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  //Creates a column with individual cards for each cryptocurrency.
  SingleChildScrollView makeCards() {
    List<CryptoCard> cryptoCards = [];
    int i = 0;
    for (String crypto in cryptoList) {
      cryptoCards.add(
        CryptoCard(
          cryptoCurrency: crypto,
          selectedCurrency: selectedCurrency,
          value: isWaiting ? '?' : coinValues[crypto],
          imageUrl: imageUrls[i],
        ),
      );
      i++;
    }
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    ));
  }

  //Builds the screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          //Contains the drop down menu.
          Container(
              height: 40.0,
              alignment: Alignment.center,
              padding: EdgeInsets.all(2.0),
              color: Color(0xFF00858A),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 40.0,
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                    color: Color(0xFF00858A),
                    child: Text(
                      "Select Currency: ",
                      style: GoogleFonts.monda(
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                  Container(
                    height: 40.0,
                    alignment: Alignment.center,
                    color: Color(0xFF00858A),
                    child: Platform.isIOS ? iOSPicker() : androidDropdown(),
                  ),
                ],
              )),
          //Creates the column with the cards.
          makeCards(),
        ],
      ),
    ));
  }
}

//Class for the cards that are used to display cryptocurrency information.
class CryptoCard extends StatelessWidget {
  const CryptoCard({
    this.imageUrl,
    this.value,
    this.selectedCurrency,
    this.cryptoCurrency,
  });

  //Class variables.
  //Used to hold information that is retrieved from the API.
  final String imageUrl;
  final String value;
  final String selectedCurrency;
  final String cryptoCurrency;

  //Builds the layout of the cards.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
          color: Color(0xFF00858A),
          elevation: 10.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  alignment: Alignment.center,
                  width: 50.0,
                  height: 50.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new NetworkImage(imageUrl.toString())))),
              Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      "Current Price: ",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.monda(
                        color: Color(0xFFFFFFFF),
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                    child: Text(
                      '1 $cryptoCurrency = $value $selectedCurrency',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.monda(
                        color: Color(0xFFFFFFFF),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}

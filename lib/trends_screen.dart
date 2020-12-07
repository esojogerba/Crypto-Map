import 'package:crypto_map/models/trends_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:crypto_map/models/crypto.dart';
import 'dart:io' show Platform;
import 'dart:async';

class TrendsScreen extends StatefulWidget {
  @override
  _TrendsScreenState createState() => _TrendsScreenState();
}

class _TrendsScreenState extends State<TrendsScreen> {
  //AUD is selected as the currency by default.
  String selectedCurrency = 'USD';

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

  //Holds the cryptocurrency information.
  var cryptos = new List<Crypto>();
  //Used to show wether the app is loading data atm.
  bool isWaiting = false;

  //Retrieves the current prices of the cryptocurrencies.
  Future<void> getData() async {
    isWaiting = true;
    //If no error occurs, passes the information into coinValues.
    try {
      var data = await TrendsData().getTrendsData(selectedCurrency);
      print("loading");
      isWaiting = false;
      setState(() {
        cryptos = data;
      });
      //If an error occurs, prints error code to terminal.
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  //Creates a column with individual cards for each cryptocurrency.
  SingleChildScrollView makeCards() {
    //List of cryptocards that contain the information for each crypto.
    List<CryptoCard> cryptoCards = [];
    //Adds all of the information for each card.
    //Info is retrieved from API.
    for (int i = 0; i < cryptos.length; i++) {
      cryptoCards.add(CryptoCard(
        cryptoCurrency: cryptos[i].id.toString(),
        selectedCurrency: selectedCurrency,
        name: cryptos[i].name.toString(),
        value: isWaiting ? '?' : cryptos[i].price.toString(),
        imageUrl: cryptos[i].imageUrl.toString(),
        dayChange: cryptos[i].dayChange.toString(),
        dayTrend: cryptos[i].dayTrend.toString(),
        weekChange: cryptos[i].weekChange.toString(),
        weekTrend: cryptos[i].weekTrend.toString(),
        weeklySummary: cryptos[i].weeklySummary,
      ));
    }
    //Returns the column containing the finished cards.
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
        //Makes screen scrollable.
        body: SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFF144B4D), const Color(0xFF80A5A7)],
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //Contains the drop down menu.
            Container(
                height: 40.0,
                alignment: Alignment.center,
                padding: EdgeInsets.all(2.0),
                color: Color(0xFFCFD8DC),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 40.0,
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                      color: Color(0xFFCFD8DC),
                      child: Text(
                        "Select Currency: ",
                        style: GoogleFonts.monda(
                          color: Color(0xFF263238),
                        ),
                      ),
                    ),
                    Container(
                      height: 40.0,
                      alignment: Alignment.center,
                      color: Color(0xFFCFD8DC),
                      child: Platform.isIOS ? iOSPicker() : androidDropdown(),
                    ),
                  ],
                )),
            //Creates the column with the cards.
            makeCards(),
            //Extra container for spacing at the bottom.
            Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            )
          ],
        ),
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
    this.name,
    this.dayChange,
    this.dayTrend,
    this.weekChange,
    this.weekTrend,
    this.weeklySummary,
  });

  //Class variables.
  //Used to hold information that is retrieved from the API.
  final String imageUrl;
  final String value;
  final String selectedCurrency;
  final String cryptoCurrency;
  final String name;
  final String dayChange;
  final String dayTrend;
  final String weekChange;
  final String weekTrend;
  final Map<String, String> weeklySummary;

  //Set dates
  Container datePrices() {
    List<DatePrice> datePrices = [];
    weeklySummary.forEach((key, value) {
      datePrices.add(DatePrice(
        date: key.toString(),
        price: value.toString(),
        currency: selectedCurrency,
      ));
    });
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: datePrices,
    ));
  }

  //Returns a container with an icon for the corresponding trend type.
  Container trendIconDay() {
    //If the trend = uptrend, color is set to green and uptrend icon is used.
    if (dayTrend == "up") {
      return Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.fromLTRB(8.0, 4.0, 5.0, 4.0),
          child: Icon(
            Icons.trending_up,
            color: Colors.green[300],
            size: 20,
          ));
    }
    //If the trend = downtrend, color is set to red and downtrend icon is used.
    else {
      return Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.fromLTRB(8.0, 4.0, 5.0, 4.0),
          child: Icon(
            Icons.trending_down,
            color: Colors.red[400],
            size: 20,
          ));
    }
  }

  //Returns a container with an icon for the corresponding trend type.
  Container trendIconWeek() {
    //If the trend = uptrend, color is set to green and uptrend icon is used.
    if (weekTrend == "up") {
      return Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.fromLTRB(8.0, 4.0, 5.0, 4.0),
          child: Icon(
            Icons.trending_up,
            color: Colors.green[300],
            size: 20,
          ));
    }
    //If the trend = downtrend, color is set to red and downtrend icon is used.
    else {
      return Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.fromLTRB(8.0, 4.0, 5.0, 4.0),
          child: Icon(
            Icons.trending_down,
            color: Colors.red[400],
            size: 20,
          ));
    }
  }

  //Builds the layout of the cards.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
          color: Color(0xFFCFD8DC),
          elevation: 10.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF263238),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        //Back white circle.
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          width: 40.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(60.0),
                          ),
                        ),
                        //Contains the logo of the cryptocurrency.
                        Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            width: 30.0,
                            height: 30.0,
                            decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(imageUrl.toString())))),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Text(
                        name,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.monda(
                          color: Color(0xFFFFFFFF),
                          fontSize: 30,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              //Contains the current price information, and the current trend.
              Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.all(5.0),
                    child: Text(
                      "Today's Trend: ",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.monda(
                        color: Color(0xFF263238),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(2.0),
                    child: Text(
                      "Current Price: ",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.monda(
                        color: Color(0xFF263238),
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(2.0),
                    child: Text(
                      '1 $cryptoCurrency = $value $selectedCurrency',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.monda(
                        color: Color(0xFF263238),
                        fontSize: value.length > 10 ? 14 : 16,
                      ),
                    ),
                  ),
                  Container(
                    width: 120,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xFF263238),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    margin: EdgeInsets.fromLTRB(0, 2, 0, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //Retrieves the corresponding icon.
                        trendIconDay(),
                        //Displays change percentage.
                        //If trend = uptrend text color is set to green.
                        //If trend = downtrend text color is set to red.
                        Container(
                          alignment: Alignment.center,
                          padding:
                              const EdgeInsets.fromLTRB(5.0, 4.0, 8.0, 4.0),
                          child: Text(
                            dayChange + "%",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.monda(
                              fontWeight: FontWeight.bold,
                              color: dayTrend == "up"
                                  ? Colors.green[300]
                                  : Colors.red[400],
                              fontSize: dayChange.length > 7 ? 14 : 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(
                height: 10,
                thickness: 2,
                color: Color(0xFF263238),
                indent: 8,
                endIndent: 8,
              ),
              Column(children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.all(5.0),
                  child: Text(
                    "Weekly Trend: ",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.monda(
                      color: Color(0xFF263238),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(2.0),
                  child: Text(
                    "Price Summary for the Week: ",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.monda(
                      color: Color(0xFF263238),
                      fontSize: 18,
                    ),
                  ),
                ),
                datePrices(),
                Container(
                  width: 120,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xFF263238),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  margin: EdgeInsets.fromLTRB(0, 2, 0, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //Retrieves the corresponding icon.
                      trendIconWeek(),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      ),
                      //Displays change percentage.
                      //If trend = uptrend text color is set to green.
                      //If trend = downtrend text color is set to red.
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.fromLTRB(5.0, 4.0, 8.0, 4.0),
                        child: Text(
                          weekChange + "%",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.monda(
                            fontWeight: FontWeight.bold,
                            color: weekTrend == "up"
                                ? Colors.green[300]
                                : Colors.red[400],
                            fontSize: weekChange.length >= 6 ? 14 : 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              )
            ],
          )),
    );
  }
}

class DatePrice extends StatelessWidget {
  const DatePrice({this.date, this.price, this.currency});

  //Class variables.
  final String date;
  final String price;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "On " + date,
            textAlign: TextAlign.center,
            style: GoogleFonts.monda(
              color: Color(0xFF263238),
              fontSize: 14,
            ),
          ),
          Text(
            " = " + price + " " + currency,
            textAlign: TextAlign.center,
            style: GoogleFonts.monda(
              color: Color(0xFF263238),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

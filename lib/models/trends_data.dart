import 'dart:convert';
import 'package:crypto_map/models/crypto.dart';
import 'package:http/http.dart' as http;

//List of optional currencies that the app supports.
const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

//List of cryptocurrencies that will be displayed on the app.
const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
  'XRP',
  'USDT',
  'LINK',
  'DOT',
  'ADA',
  'BNB',
  'XLM'
];

//Map containing the image urls for each cryptocurrency
//If new cryptocurrencies are added, they must be entered here along with their image url.
const imageUrls = {
  "BTC": "https://cryptologos.cc/logos/bitcoin-btc-logo.png?v=008",
  "ETH": "https://cryptologos.cc/logos/ethereum-eth-logo.png?v=008",
  "LTC": "https://cryptologos.cc/logos/litecoin-ltc-logo.png?v=008",
  "XRP": "https://cryptologos.cc/logos/xrp-xrp-logo.png?v=008",
  "USDT": "https://cryptologos.cc/logos/tether-usdt-logo.png?v=008",
  "LINK": "https://cryptologos.cc/logos/chainlink-link-logo.png?v=008",
  "DOT": "https://cryptologos.cc/logos/polkadot-new-dot-logo.png?v=008",
  "ADA": "https://cryptologos.cc/logos/cardano-ada-logo.png?v=008",
  "BNB": "https://cryptologos.cc/logos/binance-coin-bnb-logo.png?v=008",
  "XLM": "https://cryptologos.cc/logos/stellar-xlm-logo.png?v=008",
};

//API Key: 9b5ad32f243349780b2db76ae31ba36a
const apiKey = '9b5ad32f243349780b2db76ae31ba36a';

class TrendsData {
  //Retrieves data using the selected currency.
  Future getTrendsData(String selectedCurrency) async {
    //Holds the first part of the API call url.
    var coinAPIURL = 'https://api.nomics.com/v1/currencies/ticker?key=';

    //Used to store the cryptocurrency information. This will be returned at the end.
    var cryptos = new List<Crypto>();
    //Crypto item used as a copy of the current object to pass into the list.
    Crypto clone;

    //Holds complete url.
    String requestURL = coinAPIURL +
        apiKey.toString() +
        "&ids=BTC,ETH,LTC,XRP,USDT,LINK,DOT,ADA,BNB,XLM" +
        "&convert=" +
        selectedCurrency.toString();
    //Retrieves data from API.
    http.Response response = await http.get(requestURL);
    //If no errors occur:
    if (response.statusCode == 200) {
      //Decodes the data.
      var decodedData = jsonDecode(response.body);
      //Adds all of the crypto names and their current prices, image urls.
      for (int i = 0; i < cryptoList.length; i++) {
        //Clone is reset
        clone =
            new Crypto(null, null, null, null, null, null, null, null, null);

        //Sets the id of the current crypto.
        clone.id = decodedData[i]['id'].toString();
        //Sets the name of the current crypto.
        clone.name = decodedData[i]['name'].toString();
        //Sets the price.
        var price = double.parse(decodedData[i]['price']);
        clone.price = price.toStringAsFixed(2);
        //Sets the image url.
        clone.imageUrl = imageUrls[clone.id];
        //Sets the price change percentage for today.
        var change =
            double.parse(decodedData[i]['1d']['price_change_pct']) * 100;
        clone.dayChange = change.toStringAsFixed(2);

        //If the change percentage is negative, trend is set to downtrend.
        if (change < 0) {
          clone.dayTrend = "down";
        }
        //If the change percentage is positive, trend is set to uptrend.
        else {
          clone.dayTrend = "up";
        }
        //Sets the price change percentage of the week.
        change = double.parse(decodedData[i]['7d']['price_change_pct']) * 100;
        clone.weekChange = change.toStringAsFixed(2);
        //If the change percentage is negative, trend is set to downtrend.
        if (change < 0) {
          clone.weekTrend = "down";
        }
        //If the change percentage is positive, trend is set to uptrend.
        else {
          clone.weekTrend = "up";
        }
        //Adds the copy to the cryptos list.
        cryptos.add(clone);
      }
    }
    //If an error occurs:
    else {
      print(response.statusCode);
      throw 'Problem with the get request 1';
    }
    //Variable that holds the current date.
    var currDate = DateTime.now();
    var weekAgo = currDate.subtract(Duration(days: 6));

    String endDay;
    String endMonth;
    //Makes sure both month and day are two-digits to satisfy API parameters.
    if (currDate.day < 10) {
      endDay = "0" + currDate.day.toString();
    } else {
      endDay = currDate.day.toString();
    }
    if (currDate.month < 10) {
      endMonth = "0" + currDate.month.toString();
    } else {
      endMonth = currDate.month.toString();
    }

    String startDay;
    String startMonth;
    //Makes sure both month and day are two-digits to satisfy API parameters.
    if (weekAgo.day < 10) {
      startDay = "0" + weekAgo.day.toString();
    } else {
      startDay = weekAgo.day.toString();
    }
    if (weekAgo.month < 10) {
      startMonth = "0" + weekAgo.month.toString();
    } else {
      startMonth = weekAgo.month.toString();
    }

    //Holds the first part of the API call url.
    //Changed here because we are making a different kind of call to retrieve the weekly prices.
    coinAPIURL = 'https://api.nomics.com/v1/currencies/sparkline?key=';

    //Setting the complete url.
    requestURL = coinAPIURL +
        apiKey.toString() +
        "&ids=BTC,ETH,LTC,XRP,USDT,LINK,DOT,ADA,BNB,XLM" +
        "&start=" +
        weekAgo.year.toString() +
        "-" +
        startMonth +
        "-" +
        startDay +
        "T00%3A00%3A00Z" +
        "&end=" +
        currDate.year.toString() +
        "-" +
        endMonth +
        "-" +
        endDay +
        "T00%3A00%3A00Z" +
        "&convert=" +
        selectedCurrency.toString();

    //Retrieves data from API.
    http.Response response2 = await http.get(requestURL);
    //Decodes the data.
    var decodedData2 = jsonDecode(response2.body);
    //test
    var test = decodedData2[0]['prices'][0];
    //If no errors occur:
    if (response2.statusCode == 200) {
      //Decodes the data.
      var decodedData2 = jsonDecode(response2.body);
      //Retrieves the weekly price information for each cryptocurrency.
      //Done seperately from the process above since they use two different API calls.
      for (int i = 0; i < cryptoList.length; i++) {
        //Current date is reset after every cryptocurrency is done.
        currDate = DateTime.now();
        //Used to copy to crypto object.
        var summaryCopy = new Map<String, String>();
        //Holds the correct index for the current crypto.
        int index = 0;
        //Find the correct information for the current cryptocurrency.
        //The data from the API call is set up in alphabetical order so we must do this.
        for (int x = 0; x < 10; x++) {
          if (decodedData2[x]['currency'].toString() == cryptos[i].id) {
            index = x;
          }
        }
        //Once the correct index is found, the weekly prices can be added.
        for (int j = 0; j < 7; j++) {
          //Current date is reset after every day is added.
          currDate = DateTime.now();
          //With the way the API is set up, the entries are done from the end to the start of the time parameters.
          //Because of this, we must work backwards when adding the weekly entries.
          currDate = currDate.subtract(Duration(days: 6 - j));
          //The weekly entry is added to the crypto currency's weeklySummary map.
          //Both the date and the price at that date are stored in the map.
          var price = double.parse(decodedData2[index]['prices'][j]);
          //Add the date and the price to the map.
          summaryCopy.putIfAbsent(
              currDate.month.toString() +
                  "-" +
                  currDate.day.toString() +
                  "-" +
                  currDate.year.toString(),
              () => price.toStringAsFixed(2));
        }
        //Copy the summaryCopy map to the crypto's map.
        cryptos[i].weeklySummary = summaryCopy;
      }
    }
    //If an error occurs:
    else {
      print(response2.statusCode);
      throw 'Problem with the get request 2';
    }

    return cryptos;
  }
}

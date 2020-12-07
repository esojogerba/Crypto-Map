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

class CoinData {
  //Retrieves data using the selected currency.
  Future getCoinData(String selectedCurrency) async {
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

        //Sets the name of the current crypto.
        clone.id = decodedData[i]['id'].toString();
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
    return cryptos;
  }
}

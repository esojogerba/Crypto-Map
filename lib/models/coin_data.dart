import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

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

//const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';
const coinAPIURL = 'https://api.nomics.com/v1/currencies/ticker?key=';
//API Key: 9b5ad32f243349780b2db76ae31ba36a
//const apiKey = '9C054822-766D-4810-980B-F48B8D6AF2BB';
const apiKey = '9b5ad32f243349780b2db76ae31ba36a';

class CoinData {
  //Retrieves data using the selected currency.
  Future getCoinData(String selectedCurrency) async {
    //Used to store the cryptocurrency and its current price
    Map<String, String> cryptoPrices = {};

    for (String crypto in cryptoList) {
      //Holds url.
      String requestURL = coinAPIURL +
          apiKey.toString() +
          "&ids=" +
          crypto.toString() +
          "&convert=" +
          selectedCurrency.toString();
      //Retrieves data from API.
      http.Response response = await http.get(requestURL);
      //If no errors occur:
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        var price = double.parse(decodedData[0]['price']);
        cryptoPrices[crypto] = price.toStringAsFixed(2);
      }
      //If an error occurs:
      else {
        print(response.statusCode);
        throw 'Problem with the get request';
      }
    }
    return cryptoPrices;
  }
}

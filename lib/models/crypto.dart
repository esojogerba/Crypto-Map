class Crypto {
  //Holds the current price.
  var price;
  //Holds the logo image url.
  var imageUrl;
  //Holds a list of the prices in a week.
  var weeklySummary = new List<String>();
  //Holds the change percent.
  var change;
  //Holds wether the crypto is in downtrend or uptrend.
  var trend;

  Crypto(
      this.price, this.imageUrl, this.weeklySummary, this.change, this.trend);
}

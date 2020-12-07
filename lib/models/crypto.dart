class Crypto {
  //Holds the id of the cryptocurrency.
  var id;
  //Holds the name of the cryptocurrency.
  var name;
  //Holds the current price.
  var price;
  //Holds the logo image url.
  var imageUrl;
  //Holds a list of the prices in a week.
  var weeklySummary = new Map<String, String>();
  //Holds the change percent for today.
  var dayChange;
  //Holds wether the crypto is in downtrend or uptrend for today.
  var dayTrend;
  //Holds the change percent for the week.
  var weekChange;
  //Holds wether the crypto is in downtrend or uptrend for the week.
  var weekTrend;

  Crypto(this.id, this.name, this.price, this.imageUrl, this.weeklySummary,
      this.dayChange, this.dayTrend, this.weekChange, this.weekTrend);
}

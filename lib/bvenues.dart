import 'package:google_maps_flutter/google_maps_flutter.dart';

class Bvenues {
  String shopName;
  String address;
  String description;
  String thumbNail;
  LatLng locationCoords;

  Bvenues(
      {this.shopName,
      this.address,
      this.description,
      this.thumbNail,
      this.locationCoords});
}

final List<Bvenues> bvenuesShops = [
  Bvenues(
      shopName: 'Coinme Bitcoin ATM',
      address: ' 2200 S 10th St, McAllen',
      description: 'ATM',
      locationCoords: LatLng(26.18455247905821, -98.2356538599739),
      thumbNail:
          'https://s27389.pcdn.co/wp-content/uploads/2020/06/bitcoin-cryptocurrencies-perfect-hedge-covid-19-crisis.jpeg'),
  Bvenues(
      shopName: 'El Znack de la 17',
      address: '17th 317, 78501 Mcallen',
      description: 'Mexican Food',
      locationCoords: LatLng(26.2012062309521, -98.2382065057755),
      thumbNail:
          'https://s27389.pcdn.co/wp-content/uploads/2020/06/bitcoin-cryptocurrencies-perfect-hedge-covid-19-crisis.jpeg'),
  Bvenues(
      shopName: 'REEDS Jewelers',
      address: 'xpressway 77 North Frontage',
      description: 'Jewelers',
      locationCoords: LatLng(27.7120005, -97.3739824),
      thumbNail:
          'https://s27389.pcdn.co/wp-content/uploads/2020/06/bitcoin-cryptocurrencies-perfect-hedge-covid-19-crisis.jpeg'),
  Bvenues(
      shopName: 'Brann Insurance',
      address: 'First National Boulevard ',
      description: 'Insurance company',
      locationCoords: LatLng(27.668656, -97.2875652),
      thumbNail:
          'https://s27389.pcdn.co/wp-content/uploads/2020/06/bitcoin-cryptocurrencies-perfect-hedge-covid-19-crisis.jpeg'),
  Bvenues(
      shopName: 'Sea Shell Inn Motel',
      address: 'Kleberg Place 202',
      description: 'Motel',
      locationCoords: LatLng(27.8203624, -97.3884958),
      thumbNail:
          'https://s27389.pcdn.co/wp-content/uploads/2020/06/bitcoin-cryptocurrencies-perfect-hedge-covid-19-crisis.jpeg')
];

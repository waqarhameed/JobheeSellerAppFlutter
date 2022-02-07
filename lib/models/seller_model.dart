class Seller {
  String address,
      businessType,
      description,
      fcm,
      name,
      onlineStatus,
      picUrl,
      uuid;

  Seller(
      this.address,
      this.blockByAdmin,
      this.businessType,
      this.description,
      this.completeOrders,
      this.timeStamp,
      this.lat,
      this.lng,
      this.name,
      this.onlineStatus,
      this.picUrl,
      this.fcm,
      this.rating,
      this.uuid);

  int blockByAdmin, completeOrders, rating;
  double lat;
  double lng;
  String timeStamp;

  factory Seller.fromJson(Map<String, dynamic> response) => Seller(
        response['address'],
        response['blockByAdmin'],
        response['businessType'],
        response['businessDescription'],
        response['completeOrders'],
        response['joinTimeStamp'],
        response['lat'],
        response['lng'],
        response['name'],
        response['onlineStatus'],
        response['picUrl'],
        response['fcm'],
        response['rating'],
        response['uuid'],
      );
}

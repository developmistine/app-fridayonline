class ProfileData {
  String registerId;
  String registerType;
  String mobile;
  String email;
  String prefix;
  String firstName;
  String lastName;
  String messageUnpaid;
  String displayName;
  String image;
  bool isUnpaid;
  String gender;
  String birthDate;
  String ranking;
  double coinBalance;

  ProfileData({
    required this.registerId,
    required this.registerType,
    required this.mobile,
    required this.email,
    required this.prefix,
    required this.firstName,
    required this.lastName,
    required this.messageUnpaid,
    required this.displayName,
    required this.image,
    required this.isUnpaid,
    required this.gender,
    required this.birthDate,
    required this.ranking,
    required this.coinBalance,
  });

  // ✅ Convert JSON to ProfileData (handles "data" key)
  factory ProfileData.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {}; // Extract the "data" key

    return ProfileData(
      registerId: data['register_id'] ?? '',
      registerType: data['register_type'] ?? '',
      mobile: data['mobile'] ?? '',
      email: data['email'] ?? '',
      prefix: data['prefix'] ?? '',
      firstName: data['first_name'] ?? '',
      lastName: data['last_name'] ?? '',
      messageUnpaid: data['message_unpaid'] ?? '',
      displayName: data['display_name'] ?? '',
      image: data['image'] ?? '',
      isUnpaid: data['is_unpaid'],
      gender: data['gender'] ?? '',
      birthDate: data['birth_date'] ?? '',
      ranking: data['ranking'] ?? '',
      coinBalance: data['coin_balance']?.toDouble() ?? 0,
    );
  }
}

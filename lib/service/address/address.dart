 
class Address {
  const Address({
    required this.name,
    required this.tumbon,
    required this.tumbonID,
    required this.amphur,
    required this.amphurID,
    required this.province,
    required this.provinceID,
    required this.postCode,
  });

  final String name;
  final String tumbon;
  final String tumbonID;
  final String amphur;
  final String amphurID;
  final String province;
  final String provinceID;
  final String postCode;

  @override
  String toString() {
    return '$name, $tumbon, $tumbonID, $amphur, $amphurID, $province, $provinceID, $postCode';
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is Address &&
        other.name == name &&
        other.tumbon == tumbon &&
        other.tumbonID == tumbonID &&
        other.amphur == amphur &&
        other.amphurID == amphurID &&
        other.province == province &&
        other.provinceID == provinceID &&
        other.postCode == postCode;
  }

  @override
  int get hashCode => Object.hash(
      name, tumbon, tumbonID, amphur, amphurID, province, provinceID, postCode);
}

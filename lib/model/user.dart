class User {
  int? id;
  String? name;
  double? money;

  userMap() {
    var mapping = <String, dynamic>{};
    mapping['id'] = id;
    mapping['name'] = name!;
    mapping['amount'] = money ?? 0.0;
    return mapping;
  }
}

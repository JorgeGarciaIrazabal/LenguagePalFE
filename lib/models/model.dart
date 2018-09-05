import 'package:intl/intl.dart';

class Model {
  int id;
  DateTime updatedAt = new DateTime.fromMillisecondsSinceEpoch(0);

  Model.fromMap(Map<String, dynamic> map) {
    this.mergeMap(map);
  }

  Map<String, dynamic> toMap() {
    var formatter = new DateFormat('yyyy-MM-ddThh:mm:ss.000');
    return {
      'updated_at': formatter.format(this.updatedAt),
      'id': this.id,
    };
  }

  Map<String, dynamic> toMapToUpload() {
    var map = toMap();
    map.remove('id');
    map.remove('updated_at');
    map.remove('created_at');
    return map;
  }

  Model mergeMap(Map<String, dynamic> map) {
    if (map == null) {
      return this;
    }
    if (map.containsKey('updated_at') && map['updated_at'] is String) {
      this.updatedAt = DateTime.parse(map['updated_at']);
    } else {
      this.updatedAt = map['updated_at'] ?? this.updatedAt;
    }
    this.id = map['id'] ?? this.id;
    return this;
  }
}

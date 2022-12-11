/// tips : [{"id":"B0FFKEPXS2","name":"肯德基(望京西)","district":"北京市朝阳区","adcode":"110105","location":"116.473974,39.997746","address":"望京西园4区410号学生宿舍1层","typecode":"050301","city":[]},{"id":"B000A7BM4H","name":"肯德基(花家地餐厅)","district":"北京市朝阳区","adcode":"110105","location":"116.469232,39.985570","address":"花家地小区1号商业楼","typecode":"050301","city":[]},{"id":"B000A7C99U","name":"肯德基(北京酒仙桥餐厅)","district":"北京市朝阳区","adcode":"110105","location":"116.490332,39.976127","address":"酒仙桥路12号(将台地铁站A西北口步行410米)","typecode":"050301","city":[]},{"id":"B000A7FVJQ","name":"肯德基(中福百货餐厅)","district":"北京市朝阳区","adcode":"110105","location":"116.463379,40.000509","address":"望京南湖东园201号楼1层","typecode":"050301","city":[]},{"id":"B0FFHPAN04","name":"肯德基(望京西路餐厅)","district":"北京市朝阳区","adcode":"110105","location":"116.456783,39.994733","address":"望京西路41号梦秀欢乐广场1层","typecode":"050301","city":[]},{"id":"B0G2M1YPQ8","name":"肯德基(酒仙桥东路)","district":"北京市朝阳区","adcode":"110105","location":"116.499839,39.974506","address":"酒仙桥东路18号1号楼一层B103、二层B206","typecode":"050301","city":[]},{"id":"B0FFIPRH9X","name":"肯德基(利泽西街店)","district":"北京市朝阳区","adcode":"110105","location":"116.466683,40.010833","address":"广顺北大街17号六佰本商业街北区(东湖渠地铁站A西北口旁)","typecode":"050301","city":[]},{"id":"B000A80GPM","name":"肯德基(酒仙桥二店)","district":"北京市朝阳区","adcode":"110105","location":"116.495381,39.961930","address":"酒仙桥路39号京客隆购物广场地下一层","typecode":"050301","city":[]},{"id":"B0HKALPLKP","name":"肯德基(霄云路餐厅)","district":"北京市朝阳区","adcode":"110105","location":"116.464691,39.959179","address":"霄云路27号中国庆安大厦F1层","typecode":"050301","city":[]}]
/// status : "1"
/// info : "OK"
/// infocode : "10000"
/// count : "10"

class InputHelpModel {
  InputHelpModel({
      this.tips, 
      this.status, 
      this.info, 
      this.infocode, 
      this.count,});

  InputHelpModel.fromJson(dynamic json) {
    if (json['tips'] != null) {
      tips = [];
      json['tips'].forEach((v) {
        tips?.add(Tips.fromJson(v));
      });
    }
    status = json['status'];
    info = json['info'];
    infocode = json['infocode'];
    count = json['count'];
  }
  List<Tips>? tips;
  String? status;
  String? info;
  String? infocode;
  String? count;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (tips != null) {
      map['tips'] = tips?.map((v) => v.toJson()).toList();
    }
    map['status'] = status;
    map['info'] = info;
    map['infocode'] = infocode;
    map['count'] = count;
    return map;
  }

}

/// id : "B0FFKEPXS2"
/// name : "肯德基(望京西)"
/// district : "北京市朝阳区"
/// adcode : "110105"
/// location : "116.473974,39.997746"
/// address : "望京西园4区410号学生宿舍1层"
/// typecode : "050301"
/// city : []

class Tips {
  Tips({
      this.id, 
      this.name, 
      this.district, 
      this.adcode, 
      this.location, 
      this.address, 
      this.typecode, 
      this.city,});

  Tips.fromJson(dynamic json) {
    id = json['id'] is String ?json['id']:'';
    name = json['name'] is String ?json['name']:'';
    district = json['district'] is String ?json['district']:'';
    adcode = json['adcode'] is String ?json['adcode']:'';
    location = json['location'] is String ?json['location']:'';
    address = json['address'] is String ?json['address']:'';
    typecode = json['typecode'] is String ?json['typecode']:'';
    if (json['city'] != null) {
      city = json['city'];
    }
  }
  String? id;
  String? name;
  String? district;
  String? adcode;
  String? location;
  String? address;
  String? typecode;
  List<dynamic>? city;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['district'] = district;
    map['adcode'] = adcode;
    map['location'] = location;
    map['address'] = address;
    map['typecode'] = typecode;
    if (city != null) {
      map['city'] = city?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}
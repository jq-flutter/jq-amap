/// count : "10"
/// infocode : "10000"
/// pois : [{"typecode":"190104","address":"福田区","adname":"福田区","citycode":"0755","pcode":"440000","adcode":"440304","pname":"广东省","cityname":"深圳市","name":"深圳市","location":"114.057939,22.543527","id":"B02F38IWRJ","type":"地名地址信息;普通地名;地市级地名"},{"typecode":"150200","address":"建设路1号","adname":"罗湖区","citycode":"0755","pcode":"440000","adcode":"440303","pname":"广东省","cityname":"深圳市","name":"深圳站","location":"114.117751,22.531948","id":"B02F30A89U","type":"交通设施服务;火车站;火车站"},{"typecode":"080601","address":"新园路1号中海商城1层(老街地铁站F口旁)","adname":"罗湖区","citycode":"0755","pcode":"440000","adcode":"440303","pname":"广东省","cityname":"深圳市","name":"深圳戏院(新园路店)","location":"114.116491,22.545469","id":"B02F3007CE","type":"体育休闲服务;影剧院;电影院"},{"typecode":"130103","address":"深南大道2006号深圳海关科技信息业务综合大楼(凤凰大厦)","adname":"福田区","citycode":"0755","pcode":"440000","adcode":"440304","pname":"广东省","cityname":"深圳市","name":"深圳海关","location":"114.066220,22.541803","id":"B02F37VWLJ","type":"政府机构及社会团体;政府机关;地市级政府及事业单位"},{"typecode":"141201","address":"粤海街道深大社区南海大道3688号","adname":"南山区","citycode":"0755","pcode":"440000","adcode":"440305","pname":"广东省","cityname":"深圳市","name":"深圳大学(粤海校区)","location":"113.936683,22.532681","id":"B02F37UIGT","type":"科教文化服务;学校;高等院校"},{"typecode":"150200","address":"民治街道北站社区致远中路28号","adname":"龙华区","citycode":"0755","pcode":"440000","adcode":"440309","pname":"广东省","cityname":"深圳市","name":"深圳北站","location":"114.029500,22.609875","id":"B02F38IPWZ","type":"交通设施服务;火车站;火车站"},{"typecode":"150202","address":"人民南路与和平路交叉口东150米","adname":"罗湖区","citycode":"0755","pcode":"440000","adcode":"440303","pname":"广东省","cityname":"深圳市","name":"深圳站(南进站口)","location":"114.117496,22.530750","id":"B0FFGXM0P6","type":"交通设施服务;火车站;进站口/检票口"},{"typecode":"150203","address":"和平路1008号(罗湖地铁站出入口步行250米)","adname":"罗湖区","citycode":"0755","pcode":"440000","adcode":"440303","pname":"广东省","cityname":"深圳市","name":"深圳站(西出站口)","location":"114.116456,22.532372","id":"B0FFGYZO8C","type":"交通设施服务;火车站;出站口"},{"typecode":"061205","address":"粤海街道海珠社区南海大道2748号","adname":"南山区","citycode":"0755","pcode":"440000","adcode":"440305","pname":"广东省","cityname":"深圳市","name":"深圳书城(南山店)","location":"113.929840,22.519265","id":"B02F30A8TO","type":"购物服务;专卖店;书店"},{"typecode":"190205","address":"罗湖区","adname":"罗湖区","citycode":"0755","pcode":"440000","adcode":"440303","pname":"广东省","cityname":"深圳市","name":"深圳水库","location":"114.153497,22.573481","id":"B0FFFEDNIM","type":"地名地址信息;自然地名;湖泊"}]
/// status : "1"
/// info : "OK"

class PoisModel {
  PoisModel({
      this.count, 
      this.infocode, 
      this.pois, 
      this.status, 
      this.info,});

  PoisModel.fromJson(dynamic json) {
    count = json['count'];
    infocode = json['infocode'];
    if (json['pois'] != null) {
      pois = [];
      json['pois'].forEach((v) {
        pois?.add(Pois.fromJson(v));
      });
    }
    status = json['status'];
    info = json['info'];
  }
  String? count;
  String? infocode;
  List<Pois>? pois;
  String? status;
  String? info;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['count'] = count;
    map['infocode'] = infocode;
    if (pois != null) {
      map['pois'] = pois?.map((v) => v.toJson()).toList();
    }
    map['status'] = status;
    map['info'] = info;
    return map;
  }

}

/// typecode : "190104"
/// address : "福田区"
/// adname : "福田区"
/// citycode : "0755"
/// pcode : "440000"
/// adcode : "440304"
/// pname : "广东省"
/// cityname : "深圳市"
/// name : "深圳市"
/// location : "114.057939,22.543527"
/// id : "B02F38IWRJ"
/// type : "地名地址信息;普通地名;地市级地名"

class Pois {
  Pois({
      this.typecode, 
      this.address, 
      this.adname, 
      this.citycode, 
      this.pcode, 
      this.adcode, 
      this.pname, 
      this.cityname, 
      this.name, 
      this.location, 
      this.id, 
      this.type,});

  Pois.fromJson(dynamic json) {
    typecode = json['typecode'];
    address = json['address'];
    adname = json['adname'];
    citycode = json['citycode'];
    pcode = json['pcode'];
    adcode = json['adcode'];
    pname = json['pname'];
    cityname = json['cityname'];
    name = json['name'];
    location = json['location'];
    id = json['id'];
    type = json['type'];
  }
  String? typecode;
  String? address;
  String? adname;
  String? citycode;
  String? pcode;
  String? adcode;
  String? pname;
  String? cityname;
  String? name;
  String? location;
  String? id;
  String? type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['typecode'] = typecode;
    map['address'] = address;
    map['adname'] = adname;
    map['citycode'] = citycode;
    map['pcode'] = pcode;
    map['adcode'] = adcode;
    map['pname'] = pname;
    map['cityname'] = cityname;
    map['name'] = name;
    map['location'] = location;
    map['id'] = id;
    map['type'] = type;
    return map;
  }

  @override
  String toString() {
    return 'Pois{typecode: $typecode, address: $address, adname: $adname, citycode: $citycode, pcode: $pcode, adcode: $adcode, pname: $pname, cityname: $cityname, name: $name, location: $location, id: $id, type: $type}';
  }
}
import 'dart:developer' as dev;

/// toto: 高德API访问状态
enum AmapStatus{
  error,
  success,
}

/// todo：高德请求常用状态码
/// 更多详情:https://lbs.amap.com/api/webservice/guide/tools/info
Map<String, dynamic> amapRespCodeMap = {
  "10000": "请求正常",
  "10041": "请求的接口权限已过期",
  "10044": "单日请求量已超出限额",
  "20000": "请求参数非法",
  "20012": "查询的信息存在非法内容",
  "40000": "所购买服务的余额耗尽，无法继续使用服务",
  "40002": "所购买的服务期限已到，无法继续使用",
  "10026": "由于违规行为，高德账号被封禁不可用",
  "10013": "当前所用Key已被开发者删除",
  "10001": "当前所用Key不正确或者过期 ",
  "10004": "请求操作过于频繁封停1分钟,1分钟后解封"
};

/// todo: 获取状态码描述
getAmapCodeDesc(String infoCode){
  // 查找本地是否存在该code
  if (amapRespCodeMap.containsKey(infoCode)) {
    dev.log(
      amapRespCodeMap[infoCode],
      name: "地图请求状态码",
    );
    return amapRespCodeMap[infoCode];
  } else {
    dev.log(
      "本地未找到（状态码：$infoCode）,请查阅https://lbs.amap.com/api/webservice/guide/tools/info",
      name: "地图请求状态码",
    );
    return "错误：$infoCode";
  }
}

/// todo：检查高德请求返回状态
checkAmapMapStatus(String infoCode) {
  // 查找本地是否存在该code
  if (amapRespCodeMap.containsKey(infoCode)) {
    dev.log(
      amapRespCodeMap[infoCode],
      name: "地图请求状态码校验",
    );
    return infoCode == "10000" ?true:false;
  } else {
    dev.log(
      "本地未找到（状态码：$infoCode）,请查阅https://lbs.amap.com/api/webservice/guide/tools/info",
      name: "地图请求状态码校验",
    );
    return false;
  }
}

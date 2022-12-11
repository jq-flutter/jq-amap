import 'dart:typed_data';
import 'dart:ui';

import 'package:jqmap/constant/constant.dart';
import 'package:jqmap/model/BckModel.dart';
import 'package:jqmap/model/InputHelpModel.dart';
import 'package:jqmap/model/PoisModel.dart';
import 'package:jqmap/utils/status_code_util.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/src/types/types.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

class JqAmapPage extends StatefulWidget {
  const JqAmapPage({
    Key? key,
  }) : super(key: key);

  @override
  State<JqAmapPage> createState() => JqAmapPageState();
}

class JqAmapPageState extends State<JqAmapPage> with WidgetsBindingObserver {
  ///先将申请的Android端可以和iOS端key设置给AMapApiKey
  AMapApiKey amapApiKeys = AMapApiKey(
    androidKey: amapConfig.androidKey,
    iosKey: amapConfig.iosKey,
  );

  /// 初始化位置
  final CameraPosition _kInitialPosition = CameraPosition(
    target: myLatLng,
    zoom: 10.0,
  );

  /// 地图版本号
  List<Widget> _approvalNumberWidget = [];

  /// 地图控制器
  AMapController? _mapController;

  /// 选择的位置
  int? selectIndex;

  /// 网络请求库
  Dio dio = Dio();

  /// 输入框是否弹出
  bool input = false;

  /// 周边数据
  List<Pois> pois = [];

  /// 输入提示
  List<Tips> tips = [];

  /// 菊花
  bool loading = false;

  /// 输入框
  TextEditingController textEditingController = TextEditingController(text: "深圳");

  /// 我的中心点marker
  final Marker marker = Marker(
    position: myLatLng,
    //使用默认hue的方式设置Marker的图标
    icon: BitmapDescriptor.defaultMarker,
  );

  static const AMapPrivacyStatement amapPrivacyStatement = AMapPrivacyStatement(
    hasContains: true,
    hasShow: true,
    hasAgree: true,
  );

  final Map<String, Marker> markerMap = <String, Marker>{};

  setLoading() {
    loading = !loading;
    update();
  }

  search() async {
    tips.clear();
    setLoading();
    Response response = await dio.get(
      "https://restapi.amap.com/v5/place/text",
      queryParameters: {
        "key": amapConfig.webKey,
        "keywords": textEditingController.text,
      },
    );
    setLoading();
    update();
    if (response.statusCode == 200) {
      PoisModel poisModel = PoisModel.fromJson(response.data);
      if (poisModel.status == "${AmapStatus.success.index}" && checkAmapMapStatus("${poisModel.infocode}")) {
        pois = poisModel.pois ?? [];
        if (pois.isNotEmpty) {
          var lac = pois[0].location!.split(",");
          _mapController!.moveCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                //中心点
                target: LatLng(double.parse(lac[1]), double.parse(lac[0])),
                zoom: 18,
              ),
            ),
          );
        }
        update();
      } else {
        showSnackBar("搜索：${getAmapCodeDesc(poisModel.infocode!)}");
      }
    }
  }

  getList({moveLatLan}) async {
    setLoading();
    Response response = await dio.get(
      "https://restapi.amap.com/v5/place/around",
      queryParameters: {
        "key": amapConfig.webKey,
        "location": moveLatLan,
      },
    );
    setLoading();
    if (response.statusCode == 200) {
      PoisModel poisModel = PoisModel.fromJson(response.data);
      if (poisModel.status == "${AmapStatus.success.index}" && checkAmapMapStatus("${poisModel.infocode}")) {
        pois = poisModel.pois ?? [];
        update();
      } else {
        showSnackBar("周边搜索: ${getAmapCodeDesc("${poisModel.infocode}")}");
      }
    }
  }

  inputHelp() async {
    setLoading();
    Response response = await dio.get(
      "https://restapi.amap.com/v3/assistant/inputtips",
      queryParameters: {
        "key": amapConfig.webKey,
        "keywords": textEditingController.text,
      },
    );
    setLoading();
    if (response.statusCode == 200) {
      InputHelpModel inputHelpModel = InputHelpModel.fromJson(response.data);
      if (inputHelpModel.status == "${AmapStatus.success.index}" && checkAmapMapStatus("${inputHelpModel.infocode}")) {
        tips = inputHelpModel.tips ?? [];
        update();
      } else {
        showSnackBar("输入提示: ${getAmapCodeDesc("${inputHelpModel.infocode}")}");
      }
    }
  }

  Future<Uint8List> takeSnapshot() async {
    final imageBytes = await _mapController?.takeSnapshot();
    if (imageBytes == null) {
      dev.log("截图失败", name: "高德地图");
      return Uint8List.fromList([]);
    }
    dev.log("截图成功", name: "高德地图");
    return imageBytes;
  }

  void onMapCreated(AMapController controller) {
    _mapController = controller;
    getApprovalNumber();
    update();
  }

  /// 获取审图号
  void getApprovalNumber() async {
    //普通地图审图号
    String? mapContentApprovalNumber = await _mapController?.getMapContentApprovalNumber();
    //卫星地图审图号
    String? satelliteImageApprovalNumber = await _mapController?.getSatelliteImageApprovalNumber();
    if (null != mapContentApprovalNumber) {
      _approvalNumberWidget.add(Text(
        mapContentApprovalNumber,
        style: const TextStyle(fontSize: 10),
      ));
    }
    if (null != satelliteImageApprovalNumber) {
      _approvalNumberWidget.add(Text(satelliteImageApprovalNumber, style: const TextStyle(fontSize: 10)));
    }
    update();
  }

  void showSnackBar(String msg) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    /// 初始化
    WidgetsBinding.instance.addObserver(this);
    search();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (MediaQuery.of(context).viewInsets.bottom == 0) {
        /// 键盘收回
        input = false;
        update();
      } else {
        /// 键盘弹出
        input = true;
        update();
      }
    });
  }

  @override
  void dispose() {
    /// 销毁
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    if (_mapController != null) {
      _mapController!.disponse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildMap(),
            buildSearchInput(),
            const Divider(height: 1),
            tips.isNotEmpty ? inputHelpList() : buildSearchList(),
          ],
        ),
      ),
      onWillPop: () async => false,
    );
  }

  Widget headerTop() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.35),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 70,
              child: MaterialButton(
                onPressed: () => Navigator.pop(context),
                elevation: 0,
                child: const Text(
                  "取消",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            SizedBox(
              width: 60,
              height: 28,
              child: selectIndex == null
                  ? null
                  : MaterialButton(
                      onPressed: () async {
                        Uint8List? temp;
                        if (amapConfig.isSnapshot) {
                          temp = await takeSnapshot();
                        }
                        dev.log(pois[selectIndex!].toString(), name: "地图返回");
                        Navigator.pop(
                          context,
                          AmapBackModel(
                            pois: pois[selectIndex!],
                            snapshot: temp,
                          ),
                        );
                      },
                      color: Colors.white,
                      elevation: 0,
                      child: Text(
                        "选择",
                        style: TextStyle(color: Colors.grey.shade700, height: 1.1, fontSize: 14),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSearchInput() {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                color: Colors.grey.shade600,
                size: 17,
              ),
              Text(
                " 深圳市 ",
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                  height: 1.1,
                ),
              ),
            ],
          ),
          Flexible(
            child: Container(
              height: 32,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                controller: textEditingController,
                onChanged: (v) {
                  inputHelp();
                  update();
                },
                style: TextStyle(color: Colors.grey.shade800, fontSize: 14),
                decoration: InputDecoration(
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 40,
                    maxWidth: 40,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Colors.grey.shade700,
                    size: 18,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 11,
                  ),
                  hintText: "搜索",
                  border: InputBorder.none,
                  suffixIcon: textEditingController.text == ""
                      ? const SizedBox()
                      : SizedBox(
                          width: 50,
                          child: MaterialButton(
                            elevation: 0.3,
                            onPressed: () => search(),
                            color: Colors.grey.shade100,
                            padding: EdgeInsets.all(0),
                            child: Text(
                              "搜索",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 14,
                                height: 1.1,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearchList() {
    return Expanded(
      child: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Listener(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(0),
                cacheExtent: 300,
                itemBuilder: (ctx, index) => ListTile(
                  title: Text(
                    "${pois[index].name}",
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  subtitle: Text(
                    "${pois[index].pname}${pois[index].cityname}${pois[index].adname}${pois[index].address == pois[index].adname ? '' : pois[index].address}",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  trailing: Icon(
                    Icons.check_rounded,
                    color: selectIndex == index ? Colors.blue : Colors.transparent,
                    size: 25,
                  ),
                  minVerticalPadding: 10,
                  minLeadingWidth: 0,
                  onTap: () {
                    selectIndex = index;
                    update();
                    var lac = pois[index].location!.split(",");
                    _mapController!.moveCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(
                        //中心点
                        target: LatLng(double.parse(lac[1]), double.parse(lac[0])),
                        zoom: 18,
                      ),
                    ));
                  },
                ),
                separatorBuilder: (ctx, index) => Divider(
                  height: 0,
                  endIndent: 15,
                  indent: 15,
                  color: Colors.grey.shade300,
                ),
                itemCount: pois.length,
                shrinkWrap: true,
              ),
              onPointerMove: (v) => FocusScope.of(context).requestFocus(FocusNode()),
            ),
    );
  }

  Widget inputHelpList() {
    return Expanded(
      child: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Listener(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(0),
                cacheExtent: 300,
                itemBuilder: (ctx, index) => ListTile(
                  title: TextHighlight(tips[index].name!, textEditingController.text),
                  leading: Icon(
                    Icons.location_on_outlined,
                    color: Colors.grey.shade300,
                    size: 22,
                  ),
                  trailing: Icon(
                    Icons.turn_left,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
                  minVerticalPadding: 10,
                  minLeadingWidth: 0,
                  onTap: () {
                    textEditingController.text = tips[index].name!;
                    search();
                  },
                ),
                separatorBuilder: (ctx, index) => Divider(
                  height: 0,
                  endIndent: 15,
                  indent: 15,
                  color: Colors.grey.shade300,
                ),
                itemCount: tips.length,
                shrinkWrap: true,
              ),
              onPointerMove: (v) => FocusScope.of(context).requestFocus(FocusNode()),
            ),
    );
  }

  Widget buildMap() {
    markerMap[marker.id] = marker;
    final AMapWidget map = AMapWidget(
      touchPoiEnabled: true,
      initialCameraPosition: _kInitialPosition,
      onMapCreated: onMapCreated,
      apiKey: amapApiKeys,
      privacyStatement: amapPrivacyStatement,
      markers: Set<Marker>.of(markerMap.values),
      onCameraMoveEnd: (v) {
        print("移动结束=>${v.target}");
        // final Marker marker1 = Marker(
        //   position: v.target,
        //   icon: BitmapDescriptor.defaultMarker,
        // );
        // markerMap.clear();
        // markerMap[marker1.id] = marker1;
        getList(moveLatLan: "${v.target.longitude},${v.target.latitude}");
        update();
      },
      onCameraMove: (v) => print("333"),
      onLocationChanged: (v) => print("44444"),
    );
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.33,
          child: map,
        ),
        Center(
          child: Icon(
            Icons.location_on,
            size: 30,
            color: Colors.blue.shade700,
          ),
        ),
        Positioned(top: 0, child: headerTop()),
        Positioned(
          bottom: 20,
          right: 20,
          child: InkWell(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey.shade400,
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.my_location_rounded,
                size: 18,
                color: Colors.grey.shade600,
              ),
              padding: EdgeInsets.all(7),
            ),
            onTap: () {
              _mapController!.moveCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                  //中心点
                  target: LatLng(31.230378, 121.473658),
                ),
              ));
            },
          ),
        ),
        // Positioned(
        //   child: Row(
        //     children: _approvalNumberWidget,
        //   ),
        //   right: 10,
        //   bottom: 5,
        // )
      ],
    );
  }

  update() => setState(() => null);
}

//从_content字符串中将_keyWord高亮显示
//注意：字体颜色默认为白色
class TextHighlight extends StatelessWidget {
  final TextStyle? normalStyle = TextStyle(color: Colors.grey.shade800,fontSize: 14); //正常样式
  final TextStyle? highlightStyle=TextStyle(color: Colors.blue.shade600,fontSize: 14); //高亮样式
  final String content; //字符串
  final String keyWord; //字符串中需要高亮的关键字

  TextHighlight(this.content, this.keyWord, );

  @override
  Widget build(BuildContext context) {
    if (this.keyWord == null || this.keyWord == "")
      return Text(
        content,
        style: normalStyle,
      );
    List<TextSpan> spans = [];
    int start = 0;
    int end;
    while ((end = content.indexOf(keyWord, start)) != -1) {
      spans.add(TextSpan(text: content.substring(start, end), style: normalStyle));
      spans.add(TextSpan(text: keyWord, style: highlightStyle));
      start = end + keyWord.length;
    }
    spans.add(TextSpan(text: content.substring(start, content.length), style: normalStyle));
    return RichText(
      text: TextSpan(children: spans),
    );
  }
}

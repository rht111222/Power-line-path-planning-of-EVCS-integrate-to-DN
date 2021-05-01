<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page import="com.mathworks.toolbox.javabuilder.MWClassID" %>
<%@ page import="com.mathworks.toolbox.javabuilder.MWException" %>
<%@ page import="com.mathworks.toolbox.javabuilder.MWCharArray"%>
<%@ page import="bianyaqi_chongdianzhan.Class3" %>
<%@ page import="loukuai_jianmofanwei.Class1" %>
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'MyJsp.jsp' starting page</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
    <link rel="stylesheet" href="https://a.amap.com/jsapi_demos/static/demo-center/css/demo-center.css" />
    <script src="https://webapi.amap.com/maps?v=1.4.15&key=4c4d99a9c47ece498bbd1621284a5eb9&plugin=AMap.PolyEditor"></script>
    <script src="https://a.amap.com/jsapi_demos/static/demo-center/js/demoutils.js"></script>
    <style>
    html,
    body,
    #container {
      width: 100%;
      height: 100%;
    }
    </style>
  </head>
  
  <body>
  
  <div id="container"></div>
   <%
  Object[] result = null;
  Class3 aOpera = new Class3();
  double bbb=1;
   MWCharArray mbbb = new MWCharArray(bbb);//向matlab传输矩阵参数是，必须使用MWNumericArray
   result = aOpera.bianyaqi_chongdianzhan(1);//向matlab传输矩阵参数是，容量转化为double
   String a=String.valueOf(result[0]);
     
 %>
  
  
 <%//从上一个页面中获得框选的充电站坐标
String name1 = request.getParameter("res");
//其实下面应该是计算框选位置，并让用户框选，现在先省略了
 %>
 <%//假设这是从matlab中获得的线路
 //String name1="(113.2528,23.132)(113.2528,23.1323)(113.2529,23.1324);(113.2529,23.1318)(113.2531,23.1317)(113.2531,23.1314)(113.2532,23.1313);63,80,";
        
 %>
  <script type="text/javascript" src='https://a.amap.com/jsapi_demos/static/resource/capitals.js'></script>
           
    <script>
    
    //将线路的坐标变为高德地图上的折线显示
    //var xll = "<%=name1%>";//获取usercode参数值
    var xl = "<%=name1%>";//获取usercode参数值
    
    var xlList = xl.split(';');//“=”代表你拿哪个标点符号后的值例如：“/”“？”
    var map = new AMap.Map("container", {
        center: [113.253,23.1321],
        zoom: 14
    });
    xrl=xlList[xlList.length-1];
    rlList=xrl.split(',');
    var arr_rl=[];//储存每条线路的容量
    for (i=0;i<xlList.length-1;i++){//一共有几条折线xlList.length
    arr_rl[i]=rlList[i]
    }
    var arr=[];//储存折线
    var arr_rlxs=[];//储存容量显示
    for (i=0;i<xlList.length-1;i++){//一共有几条折线
    var xli=xlList[i];
    var xliList=xli.split(')');
    var path = [];
    for (j=0;j<xliList.length-1;j++){//一条折线几个点
    aaa=xliList[j].split('(');
    aaaa=aaa[1].split(',')
    zuobiao=[aaaa[0],aaaa[1]];
    path.push(zuobiao);
    }
    

    var polyline = new AMap.Polyline({
        path: path,
    })
    arr[i]=polyline;
    arr[i].setMap(map)
    
    //var infoWindow = new AMap.InfoWindow({
    //anchor: 'top-left',
    //content: arr_rl[i],
    //});
   // arr_rlxs[i]=infoWindow
    //arr_rlxs[i].open(map,path[1])
    
    
        // 创建纯文本标记,标记接入容量
    var text = new AMap.Text({
        text:arr_rl[i]+'MW',
        anchor:'middle-left', // 设置文本标记锚点
        //cursor:'pointer',
        position: path[1]
    });
    arr_rlxs[i]=text
    arr_rlxs[i].setMap(map)
    //text.setMap(map);
    }
     map.setFitView([ polyline ])

    //以下信息，通过一个matlab从保存的文件中读出来，这样可以避免传值的困扰
    var xs = "<%=a%>";
    xss=xs.split(';');
    //使用点标记，标记变压器位置与信息
    var path1 = [];
    byq=xss[1]
    byqlist=byq.split(')');
    for (j=0;j<byqlist.length-1;j++){//充电站端点
    aaa=byqlist[j].split('(');
    aaaa=aaa[1].split(',')
    zuobiao=[aaaa[0],aaaa[1]];
    path1.push(zuobiao);
    }
    // 多个点实例组成的数组
      var center = capitals[1].center;
      for(var i=0;i<byqlist.length-1;i+=1){
        var center = path1[i];
        var circleMarker = new AMap.CircleMarker({
          center:center,
          radius:15,//3D视图下，CircleMarker半径不要超过64px
          strokeColor:'white',
          strokeWeight:2,
          strokeOpacity:0.5,
          fillColor:'rgba(0,0,255,1)',
          fillOpacity:0.5,
          zIndex:10,
          bubble:true,
          cursor:'pointer',
          clickable: true
        })
        circleMarker.setMap(map)
      }
    //使用多边形，标记充电站位置
    var path2 = [];
    cdz=xss[0]
    cdzlist=cdz.split(')');
    for (j=0;j<cdzlist.length-1;j++){//充电站端点
    aaa=cdzlist[j].split('(');
    aaaa=aaa[1].split(',')
    zuobiao=[aaaa[1],aaaa[0]];
    path2.push(zuobiao);
    }
     var polygon = new AMap.Polygon({
        path: path2,
        strokeColor: "#000000", 
        strokeWeight: 6,
        strokeOpacity: 0.2,
        fillOpacity: 0,
        fillColor: '#1791fc',
        zIndex: 50,
    })

    map.add(polygon)
    map.setFitView([ polygon ])
    </script>
    
  </body>
</html>

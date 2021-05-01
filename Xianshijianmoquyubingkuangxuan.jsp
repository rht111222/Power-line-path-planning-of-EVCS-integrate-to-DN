<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no, width=device-width">
    <link rel="stylesheet" href="https://a.amap.com/jsapi_demos/static/demo-center/css/demo-center.css" />
    <title>根据要求显示范围，显示框选区域，用户截图保存后，跳转至新页面</title>
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
<div id="container">
<div class="info" id="text"  style="z-index:100;position:absolute;margin-left:500px;"/></div>  
<div class="input-item" style="z-index:100;position:absolute;bottom:15%;left:80%">
            <input id="submit" type="button" onclick="getFormInfo()" class="btn" value="开始规划" style="width:100px;height:150%"/>
            
</div>


</div>
<!-- 加载地图JSAPI脚本 -->
<script src="https://webapi.amap.com/maps?v=1.4.15&key=4c4d99a9c47ece498bbd1621284a5eb9"></script>
<script>
    path = "请对框中图片截图，并以map.png的命名，保存至C://test";
    document.querySelector("#text").innerText = path;
    var map = new AMap.Map('container', {
        resizeEnable: true, //是否监控地图容器尺寸变化
        zoom:11, //初始化地图层级
        center: [116.397428, 39.90923] //初始化地图中心点
    });
    map.setMapStyle('amap://styles/0c023ce5fc66fa092303a33839091bae');
    
    //显示需要建模的区域位置
     <%//从上一个页面中获得框选的框选范围坐标
    String name1 = request.getParameter("res");
     %>
     var xl = "<%=name1%>"
     //整理框选范围坐标
     var xlList = xl.split(';');
     var path = [];
     for (i=0;i<4;i++){
     var xli=xlList[i];
     var xliList=xli.split(')');
     aaa=xliList[0].split('(');
     aaaa=aaa[1].split(',')
     zuobiao=[aaaa[0],aaaa[1]];
     path.push(zuobiao);
     }
     //var path = [
     //[113.252093000000,23.1330783000000],
     //[113.252093000000,23.1308051000000],
     //[113.253704100000,23.1308051000000],
     //[113.253704100000,23.1330783000000]
     //]


    var polygon = new AMap.Polygon({
        path: path,
        strokeColor: "#FF33FF", 
        strokeWeight: 6,
        strokeOpacity: 0.2,
        fillOpacity: 0,
        fillColor: '#1791fc',
        zIndex: 50,
    })

    map.add(polygon)
     
    // 缩放地图到合适的视野级别
    map.setFitView([ polygon ])
</script>
<script type="text/javascript" src="./jquery/jquery11.js"></script>
<script type="text/javascript">
 function getFormInfo(){
        $.ajax({
        async : false,
        cache : false,
         url:  "Guihua_m.jsp",
         type: "POST",
         //data:  {"area": JSON.stringify(path_num) },
         //data:  {"xx": xl}, //前面是充电站范围，后面可以加上充电站的容量等信息
         success: function(result){
         b=0
         a=result.substr(b)
         res=a
         self.location.href="Xianshiguihuajieguo.jsp?res="+res; 
		          },
          error:function(err){
            console.log(err.statusText);
            console.log('异常');
          }
        });
        return a
    } 
</script>
</body>
</html>


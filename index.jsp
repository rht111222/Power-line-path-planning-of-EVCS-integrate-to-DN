<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page language="java" import="java.util.*" pageEncoding="utf-8"%>

<%@ page import="operation.Class1" %>
<%@ page import="com.mathworks.toolbox.javabuilder.MWClassID" %>
<%@ page import="com.mathworks.toolbox.javabuilder.MWException" %>
<%@ page import="com.mathworks.toolbox.javabuilder.MWNumericArray"%>

<html>
  <head>
    <link rel="stylesheet" href="https://a.amap.com/jsapi_demos/static/demo-center/css/demo-center.css" />
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">

  </head>
  
  <body>

 <table>
<tr height=300px >
<td width="100px" >

</td>

<td align="center" width="800px" id="map1" rowspan="2">  <!--表格中直接加入地图   --> 
  <div style="width:1000px;height:600px; z-index:1;" id="container1">  
  <div class="info" id="text"  style="z-index:100;position:absolute"/></div>  
  <div class="input-item" style="z-index:100;position:absolute;bottom:15px;left:600px;">
            <input id="restart" type="button" class="btn" value="重新开始" style="margin-left:20px;"/>
            <input id="clear" type="button" class="btn" value="清除" style="margin-left:20px;"/>
            <input id="close" type="button" class="btn" value="确定选择" style="margin-left:20px;"/>
            <input id="submit" type="button" onclick="getFormInfo(area)" class="btn" value="开始报装" style="width:100px;height:50px;margin-left:20px;"/>
            <!--<a href="matlab.jsp"> --> 
            <!--</a> --> 
   </div>
  </div>  
</td>
<td>
<INPUT type="text" name="pname" id="pname" value="111"/>
</td>
</tr>

</table>
<!-- 加载地图 -->
    <script type="text/javascript" src="https://webapi.amap.com/maps?v=1.4.15&key=3b0545096e4e313d068bdd2fbeabfa04"> </script>
    <script>
    var map = new AMap.Map('container1',{  <!--id为container1中的表格中加入地图   --> 
        zoom:16,//级别
        center:[113.25285364866255,23.132030838422406],//中心点坐标
        //viewMode:'3D'//使用3D视图
    });
    </script>
    <script>
path = "请框选充电桩位置";//获取路径/各点坐标
var path_num=[];
var m=[];
var area=[];
document.querySelector("#text").innerText = path;
//通过插件方式引入 AMap.MouseTool 工具
map.plugin(["AMap.MouseTool"],function(){ 
   //在地图中添加MouseTool插件
    var mouseTool = new AMap.MouseTool(map);
    var overlays = [];
    mouseTool.on('draw',function(e){
        overlays.push(e.obj);
    }) 
    //用鼠标工具画多边形
    var drawPolygon = mouseTool.polygon(); 
  //  添加事件
    AMap.event.addListener( mouseTool,'draw',function fucn(e){
        path = e.obj.getPath();//获取路径/各点坐标
        area=e.obj.getArea();//获取面积
        m=path.length;
        for (i=0;i<m;i++) {
        var k= e.obj.getPath()[i];
        var kQR=[];
        kQR[0]=k.Q;
        kQR[1]=k.R;
        path_num[i]=kQR;
        }
        path = "充电站面积为"+path_num[1][1]+"平方米";
        document.querySelector("#text").innerText = path;
        aaaaaaa=path_num.toString();
        return path_num,area,aaaaaaa
    });
  
      document.getElementById('clear').onclick = function(){
        map.remove(overlays)
        overlays = [];
        path_num=[];
        m=0;
        area=0;
        path = "请重新框选充电桩位置";
        document.querySelector("#text").innerText = path;
        
    }  
    document.getElementById('close').onclick = function(path_num){
        mouseTool.close(false)//关闭，并保留覆盖物
        path_num=[];
        path = "充电站位置已选定";
        document.querySelector("#text").innerText = path;
        
    }
        document.getElementById('restart').onclick = function(){
        mouseTool.polygon(); 
        path = "请重新框选充电桩位置";//获取路径/各点坐标
        path_num=[];
        m=0;
        area=0;
        document.querySelector("#text").innerText = path;
    }
});

</script>
<script type="text/javascript" src="./jquery/jquery11.js"></script>
<script>
function submit_a(reg){
document.getElementById("pname").value=reg;
window.location.href="?reg="+reg;
}
var res
 function getFormInfo(area){
        $.ajax({
        async : false,
        cache : false,
         url:  "Jianmofanwei_m.jsp",
         type: "POST",
         //data:  {"area": JSON.stringify(path_num) },
         data:  {"area": aaaaaaa,"fpx": m}, //前面是充电站范围，后面可以加上充电站的容量等信息
         success: function(result){
         b=0
         a=result.substr(b)
         res=a
         self.location.href="Xianshijianmoquyubingkuangxuan.jsp?res="+res; 
		          },
          error:function(err){
            console.log(err.statusText);
            console.log('异常');
          }
        });
        return a
    }    
    res
    //var abc=res.split(",")
    </script> 
   <script>
   
   
   
   </script> 
  </body>
</html>
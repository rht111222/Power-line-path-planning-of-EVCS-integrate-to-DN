

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page language="java" import="java.util.*" pageEncoding="utf-8"%>
 <%@ page import="loukuai_jianmofanwei.Class1" %>
<%@ page import="com.mathworks.toolbox.javabuilder.MWClassID" %>
<%@ page import="com.mathworks.toolbox.javabuilder.MWException" %>
<%@ page import="com.mathworks.toolbox.javabuilder.MWNumericArray"%>
<%@ page import="com.mathworks.toolbox.javabuilder.MWCharArray"%>
<%@ page import="com.mathworks.toolbox.javabuilder.MWArray"%>
<%@ page import="java.io.IOException"%>
<%@ page import="com.alibaba.fastjson.*"%>


<html>
<head>
	<title>用户输入充电站范围，matlab根据候选变压器得到需要建模的范围坐标,并传回ajax；并将充电站容量等其余信息保存至本地</title>
</head>
<body>
<% 
  String area = request.getParameter("area"); //充电站范围
  String m = request.getParameter("fpx");//充电站的容量等其余信息
  //String area="23.131991920956906,113.25291146770121,23.131750197315757,113.25293292537333,23.13200178721872,113.25306703582407";
  //String m="3223.34";
  %>
  <%
  Object[] result = null;
  Class1 aOpera = new Class1();
  //operationRe = aOpera.operation(4, ma,mb);//计算并输出四个值
    MWCharArray marea = new MWCharArray(area);//向matlab传输矩阵参数是，必须使用MWNumericArray
    MWNumericArray mm = new MWNumericArray(m,MWClassID.DOUBLE);//向matlab传输矩阵参数是，坐标转化为
  result = aOpera.loukuai_jianmofanwei(1,marea,mm);//向matlab传输矩阵参数是，容量转化为double
     String a=String.valueOf(result[0]);
     %>
     <script type="text/javascript" src="./jquery/jquery11.js"></script>
     <script>  var xl = "<%=a%>"
     
     </script>
     <%
     

   %>
  <% 
  System.out.println(a);
  response.getWriter().write(a);   
  //response.getWriter().write(m); 
  //System.out.println(m);
  response.getWriter().close();
%>


</body>
</html>
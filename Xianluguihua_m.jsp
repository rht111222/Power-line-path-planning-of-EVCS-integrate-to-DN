

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
	<title>调用保存到本地的数据+matlab的人工势场计算程序，计算得到线路信息</title>
</head>
<body>
<% 
  //String area = request.getParameter("area"); //充电站范围
  //String m = request.getParameter("fpx");//充电站的容量等其余信息

  %>
  <%
  Object[] result = null;
  Class1 aOpera = new Class1();
  //operationRe = aOpera.operation(4, ma,mb);//计算并输出四个值
    //MWCharArray marea = new MWCharArray(area);//向matlab传输矩阵参数是，必须使用MWNumericArray
    //MWNumericArray mm = new MWNumericArray(m,MWClassID.DOUBLE);//向matlab传输矩阵参数是，坐标转化为
  result = aOpera.loukuai_jianmofanwei(1);//向matlab传输矩阵参数是，容量转化为double
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
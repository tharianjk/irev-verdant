
<%@ page import="org.springframework.context.ApplicationContext" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>

<%@ page import="ireveal.domain.ProductSerial" %>
<%@ page import="ireveal.repository.DataDao" %>
<%@ page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
 <jsp:useBean id="link" scope="application" class = "ireveal.repository.JdbcDataDao" />   
 
 <%
 String prodid=request.getParameter("prodid");  
 
 String buffer="<table id='chktbl' name='chktbl'> ";  
 try{
	 ApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(config.getServletContext()); 
	// ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
	 DataDao datadao = (DataDao) context.getBean("DataDao");
	  
	  List<ProductSerial> pslist= datadao.getDWProductSerial(prodid);
	 
	 for(int i=0;i<pslist.size();i++)
	 {
		 
   buffer=buffer+"<tr><td><input type='checkbox' class='chkclass' value='"+pslist.get(i).getProductserialid()+"'>"+pslist.get(i).getProductserial() +"</td></tr>";  
	 }
    
   buffer=buffer+"</table>";  
 response.getWriter().println(buffer); 
 }
 catch(Exception e){
     System.out.println(e);
 }
			
 	
 %>
 


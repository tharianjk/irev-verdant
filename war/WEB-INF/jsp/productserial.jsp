<%@ include file="/WEB-INF/jsp/include.jsp" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
    <html>  
    <head>  
    <title><fmt:message key="title"/></title>
   <script src="js/jquery.js"></script>
	<script src="js/jquery-ui.js"></script>
    <link rel="stylesheet" type="text/css" href="irev-style.css" />	
	<link rel="stylesheet" href="css/jquery-ui.css">
    <script type='text/javascript' src="js/popupmessage.js" ></script>
    <link rel="stylesheet" href="css/popupmessage.css">
  
    </head>  
    <body> 
    <script type="text/javascript">
	
function Redirect(){
	//alert("redirect");
	window.location = "setup.htm?oper=product";
	 }
</script>
           
    <div id="pageHdr">
	<h2><fmt:message key="ProductSerial.heading"/></h2>
</div>      
       
      <div>  
       <form:form method="post" align ="left" commandName="newProductSerial" >  
        <table>  
         <tr>  
          <td>Serial No. *  :</td>  
          <td><form:input path="productserial"  required="required" />  
          </td>  
         </tr>  
          
         <tr>
		<td width="20%"> Product : </td>
       <td width="50">
			           
			 <form:select id="productk"   path="productid" required="required" >  
			 <option value="">--Select--</option>              
			 <c:forEach items="${prodlist}" var="prd"> 
			  <form:option label="${prd.productname}"   value="${prd.productid}"/>	     
			</c:forEach>
			</form:select>     
          </td>
		
		</tr>
        <tr>
		<td>Report Header  :</td> 
		<td><form:textarea   path="rptheader"  rows="2" cols="50" /></td>
		</tr>
        <tr>
		<td>Report Footer  :</td> 
		<td><form:textarea   path="rptfooter"  rows="2" cols="40" /></td> 
		</tr>
          
          <tr>
          <td> </td>  
          <td><input type="submit" value="Save" class="myButton"  />  
          </td>  
         </tr>  
        </table>  
        <form:hidden  path="productserialid"  />               
       </form:form>  
      </div>  
     
       <script>
     $(document).ready(function () {
    	 var savestat='<%=request.getParameter("savestat")%>';
   		//alert (parmdelete);
   		if(savestat!=null && savestat!="")
   			{
   			if(savestat==1)
 				{
 		flashMessenger.setText('Saved');
 				}               
   			}
   	var ref='<%=request.getParameter("refresh")%>';
   	   if(ref=="true")
   		   {
   	         var url = '<%=request.getContextPath()%>/assettree.htm?treemode=edit';     
   	                       parent.frames['AssetTree'].location = url;
   	                    parent.document.getElementById("od").style.display="none";
			        	    parent.document.getElementById("ar").style.display="none";
			        	    parent.document.getElementById("pp").style.display="none";
			        	    parent.document.getElementById("3db").style.display="none";
			        	    parent.document.getElementById("10db").style.display="none";
			        	    parent.document.getElementById("cpg").style.display="none";
			        	    parent.document.getElementById("blobe").style.display="none";}
  		 
  	});
     </script>
    </body>  
    </html>  
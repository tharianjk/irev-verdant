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

</script>
           
    <div id="pageHdr">
	<h2><fmt:message key="Company.heading"/> </h2>
	</div>      
       
      <div>  
       <form:form method="post" align ="left" commandName="editCompany" > 
       <br> 
        <table>  
         <tr>  
          <td>Company *  :</td>  
          <td><form:input path="Companyname"  required="required" />  
          </td>  
         </tr>  
         <tr> 
         
         <tr>  
          <td>Company Address  * :</td>  
        <td><form:textarea   path="CompanyAddress"  rows="5" cols="70" /></td>  
       
         </tr>  
         <tr>  
         <td>Decimal places in reports :</td>  
          
          <td><form:input type="number"  path="nprecision" maxlength="2"  /></td>
          
          </tr>
         
         <tr>
           
             <td> <br><form:checkbox path="bdebugflag" />Logging on </td>
              <td> <br><form:checkbox path="bpurge" />Purge Log data </td>
             </tr>
          
          <tr>
          <td>
          
           </td>  
          <td><input type="submit" value="Save" class="myButton"  />  
          </td>  
         </tr>  
        </table>  
        <form:hidden  path="companyid"  />               
       </form:form>  
      </div>  
     
      <script>
     
     $(document).ready(function () {
    	 
    	 var savestat='<%=request.getParameter("savestat")%>';
   		if(savestat!=null && savestat!="")
   			{
   			if(savestat==1)
 				{
 		flashMessenger.setText('Saved');
 				} 
   			else if(savestat==0) {errorflashMessenger.setText(' Could not save');} 
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
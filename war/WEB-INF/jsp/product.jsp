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
	<fmt:message key="Product.heading"/>
</div>      
       
      <div>  
       <form:form method="post" align ="left" commandName="newProduct" >  
        <table>  
         <tr>  
          <td>Product *  :</td>  
          <td><form:input path="Productname"  required="required" />  
          </td>  
         </tr>  
         <tr> 
         
         <tr>  
          <td>Version :</td>  
          <td><form:input path="version"  />  
          </td>  
         </tr>  
         <tr>  
          <td>Type * :</td> 
          
          <td width="50">
          
           <form:select   path="ptype" required="required" >
          <option value="">--Select--</option>                 
   		 <option value="Circular">Circular</option>
   		 <option value="Linear">Linear</option>    
		</form:select>  
            
          </td>  
         </tr> 
         <tr>  
          <td>Image File Name :</td>  
          <td><form:input path="imagefilename"   />  
          </td>  
         </tr>  
         <tr> 
        
          
          <tr>
          <td> </td>  
          <td><input type="submit" value="Save" class="myButton"  />  
          <input type="button" value="Back" class="myButton" name="cancel" onclick="Redirect()"/>
          </td>  
         </tr>  
        </table>  
        <form:hidden  path="productid"  />               
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
   	                       parent.frames['AssetTree'].location = url; }
  		 
  	});
     </script>
    </body>  
    </html>  
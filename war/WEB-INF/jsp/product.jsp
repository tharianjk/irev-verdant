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
       <br> 
        <table>  
         <tr>  
          <td>Product *  :</td>  
          <td><form:input path="Productname"  required="required" />  
          </td>  
         </tr>  
         <tr> 
         
         <tr>  
          <td>Product Part No * :</td>  
          <td><form:input path="version"  />  
          </td>  
         </tr>  
         <tr>  
          <td>Type * :</td> 
          
          <td width="50">
          
           <form:select id="ptype"  path="ptype" required="required" >
          <option value="">--Select--</option>                 
   		 <form:option value="C" label="Circular"></form:option>
   		 <form:option value="L" label="Linear"></form:option>  
   		 <form:option value="S" label="Slant"></form:option>    
		</form:select>              
          </td> 
          
          <td>
       	  
	  <!--  <form:checkbox id="bwithcp"  path="bwithcp" style="visibility:hidden;"  /><label id="lbl1" style="visibility:hidden;" >With CP conversion</label></td>--> 
         </tr> 
        <!--  <tr>  
          <td>Image File Name :</td>  
          <td><form:input path="imagefilename"   />  
          </td>  
         </tr>  -->
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
      function fntypechange(){
    	  if(document.getElementById("ptype").value=="Circular")
    		  {
    		  document.getElementById("bwithcp").style.visibility="visible";
    		  document.getElementById("lbl1").style.visibility="visible";
    		  
    		  }
    	  else
    		  {document.getElementById("bwithcp").style.visibility="hidden";
    	  document.getElementById("lbl1").style.visibility="hidden";
		        }
      }
     $(document).ready(function () {
    	 fntypechange();
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
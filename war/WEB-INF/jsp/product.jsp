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
	<h2><fmt:message key="Product.heading"/> </h2>
	</div>      
       
      <div>  
       <form:form method="post" align ="left" commandName="newProduct" > 
       <br> 
        <table>  
         <tr>  
          <td>Product Title *  :</td>  
          <td><form:input path="Productname"  required="required" />  
          </td>  
         </tr>  
         <tr> 
         
         <tr>  
          <td>Product Part No * :</td>  
          <td><form:input path="version"  required="required"/>  
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
   		 <form:option value="V" label="VT-JK S10 L ATP-2 REV 00"></form:option> 
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
          </td>  
         </tr>  
        </table>  
        <form:hidden  path="productid"  />               
       </form:form>  
      </div>  
     
      <script>
     
     $(document).ready(function () {
    	 //fntypechange();
    	var testcnt='${testcnt}';
    	console.log("testcnt "+testcnt);
    	if(testcnt!=null && testcnt!="" && testcnt!="0"){
    		document.getElementById("ptype").disabled=true;
    	}
    	else{document.getElementById("ptype").disabled=false;}
    	 var savestat='<%=request.getParameter("savestat")%>';
   		//alert (parmdelete);
   		if(savestat!=null && savestat!="")
   			{
   			if(savestat==1)
 				{
 		flashMessenger.setText('Saved');
 				} 
   			else if(savestat==0) {errorflashMessenger.setText('Product Name /Part No. already entered, Could not save');} 
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
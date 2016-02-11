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
	<h2><fmt:message key="Test.heading"/></h2>
</div>      
       
      <div>  
       <form:form method="post" align ="left" commandName="PVTest" >  
        <table>  
         
		<tr>
		<td>Test Configuration * :</td>  
          <td><form:input path="testname" id="testname" required="required" />  
          </td>
          <td>Test Center * :</td>  
		<td><form:input path="testcenter" required="required" /></td>
         </tr>
         <tr>
          <td>Test date *:</td>
	     <td><form:input id="dttest" path="strtestdate" type="datetime-local" required="required" /> </td>
		<td>
		Antenna Type :</td> <td><input type="text" value='${prodtype}' readonly="readonly"/></td>
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
          <td width="20%"> Test Type : </td>
		<td><form:select path="testtype" id="testtype">
        <form:option value="M" label="Gain measurement"></form:option>
   		 <form:option value="T" label="Gain tracking"></form:option>  
   		  <form:option value="C" label="Combination"></form:option> 
		</form:select> 
        </td>
        <td><form:select path="frequnit" id="frequnit">
        <form:option value="MHz" label="MHz"></form:option>
   		 <form:option value="GHz" label="GHz"></form:option>  
   		 
		</form:select> 
		</tr>
		<tr>
          <td>Test Description :</td>  
        <td><form:textarea id="testdesc"  path="testdesc"  rows="2" cols="50" /></td>  
        </tr> 
          <tr>
		<td>Test Procedure  :</td> 
		<td><form:textarea id="testproc"  path="testproc"  rows="2" cols="50" /></td>   
		        
		</tr>
		<tr>
		<td>Instruments Used  :</td> 
		<td><form:textarea   path="instruments"  rows="2" cols="50" /></td>
		</tr>
		<tr>
		<td>Calibration Status  :</td> 
		<td><form:textarea   path="calibration"  rows="2" cols="50" /></td> 
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
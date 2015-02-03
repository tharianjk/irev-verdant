 <%@ include file="/WEB-INF/jsp/include.jsp" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<html>
<head> 
  <link rel="stylesheet" type="text/css" href="irev-style.css" />
  <link rel="stylesheet" href="css/jquery-ui.css">
  <script src="js/jquery.js"></script>
  <script src="js/jquery-ui.js"></script>  

<style>
#drop{
	border:2px dashed #bbb;
	-moz-border-radius:5px;
	-webkit-border-radius:5px;
	border-radius:5px;
	padding:25px;
	text-align:center;
	font:20pt bold,"Vollkorn";color:#bbb
}
#b64data{
	width:100%;
}
 
.errorblock {
	color: #000;
	background-color: #ffEEEE;
	border: 3px solid #ff0000;
	padding: 8px;
	margin: 16px;
}
</style>
</head>
 
<body>
<script>
var fileext;

//<!-- Begin Script
var progressEnd = 10; // set to number of progress <span>'s.
var progressColor = 'blue'; // set to progress bar color
var progressInterval = 1000; // set to time between updates (milli-seconds)

var progressAt = progressEnd;
var progressTimer;
function progress_clear() {
for (var i = 1; i <= progressEnd; i++) document.getElementById('progress'+i).style.backgroundColor = 'transparent';
progressAt = 0;
}
function progress_update() {
	//console.log("progress_update");
	
	/*var filename=document.getElementById("filename").value;
	if(filename==null || filename=="")
		{
	alert("Please Select file to import");
		}
	*/
	document.getElementById("progressbar").style.display="block"
progressAt++;
if (progressAt > progressEnd) progress_clear();
else document.getElementById('progress'+progressAt).style.backgroundColor = progressColor;
progressTimer = setTimeout('progress_update()',progressInterval);
}
function progress_stop() {
clearTimeout(progressTimer);
progress_clear();
}
// End --> 

//$('#myTable tr:last').after('<tr>...</tr><tr>...</tr>');

</script>



<div id="appbody">



	<h2>Amplitude Phase Tracking Data</h2>
 
	<form:form name="form1" id="form1" method="POST" commandName="ImportData" enctype="multipart/form-data">
 
		<form:errors path="*" cssClass="errorblock" element="div" />
 
		<br>
		<table>
		<tr><td>
		<table id="tblmain">
		<tr>
		<td > Test ID: </td>
       <td width="50"><form:input type="text" path="testname"/>
       </td>
		<tr>
		<td > Product Serial No: </td>
       <td width="50">
			           
			 <form:select path="productserialid" required="required" >  
			 <option value="">--Select--</option>              
			 <c:forEach items="${prodserlist}" var="prdser"> 
			  <form:option label="${prdser.productserial}"   value="${prdser.productserialid}"/>	     
			</c:forEach>
			</form:select>     
          </td>
          
          </tr>
          <tr> 
      
		<td>File Type * :</td> 
          
          <td width="50">
          
           <form:select id="ttype"  path="filetype" required="required" onchange="typeonchange();">
          <option value="">--Select--</option>                 
   		 <option value="A">Amplitude Data</option>
   		 <option value="P">Phase Data</option>
   		 
		</form:select>
		</td>
		</tr>
        </table> 
         <br> 
       <table>  
       
	
		<tr>
		<td>
		<div id="imp">
		<p><input type="file" name="filename" id="filename" accept="application/csv" title=" click here to select an Amplitude/Phase Data file"/></p>
		</div>
		</td>
		
		
		</table>
		</td>
		
		<td>
		<c:if test="${listsize >0}">
	&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;<table id="listtab"  border="1" cellpadding="1" cellspacing="2" style="width: 300px;vertical-align:top;">
		
	<thead>
				<tr>
				   
					<th scope="col"> Type </th>
					 <th scope="col"> Test-ID </th>					
					<th scope="col"> Delete  </th>
					
				</tr>
	</thead>
	<tbody>
    <c:forEach items="${preventries}" var="prev">
		<tr>
			<td> <c:out value="${prev.ttype}"/> </td>
			<td> <c:out value="${prev.testname}"/> </td>			
			<td> <a  href="<c:url value="ampphaseimp.htm?PId=${prev.prodserialid}&oper=deltrack&testname=${prev.testname}&ttype=${prev.ttype}"/>" ><img  src ="/irev-verdant/img/delete.jpg"></a>  </td>
			
		</tr>
    </c:forEach>  
	</tbody>
	</table> 
	</c:if>
		</td>
		</tr>
		</table>
		
		<form:hidden path="ptype" ></form:hidden>
		
		<input type="submit" id="more" value="Import" name="fmaction" class="myButton"  onclick="progress_update();form1.submit();"/>
		
		<span><form:errors path="filename" cssClass="error" />
		</span>
 
	</form:form>
	<table align="center" id="progressbar" style="display:none"><tr><td><b>Loading ....</b>
<div style="font-size:8pt;padding:2px;border:solid black 1px">
<span id="progress0">&nbsp; &nbsp;</span>
<span id="progress1">&nbsp; &nbsp;</span>
<span id="progress2">&nbsp; &nbsp;</span>
<span id="progress3">&nbsp; &nbsp;</span>
<span id="progress4">&nbsp; &nbsp;</span>
<span id="progress5">&nbsp; &nbsp;</span>
<span id="progress6">&nbsp; &nbsp;</span>
<span id="progress7">&nbsp; &nbsp;</span>
<span id="progress8">&nbsp; &nbsp;</span>
<span id="progress9">&nbsp; &nbsp;</span>
<span id="progress10">&nbsp; &nbsp;</span>
</div>
</td></tr></table>
	
 </div>



<script>

$(document).ready( function () {
	//document.getElementById("strfreq").value='{"jsonfreq":[{"freq":100, "lg":1},{"freq":1000, "lg":2},{"freq":2000, "lg":2}]}';
	 document.getElementById("more").disabled = true;
	 document.getElementById("done").disabled = true;
	 
	
	
} );

function typeonchange()
{
if(document.getElementById("ttype").value!=""){
	 document.getElementById("more").disabled = false;
	 document.getElementById("done").disabled = false;
}
else
	{
	 document.getElementById("more").disabled = true;
	 document.getElementById("done").disabled = true;
	}
}
</script>

 
</body>
</html>


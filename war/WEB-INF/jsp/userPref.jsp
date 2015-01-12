<%@ include file="/WEB-INF/jsp/include.jsp" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<meta http-equiv='cache-control' content='no-cache'>
<meta http-equiv='expires' content='0'>
<meta http-equiv='pragma' content='no-cache'>

<html>
<head>
   <title><fmt:message key="title"/></title>
<link rel="stylesheet" type="text/css" href="irev-style.css" />
		<link rel="stylesheet" href="css/jquery-ui.css">
		<script src="js/jquery.js"></script>
		<script src="js/jquery-ui.js"></script>
</head>
<body>
<script>
function cancelclick()
{	
	parent.window.top.$('#dialog-form-upref').dialog('close');
}
</script>

<!--<div id="pageHdr">
	<fmt:message key="UserPref.heading"/>
</div> -->


<div id="dialog-form-upref" title="User Preference">
<form:form method="post" commandName="newUserPref">
  <table  >
  	
   
	<tr>
		<td width="20%"> Favourite Operation :</td>
       <td>		
           <form:select id="userpref" name="D1" path="Favoperation"  ></form:select>
        </td>
	</tr>
	<tr>
 	<td>Show Tool Tip</td>
 	<td>
     <form:checkbox path="showtip" value="TRUE" /></td>
	</tr>
	
  </table>
  <br>
 <table>
  <tr> <td> <input type="submit" align="center" class="myButton" value="Save">
   	<td> <input type="button" align="center" value="Back" class="myButton" onclick="cancelclick();">  
  </table>
   <form:hidden  path="User_id"   />
</form:form>
</div>


<script>
var savestat='<%=request.getParameter("savestat")%>';
if(savestat=="saved")
	{
	parent.window.top.$('#dialog-form-upref').dialog('close');
	//parent.dialog.dialog( "close" );	
	}
$(document).ready(function(){
	
          $("#userpref").val("${requestScope.favmenutxt}").attr('selected', 'selected');
    });
  
var elements =parent.pagearrsrc;
var elementName =parent.pagearr;
var userpref = document.getElementById('userpref');

var i;
var el1 = document.createElement("option");
el1.textContent = "--Select--";
el1.value = "about:blank";
userpref.appendChild(el1);
for (i = 0; i < elements.length; i++) {
   
    var el = document.createElement("option");
    el.textContent = elementName[i];
    el.value = elements[i];
   // if(elementName[i]==document.getElementById('favoperation').value){
  //  el.selected="selected";
    //}
    userpref.appendChild(el);
}


</script>

</body>
</html>
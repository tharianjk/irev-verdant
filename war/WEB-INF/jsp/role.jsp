<%@ include file="/WEB-INF/jsp/include.jsp" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<html>
<head>
  <title><fmt:message key="title"/></title>
	<link rel="stylesheet" type="text/css" href="irev-style.css" />
	<link rel="stylesheet" href="css/jquery-ui.css">
	<script src="js/jquery.js"></script>
	<script src="js/jquery-ui.js"></script>
 <script type='text/javascript' src="js/popupmessage.js" ></script>
    <link rel="stylesheet" href="css/popupmessage.css">	 
</head>
<body>
<script>
$(document).ready(function () {
	var rolename=document.getElementById("rolename").value;
	console.log("rolename="+rolename);
	if(rolename=="ROLE_ADMIN")
		{
	
	document.getElementById("rolename").disabled = true;
	$('#asssec').find('input, textarea, button, select,checkbox').attr('disabled',true);
	$('#chkmenu').find('input, textarea, button, select,checkbox').attr('disabled',true);
		}
	
 	var savestat='<%=request.getParameter("savestat")%>';
		if(savestat!=null && savestat!="")
			if(savestat==1)
				{
		flashMessenger.setText('Saved');
				}
	});
	
function RedirectCancel(){
	window.location = "setup.htm?oper=role";
	 }
</script>
<div id="pageHdr">
	<fmt:message key="Role.heading"/>
</div>
<form:form method="post" commandName="newRole">
  <table bgcolor="f8f8ff" border="1" cellspacing="1" cellpadding="2">
  	<tr> <th> Property </th>
  		<th> Current Value </th>
  		<th> New Value </th>
    <tr>
		<td> RoleName :</td>
		<td>	<form:input id="rolename" path="rolename"/>    </td>
	</tr>
	
	<tr>
		
		
		<td>Menu Access
		<table id="chkmenu">
		
			<tr>
		<td> <form:checkbox path="bln_reports" value="${map.RoleDsp.bln_reports}" />Reports</td>
		</tr>
			
			<tr>
		<td> <form:checkbox path="bln_settings" value="${map.RoleDsp.bln_settings}"/>Settings</td>
		</tr>
		</table>
		</td>
		
	</tr>
	
  </table>
  <br>
  
	<table align="left" border="1" cellpadding="1" cellspacing="2">
 
  		<tr> <td> <input type="submit" align="center" value="Save" class="myButton" > </td>
  			<td> <input type="button" align="center" value="Back" class="myButton" onclick="RedirectCancel();"> </td>
  		</tr>
	</tbody>
	</table> <br><br>

</form:form>

</body>
</html>
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
function fnCheck()
{
var usrname=document.getElementById("username").value;
   console.log("usrname: "+ usrname);
var urls = '/ireveal-base/MWAPI/validateuser/'+$("#username" ).val();
			$.ajax({
				type: "GET",
				url: urls,
				error: function(XMLHttpRequest, textStatus, errorThrown)  {
							alert("An error has occurred making the request: " + errorThrown)
						},
				success : function(response) {
                console.log("Success-usr: "+ response);
				if(response=='1')
				{
		        document.getElementById("btnreg").disabled = true;
				$( "#usrvalidate" ).dialog({
				height: 200,
				width: 300,
				modal: true				
				});	
				}
				else
				{
				document.getElementById("btnreg").disabled = false;
				}
				},				
			});
}
</script>
<div id="pageHdr">
	<fmt:message key="User.heading"/>
</div>
<div id="usrvalidate" title="Validate User" style="display:none;">
				<p> Please select a different user
</div>
<form:form method="post" commandName="newUser">
  <table bgcolor="f8f8ff" border="1" cellspacing="1" cellpadding="2">
    <tr>
		<td> UserName :</td>
		<td>	<form:input id="username" path="username" maxlength="20" required="required" onchange="fnCheck();"/>    </td>
	</tr>
	<tr>
		<td> Password :</td>
        <td> <form:password path="password" showPassword="true" maxlength="20" required="required"/>  </td>
	</tr>
	<tr>
		<td> Enabled :</td>
        <td> <form:checkbox path="enabled" checked="checked"/>  </td>
	</tr>
	<tr>
		<td>Assign to Role</td>
		<td><form:select path="role_id" required="required">
	        <option value="">--Select--</option>   
	          <c:forEach items="${AllRoles}" var="role">
	        	<form:option label="${role.rolename}"   value="${role.role_id}"/>  
	          </c:forEach>
	 		</form:select></td>
	</tr>
	<tr>
		<td>Mobile no.</td>
		<td><form:input type="number" path="mobileno" required="required" maxlength="20"  /></td>
	</tr>
	<tr>
		<td>E-Mail</td>
		<td><form:input type="email" path="email" required="required" maxlength="50" /></td>
	</tr>
	<!-- <tr>
		<td> Current Role</td>
        <td> <c:out value="${cur_role}"/> <br>  </td>
	</tr>
	<tr>
		<td>Assign to Role</td>
		<td><form:radiobuttons items="${AllRoles}"
					path="role" delimiter="<br>" /></td>
	</tr> -->
	

  </table>
  <br>
	<input type="submit" align="center" class="myButton" id="btnreg" value="Save">
	<input type="button" align="center" class="myButton" value="Back" onclick="RedirectCancel();">
</form:form>
<script >
$(document).ready(function () {
	var username='<%=request.getParameter("usr")%>';
	if(username!=null && username!="" && username!="null")
	{   
    document.getElementById("username").disabled = true;
    }
 	var savestat='<%=request.getParameter("savestat")%>';
		if(savestat!=null && savestat!="")
			if(savestat==1)
				{
		flashMessenger.setText('Saved');
				}
	});
function RedirectCancel(){
	window.location = "setup.htm?oper=user";
	 }

</script>
</body>
</html>
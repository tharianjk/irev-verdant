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
	parent.window.top.$('#dialog-form-scaling').dialog('close');
}
</script>


<div id="dialog-form-scaling" title="scaling">
<form:form method="post" commandName="newscaling">
<table>
<tr>
<td>
  <table id="tblData" class="hover order-column cell-border">
	<thead>
				<tr>
					<th scope="col"> Frequency </th>
					<th scope="col"> Minimum Scale </th>
					<th scope="col"> Maximum Scale </th>
					<th scope="col"> </th>
					
				</tr>
	</thead>
	<tbody>
    <c:forEach items="${scalelist}" var="scalelst">
		<tr>
			<td><input type="number" value='<c:out value="${scalelst.frequency}"'/> </td>
			<td><input type="number" value='<c:out value="${scalelst.minscale}"'/> </td>
			<td><input type="number" value='<c:out value="${scalelst.maxscale}"'/> <br>			
			<td> </td> 
			
		</tr>
    </c:forEach> 
	</tbody>
	</table> 
  <tr> <td> <input type="submit" align="center" class="myButton" value="Save">
   	<td> <input type="button" align="center" value="Back" class="myButton" onclick="cancelclick();">  
  </table>
  <form:hidden id="strfreq" path="strjsonfreq"></form:hidden>
</form:form>
</div>


<script>
var savestat='<%=request.getParameter("savestat")%>';
if(savestat=="saved")
	{
	parent.window.top.$('#dialog-form-scaling').dialog('close');
	//parent.dialog.dialog( "close" );	
	}
$(document).ready(function(){
	
         
    });
  

function tabledata()
{
	var freq;
	var minscale;
	var maxscale;
	var json='{"jsonfreq":[';
	var idx=0;
	 //console.log("tabledata");
	var table = $("#tblData");
	table.find('tr').each(function (i, el) {
		var tdfreq = this.children("td:nth-child(1)");
		var tdminscale = this.children("td:nth-child(2)");
		var tdmaxscale = this.children("td:nth-child(3)");
		freq=tdfreq.children("input[type=text]").val();
		minscale=tdminscale.children("input[type=text]").val();
		maxscale=tdmaxscale.children("input[type=text]").val();
		
        if(freq!="" && freq!=null && freq !='null'){
       if(idx==0){
        json=json+'{"freq":'+freq+', "minscale":'+minscale+',"maxscale":'+maxscale+'}';}
       else{json=json+',{"freq":'+freq+', "minscale":'+minscale+',"maxscale":'+maxscale+'}';}
       
       idx=1;
        }
    });
	
	if(json.length > 15)
		{
		json=json+']}';
		document.getElementById("strfreq").value=json;
		console.log(""+json);
		}
}


</script>

</body>
</html>
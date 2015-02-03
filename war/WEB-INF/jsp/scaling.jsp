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
<form:form id="form1" method="post" commandName="newscaling">
<table>
<tr>
<td>		
           <input type="button" id="add" class="mybutton" value ="Add Freq" onclick="Add();" />
        </td></tr>
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
			<td><input type="text" name="freq" value='<c:out value="${scalelst.frequency}"/>'/> </td>
			<td><input type="text" name="min" value='<c:out value="${scalelst.minscale}"/>'/> </td>
			<td><input type="text" name="max" value='<c:out value="${scalelst.maxscale}"/>'/> <br>			
			<td> </td> 
			
		</tr>
    </c:forEach> 
	</tbody>
	</table> 
  <tr> <td> <input type="button" align="center" class="myButton" value="Save" onclick="saveclick();">
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
  
function Add(){
	$("#tblData tbody").append(
		"<tr>"+
		"<td><input type='text'/></td>"+
		"<td><input type='text'/></td>"+
		"<td><input type='text'/></td>"+		
		"</tr>");
	
}; 
function tabledata()
{
	var freq;
	var minscale;
	var maxscale;
	var json='{"jsonfreq":[';
	var idx=0;
	 //console.log("tabledata");
	var table = $("#tblData");
	$('#tblData tr').each(function(){
	    $(this).find('td').each(function(){
	    	freq=$(this).children('input[name="freq"]').val();
			minscale=$(this).children('input[name="min"]').val();
			maxscale=$(this).children('input[name="max"]').val();
			console.log("freq "+freq+"minscale "+minscale)
	    })
		
		
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
function saveclick()
{	
	tabledata();
	form1.submit();
}


</script>

</body>
</html>
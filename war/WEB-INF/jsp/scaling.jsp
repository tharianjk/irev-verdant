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
			<td><input type="number" style="width:50" name="freq" value='<c:out value="${scalelst.frequency}"/>'/> </td>
			<td><input type="number" style="width:50"  name="min" value='<c:out value="${scalelst.minscale}"/>'/> </td>
			<td><input type="number" style="width:50"  name="max" value='<c:out value="${scalelst.maxscale}"/>'/> </td>						
			<td> <a id="deleteclick" href='<c:url value="scaling.htm?oper=del&prodid=${scalelst.productid}&freq=${scalelst.frequency}"/>'><img  src ="/irev-verdant/img/delete.jpg" >  </a> </td>
			
			<td> </td> 
			
		</tr>
    </c:forEach> 
	</tbody>
	</table> 
  <tr> <td> <input type="button" align="center" class="myButton" value="Save" onclick="saveclick();">
   	  
  </table>
  <form:hidden id="strfreq" path="strjsonfreq"></form:hidden>
  <form:hidden id="prodid" path="productid"></form:hidden>
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
		"<td><input type='number' style='width:50' /></td>"+
		"<td><input type='number' style='width:50'/></td>"+
		"<td><input type='number' style='width:50'/></td>"+	
		"<td> <img src='img/delete.jpg' class='btnDelete'/></td>"+
		"</tr>");
	$(".btnDelete").bind("click", Delete);
	
};
function Delete(){
	var par = $(this).parent().parent(); //tr
	par.remove();
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
	
	table.find('tr').each(function (i, el) {
		var tdfreq = $(this).children("td:nth-child(1)");
		var tdmin = $(this).children("td:nth-child(2)");
		var tdmax = $(this).children("td:nth-child(3)");
		
        freq = tdfreq.children("input[type=number]").val();
        minscale = tdmin.children("input[type=number]").val();
        maxscale = tdmax.children("input[type=number]").val();
        console.log("freq "+freq+"minscale "+minscale)
        if(freq!="" && freq!=null && freq !='null' && freq !='undefined' && minscale!="" && minscale!=null && minscale !='null' && minscale !='undefined' && maxscale!="" && maxscale!=null && maxscale !='null' && maxscale !='undefined'){
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
	if(document.getElementById("strfreq").value.length==0){
		alert("Enter Valid Data");
		return;
	}
	form1.submit();
}


</script>

</body>
</html>
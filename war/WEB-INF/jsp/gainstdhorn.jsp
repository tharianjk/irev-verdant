 <%@ include file="/WEB-INF/jsp/include.jsp" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<html>
<head>

<link rel="stylesheet" href="css/jquery-ui.css">
  <script src="js/jquery.js"></script>
  <script src="js/jquery-ui.js"></script>  
  <script type='text/javascript' src="js/popupmessage.js" ></script>
    <link rel="stylesheet" href="css/popupmessage.css">    
    <link rel="stylesheet" type="text/css" href="irev-style.css" />
<style>

</style>
</head>
 
<body>
<script>
</script>



<div id="appbody">
	<h2>Gain STD Horn</h2>
 
	<form:form name="form1" id="form1" method="get"  >	
 
		<br>
		<table id="tblmain">
		<tr><td>Test * :</td>  
		<td><input type="text" value="${model.testname}" readonly="readonly"/></td></tr>
		</table>		
		
	<table id="tblData" class="hover order-column cell-border">
	<thead>
				<tr>
					<th scope="col"> Frequency(<label>${model.frequnit}</label>) </th>
					<th scope="col"> STD Horn</th>
					<th scope="col"> </th>
					<th scope="col"> </th>
					
				</tr>
	</thead>
	<tbody>
    <c:forEach items="${model.freqlist}" var="freqlst">
		<tr>
			<td> <c:out value="${freqlst.frequency}"/> <br>
			<td> <input type='text' id='txtlg' value='<c:out value="${freqlst.stdhorn}"/>'/> <br>
			
			<td> </td> 
			<td> </td>
		</tr>
    </c:forEach> 
	</tbody>
	</table> 
	    
		
		<input type="button" value="Save" id="save"  class="myButton" />
		<input type="button" value="Cancel" id="cancel" class="myButton" onclick="redirect();" style="display:none"/>
		 
	</form:form>
 </div>

<script>
var json="";
var testid="";
var frequnit="";
$(document).ready( function () {
	//document.getElementById("strfreq").value='{"jsonfreq":[{"freq":100, "lg":1},{"freq":1000, "lg":2},{"freq":2000, "lg":2}]}';
	
	 testid="${model.testid}";
	 frequnit="${model.frequnit}";
	
	
} );

function tabledata()
{
	var freq;
	var lg;
	 json='{"jsonfreq":[';
	var idx=0;
	 //console.log("tabledata");
	var table = $("#tblData");
	table.find('tr').each(function (i, el) {
        var $tds = $(this).find('td'),
            freq = $tds.eq(0).text(),
            lg = $tds.eq(1).children("input[type=text]").val();
           // Quantity = $tds.eq(2).text();
        if(lg=="" || lg==null || lg =='null')
        	{lg=0;}
        // document.getElementById("strfreq").value='{"jsonfreq":[{"freq":100, "lg":1},{"freq":1000, "lg":2},{"freq":2000, "lg":2}]}';
        if(freq!="" && freq!=null && freq !='null'){
       if(idx==0){
        json=json+'{"freq":'+freq+', "lg":'+lg+'}';}
       else{json=json+',{"freq":'+freq+', "lg":'+lg+'}';}
       
       idx=1;
        }
    });
	
	if(json.length > 15)
		{
		json=json+']}';
	//	document.getElementById("strfreq").value=json;
		console.log("json "+json);
		}
}
 $("#save").click(function(e){
		console.log("save: True");
		
		tabledata();
		if(json!="" && json!=null && json !='undefined' && json!='null' && json.length > 15){
		var url="gainstdhorn.htm?oper=save&testid="+testid+"&frequnit="+frequnit+"&strjsonfreq="+json;
		console.log("url "+url);
		window.location = url;
		}
		else{
			alert("No Data Imported");
		}
	});
 $("#cancel").click(function(e){
		console.log("cancel: True");
		
		tabledata();
		var url="/birt-viewer/frameset?__report=verdant/CPGain.rptdesign&testid="+testid;
		console.log("url "+url);
		window.location = url;
	});
</script>

 
</body>
</html>


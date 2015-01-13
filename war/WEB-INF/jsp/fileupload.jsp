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
    <script src="js/shim.js"></script>
<script src="js/jszip.js"></script>
<script src="js/xlsx.js"></script>
<script src="js/xls.js"></script>
<!-- uncomment the next line here and in xlsxworker.js for ODS support -->
<script src="js/ods.js"></script>
    <link rel="stylesheet" type="text/css" href="irev-style.css" />
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
	tabledata();
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



	<h2>Import Test Data</h2>
 
	<form:form name="form1" id="form1" method="POST" commandName="TestData" enctype="multipart/form-data">
 
		<form:errors path="*" cssClass="errorblock" element="div" />
 
		<br>
		<table id="tblmain">
		<tr><td>Test Center * :</td>  
		<td><form:input path="testcenter" required="required" /></td></tr>
		<tr>
		<td>Test Name * :</td>  
          <td><form:input path="testname" required="required" />  
          </td>
          <td>Test date *:</td>
	     <td><form:input id="dttest" path="strtestdate" type="datetime-local" required="required" /> </td>
		</tr>
		<tr>
		<td width="20%"> Product Serial No: </td>
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
          <td>Test Description * :</td>  
        <td><form:textarea id="testdesc"  path="testdesc"  rows="2" cols="50" /></td>   
          
		<td>Test Procedure  :</td> 
		<td><form:textarea id="testproc"  path="testproc"  rows="2" cols="40" /></td>   
		        
		</tr>
		<tr>
		<td>Instruments Used  :</td> 
		<td><form:textarea   path="instruments"  rows="2" cols="50" /></td>
		<td>Calibration Status  :</td> 
		<td><form:textarea   path="calibration"  rows="2" cols="40" /></td> 
		</tr>
        </table> 
         <br> 
       <table>  
      	<tr>
		<td>
		<div id="imp">
		<p>Select VP Data<input type="file" name="filename" id="filename1" accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.ms-excel" title=" click here to select an excel file"/></p>
		</div>
		</td>
		</tr>
		<tr>
		<td>
		<div id="imp">
		<p>Select HP Data<input type="file" name="filename" id="filename" accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.ms-excel" title=" click here to select an excel file"/></p>
		</div>
		</td>
		</tr>
		</table>
		<br>
		<table>
		<tr>
		<td width="20%"> Frequency :</td>
       <td>		
           <select id="selfreq" name="D1"  ></select>
        </td>
        <td width="20%"> Linear Gain :</td>
        <td>		
           <input type="number" id="lg" />
        </td>
        <td>		
           <input type="button" id="lg" class="mybutton" value ="Add Freq" onclick="AddNew();" />
        </td>
	  </tr>
		</table>
		
		
	<table id="tblData" class="hover order-column cell-border">
	<thead>
				<tr>
					<th scope="col"> Frequency </th>
					<th scope="col"> Linear Gain</th>
					<th scope="col"> </th>
					<th scope="col"> </th>
					
				</tr>
	</thead>
	<tbody>
    <c:forEach items="${freqlist}" var="freqlst">
		<tr>
			<td> <c:out value="${freqlst.frequency}"/> <br>
			<td> <c:out value="${freqlst.lineargain}"/> <br>
			
			<td> </td> <br>
			<td> <img src='img/delete.jpg' class='btnDelete'/><img src='img/edit.jpg' class='btnEdit'/> </td>
		</tr>
    </c:forEach> 
	</tbody>
	</table> 
	
	
	
	    <form:hidden id="testid" path="testid"></form:hidden>
		<form:hidden id="strfreq" path="strjsonfreq"></form:hidden>
		<form:hidden id="originalfilename" path="originalfilename"></form:hidden>
		<form:hidden path="ptype" ></form:hidden>
		<input type="submit" value="More" name="fmaction" class="myButton" onclick="progress_update();form1.submit();"/>
		<input type="submit" value="Done" name="fmaction" class="myButton" onclick="progress_update();form1.submit();"/>
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
var X = XLS;
$(document).ready( function () {
	//document.getElementById("strfreq").value='{"jsonfreq":[{"freq":100, "lg":1},{"freq":1000, "lg":2},{"freq":2000, "lg":2}]}';
	
	var testid=document.getElementById("testid").value;
	
	 if(testid!="" && testid!=null && testid !='null')
		{
		 console.log("testid "+testid);
		document.getElementById("tblmain").disabled=true;
		}
	
} );
function AddNew(){

	var freq=document.getElementById("selfreq").value;
	var lg=document.getElementById("lg").value;
	console.log("selfreq"+selfreq);
	console.log("lg"+lg);
	document.getElementById("selfreq").value="";
	document.getElementById("lg").value="";
	$("#tblData tbody").append(
		"<tr>"+
		"<td>"+freq+"</td>"+
		"<td>"+lg+"</td>"+
		"<td></td>"+
		"<td><img src='img/edit.jpg' class='btnEdit'><img src='img/delete.jpg' class='btnDelete'/></td>"+
		"</tr>");
	
	$(".btnEdit").bind("click", Edit);
	$(".btnDelete").bind("click", Delete);
};
function Add(){
	$("#tblData tbody").append(
		"<tr>"+
		"<td><input type='text'/></td>"+
		"<td><input type='text'/></td>"+
		"<td><input type='text'/></td>"+
		"<td><img src='img/save.jpg' class='btnSave'><img src='img/delete.jpg' class='btnDelete'/></td>"+
		"</tr>");
	
		$(".btnSave").bind("click", Save);		
		$(".btnDelete").bind("click", Delete);
}; 
function Save(){
	var par = $(this).parent().parent(); //tr
	var tdName = par.children("td:nth-child(1)");
	var tdPhone = par.children("td:nth-child(2)");
	var tdEmail = par.children("td:nth-child(3)");
	var tdButtons = par.children("td:nth-child(4)");

	tdName.html(tdName.children("input[type=text]").val());
	tdPhone.html(tdPhone.children("input[type=text]").val());
	tdEmail.html(tdEmail.children("input[type=text]").val());
	tdButtons.html("<img src='img/delete.jpg' class='btnDelete'/><img src='img/edit.jpg' class='btnEdit'/>");

	$(".btnEdit").bind("click", Edit);
	$(".btnDelete").bind("click", Delete);
};
function Edit(){
	var par = $(this).parent().parent(); //tr
	var tdName = par.children("td:nth-child(1)");
	var tdPhone = par.children("td:nth-child(2)");
	var tdEmail = par.children("td:nth-child(3)");
	var tdButtons = par.children("td:nth-child(4)");

	tdName.html("<input type='text' id='txtName' value='"+tdName.html()+"'/>");
	tdPhone.html("<input type='text' id='txtPhone' value='"+tdPhone.html()+"'/>");
	tdEmail.html("<input type='text' id='txtEmail' value='"+tdEmail.html()+"'/>");
	tdButtons.html("<img src='img/save.jpg' class='btnSave'/>");

	$(".btnSave").bind("click", Save);
	$(".btnEdit").bind("click", Edit);
	$(".btnDelete").bind("click", Delete);
};
function Delete(){
	var par = $(this).parent().parent(); //tr
	par.remove();
};
var wtf_mode = false;

function fixdata(data) {
	var o = "", l = 0, w = 10240;
	for(; l<data.byteLength/w; ++l) o+=String.fromCharCode.apply(null,new Uint8Array(data.slice(l*w,l*w+w)));
	o+=String.fromCharCode.apply(null, new Uint8Array(data.slice(l*w)));
	return o;
}
function to_csv_xls(workbook) {
	  var result = [];
	  workbook.SheetNames.forEach(function(sheetName) {
		  var csv = X.utils.sheet_to_csv(workbook.Sheets[sheetName]);
	    if(csv.length > 0){
	          result.push(csv);
	    }
	  });
	  return result.join("\n");
	}
function to_csv_xlsx(workbook) {
	var result = [];
	workbook.SheetNames.forEach(function(sheetName) {
		var csv = XLSX.utils.sheet_to_csv(workbook.Sheets[sheetName]);
		if(csv.length > 0){
			result.push(csv);
		}
	});
	return result.join("\n");
}


function process_wb(wb) {	
	var output = "";	
	if(fileext=='xlsx'){
	output = to_csv_xlsx(wb);}
	else
		{output = to_csv_xls(wb);}
	loadLov(output);
}

function loadLov(output)
{	
	if(typeof console !== 'undefined') console.log("output", output);	
	var elements =output.split(",");	
	var selfreq = document.getElementById('selfreq');
	var length = selfreq.options.length;
	console.log("length "+length);
	if(length >1){
	document.getElementById("selfreq").innerHTML = "";}
	var i;
	var el1 = document.createElement("option");
	el1.textContent = "--Select Frequency--";
	el1.value = "";
	selfreq.appendChild(el1);
	for (i = 0; i < elements.length; i++) {
	   
	    var el = document.createElement("option");
	    el.textContent = elements[i];
	    el.value = elements[i];
	   // if(elementName[i]==document.getElementById('favoperation').value){
	  //  el.selected="selected";
	    //}
	    selfreq.appendChild(el);
}
}
var xlf = document.getElementById('filename');

function handleFile(e) {

//	rABS = document.getElementsByName("userabs")[0].checked;
//	use_worker = document.getElementsByName("useworker")[0].checked;
	var files = e.target.files;
	var i,f;
	for (i = 0, f = files[i]; i != files.length; ++i) {
		var reader = new FileReader();
		var name = f.name;
		document.getElementById("originalfilename").value=name;
		reader.onload = function(e) {
			if(typeof console !== 'undefined') console.log("name", name);
			var str=name.split('.');
			fileext=str[1];
			
			var data = e.target.result;			
				var wb;				 
				var arr = fixdata(data);
				if(fileext=='xlsx'){
					if(typeof console !== 'undefined') console.log("xlsx", str[1]);
					wb = XLSX.read(btoa(arr), {type: 'base64'});}
				else{
					if(typeof console !== 'undefined') console.log("xls", str[1]);
					wb = X.read(btoa(arr), {type: 'base64'});
					}
				process_wb(wb);
			
		};
		 reader.readAsArrayBuffer(f);
	}
}

if(xlf.addEventListener) xlf.addEventListener('change', handleFile, false);


function tabledata()
{
	var freq;
	var lg;
	var json='{"jsonfreq":[';
	var idx=0;
	 //console.log("tabledata");
	var table = $("#tblData");
	table.find('tr').each(function (i, el) {
        var $tds = $(this).find('td'),
            freq = $tds.eq(0).text(),
            lg = $tds.eq(1).text();
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
		document.getElementById("strfreq").value=json;
		console.log(""+json);
		}
}

</script>

 
</body>
</html>


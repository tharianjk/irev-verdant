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



</script>
<div id="appbody">



	<h2>Import Meter Log</h2>
 
	<form:form name="form1" id="form1" method="POST" commandName="fileUpload" enctype="multipart/form-data">
 
		<form:errors path="*" cssClass="errorblock" element="div" />
 
		Please select a file to upload (order of columns as (1) Meter Name, (2) Attribute, (3) Reading, (4)Logdate): 
		<div id="imp">
		<input type="file" required="required" id="filename"  name="filename" class="myButton"  title="Please select excel file for uploading in the format Meter Name,Attribute,Reading,Logdate"/>
		</div>
		<input type="submit" value="upload" class="myButton" onclick="progress_update();form1.submit();"/>
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
</body>
</html>


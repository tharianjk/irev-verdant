<%@ include file="/WEB-INF/jsp/include.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>


<html>
<head><title>Amplitude Phase Tracking</title>
<link rel="stylesheet" type="text/css" href="irev-style.css" />
		<link rel="stylesheet" href="css/jquery-ui.css">		
		<script src="js/jquery.js"></script>
		<script src="js/jquery-ui.js"></script>
</head>
<body>
 <script type="text/javascript">
 var xmlHttp  
  
    function showPS(str){
  	  var seltyp=document.getElementById("typ").value
    if (typeof XMLHttpRequest != "undefined"){
    xmlHttp= new XMLHttpRequest();
    }
    else if (window.ActiveXObject){
    xmlHttp= new ActiveXObject("Microsoft.XMLHTTP");
    }
    if (xmlHttp==null){
    alert("Browser does not support XMLHTTP Request")
    return;
    } 
    var url="dropdown.htm";
    url +="?prodserid=" +str+"&typ="+seltyp;
    xmlHttp.onreadystatechange = prodChange;
    xmlHttp.open("GET", url, true);
    xmlHttp.send(null);
    }

    function prodChange(){   
    if (xmlHttp.readyState==4 || xmlHttp.readyState=="complete"){   
    document.getElementById("chktbl").innerHTML=xmlHttp.responseText   
    }   
    } 
    </script>
<table>
 <tr>
		<td>Select Type *</td>
       <td>
       	 <select id="typ">
       	 <option>--Select--</option>
       	 <option value ='A'>Amplitude</option>
       	 <option value='P'>Phase</option>
       	 </select>
	   
          </td>
          
          <td > &nbsp; &nbsp;&nbsp;Product Serial: *</td>
       <td >			           
			 <select  id="prodk" onchange="showPS(this.value);">  
			 <option value='-1'>--Select--</option>              
			 <c:forEach items='${model.prodserlist}' var="prd"> 
			  <option value='${prd.productserialid}'>${prd.productserial}</option>	     
			</c:forEach>
			</select>     
          </td>
          <td>
          <table id="chktbl"></table>
          </td>
          <td>&nbsp; &nbsp;&nbsp;<input type="button" value="Select" name="add" class="myButtonGo" onclick="Add()"/>
         		
		</td>
		
		<td>
		Selected :</td>
				<td><textarea  id="selfiles" readonly="true"   rows="2" cols="50" ></textarea></td>
				  <td>
					<input type="button" value="Clear" class="myButton"  name="clearExp" onclick="ClearExp()"/>	
				</td> 
	 	   </tr>	
	 	   <tr><td>
	 	   &nbsp; &nbsp;&nbsp;<input type="button" value="Chart" name="go" class="myButtonGo" onclick="Redirect()"/>
	 	   </td></tr> 	   
          
</table>

<iframe id="AppBody" name="AppBody"  frameborder="1" scrolling="yes" width="98%" height="95%" 
marginwidth="0" marginheight="0" align="right" class="AppBody"> 
</iframe>

</body>



<script type="text/javascript">
var prodserids="";
var typ="";
	function Add()
	{		
		$(".chkclass").each(function(index, element){							
			if(element.checked){
				if(prodserids=="")
					{
					prodserids=element.value;
					}
				else
				prodserids=prodserids+','+element.value;				
			}
			else{
				prodserids.replace(element.value, ""); 
				if(prodserids.length==1)
					prodserids="";
			}
			document.getElementById("selfiles").value=prodserids;
		});		
		document.getElementById("prodk").value="-1";
		document.getElementById("chktbl").innerHTML="";
	}
	function ClearExp()
    {
    	document.getElementById("selfiles").value='';
    	prodserids='';
    }
	function Redirect(){
		if(document.getElementById("chktbl").innerHTML !="")
			 Add();
		typ=document.getElementById("typ").value;
		
		if(typ=="" || prodserids=="")
			{
			alert("Please select mandatory fields!");
			return;
			}
				var url="ampphaserpt.htm?oper=viewaptracking&prodseriallist="+prodserids+"&typ="+typ;
			
			//"tools.htm?oper=registry&frm=view&sel=true&secid="+sectionid+"&meterid="+meterid+"&tagid="+tagid+"&dtfrom="+frm+"&dtto="+dtto;
		console.log("url " + url);
		//window.location =url; 
		prodserids="";
		window.frames['AppBody'].location=url;
		 }
</script>

</html>
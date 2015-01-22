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
    url +="?prodid=" +str;
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
          
          <td width="20%"> &nbsp; &nbsp;&nbsp;Product: *</td>
       <td >
			           
			 <select  id="prodk" onchange="showPS(this.value);">  
			 <option value='-1'>--Select--</option>              
			 <c:forEach items='${model.prodlist}' var="prd"> 
			  <option value='${prd.productid}'>${prd.productname}</option>	     
			</c:forEach>
			</select>     
          </td>
          <td>
          <table id="chktbl"></table>
          </td>
          <td>&nbsp; &nbsp;&nbsp;<input type="button" value="Add More" name="add" class="myButtonGo" onclick="Add()"/></td>
          </tr>
          
		<tr><td><input type="button" value="Go" name="go" class="myButtonGo" onclick="Redirect()"/>
		
		</td>
		</tr>
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
		});		
		document.getElementById("prodk").value="-1";
		document.getElementById("chktbl").innerHTML="";
	}
	function Redirect(){
		
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
		window.frames['AppBody'].location=url;
		 }
</script>

</html>
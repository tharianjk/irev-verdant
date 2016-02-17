<%@ include file="/WEB-INF/jsp/include.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<html>
  <head><title><fmt:message key="title"/></title>
  <link rel="stylesheet" type="text/css" href="css/jquery.dataTables.css">  
  <link rel="stylesheet" type="text/css" href="irev-style.css" />
  <link rel="stylesheet" href="css/jquery-ui.css">
  <script src="js/jquery.js"></script>
  <script src="js/jquery-ui.js"></script>  
  <script type="text/javascript" charset="utf8" src="js/jquery.dataTables.js"></script>
  <script src="js/jquery.confirm.js"></script>
  <script src="js/bootstrap.js"></script>
  <link rel="stylesheet" href="css/bootstrap.css">
  <script type='text/javascript' src="js/popupmessage.js" ></script>
    <link rel="stylesheet" href="css/popupmessage.css">
  </head>
  <body>
  <h3 id="head3"> Serial List </h3>
  <input type="button"  class="myButton" value="NEW"  onclick="fnnew();"/>
 <div id="dialogdelete" title="Delete Status" style="display:none;" >"${model.msg}" </div>
<table id="listtab" class="display">
	<thead>
				<tr>
				    <th scope="col"> No </th>
					<th scope="col"> Serial </th>
					<th scope="col">  </th>
				</tr>
	</thead>
	<tbody>
    <c:forEach items="${model.pvserial}" var="pvserial" varStatus="Loop">
		<tr>
		    <td> <c:out value="${Loop.index+1}" /></td>
		    
			<td> <a href="<c:url value="pvserialimport.htm?mode=new&PId=${pvserial.testid}&id=${pvserial.productserialid}"/>"> <c:out value="${pvserial.productserial}"/> </a> </td>
			<td> <a id="deleteclick" href='<c:url value="setup.htm?oper=deleterle&pvserialid=${pvserial.productserialid}&role=${pvserial.productserial}"/>' class="confirm"><img  src ="/irev-verdant/img/delete.jpg" >  </a> </td>
		</tr>
    </c:forEach>
   		<tr> <td>
			<input type="button"  class="myButton" value="NEW"  onclick="fnnew();"/>
		</tr> 
	</tbody>
	</table> <br><br>
	
	<script>
$(document).ready(function() {
	document.getElementById("head3").innerHTML='${model.testname}  Serial List';
     var eventFired = function ( type ) {
        $(".confirm").confirm();
    } 
 
    $('#listtab')
        .on( 'order.dt',  function () { eventFired( 'Order' ); } )
        .on( 'search.dt', function () { eventFired( 'Search' ); } )
        .on( 'page.dt',   function () { eventFired( 'Page' ); } )
        .dataTable();
    
    if("${model.stat}" ==1)
    {	
  		flashMessenger.setText('${model.msg}');    			
    }
    else if("${model.stat}" ==0)
    {	
    	errorflashMessenger.setText('${model.msg}');    			
    }
} );


$(".confirm").confirm({
    text: "Are you sure you want to delete ?",
    title: "Confirmation required",
    confirm: function(button) {
    	   
    },
    cancel: function(button) {
    	  
    },
    confirmButton: "Yes",
    cancelButton: "No"
});

dialog = $( "#dialogdelete" ).dialog({
    autoOpen: false,
    height: 80,
    width: 100,
    modal: true
  }); 
  
function fnnew(){
	window.location = 'pvserialimport.htm?PId=${model.testid}'
}

</script>
	
  </body>
</html>
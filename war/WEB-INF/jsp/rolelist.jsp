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
  <h3> Roles List </h3>
  <form action="role.htm" method="GET">
			<input type="submit" name="newrole"  class="myButton" value="NEW" />
		</form>
 <div id="dialogdelete" title="Delete Status" style="display:none;" >"${model.msg}" </div>
<table id="listtab" class="display">
	<thead>
				<tr>
				    <th scope="col"> No </th>
					<th scope="col"> Role Name </th>
					<th scope="col">  </th>
				</tr>
	</thead>
	<tbody>
    <c:forEach items="${model.roles}" var="role" varStatus="Loop">
		<tr>
		    <td> <c:out value="${Loop.index+1}" />
		    
			<td> <a href="<c:url value="role.htm?id=${role.role_id}"/>"> <c:out value="${role.rolename}"/> </a>  <br>
			<td> <a id="deleteclick" href='<c:url value="setup.htm?oper=deleterle&roleid=${role.role_id}&role=${role.rolename}"/>' class="confirm"><img  src ="/irev-verdant/img/delete.jpg" >  </a> </td>
		</tr>
    </c:forEach>
   		<tr> <td>
		<form action="role.htm" method="GET">
			<input type="submit" name="newrole" id="newrole" class="myButton" value="NEW" />
		</form>
		</tr> 
	</tbody>
	</table> <br><br>
	
	<script>
$(document).ready(function() {
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
  


</script>
	
  </body>
</html>
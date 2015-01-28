<%@ include file="/WEB-INF/jsp/include.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<html>
  <head><title><fmt:message key="title"/></title></head>
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
  <body>
  <h3> User List </h3>
  <form action="user.htm" method="GET">
			<input type="submit" name="newuser"  class="myButton" value="NEW" />
		</form>
  <table id="listtab" class="display">
	<thead>
				<tr>
					<th scope="col"> User </th>
					<th scope="col"> Enabled</th>
					<th scope="col"> Last Seen On</th>
					<th scope="col">  </th>
				</tr>
	</thead>
	<tbody>
    <c:forEach items="${model.users}" var="user">
		<tr><td> <a href="<c:url value="user.htm?usr=${user.user_id}"/>"> <c:out value="${user.username}"/> </a> </td>
			<td> <c:out value="${user.enabled}"/>  <td> <c:out value="${user.lastlogin}"/> </td>
			<td> <a id="deleteclick" href='<c:url value="setup.htm?oper=deleteusr&userid=${user.user_id}&user=${user.username}"/>' class="confirm"><img  src ="/irev-verdant/img/delete.jpg" >  </a> </td>
		</tr>
    </c:forEach> 
	</tbody>
	</table> 
	<form action="user.htm" method="GET">
			<input type="submit" name="newuser" id="newuser" class="myButton" value="NEW" />
		</form>
<script>
$(document).ready(function() {
     var eventFired = function ( type ) {
       // var n = $('#demo_info')[0];
       // n.innerHTML += '<div>'+type+' event - '+new Date().getTime()+'</div>';
      //  n.scrollTop = n.scrollHeight;  
        $(".confirm").confirm();
       // alert("1");
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
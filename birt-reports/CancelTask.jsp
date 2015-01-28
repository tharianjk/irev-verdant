<%-----------------------------------------------------------------------------
	Jithu K.R.
-----------------------------------------------------------------------------%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page session="false" buffer="none" %>
<%@ page import="org.eclipse.birt.report.utility.BirtUtility,
				 org.eclipse.birt.report.IBirtConstants,	
				 org.eclipse.birt.report.resource.BirtResources" %>

<%-----------------------------------------------------------------------------
	Cancel Task
-----------------------------------------------------------------------------%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<TITLE>
			<%= BirtResources.getMessage( "birt.viewer.title.message" )%>
		</TITLE>
		<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=utf-8">
		<LINK REL="stylesheet" HREF="<%= request.getContextPath( ) + "/webcontent/birt/styles/style.css" %>" TYPE="text/css">
	</HEAD>
	<%
		String taskid = request.getParameter( IBirtConstants.OPRAND_TASKID );
		try
		{
			BirtUtility.cancelTask( request, taskid );
		}
		catch( Exception e )
		{
			e.printStackTrace( );
		}
	%>
	<BODY>
		<TABLE CLASS="BirtViewer_Highlight_Label">
			<TR>
				<TD NOWRAP>
					<%= BirtResources.getMessage( "birt.viewer.message.taskcanceled" )%>
				</TD>
			</TR>
		</TABLE>
	</BODY>
</HTML>
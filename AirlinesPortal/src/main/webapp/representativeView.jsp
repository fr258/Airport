<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,connection.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
 
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Representative</title>
</head>
<body>
	<%
		String username = request.getParameter("username");
		if(username == null)
			request.getRequestDispatcher(("welcomePage.jsp")).forward(request, response);
		session.setAttribute("username", username);
			
	%>
	
	
	<p> Representative  View for <strong> <%= username %> </strong></p>
	<form method="post" action="repModifyAirport.jsp">
		<input type="submit" value="Modify Airport Info">
	</form>
	
	<br>
	<form method="post" action="repModifyAircraft.jsp">
		<input type="submit" value="Modify Aircraft Info">
	</form>
	
	<br>
	<form method="post" action="repModifyFlight.jsp">
		<input type="submit" value="Modify Flight Info">
	</form>
	
	<br>
	<%
		
		ApplicationDB db1 = new ApplicationDB();	
		Connection con1 = db1.getConnection(); 
		Statement stmt1 = con1.createStatement();
		ResultSet result1 = stmt1.executeQuery("SELECT * FROM airport");%>
		
	<form method="post" action="viewFlightsForAirport.jsp">
			<select name="airport" size=1>
			<% while(result1.next())
				{%>
				<option value= <%=result1.getString("apID")%> > <%=result1.getString("apname")%>
				<%}%>
			</select>&nbsp;<br> 
			<input type="submit" value="View">
	</form>
	<%	db1.closeConnection(con1); %>
	
	<br>
	<%
		
		ApplicationDB db2 = new ApplicationDB();	
		Connection con2 = db2.getConnection(); 
		Statement stmt2 = con2.createStatement();
		ResultSet result2 = stmt2.executeQuery("SELECT * FROM flight");%>
		
	<form method="post" action="viewWaitingListForFlight.jsp">
			<select name="flight" size=1>
			<% while(result2.next())
				{%>
				<option value= <%=result2.getString("fnum")%> > <%=result2.getString("fnum")%>
				<%}%>
			</select>&nbsp;<br> 
			<input type="submit" value="View">
	</form>
	<%	db2.closeConnection(con2); %>
	
	<br>
		<form method="post" action="welcomePage.jsp">
			<input type="submit" value="logout">
		</form>
	<br>
	 
	 
</body>
</html>
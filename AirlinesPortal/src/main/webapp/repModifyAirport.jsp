<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,connection.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Modify Airport Info</title>
</head>
<body>

	Add a new airport:
	<br>
		<form method="post" action="repAddAirport.jsp">
		<table>
		<tr>
		<td>Airport ID# (3 digits)</td><td><input type="text" name="apID"></td>
		</tr>
		<tr>
		<td>Airport Name</td><td><input type="text" name="name"></td>
		</tr>
		</table>
		<input type="submit" value="Add">
		</form>
	<br>
	
	Change Airport Name:
	<br>
		<%
		
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection(); 
		Statement stmt = con.createStatement();
		ResultSet result = stmt.executeQuery("SELECT * FROM airport");%>
		<form method="get" action="repEditAirport.jsp">
			<select name="airportOld" size=1>
			<% while(result.next())
				{%>
				<option value= <%=result.getString("apID")%> > <%=result.getString("apname")%>
				<%}%>
			</select>&nbsp;<br> 
			<input type="text" name = "airportNew">
			<br>
			<input type="submit" value="submit">
		</form>
		<%
		db.closeConnection(con);
		%>
		
	<br>
	
	Delete Airport
	<br>
		<%
		
		ApplicationDB db1 = new ApplicationDB();	
		Connection con1 = db1.getConnection(); 
		Statement stmt1 = con1.createStatement();
		ResultSet result1 = stmt1.executeQuery("SELECT * FROM airport");%>
		<form method="get" action="repModifyAirport.jsp">
			<select name="airport" size=1>
			<% while(result1.next())
				{%>
				<option value= <%=result1.getString("apID")%> > <%=result1.getString("apname")%>
				<%}%>
			</select>&nbsp;<br> 
			<input type="submit" value="Delete">
		</form>
		<%
		String apID = request.getParameter("airport");

		String delete = "DELETE FROM airport WHERE apID = ?";
		
		PreparedStatement ps = con1.prepareStatement(delete);

		ps.setString(1, apID);
		
		ps.executeUpdate();		

		db1.closeConnection(con1);
		%>
		
	<br>
</body>
</html>
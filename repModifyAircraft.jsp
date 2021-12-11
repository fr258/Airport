<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,connection.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

	Add a new aircraft:
	<br>
		<%
		
		ApplicationDB db1 = new ApplicationDB();	
		Connection con1 = db1.getConnection(); 
		Statement stmt1 = con1.createStatement();
		ResultSet result1 = stmt1.executeQuery("SELECT * FROM airline");%>
		
		<form method="post" action="repAddAircraft.jsp">
		<table>
		<tr>
		<td>Aircraft ID#</td><td><input type="text" name="acrID"></td>
		</tr>
		<tr>
		<td>Number of seats</td><td><input type="text" name="numSeats"></td>
		</tr>
		<tr>
		<td>Airline</td><td>
		<select name="aID" size=1>
			<% while(result1.next())
				{%>
				<option value= <%=result1.getString("aID")%> > <%=result1.getString("aID")%>
				<%}%>
			</select></td></tr>
		</table>
		<br> 
		<input type="submit" value="Add">
		</form>
		<%db1.closeConnection(con1); %>
	<br>
	
	
	Edit Aircraft:
	<br>
		<%
		
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection(); 
		Statement stmt = con.createStatement();
		ResultSet result = stmt.executeQuery("SELECT * FROM aircraft");
		
		Statement stmt2 = con.createStatement();
		ResultSet result2 = stmt2.executeQuery("SELECT * FROM airline");
		%>
		<form method="get" action="repEditAircraft.jsp">
			<select name="aircraftOld" size=1>
			<% while(result.next())
				{%>
				<option value= <%=result.getString("acrID")%> > <%=result.getString("acrID")%>
				<%}%>
			</select>&nbsp;
			<table>
		<tr>
		<td>Number of seats</td><td><input type="text" name="numSeats" ></td>
		<td>Airline</td><td>
		<select name="airline" size=1>
			<% while(result2.next())
				{%>
				<option value= <%=result2.getString("aID")%> > <%=result2.getString("aID")%>
				<%}
			%>
			</select></td>
		</tr>
		</table>
			<input type="submit" value="Edit">
		</form>
		<%
		db.closeConnection(con);
		%>
		
	<br>


	Delete Aircraft:
	<br>
		<%
		
		ApplicationDB db3 = new ApplicationDB();	
		Connection con3 = db3.getConnection(); 
		Statement stmt3 = con3.createStatement();
		ResultSet result3 = stmt3.executeQuery("SELECT * FROM aircraft");%>
		<form method="get" action="repModifyAircraft.jsp">
			<select name="aircraft" size=1>
			<% while(result3.next())
				{%>
				<option value= <%=result3.getString("acrID")%> > <%=result3.getString("acrID")%>
				<%}%>
			</select>&nbsp;<br> 
			<input type="submit" value="Delete">
		</form>
		<%
		String acrID = request.getParameter("aircraft");

		String delete = "DELETE FROM aircraft WHERE acrID = ?";
		
		PreparedStatement ps = con3.prepareStatement(delete);

		ps.setString(1, acrID);
		
		ps.executeUpdate();		

		db3.closeConnection(con3);
		%>
		
	<br>
</body>
</html>
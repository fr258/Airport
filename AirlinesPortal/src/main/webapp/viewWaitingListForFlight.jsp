<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,connection.* " %>
<%@ page import="javax.servlet.http.*,javax.servlet.*,java.text.SimpleDateFormat"%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%
	try {

		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();

		//Create a SQL statement
		Statement stmt = con.createStatement();

		//Get parameters from the HTML form at the index.jsp
		String flight = request.getParameter("flight");		
		
		//Make an insert statement for the Sells table:
		String command = "SELECT username, firstName, lastName FROM userInfo WHERE username IN (SELECT username FROM waitingLine WHERE fnum = " + flight +" )";

		ResultSet result = stmt.executeQuery(command); %>
		
		<table>
		<tr>    
			<td>Username</td>
			<td>First Name</td>
			<td>Last Name</td>
			</tr>
			<tr>
			<% if(result.next())
				{%>
				<td><%out.print(result.getString("username"));%></td>
				<td><%out.print(result.getString("firstName"));%></td>
				<td><%out.print(result.getString("lastName"));%></td>
				
				<%} %>
			</tr>
		</table>
			

		<%con.close();
		
		
	} catch (Exception ex) {
		out.print(ex);
		out.print("unable to get info");
	}
%>
</body>
</html>
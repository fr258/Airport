<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="connection.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Insert title here</title>
	</head>
	<body>
		<% try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		

			//Create a SQL statement
			Statement stmt = con.createStatement();
			//Get the selected radio button from the index.jsp
			String entity = request.getParameter("command");
			//Make a SELECT query from the table specified by the 'command' parameter at the index.jsp
			String str = "SELECT SUM(totalFare) as totalRevenue FROM ticket t, includes i WHERE t.tId = i.tId AND MONTH(i.date) = " + entity;
			//Run the query against the database.
			ResultSet result = stmt.executeQuery(str);
		%>
		<%
			if(entity.equals("1"))
				out.print("January Sales Report");
			else if(entity.equals("2"))
				out.print("February Sales Report");
			else if(entity.equals("3"))
				out.print("March Sales Report");
			else if(entity.equals("4"))
				out.print("April Sales Report");
			else if(entity.equals("5"))
				out.print("May Sales Report");
			else if(entity.equals("6"))
				out.print("June Sales Report");
			else if(entity.equals("7"))
				out.print("July Sales Report");
			else if(entity.equals("8"))
				out.print("August Sales Report");
			else if(entity.equals("9"))
				out.print("September Sales Report");
			else if(entity.equals("10"))
				out.print("October Sales Report");
			else if(entity.equals("11"))
				out.print("November Sales Report");
			else
				out.print("December Sales Report");%>
			<br>
			<%
			while (result.next()) { %>
					<%= result.getString("totalRevenue") %>
			<%}
	
			//close the connection.
			db.closeConnection(con); %>
			
			
		<%} catch (Exception e) {
			out.print(e);
    		out.print("Total Revenue Aggregation failed");
		}%>
		
		<% try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		

			//Create a SQL statement
			Statement stmt = con.createStatement();
			//Get the selected radio button from the index.jsp
			String entity = request.getParameter("command");
			//Make a SELECT query from the table specified by the 'command' parameter at the index.jsp
			String str = "SELECT COUNT(totalFare) as numTickets FROM ticket t, includes i WHERE t.tId = i.tId AND MONTH(i.date) = " + entity;
			//Run the query against the database.
			ResultSet result = stmt.executeQuery(str);
		%>
			<br>
			<%
			while (result.next()) { %>
					<%= result.getString("numTickets") %>
			<%}
	
			//close the connection.
			db.closeConnection(con); %>
			
			
		<%} catch (Exception e) {
			out.print(e);
    		out.print("Total Ticket Aggregation failed");
		}%>

	</body>
</html>
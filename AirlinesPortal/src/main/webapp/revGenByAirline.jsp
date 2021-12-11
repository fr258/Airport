<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="connection.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>List Revenue Generated (Airline)</title>
</head>
<body>
		<% try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		

			//Create a SQL statement
			Statement stmt = con.createStatement();
			//Get the selected airline
			String entity = request.getParameter("flight");
			//Make a SELECT query from the table
			String str = "SELECT SUM(totalFare) totalRevenue, COUNT(*) numTickets FROM ticket t, airline a, includes i WHERE a.aID = i.aID AND i.tID = t.tID AND a.aID = '" + entity+"'";
			//Run the query against the database.
			ResultSet result = stmt.executeQuery(str);
			
			//Make an HTML table to show the results in:
			out.print("<table>");

			//make a row
			out.print("<tr>");
			//make a column
			out.print("<td>");
			//print out column header
			out.print("totalRevenue");
			out.print("</td>");
			//make a column
			out.print("<td>");
			out.print("numTickets");
			out.print("</td>");

			//parse out the results
			while (result.next()) {
				//make a row
				out.print("<tr>");
				//make a column
				out.print("<td>");
				//Print out current revenue generated name:
				out.print(result.getString("totalRevenue"));
				out.print("</td>");
				out.print("<td>");
				//Print out current number of tickets name:
				out.print(result.getString("numTickets"));
				out.print("</td>");
				out.print("<td>");
			}
			out.print("</table>");
			%>
		<%} catch (Exception e) {
			out.print(e);
    		out.print("List Revenue Generation failed");
		}%>
</body>
</html>
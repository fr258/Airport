<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="connection.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Find Customer With Most Generated Revenue</title>
</head>
<body>
		<% try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		

			//Create a SQL statement
			Statement stmt = con.createStatement();
			//Make a SELECT query from the table
			String str = "SELECT u.username FROM userInfo u, ticket t, (SELECT u.username, SUM(totalFare) totalRevenue, COUNT(*) numTickets FROM ticket t, userInfo u WHERE u.username = t.username GROUP BY u.username) v WHERE u.username = t.username AND v.username = u.username AND v.totalRevenue =  (SELECT MAX(totalRevenue) maxRevenue FROM (SELECT u.username, SUM(totalFare) totalRevenue, COUNT(*) numTickets FROM ticket t, userInfo u WHERE u.username = t.username GROUP BY u.username) a) GROUP BY u.username";
			//Run the query against the database.
			ResultSet result = stmt.executeQuery(str);
			
			//Make an HTML table to show the results in:
			out.print("<table>");

			//make a row
			out.print("<tr>");
			//make a column
			out.print("<td>");
			//print out column header
			out.print("username");
			out.print("</td>");

			//parse out the results
			while (result.next()) {
				//make a row
				out.print("<tr>");
				//make a column
				out.print("<td>");
				//Print out current username name:
				out.print(result.getString("username"));
				out.print("</td>");
				out.print("<td>");
			}
			out.print("</table>");
			%>
		<%} catch (Exception e) {
			out.print(e);
    		out.print("User search failed");
		}%>
</body>
</html>
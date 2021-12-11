<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="connection.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Find Flight With Most Generated Revenue (Most Active Flight)</title>
</head>
<body>
		<% try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		

			//Create a SQL statement
			Statement stmt = con.createStatement();
			//Make a SELECT query from the table
			String str = "SELECT f.fnum FROM flight f, ticket t, includes i, (SELECT f.fnum, sum(totalFare) totalRevenue, COUNT(*) numTickets FROM ticket t, flight f, includes i WHERE t.tID = i.tID AND f.fnum = i.fnum GROUP BY f.fnum) v WHERE f.fnum = i.fnum AND i.tID = t.tID AND v.fnum = f.fnum AND v.totalRevenue = ( SELECT MAX(totalRevenue) maxRevenue FROM (SELECT f.fnum, SUM(totalFare) totalRevenue, COUNT(*) numTickets FROM ticket t, includes i, flight f WHERE f.fnum = i.fnum AND i.tID = t.tID GROUP BY f.fnum) a) GROUP BY f.fnum";
			//Run the query against the database.
			ResultSet result = stmt.executeQuery(str);
			
			//Make an HTML table to show the results in:
			out.print("<table>");

			//make a row
			out.print("<tr>");
			//make a column
			out.print("<td>");
			//print out column header
			out.print("fnum");
			out.print("</td>");

			//parse out the results
			while (result.next()) {
				//make a row
				out.print("<tr>");
				//make a column
				out.print("<td>");
				//Print out current fnum name:
				out.print(result.getString("fnum"));
				out.print("</td>");
				out.print("<td>");
			}
			out.print("</table>");
			%>
		<%} catch (Exception e) {
			out.print(e);
    		out.print("Flight search failed");
		}%>
</body>
</html>
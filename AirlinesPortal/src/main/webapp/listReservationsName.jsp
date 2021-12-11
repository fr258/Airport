<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="connection.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>List Flight Reservations (Username)</title>
</head>
<body>
		<% try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		

			//Create a SQL statement
			Statement stmt = con.createStatement();
			//Get the selected name
			String entity = request.getParameter("name");
			//Make a SELECT query from the table
			String str = "SELECT t.tID, i.date, t.timePurchased, t.class, t.seatNum, t.totalFare, t.username FROM ticket t, includes i WHERE t.tID = i.tID AND t.username = '" + entity + "'";
			//Run the query against the database.
			ResultSet result = stmt.executeQuery(str);
			
			//Make an HTML table to show the results in:
			out.print("<table>");

			//make a row
			out.print("<tr>");
			//make a column
			out.print("<td>");
			//print out column header
			out.print("tID");
			out.print("</td>");
			//make a column
			out.print("<td>");
			out.print("date");
			out.print("</td>");
			//make a column
			out.print("<td>");
			out.print("timePurchased");
			out.print("</td>");
			//make a column
			out.print("<td>");
			out.print("class");
			out.print("</td>");
			//make a column
			out.print("<td>");
			out.print("seatNum");
			out.print("</td>");
			//make a column
			out.print("<td>");
			out.print("totalFare");
			out.print("</td>");
			//make a column
			out.print("<td>");
			out.print("username");
			out.print("</td>");
			out.print("</tr>");

			//parse out the results
			while (result.next()) {
				//make a row
				out.print("<tr>");
				//make a column
				out.print("<td>");
				//Print out current bar name:
				out.print(result.getString("t.tID"));
				out.print("</td>");
				out.print("<td>");
				//Print out current beer name:
				out.print(result.getString("i.date"));
				out.print("</td>");
				out.print("<td>");
				//Print out current price
				out.print(result.getString("t.timePurchased"));
				out.print("</td>");
				out.print("<td>");
				//Print out current price
				out.print(result.getString("t.class"));
				out.print("</td>");
				out.print("<td>");
				//Print out current price
				out.print(result.getString("t.seatNum"));
				out.print("</td>");
				out.print("<td>");
				//Print out current price
				out.print(result.getString("t.totalFare"));
				out.print("</td>");
				out.print("<td>");
				//Print out current price
				out.print(result.getString("t.username"));
				out.print("</td>");
				out.print("</tr>");

			}
			out.print("</table>");
			%>
		<%} catch (Exception e) {
			out.print(e);
    		out.print("List Flight Reserves failed");
		}%>
</body>
</html>
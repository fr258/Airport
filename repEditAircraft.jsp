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
	<% try{
		
		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();

		//Create a SQL statement
		Statement stmt = con.createStatement();

		//Get parameters from the HTML form at the index.jsp
		String numSeats = request.getParameter("numSeats");
		String aID = request.getParameter("airline");
		String aircraft = request.getParameter("aircraftOld");
		
		if(numSeats != null || !numSeats.equals("")){
		//Make an insert statement for the Sells table:
		String insert = "UPDATE aircraft SET numSeats = ?, aID = ? WHERE acrID = ?";
		//Create a Prepared SQL statement allowing you to introduce the parameters of the query
		PreparedStatement ps = con.prepareStatement(insert);

		//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
		ps.setString(1, numSeats);
		ps.setString(2, aID);
		ps.setString(3, aircraft);
		//Run the query against the DB
		ps.executeUpdate();
		//Run the query against the DB
		
		//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
		con.close();
		out.print("success");}
	
	} catch (Exception ex) {
		out.print(ex);
		out.print("update failed");
	}
%>
	
	
</body>
</html>
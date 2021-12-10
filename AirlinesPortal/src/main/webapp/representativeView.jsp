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
		//if(username == null)
			//request.getRequestDispatcher(("welcomePage.jsp")).forward(request, response);
		session.setAttribute("username", username);
			
	%>
	
	
	<h> <strong>Representative  View </strong></h> <!--  <strong> <%= username %> </strong> -->
	
	<p>Modify Airport Information</p>
	<form method="post" action="repModifyAirport.jsp">
		<input type="submit" value="Modify Airport Info">
	</form>
	
	<p> Modify Aircraft Information</p>
	<form method="post" action="repModifyAircraft.jsp">
		<input type="submit" value="Modify Aircraft Info">
	</form>
	
	<br>
	<p>Modify Flight Information</p>
	
	<form method="post" action="repModifyFlight.jsp">
		<input type="submit" value="Modify Flight Info">
	</form>
	
	<br>
	<p> To edit reservation information, please input ticket ID </p>
	<form method="post" action= "representativeView.jsp">
		<table>
			<tr>    
				<td>ticket ID</td><td><input type="text" name="tid"></td></tr>
		</table>
		<input type="submit" value="submit">
	</form>
	<br>
	
	<%
			String tid = request.getParameter("tid");
			ApplicationDB db3 = new ApplicationDB();
			Connection con3 = db3.getConnection();
			Statement stmt3 = con3.createStatement();
			PreparedStatement ps3 = con3.prepareStatement("SELECT * FROM ticket WHERE tid=" +tid);
	        ResultSet rs3 = ps3.executeQuery();
			if(!rs3.next())
			{
				//basically that ticket doesnt exist;
				//out.println("ticket does not exist");
			}
			else
			{
				request.getRequestDispatcher("editTicket.jsp").forward(request, response);
			}
			
			db3.closeConnection(con3);
	%>
	
	<p>Book Flight Tickets for Customer</p>
	<form method="post" action= "representativeView.jsp">
		<table>
			<tr>    
				<td>Customer Username</td><td><input type="text" name="customer"></td></tr>
		</table>
		<input type="submit" value="submit">
	</form>
	<%
			String customerUsername = request.getParameter("customer");
			ApplicationDB db4 = new ApplicationDB();
			Connection con4 = db4.getConnection();
			Statement stmt4 = con4.createStatement();
			PreparedStatement ps4 = con4.prepareStatement("SELECT role FROM userInfo WHERE username='" +customerUsername+ "'");
	        ResultSet rs4 = ps4.executeQuery();
			if(rs4.next())
			{
				request.getRequestDispatcher("repBookTicket.jsp").forward(request, response);
			}
			
			db3.closeConnection(con4);
	%>
	
	
	<br>
	<p>View Flights for an Airport</p>
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
			<input type="submit" value="View Flights for Airport">
	</form>
	<%	db1.closeConnection(con1); %>
	
	<br>
	<p> View Waiting List for Flight</p>
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
			<input type="submit" value="View Waiting List">
	</form>
	<%	db2.closeConnection(con2); %>
	
	<br>
		<form method="post" action="welcomePage.jsp">
			<input type="submit" value="logout">
		</form>
	<br>
	 
	 
</body>
</html>
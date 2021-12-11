<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,connection.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
 
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Edit Ticket</title>
</head>
<body>
	<br>
	<%ApplicationDB db1 = new ApplicationDB();	
	Connection con1 = db1.getConnection(); 
	Statement stmt1 = con1.createStatement();
	ResultSet result1 = stmt1.executeQuery("SELECT * FROM ticket WHERE tID= '"+ request.getParameter("tid")+"'");
	if(!result1.next())
	{
		request.getRequestDispatcher("representativeView.jsp").forward(request, response);
	}%>
		<form method="post" action="editTicket.jsp">
		<table>
		<tr>
		<td><input type="hidden" name="tid" value = <%=request.getParameter("tid")%>></td>
		</tr>
		<tr>
		<td>Booking Fee</td><td><input type="text" name="bookingFee" value=<%=result1.getString("bookingFee") %>></td>
		</tr>
		<tr>
		<td>Total Fare</td><td><input type="text" name="totalFare" value=<%=result1.getString("totalFare") %>></td>
		</tr>
		<tr>
		<td>Class</td><td><select name="class" size = 1>
			<option value="first" <%if(result1.getString("class")!=null && result1.getString("class").equals("first")){%>selected<%} %>>First Class</option>
			<option value="business" <%if(result1.getString("class")!=null &&result1.getString("class").equals("business")){%>selected<%} %>>Business Class</option>
			<option value="economy" <%if(result1.getString("class")!=null &&result1.getString("class").equals("economy")){%>selected<%} %>>Economy Class</option>
			</select>
		</td>
		</tr>
		</table>
		<input type="submit" value="Save Changes">
		</form>
	<br>
	
	<% 
		Statement stmt2 = con1.createStatement();
	String s = "UPDATE ticket SET bookingFee = ?, totalFare = ?, class=? WHERE tID = ?";
	PreparedStatement ps = con1.prepareStatement(s);
	ps.setString(1, request.getParameter("bookingFee"));
	ps.setString(2,request.getParameter("totalFare"));
	ps.setString(3, request.getParameter("class"));
	ps.setString(4, request.getParameter("tid"));
	ps.executeUpdate();
	%>
</body>
</html>
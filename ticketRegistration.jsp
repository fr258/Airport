<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" %>
<%@ page import="java.io.*,java.util.*,java.sql.*,connection.* " %>
<%@ page import="javax.servlet.http.*,javax.servlet.*,java.text.SimpleDateFormat"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Ticket Registration</title>
</head>
<body>

	<%
		String id = "";
		if(request.getParameter("flight") != null) {
			session.setAttribute("id", request.getParameter("flight"));		
			id = request.getParameter("flight");
		}
		else
			id = (String)session.getAttribute("id");
		
		out.println("id is "+id);
			
		Connection con = (Connection)session.getAttribute("connection");
		PreparedStatement ps = con.prepareStatement("select * from results where id = "+id);
		ResultSet rs = ps.executeQuery();
		rs.next();
		
		float price = rs.getFloat("price");
		//if(request.getParameter("class") == null) {
		%>
			<form action="ticketRegistration.jsp">
				Select class: <select name="class" size=1>		
				<option 
					value=<%= "first," + (price + 500) %> 
					<%if(request.getParameter("class")!=null && (request.getParameter("class").split(","))[0].equals("first")) {%> selected <%} %> >
					first class: <%= String.format("$%.2f", price + 500) %> 
				</option>
				<option 
					value=<%= "business,"+ (price + 200) %>
					<%if(request.getParameter("class")!=null && (request.getParameter("class").split(","))[0].equals("business")) {%> selected <%} %> >
					business class: <%= String.format("$%.2f", price + 200) %>
				</option>
				<option 
					value=<%= "economy,"+ (price) %>
					<%if(request.getParameter("class")!=null && (request.getParameter("class").split(","))[0].equals("economy")) {%> selected <%} %> >
					economy: <%= String.format("$%.2f", price) %> 
				</option>
				</select>&nbsp;<br> <input type="submit" value="submit">
			</form>
		<% 

		if(request.getParameter("class") != null) {
			//out.print("class: '"+request.getParameter("class")+"'");
			session.setAttribute("class", request.getParameter("class"));
			session.setAttribute("price", Float.parseFloat((request.getParameter("class").split(","))[1])+30);
		%> 
			<p> <strong> Subtotal: </strong> <br> <%= String.format("$%.2f", Float.parseFloat((request.getParameter("class").split(","))[1])) %> </p>
			<p> <strong>Booking Fee:</strong> <br> $30.00 </p>
			<p> <strong>Total:</strong> <br> <%= String.format("$%.2f", Float.parseFloat((request.getParameter("class").split(","))[1])+30) %> </p>
			<table>
				<tr>
					<td><form method="post" action = "ticketRegistrationROundTr.jsp"> <input type="submit" value="Cancel"> </form> </td>
					<td><form action = "purchaseTicketScreen.jsp"> <input type="submit" value="Buy"> </form> </td>
				</tr>
			</table>
		<%
		}
		
	%>


</body>
</html>
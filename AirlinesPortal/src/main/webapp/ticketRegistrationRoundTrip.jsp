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
		String ida = "", idb = "";
		if(request.getParameter("flight") != null) {
			String flight = request.getParameter("flight");
			String[] ids = flight.split(",");
			session.setAttribute("ida", ids[0]);
			session.setAttribute("idb", ids[1]);
			ida = ids[0];
			idb = ids[1];
			
		}
		else {
			ida = (String)session.getAttribute("ida");
			idb = (String)session.getAttribute("idb");
		}
		
		Connection con = (Connection)session.getAttribute("connection");
		PreparedStatement ps = con.prepareStatement("select * from finalResults where id = "+ida);
		ResultSet rs = ps.executeQuery();
		rs.next();
		
		//float price = rs.getFloat("price");
		float price = 3;
		//if(request.getParameter("class") == null) {
		%>
			<form action="ticketRegistrationRoundTrip.jsp">
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
					<td><form method="post" action = "ticketRegistrationRoundTrip.jsp"> <input type="submit" value="Cancel"> </form> </td>
					<td><form action = "purchaseTicketScreenRoundTrip.jsp"> <input type="submit" value="Buy"> </form> </td>
				</tr>
			</table>
		<%
		}
		
	%>


</body>
</html>
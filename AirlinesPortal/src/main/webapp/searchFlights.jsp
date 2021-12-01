<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" %>
<%@ page import="java.io.*,java.util.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*, java.text.ParseException,java.text.SimpleDateFormat"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Search for Flights</title>
</head>
<body>
		<h2> Search for flights</h2>
		<table>
			<tr>   
				<td> I want: </td>
				<td><form action="searchFlights.jsp"> <input type="submit" value="One Way" name="triptype"> </form></td>
				<td><form action="searchFlights.jsp"> <input type="submit" value="Round Trip" name="triptype"> </form></td>
			</tr>
		</table><br>
		
		<% 
			
			if(request.getParameter("triptype") != null || session.getAttribute("triptype") != null) {
				if(request.getParameter("triptype") != null)
					session.setAttribute("triptype", request.getParameter("triptype"));  %>
				<form method="get" action="searchFlights.jsp">
					<table>
						<tr>
							<td> Depart date: </td> <td> <input type="text" name="departDate" > must follow format mm/dd/yyyy </td>
						</tr>
						<% if(session.getAttribute("triptype").equals("Round Trip")) { %>
							<tr>
					        	<td> Return date: </td> <td> <input type="text" name="returnDate"> must follow format mm/dd/yyyy</td>
					        </tr>
				        <% } %>
				        </table>
				        <input type="checkbox" name="isFlexible" value="yes"> Date is flexible plus minus 3 days<br>
						<br> <input type="submit" value="submit">
				</form> 
		<% 		
				String departure, arrival;
				
				if((departure = request.getParameter("departDate")) != null || (arrival = request.getParameter("returnDate")) != null) {
					try {
						Date date = new SimpleDateFormat("dd/MM/yyyy").parse(departure);
						out.println("selected: "+date);
						out.println("current: "+new Date());
						if(date.after(new Date())) {
							
						}
					}
					catch(ParseException e) {
						out.println("caught");
					}
				}
				else {
					out.println("both null");
				}
			 
		} 
			out.println("departure: "+request.getParameter("departDate"));
		%>


</body>
</html>
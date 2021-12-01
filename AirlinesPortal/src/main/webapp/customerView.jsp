<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Customer View</title>
</head>
<body>

	<%
		String username = request.getParameter("username");
		if(username == null)
			request.getRequestDispatcher(("welcomePage.jsp")).forward(request, response);
		session.setAttribute("username", username);
			
	%>
	
	
	<p> Customer View for <strong> <%= username %> </strong></p>
	<h3>I want to:</h3>

			<table>
				<tr>    
					<td><form method="get" action="searchFlights.jsp"> <input type="submit" value="Search for Flights/ Buy Tickets"> </form></td>
					<td><form method="get" action="searchFlights.jsp"> <input type="submit" value="Review Tickets"> </form></td>
				</tr>
			</table>
			
		

	
	
	<br>
	<form method="post" action="welcomePage.jsp">
		<input type="submit" value="logout">
	</form>
	
</body>
</html>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" %>
<%@ page import="java.io.*,java.util.*,java.sql.*,connection.* " %>
<%@ page import="javax.servlet.http.*,javax.servlet.*,java.time.format.DateTimeFormatter, java.time.LocalDateTime"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>View Flights</title>
</head>
<body>
		<form method="get" action="viewFlightDisplay.jsp">
			Sort by <select name="sorter" size=1>
				<option value="priceasc"> price low to high </option>
				<option value="pricedesc">price high to low</option>
				<option value="durasc"> duration low to high</option>
				<option value="durdesc"> duration high to low</option>
			</select> <input type="submit" value="submit">
		</form>
		<%
		Connection con = (Connection)session.getAttribute("connection");
		PreparedStatement ps = con.prepareStatement("select * from finalResults order by price asc");
		DateTimeFormatter format = DateTimeFormatter.ofPattern("MM/dd/yyy HH:mm");  
		
		if(request.getParameter("sorter") != null) {
			if(request.getParameter("sorter").equals("priceasc")) {
				ps = con.prepareStatement("select * from finalResults order by price asc");
			}
			else if(request.getParameter("sorter").equals("pricedesc")) {
				ps = con.prepareStatement("select * from finalResults order by price desc");
			}
			else if(request.getParameter("sorter").equals("durasc")) {
				ps = con.prepareStatement("select *, timediff(arrivalTime, departTime) diff from finalResults order by diff asc");
			}
			else if(request.getParameter("sorter").equals("durdesc")) {
				ps = con.prepareStatement("select *, timediff(arrivalTime, departTime) diff from finalResults order by diff desc");
			}
			
		}
		ResultSet tempSet = ps.executeQuery();
		
		if(tempSet.next()) {  %>
				<form method="post" action="ticketRegistration.jsp">
					<table>
						<tr>
							<td></td><td> <strong> Flight Path </strong> </td> <td> <strong> Departure Time </strong> </td> <td> <strong> Arrival Time  </strong> </td>  <td> <strong> Price Starting At </strong> </td>
						</tr>
						
						<tr>
						<%
							LocalDateTime departTime = LocalDateTime.parse(tempSet.getString("departTime").replace(" ", "T"));
							String departTimeStr = departTime.format(format);	
							
							
							LocalDateTime arrivalTime = LocalDateTime.parse(tempSet.getString("arrivalTime").replace(" ", "T"));
							String arrivalTimeStr = arrivalTime.format(format);	
							
						%>
							<td><input type="radio" name="flight" value=<%= tempSet.getInt("id")%> required/></td>
							<td> <%=tempSet.getString("flightPath") %> </td> 
							<td> <%= departTimeStr %> </td> 
							<td> <%= arrivalTimeStr %> </td> 
							<td> <%=String.format("$%.2f", (Float)tempSet.getFloat("price")) %> </td> 
						</tr>
					<%while(tempSet.next()) { 
						departTime = LocalDateTime.parse(tempSet.getString("departTime").replace(" ", "T"));
						departTimeStr = departTime.format(format);	
						arrivalTime = LocalDateTime.parse(tempSet.getString("arrivalTime").replace(" ", "T"));
						arrivalTimeStr = arrivalTime.format(format);

					%> 
						<tr>
							<td><input type="radio" name="flight" value= <%=tempSet.getInt("id")%> /></td>
							<td> <%=tempSet.getString("flightPath") %> </td>
							<td> <%= departTimeStr %> </td> 
							<td> <%= arrivalTimeStr %> </td> 
							<td> <%=String.format("$%.2f", (Float)tempSet.getFloat("price")) %> </td>
						</tr>
					<%} %>
						<tr>
							<td> <input type="submit" value="Buy Now" > </td>
						</tr>
						
					</table>
				</form> 
			<% 
		
		} //end if %>

</body>
</html>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" %>
<%@ page import="java.io.*,java.util.*,java.sql.*,connection.* " %>
<%@ page import="javax.servlet.http.*,javax.servlet.*,java.text.SimpleDateFormat"%>

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
		
		<% if(request.getParameter("triptype") != null || request.getParameter("departDate") != null) { %>
			<form method="get" action= "searchFlights.jsp" >
				<%
				try {
					ApplicationDB db = new ApplicationDB();	
					Connection con = db.getConnection();
					String getAirports = "select * from airport";
					PreparedStatement ps = con.prepareStatement(getAirports);
			        ResultSet rs = ps.executeQuery();
			     %>
			        <table>
						<tr>
				        	<td> From: </td> <td> <select name="originAirport" required size=1>
							<%
								while(rs.next()) { %>
									<option value= <%=rs.getString("apID")%> > <%= rs.getString("apname") %> </option>
								<% }
							
							%>
							</select> &nbsp;<br> </td>
						</tr>
						<% 
						rs = ps.executeQuery(); %>
						<tr> 
							<td> To: </td> <td> <select name="destAirport" required size=1>
							<%
								while(rs.next()) { %>
									<option value= <%=rs.getString("apID")%> > <%= rs.getString("apname") %> </option>
								<% }
							
							%>
							</select> </td> 
						</tr> 
					</table> &nbsp;<br>
				<% 
						con.close();
			    } 
			    catch (Exception ex) {
			    		out.print(ex);
			    		out.print("select failed");
			    }
				%>
				<table>
					<tr>
						<td> Depart date: </td> <td> 
						<%String departStr =  (request.getParameter("departDate") == null) ? "" : request.getParameter("departDate"); %>
						<input type="text" name="departDate"  required value=<%=departStr%>> must follow format mm/dd/yyyy </td>
					</tr>
					<% if(request.getParameter("returnDate") != null || (request.getParameter("triptype")!= null && request.getParameter("triptype").equals("Round Trip"))) { 
						String returnStr =  (request.getParameter("returnDate") == null) ? "" : request.getParameter("returnDate"); %>
						<tr>
				        	<td> Return date: </td> <td> <input type="text" name="returnDate" required value=<%= returnStr %>> must follow format mm/dd/yyyy</td>
				        </tr>
			        <%}%>
			        </table>
			        <input type="checkbox" name="isFlexible" value="yes"> Date is flexible plus minus 3 days<br>
					<br> <input type="submit" value="submit">
			</form> 
		<% 		
			String departure, arrival;
			
			if((departure = request.getParameter("departDate")) != null) {
				try {
					java.util.Date dateDepart = new SimpleDateFormat("MM/dd/yyyy").parse(departure);
					if((arrival = request.getParameter("returnDate")) != null) {
						java.util.Date dateReturn = new SimpleDateFormat("MM/dd/yyyy").parse(arrival);
						if(dateDepart.after(dateReturn))
							throw new Exception();
					}
					if(dateDepart.before(new java.util.Date()))
						throw new Exception();
					
					request.getRequestDispatcher("viewFlights.jsp").forward(request, response);
				}
				catch(Exception e) {
					out.println("Invalid date(s). Try again. Dates may be incorrectly formatted, before the current date, or the return date might precede the depart date.");
				}
			}
			 
		} %>


</body>
</html>
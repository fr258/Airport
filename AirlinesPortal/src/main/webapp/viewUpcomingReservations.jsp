<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" %>
<%@ page import="java.io.*,java.util.*,java.sql.*,connection.* " %>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Future Reservations</title>
</head>
<body>

<%
	try {
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		String username = (String) session.getAttribute("username");
        String flights = "select t.tID ticket, i.fnum fnum, i.aID id from includes i, ticket t, where t.username = '"+username+"' and t.tID = i.tID and isCanceled = ?";
        PreparedStatement ps = con.prepareStatement(flights);
        ps.setInt(1, 0);
        ResultSet rs = ps.executeQuery();
        boolean noFlights = false;
        if (!rs.next()) {
	        	noFlights = true;
	        } else {
%>		
<form action="processCancel.jsp" method="post">	
		<table BORDER="1">
            <tr>
            	<th>Ticked ID</th>
                <th>Departure Airport</th>
				<th>Arrival Airport</th>
				<th>Date</th>
            </tr>
            <% rs = ps.executeQuery();
            String arrival, departure;
            ResultSet rs1, rs2;
            while(rs.next()){
            	arrival = "select a.apname name from flight f, airport a where f.arrivalApID = a.apID and f.fnum = ? and f.aID = ?";	
            	departure = "select a.apname name from flight f, airport a where f.departApID = a.apID and f.fnum = ? and f.aID = ?";
            	String query = "SELECT * FROM mobile_sales WHERE unit_sale >= ?";
                //Creating the PreparedStatement object
            	ps = con.prepareStatement(arrival);
            	ps.setInt(1, rs.getInt("fnum"));
            	ps.setString(2, rs.getString("id"));
            	rs2 = ps.executeQuery();
            	ps = con.prepareStatement(departure);
            	ps.setInt(1, rs.getInt("fnum"));
            	ps.setString(2, rs.getString("id"));
            	rs1 = ps.executeQuery();
            	rs1.next();
            	rs2.next();
            %>
            <tr>
            	<td><%= rs.getInt("tID")%></td>>
				<td><%= rs1.getString("name")%></td> 
				<td><%= rs2.getString("name")%></td> 
                <td><%= rs.getDate("date")%></td>  
                <td><button type="submit" name="id" value=<%=rs.getInt("tID") %>>Go</button></td>
            </tr>
            <% } %>
        </table>
        </form>
		<table>
	<% }
        if (noFlights) {
			%> 
			<tr>    
				<td>No flights yet. </td>
			</tr>
			</table>
			<%
		}
		ArrayList<String> errors = (ArrayList<String>) request.getAttribute("msg");
		if(errors != null) {
			for(String a: errors)
				out.println(a);
			request.setAttribute("msg", null);
		}
			//close the connection.
			db.closeConnection(con);
			%>
			
		

		

		
	<%	
	}
     catch (Exception ex) {
    		out.print(ex);
    		out.print("select failed");
    }
%>

</body>
</html>

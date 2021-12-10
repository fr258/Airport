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
			String tickets = "select t.tID tID from ticket t where t.username = '"+username+"' and t.isPast = 0 and t.isCancelled = 0";
			PreparedStatement ps = con.prepareStatement(tickets);
	        ResultSet rs = ps.executeQuery();
	        ResultSet rs3, rs4;
			
			 while(rs.next()){
	         	String ifPast = "select count(*) num from includes i where i.tID = ? and i.date > cast((now()) as date)";
	         	ps = con.prepareStatement(ifPast);
	         	ps.setInt(1, rs.getInt("tID"));
	         	rs3 = ps.executeQuery();
	         	rs3.next();
	         	if (rs3.getInt("num") == 0) {
	         		String newflight;
	             	String setPast = "update ticket set isPast = 1 where tID = ?";
	             	ps = con.prepareStatement(setPast);
	             	ps.setInt(1, rs.getInt("tID"));
	             	ps.executeUpdate();
	             	String pastFlights = "select i.fnum fnum, i.aID aID, i.date date from includes i where i.tID = ?";
	             	ps = con.prepareStatement(pastFlights);
	             	ps.setInt(1, rs.getInt("tID"));
	             	rs4 = ps.executeQuery();
	             	while (rs4.next()) {
	             		newflight = "INSERT INTO hasflight(flightDate, aID, fnum, username) VALUES (?, ?, ?, ?)";
	             		ps = con.prepareStatement(newflight);
	             		ps.setDate(1, rs4.getDate("date"));
	             		ps.setString(2, rs4.getString("aID"));
	             		ps.setInt(3, rs4.getInt("fnum"));
	             		ps.setString(4, username);
	                 	ps.executeUpdate();
	             	}
	             	
	         	}
			 }
		tickets = "select t.tID tID from ticket t where t.username = '"+username+"' and t.isPast = 0 and t.isCancelled = 0";
		ps = con.prepareStatement(tickets);
        rs = ps.executeQuery();
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
            	String flights = "select i.fnum fnum, i.aID aID, i.date date from includes i where i.tID = ?";
             	ps = con.prepareStatement(flights);
             	ps.setInt(1, rs.getInt("tID"));
             	rs4 = ps.executeQuery();
             	while (rs4.next()) {
            	arrival = "select a.apname name from flight f, airport a where f.arrivalApID = a.apID and f.fnum = ? and f.aID = ?";	
            	departure = "select a.apname name from flight f, airport a where f.departApID = a.apID and f.fnum = ? and f.aID = ?";
            	ps = con.prepareStatement(arrival);
            	ps.setInt(1, rs4.getInt("fnum"));
            	ps.setString(2, rs4.getString("aID"));
            	rs2 = ps.executeQuery();
            	ps = con.prepareStatement(departure);
            	ps.setInt(1, rs4.getInt("fnum"));
            	ps.setString(2, rs4.getString("aID"));
            	rs1 = ps.executeQuery();
            	rs1.next();
            	rs2.next();
            %>
            <tr>
            	<td><%= rs.getInt("tID")%></td>
				<td><%= rs1.getString("name")%></td> 
				<td><%= rs2.getString("name")%></td> 
                <td><%= rs4.getDate("date")%></td>  
                <td><button type="submit" name="id" value=<%=rs.getInt("tID") %>>Cancel</button></td>
            </tr>
            <% }} %>
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
        %>
        <form action="customerView.jsp" method="post">	
    	<button type="submit" name="username" value=<%=session.getAttribute("username") %>>Go to homepage</button>
	</form>
	<%
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

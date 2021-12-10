<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" %>
<%@ page import="java.io.*,java.util.*,java.sql.*,connection.* " %>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Waiting List</title>
</head>
<body>

<%

	try {
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			String username = (String) session.getAttribute("username");
			String waitFl = "select w.legsKey k from waitingLine w where w.username = '"+username+"'";
			PreparedStatement ps = con.prepareStatement(waitFl);
	        ResultSet rs = ps.executeQuery();
	        ResultSet rs3, rs4;
        boolean noFlights = false;
        if (!rs.next()) {
	        	noFlights = true;
	        } else {
//change to correct page
%>		<% rs = ps.executeQuery();
            String arrival, departure;
            ResultSet rs1, rs2;
            while(rs.next()){ %>
		<form action="processBook.jsp" method="post">	
			<table BORDER="1">
            <tr>
            	<th>ID</th>
                <th>Departure Airport</th>
				<th>Arrival Airport</th>
				<th>Date</th>
				<th>Open seat</th>
            </tr>
            <%
            	boolean allowRes = true;
            	String flights = "select w.fnum fnum, w.aID aID, w.dateFl date from waitingLine w where w.legsKey = ? and w.username = '"+username+"'";
             	ps = con.prepareStatement(flights);
             	ps.setInt(1, rs.getInt("k"));
             	rs4 = ps.executeQuery();
             	while (rs4.next()) {
            	arrival = "select a.apname name, ac.numSeats seats from flight f, airport a, aircraft ac where f.arrivalApID = a.apID and ac.acrID = f.acrID and f.fnum = ? and f.aID = ?";	
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
            	String num = "select count(*) num from includes i where i.fnum = ? and i.aID = ? and i.date = ?";
            	ps = con.prepareStatement(num);
            	ps.setInt(1, rs4.getInt("fnum"));
            	ps.setString(2, rs4.getString("aID"));
            	ps.setDate(3, rs4.getDate("date"));
            	rs3 = ps.executeQuery(num);
            	rs3.next();
            	if (rs3.getInt("num") >= rs2.getInt("seats")) {
            		allowRes = false;
            	}
            %>
            <tr>
            	<td><%= rs.getInt("k")%></td>
				<td><%= rs1.getString("name")%></td> 
				<td><%= rs2.getString("name")%></td> 
                <td><%= rs4.getDate("date")%></td> 
                <% if (rs3.getInt("num") < rs2.getInt("seats")) {%>
                <td>yes</td> <%
                } else {%>
                <td>no</td> 
                <%} %> 
            </tr>
            <% } %>
             
        </table>
        <% 
        if (allowRes) {%>
         	
    	<button type="submit" name="keyID" value=<%=rs.getInt("k") %>>Buy Ticket</button>
	<%} %>
        </form>
        
       <% } %>
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

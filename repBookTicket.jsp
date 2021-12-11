<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,connection.*,java.time.format.DateTimeFormatter,java.time.LocalDateTime,java.text.SimpleDateFormat"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
 
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Book Ticket</title>
</head>
<body>
	<p>Make Reservation</p>
		<%String username = request.getParameter("customer"); %>
	<br>
	<%
		
		ApplicationDB db1 = new ApplicationDB();	
		Connection con1 = db1.getConnection(); 
		Statement stmt1 = con1.createStatement();
		ResultSet result1 = stmt1.executeQuery("SELECT fnum,aID FROM flight");
		Statement stmt2 = con1.createStatement();
		ResultSet result2 = stmt2.executeQuery("SELECT * FROM airport");
		Statement stmt4 = con1.createStatement();
		ResultSet result4 = stmt4.executeQuery("SELECT * FROM airport");
		
		PreparedStatement ps = con1.prepareStatement("SELECT max(tID) AS largest FROM ticket");
        ResultSet rs = ps.executeQuery();
        int maxtid = 0;
        
        if(!rs.next())
        {
        	maxtid = 1;
        }
        else
        {
        	maxtid = rs.getInt("largest")+1;
        }%>
        
		<form method="post" action="repBookTicket.jsp">
		<table>
		<tr>
		<td><input type = "hidden" name = "username" value=<%=username %>> </td>
		</tr>
		<tr>
		<td><input type = "hidden" name = "tID" value=<%=maxtid %>> </td>
		</tr>
		<tr>
		<td>Booking Fee</td><td><input type="number" name="bookingFee"></td>
		</tr>
		<tr>
		<td>Arrival Airport</td><td>
		<select name="arrivalApID" size=1>
			<% while(result2.next())
				{%>
				<option value= <%=result2.getString("apID")%> > <%=result2.getString("apname")%>
				<%}%>
			</select></td></tr>
		<tr>
		<td>Departure Airport</td><td>
		<select name="departApID" size=1>
			<% while(result4.next())
				{%>
				<option value= <%=result4.getString("apID")%> > <%=result4.getString("apname")%>
				<%}%>
			</select></td></tr>
		<tr>
		<tr>
		<td>Total Fare</td><td><input type="number" name="totalFare"></td>
		</tr>
		<tr>
		<td>Class</td><td><select name="class" size = 1>
			<option value="first">First Class</option>
			<option value="business">Business Class</option>
			<option value="economy">Economy Class</option></select>
		</td>
		</table>
		<input type="submit" value="Save Changes">
		</form>
	<br>
	
	<%
	
	
	try {
		if(request.getParameter("bookingFee")!=null){

		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();
		//PreparedStatement ps = con.prepareStatement("SELECT max(tID) AS largest FROM ticket");
       // ResultSet rs = ps.executeQuery();
        //int maxtid = 0;
        
        //if(!rs.next())
        //{
        	//maxtid = 1;
        //}
        //else
        //{
       // 	maxtid = rs.getInt("largest")+1;
        //}
		String tid=request.getParameter("tID");
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");  
        LocalDateTime now = LocalDateTime.now();  
        String timePurchased = dtf.format(now);  
        
		String bookingFee = request.getParameter("bookingFee");
		String totalFare = request.getParameter("totalFare");
		String flightClass = request.getParameter("class");
		username = request.getParameter("username");
		String arrivalApID = request.getParameter("arrivalApID");
		String departApID = request.getParameter("departApID");
		
		//Make an insert statement for the Sells table:
		String insert = "INSERT INTO ticket(tID, bookingFee, timePurchased, arrivalApID, departApID, class, totalFare, isCancelled, isPast, username)"
				+ "VALUES (?, ?, ?, ?,?, ?,?,?,?,?)";
		//Create a Prepared SQL statement allowing you to introduce the parameters of the query
		 ps = con.prepareStatement(insert);

		//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
		ps.setString(1, tid+"");
		ps.setString(2, bookingFee+"");
		ps.setString(3,timePurchased);
		ps.setString(4,arrivalApID);
		ps.setString(5,departApID);
		ps.setString(6,flightClass);
		ps.setString(7,totalFare+"");
		ps.setBoolean(8, false);
		ps.setBoolean(9,false);
		ps.setString(10,username);
		
		//Run the query against the DB
		ps.executeUpdate();
		//Run the query against the DB
		
		request.getRequestDispatcher("repTicketConfirmation.jsp").forward(request, response);
		
		}} catch (Exception ex) {
		out.print(ex);
		out.print("insert failed");
	}
	%>
</body>
</html>
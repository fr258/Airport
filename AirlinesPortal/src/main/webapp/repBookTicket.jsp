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
		ResultSet result1 = stmt1.executeQuery("SELECT fnum,aID FROM flight");%>
		
		<form method="post" action="repBookTicket.jsp">
		<table>
		<tr>
		<td><input type = "hidden" name = "username" value=<%=username %>> </td>
		</tr>
		<tr>
		<td>Booking Fee</td><td><input type="number" name="bookingFee"></td>
		</tr>
		<tr>
		<td>Total Fare</td><td><input type="number" name="totalFare"></td>
		</tr>
		<tr>
		<td>Seat Number</td><td><input type = "number" name="seatNum"></td>
		</tr>
		<tr>
		<td>Class</td><td><select name="class" size = 1>
			<option value="first">First Class</option>
			<option value="business">Business Class</option>
			<option value="economy">Economy Class</option></select>
		</td>
		</tr>
		<tr>
		<td>Flight</td><td><select name="flight" size=1>
			<% while(result1.next())
				{%>
				<option value= <%=result1.getString("fnum")+result1.getString("aID") %> > <%=result1.getString("fnum")+result1.getString("aID")%>
				<%}%>
			</select>&nbsp;</td>
		</tr>
		<tr>
		<td>Departure Date (yyyy-mm-dd)</td><td><input type="text" name="departDate"></td>
		</tr>
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
		PreparedStatement ps = con.prepareStatement("SELECT max(tID) AS largest FROM ticket");
        ResultSet rs = ps.executeQuery();
        int maxtid = 0;
        
        if(!rs.next())
        {
        	maxtid = 1;
        }
        else
        {
        	maxtid = rs.getInt("largest")+1;
        }

        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");  
        LocalDateTime now = LocalDateTime.now();  
        String timePurchased = dtf.format(now);  
        
		String bookingFee = request.getParameter("bookingFee");
		String totalFare = request.getParameter("totalFare");
		String seatNum = request.getParameter("seatNum");
		String flightClass = request.getParameter("class");
		
		
		//Make an insert statement for the Sells table:
		String insert = "INSERT INTO ticket(tID, bookingFee, timePurchased, class, totalFare, username)"
				+ "VALUES (?, ?, ?, ?,?, ?)";
		//Create a Prepared SQL statement allowing you to introduce the parameters of the query
		 ps = con.prepareStatement(insert);

		//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
		ps.setString(1, maxtid+"");
		ps.setString(2, bookingFee+"");
		ps.setString(3,timePurchased);
		ps.setString(4,flightClass);
		ps.setString(5,totalFare+"");
		//ps.setString(6,seatNum+"");
		ps.setString(6,username);
		
		//Run the query against the DB
		ps.executeUpdate();
		//Run the query against the DB
		
		ps = con.prepareStatement("SELECT * FROM flight");
		rs = ps.executeQuery();
		while(rs.next())
		{
			if((rs.getString("fnum") + "" + rs.getString("aID")).equals(request.getParameter("flight")))
			{
				insert = "INSERT INTO includes(arrivalApID, departApID, aID, acrID, fnum,seatNum, tID,departDate)" + "VALUES (?,?,?,?,?,?,?,?)";
				ps = con.prepareStatement(insert);
				ps.setString(1,rs.getString("arrivalApID"));
				ps.setString(2, rs.getString("departApID"));
				ps.setString(3, rs.getString("aID"));
				ps.setString(4,rs.getString("acrID"));
				ps.setString(5,rs.getString("fnum"));
				ps.setString(6,seatNum);
				ps.setString(7, maxtid+"");
				Calendar cal = Calendar.getInstance();
				SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH);

				java.util.Date date = formatter.parse(request.getParameter("departDate"));
				ps.setString(8,date.toString());
				ps.executeUpdate();//ADD TIME/DATE STUFF
			}
		}
		//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
		con.close();
		out.print("ticket booked. Edit ticket to add more flights");
		}
	} catch (Exception ex) {
		out.print(ex);
		out.print("insert failed");
	}
	%>
</body>
</html>
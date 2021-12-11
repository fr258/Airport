<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,connection.*,java.time.format.DateTimeFormatter,java.time.LocalDateTime"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
 
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<%
	ApplicationDB db1 = new ApplicationDB();	
	Connection con1 = db1.getConnection(); 
	Statement stmt1 = con1.createStatement();
	ResultSet result1 = stmt1.executeQuery("SELECT fnum,aID FROM flight");
	Statement stmt2 = con1.createStatement();
	%>
	
	<form method="post" action="repTicketConfirmation.jsp">
	<table>
	<tr>
		<td>Select Flights</td>
		</tr>
		<tr><td><input type="hidden" name="tID" value=<%=request.getParameter("tID") %>></td></tr>
		<tr>
		<td>Flights</td><td>
		<select name="flight" size=1>
			<% while(result1.next())
				{%>
				<option value= <%=result1.getString("fnum")+result1.getString("aID")%> > <%=result1.getString("fnum")+result1.getString("aID")%>
				<%}%>
			</select></td></tr>
		<tr>
		<td>Seat Number</td><td><input type="number" name="seatNum"></td>
		</tr>
		<tr>
		<td>Departure Date yyyy-mm-dd</td><td><input type="text" name="departDate"></td>
		</tr>
	</table>
	<input type="submit" value="Add Flight To Ticket">
	<br>
	</form>
	
	<%
	Statement stmt7 = con1.createStatement();
	ResultSet result7 = stmt7.executeQuery("SELECT * FROM flight");
	
	while(result7.next())
	{
		if((result7.getString("fnum")+result7.getString("aID")).equals(request.getParameter("flight")))
		{
			String s = "INSERT INTO includes(aid,fnum,date,tID,seatNum)"+"VALUES(?,?,?,?,?)";
			PreparedStatement ps = con1.prepareStatement(s);
			ps.setString(1,result7.getString("aID"));
			ps.setString(2,result7.getString("fnum"));
			ps.setString(3,request.getParameter("departDate"));
			ps.setString(4,request.getParameter("tID"));
			ps.setString(5,request.getParameter("seatNum"));
			ps.executeUpdate();
			//System.out.println("added flight to ticket");
			break;
		}
	}
	%>
</body>
</html>
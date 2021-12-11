<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,connection.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	Add a new flight:
	<br>
		<%
		
		ApplicationDB db1 = new ApplicationDB();	
		Connection con1 = db1.getConnection(); 
		Statement stmt1 = con1.createStatement();
		ResultSet result1 = stmt1.executeQuery("SELECT * FROM airport");
		Statement stmt4 = con1.createStatement();
		ResultSet result4 = stmt4.executeQuery("SELECT * FROM airport");
		Statement stmt2 = con1.createStatement();
		ResultSet result2 = stmt2.executeQuery("SELECT * FROM airline");
		Statement stmt3 = con1.createStatement();
		ResultSet result3 = stmt3.executeQuery("SELECT * FROM aircraft");
		%>
		
		<form method="post" action="repAddFlight.jsp">
		<table>
		<tr>
		<td>Arrival Airport</td><td>
		<select name="arrivalApID" size=1>
			<% while(result1.next())
				{%>
				<option value= <%=result1.getString("apID")%> > <%=result1.getString("apname")%>
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
		<td>Airline</td><td>
		<select name="aID" size=1>
			<% while(result2.next())
				{%>
				<option value= <%=result2.getString("aID")%> > <%=result2.getString("aID")%>
				<%}%>
			</select></td></tr>
		<tr>
		<td>Aircraft</td><td>
		<select name="acrID" size=1>
			<% while(result3.next())
				{%>
				<option value= <%=result3.getString("acrID")%> > <%=result3.getString("acrID")%>
				<%}%>
			</select></td></tr>
		<tr>
		<td>Departure Time hh:mm:ss</td><td><input type="time" name="departureTime"></td>
		</tr>
		<tr>
		<td>Arrival Time hh:mm:ss</td><td><input type="time" name="arrivalTime"></td>
		</tr>
		<tr>
		<td>is Domestic <input type="checkbox" name="isDomestic"></td>
		</tr>
		<tr>
		<td><input type="checkbox" name="days" value="Sunday">Sunday</td>
		<td><input type="checkbox" name="days" value="Monday">Monday</td>
		<td><input type="checkbox" name="days" value="Tuesday">Tuesday</td>
		<td><input type="checkbox" name="days" value="Wednesday">Wednesday</td>
		<td><input type="checkbox" name="days" value="Thursday">Thursday</td>
		<td><input type="checkbox" name="days" value="Friday">Friday</td>
		<td><input type="checkbox" name="days" value="Saturday">Saturday</td>
		</tr>
		</table>
		<br> 
		<input type="submit" value="Add">
		</form>
		
	<br>
	
	Edit a Flight:
	<% 
	Statement stmt5 = con1.createStatement();
	ResultSet result5 = stmt5.executeQuery("SELECT * FROM flight");
	%>
	<form method="post" action= "repEditFlight.jsp">
	<select name="flight" size=1>
			<% while(result5.next())
				{%>
				<option value= <%=result5.getString("fnum")+result5.getString("aID")%> > <%=result5.getString("fnum")+"-"+result5.getString("aID")%>
				<%}%>
	</select>
	<input type="submit" value="submit">
	</form>
	
	
	<br>
	Delete a Flight:
	<br>
		<%
		Statement stmt6 = con1.createStatement();
		ResultSet result6 = stmt6.executeQuery("SELECT * FROM flight");%>
		<form method="get" action="repModifyFlight.jsp">
			<select name="flight" size=1>
			<% while(result6.next())
				{%>
				<option value= <%=result6.getInt("fnum")+result6.getString("aID")%> > <%=result6.getString("fnum")+"-"+result6.getString("aID")%>
				<%}%>
			</select>&nbsp;<br> 
			<input type="submit" value="Delete">
		</form>
		<%
		if(request.getParameter("flight")!=null){
		Statement stmt7 = con1.createStatement();
		ResultSet result7 = stmt7.executeQuery("SELECT * FROM flight");
		String fnum=""; String aid="";
		while(result7.next())
		{
			if((result7.getString("fnum")+result7.getString("aID")).equals(request.getParameter("flight")))
			{
				fnum = result7.getString("fnum");
				aid = result7.getString("aID");
				
				String delete = "DELETE FROM waitingLine WHERE fnum = ? and aID = ? ;";//+"VALUES(?,?)";
				
				PreparedStatement ps = con1.prepareStatement(delete);
				ps.setString(1,fnum);
				ps.setString(2, aid);
				
				ps.executeUpdate();	
				
				 delete = "DELETE FROM hasFlight WHERE fnum = ? and aID = ? ;";//+"VALUES(?,?)";
				
				 ps = con1.prepareStatement(delete);
				ps.setString(1,fnum);
				ps.setString(2, aid);
				
				ps.executeUpdate();	
				
				 delete = "DELETE FROM includes WHERE fnum = ? and aID = ? ;";//+"VALUES(?,?)";
				
				 ps = con1.prepareStatement(delete);
				ps.setString(1,fnum);
				ps.setString(2, aid);
				
				ps.executeUpdate();	
				
				 delete = "DELETE FROM operatingDays WHERE fnum = ? and aID = ? ;";//+"VALUES(?,?)";
				
				 ps = con1.prepareStatement(delete);
				ps.setString(1,fnum);
				ps.setString(2, aid);
				
				ps.executeUpdate();	
				
				 delete = "DELETE FROM flight WHERE fnum = ? and aID = ? ;";//+"VALUES(?,?)";
				
				 ps = con1.prepareStatement(delete);
				ps.setString(1,fnum);
				ps.setString(2, aid);
				
				ps.executeUpdate();		
				
			}
		}
	
		}
		%>
	<br>
	
	<%db1.closeConnection(con1); %>
</body>
</html>
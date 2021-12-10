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
	
	String username = request.getParameter("username");
	String bookingFee = request.getParameter("bookingFee");
	String totalFare = request.getParameter("totalFare");
	int seatNum = request.getParameter("seatNum");
	String classSeat = request.geteParameter("class");
	
	
	ResultSet result1 = stmt1.executeQuery("SELECT * FROM flight");
	String fnum=""; String aid="";
	while(result1.next())
	{
		if((result1.getString("fnum")+result1.getString("aID")).equals(request.getParameter("flight")))
		{
			fnum = result1.getString("fnum");
			aid = result1.getString("aID");
		}
	}
	
	String date = request.getString("departDate");
	
	//check if seat is taken or if date is incorrect
	Statement stmt2 = con1.createStatement();
	String select = "SELECT t.seatNum FROM ticket t, includes i, flight f WHERE f.aID = ? and f.fnum = ? and f.aID=i.aID and f.fnum = i.fnum and i.tID = t.tID and t.seatNum = ?";
	PreparedStatement ps = con1.prepareStatement(select);
	ps.setString(1,aid);
	ps.setString(2,fnum);
	ps.setInt(3,seatNum);
	ResultSet rs1 = ps.executeQuery();
	if(rs1.next())
	{
		out.println("seat is reserved, please choose another");
	}
	else
	{
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH);
		cal.setTime(sdf.parse("Mon Mar 14 16:02:37 GMT 2011"));
	}
	
	%>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" %>
<%@ page import="java.io.*,java.util.*,java.sql.*,connection.* " %>
<%@ page import="javax.servlet.http.*,javax.servlet.*,java.time.format.DateTimeFormatter, java.time.LocalDateTime"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Flight Combiner</title>
</head>
<body>
	<%
		Connection con = (Connection)session.getAttribute("connection");
		if(request.getAttribute("returnDate") == null) {
			PreparedStatement ps = con.prepareStatement("create temporary table finalResults as select * from results");
			ps.executeUpdate();
		}
		else {
			PreparedStatement ps = con.prepareStatement("create temporary table finalResults as "+
															" select "+
							        						" a.id id,"+
							        						" a.flightPath flightPath, "+
							        						" a.departTime departTime, "+
							        						" a.departTime2 departTime2, "+
							        						" a.departTime3 departTime3, "+
							        						" a.arrivalTime arrivalTime,"+
							        						" a.price price,"+
							        						" a.numStops numStops,"+
							        						" a.airline1 airline1,"+
							        						" a.airline2 airline2 ,"+
							        						" a.airline3 airline3,"+
							        						" a.fnum1 fnum1,"+
							        						" a.fnum2 fnum2,"+
							        						" a.fnum3 fnum3, "+
							        						
							        						" b.id idb,"+
							        						" b.flightPath flightPathb, "+
							        						" b.departTime departTimeb, "+
							        						" b.departTime2 departTime2b, "+
							        						" b.departTime3 departTime3b, "+
							        						" b.arrivalTime arrivalTimeb,"+
							        						" b.price priceb,"+
							        						" b.numStops numStopsb,"+
							        						" b.airline1 airline1b,"+
							        						" b.airline2 airline2b ,"+
							        						" b.airline3 airline3b,"+
							        						" b.fnum1 fnum1b,"+
							        						" b.fnum2 fnum2b,"+
							        						" b.fnum3 fnum3b "+
															" from results a, resultsReturn b "+
							        						" where b.departTime > a.arrivalTime"
														);
			ps.executeUpdate();
			
		}
		String toPage = (request.getAttribute("returnDate") == null) ? "viewFlightDisplay.jsp" : "viewFlightDisplayRoundTrip.jsp";
		//out.println("toPage: "+toPage);
		request.getRequestDispatcher(toPage).include(request, response);
	%>

</body>
</html>
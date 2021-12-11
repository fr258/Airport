<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" %>
<%@ page import="java.io.*,java.util.*,java.sql.*,connection.* " %>
<%@ page import="javax.servlet.http.*,javax.servlet.*,java.text.SimpleDateFormat"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Flight Results</title>
</head>
<body>
<!-- <p> in viewflight </p> -->
<%
	String toPage = "viewFlightsHelper.jsp";
	if(request.getAttribute("helperCount") == null) { //first run
		try {
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			
			String departureDate = request.getParameter("departDate");
			
			Calendar c = Calendar.getInstance();
			c.setTime(new SimpleDateFormat("MM/dd/yyyy").parse(departureDate));
			int departDay = c.get(Calendar.DAY_OF_WEEK); 
			
			String returnDate = request.getParameter("returnDate");
			if(returnDate != null) {
				c.setTime(new SimpleDateFormat("MM/dd/yyyy").parse(returnDate));
				int returnDay = c.get(Calendar.DAY_OF_WEEK); 
				
				request.setAttribute("returnDate", returnDate);
				request.setAttribute("returnDay", returnDay);
				request.setAttribute("inReturnDate", returnDate);
				request.setAttribute("inReturnDay", returnDay);
				
		        String tempTable = "create temporary table resultsReturn ( "+
						" id int primary key, "+
						" flightPath varchar(200),"+
						" departTime datetime,"+
						" departTime2 datetime,"+
						" departTime3 datetime,"+
						" arrivalTime datetime,"+
						" price float,"+
						" numStops int,"+
						" airline1 char(2),"+
						" airline2 char(2),"+
						" airline3 char(2),"+
						" fnum1 int,"+
						" fnum2 int,"+
						" fnum3 int"+
					")";

				PreparedStatement ps = con.prepareStatement(tempTable);
				ps.executeUpdate();
			}
			
			//out.println("departDay: "+departDay);
			
			String origin = request.getParameter("originAirport");
			String dest = request.getParameter("destAirport");
			
	        /*PreparedStatement ps = con.prepareStatement("drop table if exists results");
	        ps.executeUpdate();*/
			
	        String tempTable = "create temporary table results ( "+
	        						" id int primary key, "+
	        						" flightPath varchar(200),"+
	        						" departTime datetime,"+
	        						" departTime2 datetime,"+
	        						" departTime3 datetime,"+
	        						" arrivalTime datetime,"+
	        						" price float,"+
	        						" numStops int,"+
	        						" airline1 char(2),"+
	        						" airline2 char(2),"+
	        						" airline3 char(2),"+
	        						" fnum1 int,"+
	        						" fnum2 int,"+
	        						" fnum3 int"+
	        					")";
	        
	        PreparedStatement ps = con.prepareStatement(tempTable);
	        ps.executeUpdate();
	        
			session.setAttribute("connection", con);			
			request.setAttribute("departureDate", departureDate);
			request.setAttribute("departDay", departDay);
			request.setAttribute("inputDate", departureDate);
			request.setAttribute("inputDay", departDay);
			request.setAttribute("origin", origin);
			request.setAttribute("dest", dest);
			request.setAttribute("helperCount", 0);
			request.setAttribute("isFlexible", request.getParameter("isFlexible"));

		}
	    catch (Exception ex) {
	    		out.print(ex);
	    		//ex.printStackTrace();
	    }
	}
	else {
		//request.setAttribute("helperCount", 0);
		toPage = "flightCombiner.jsp";
		if(request.getAttribute("isFlexible") == null) { //same date
			if(request.getAttribute("returnDate")!=null && ((Integer)request.getAttribute("helperCount") == 1)) { //round trip
				toPage = "viewFlightsHelperRoundTrip.jsp";
			}

		}
		// 1 -1 days 2 -2 days 3 -3days 4 +1 days 5 +2 days 6 +3 days
		else {
     		SimpleDateFormat formatter = new SimpleDateFormat("MM/dd/yyyy");
      		Calendar c1 = Calendar.getInstance();
			c1.setTime(formatter.parse((String)request.getAttribute("inputDate")));
			c1.set(Calendar.HOUR_OF_DAY, 23);
 
			java.util.Date currDate = new java.util.Date();
      		
			if((Integer)request.getAttribute("helperCount") == 1) { //flexible, get flights at departDate-1
				
	     		c1.add(Calendar.DATE, -1);
				if(c1.getTime().after(currDate)) {
	      			request.setAttribute("departureDate", formatter.format(c1.getTime()));
	      			int day = ((Integer)request.getAttribute("inputDay")+5)%7+1;
	      			request.setAttribute("departDay", day);
				}
				else {
					c1.add(Calendar.DATE, 1); //undo subtraction
					request.setAttribute("helperCount", 4); //jump to flexible dates 1 day after current date

				}
			}
			else if((Integer)request.getAttribute("helperCount") == 2) { //flexible, get flights at departDate-2
	     		c1.add(Calendar.DATE, -2);
				if(c1.getTime().after(currDate)) {
					request.setAttribute("departureDate", formatter.format(c1.getTime()));
	      			int day = ((Integer)request.getAttribute("inputDay")+4)%7+1;
	      			request.setAttribute("departDay", day);
				}
				else {
					c1.add(Calendar.DATE, 2); //undo subtraction
					request.setAttribute("helperCount", 4); //jump to flexible dates 1 day after current date
				}
			}
			else if((Integer)request.getAttribute("helperCount") == 3) { //flexible, get flights at departDate-3
	     		c1.add(Calendar.DATE, -3);
				if(c1.getTime().after(currDate)) {
					request.setAttribute("departureDate", formatter.format(c1.getTime()));
	      			int day = ((Integer)request.getAttribute("inputDay")+3)%7+1;
	      			request.setAttribute("departDay", day);
				}
				else {
					c1.add(Calendar.DATE, 3); //undo subtraction
					request.setAttribute("helperCount", 4); //jump to flexible dates 1 day after current date
				}
			}
			if((Integer)request.getAttribute("helperCount") == 4) { //flexible, get flights at departDate+1
	     		c1.add(Calendar.DATE, 1);
				request.setAttribute("departureDate", formatter.format(c1.getTime()));
      			int day = ((Integer)request.getAttribute("inputDay"))%7+1;
      			request.setAttribute("departDay", day);
			}
			else if((Integer)request.getAttribute("helperCount") == 5) { //flexible, get flights at departDate+2
	     		c1.add(Calendar.DATE, 2);
				request.setAttribute("departureDate", formatter.format(c1.getTime()));
      			int day = ((Integer)request.getAttribute("inputDay")+1)%7+1;
      			request.setAttribute("departDay", day);
			}
			else if((Integer)request.getAttribute("helperCount") == 6) { //flexible, get flights at departDate+3
	     		c1.add(Calendar.DATE, 3);
				request.setAttribute("departureDate", formatter.format(c1.getTime()));
      			int day = ((Integer)request.getAttribute("inputDay")+2)%7+1;
      			request.setAttribute("departDay", day);
			}
			
			if(request.getAttribute("returnDate") != null) {
	      		c1 = Calendar.getInstance();
				c1.setTime(formatter.parse((String)request.getAttribute("inReturnDate")));
				c1.set(Calendar.HOUR_OF_DAY, 23);
				
				if((Integer)request.getAttribute("helperCount") == 7) { //flexible, get flights at departDate+1
		     		c1.add(Calendar.DATE, -1);
					request.setAttribute("returnDate", formatter.format(c1.getTime()));
	      			int day = ((Integer)request.getAttribute("inReturnDay")+5)%7+1;
	      			request.setAttribute("returnDay", day);
				}
				else if((Integer)request.getAttribute("helperCount") == 8) { //flexible, get flights at departDate+1
		     		c1.add(Calendar.DATE, -1);
					request.setAttribute("returnDate", formatter.format(c1.getTime()));
	      			int day = ((Integer)request.getAttribute("inReturnDay")+4)%7+1;
	      			request.setAttribute("returnDay", day);
				}
				else if((Integer)request.getAttribute("helperCount") == 9) { //flexible, get flights at departDate+1
		     		c1.add(Calendar.DATE, -1);
					request.setAttribute("returnDate", formatter.format(c1.getTime()));
	      			int day = ((Integer)request.getAttribute("inReturnDay")+3)%7+1;
	      			request.setAttribute("returnDay", day);
				}
				else if((Integer)request.getAttribute("helperCount") == 10) { //flexible, get flights at departDate+1
		     		c1.add(Calendar.DATE, 1);
					request.setAttribute("returnDate", formatter.format(c1.getTime()));
	      			int day = ((Integer)request.getAttribute("inReturnDay"))%7+1;
	      			request.setAttribute("returnDay", day);
				}
				else if((Integer)request.getAttribute("helperCount") == 11) { //flexible, get flights at departDate+1
		     		c1.add(Calendar.DATE, 2);
					request.setAttribute("returnDate", formatter.format(c1.getTime()));
	      			int day = ((Integer)request.getAttribute("inReturnDay")+1)%7+1;
	      			request.setAttribute("returnDay", day);
				}
				else if((Integer)request.getAttribute("helperCount") == 12) { //flexible, get flights at departDate+1
		     		c1.add(Calendar.DATE, 3);
					request.setAttribute("returnDate", formatter.format(c1.getTime()));
	      			int day = ((Integer)request.getAttribute("inReturnDay")+2)%7+1;
	      			request.setAttribute("returnDay", day);
				}
			}
			
  			if((Integer)request.getAttribute("helperCount") <= 6) {
  				toPage = "viewFlightsHelper.jsp";
  			}
  			else if ((request.getAttribute("returnDate")!=null) && ((Integer)request.getAttribute("helperCount") <= 12) && ((Integer)request.getAttribute("helperCount") > 6)) {
  				toPage = "viewFlightsHelperRoundTrip.jsp";
  			}
		}

	}
	
	request.getRequestDispatcher(toPage).include(request,response);

%>
</body>
</html>
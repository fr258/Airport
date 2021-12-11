<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" %>
<%@ page import="java.io.*,java.util.*,java.sql.*,connection.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>processing cancellation</title>
</head>
<body>
	<%
		String tID = request.getParameter("id"); 
		String first = "first";
		String business = "business";
		String economy = "economy";
		ArrayList<String> msg = new ArrayList<>();
		try {
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			String getTicket ="select tID, class from ticket where tID ="+tID;
			PreparedStatement ps = con.prepareStatement(getTicket);
	        ResultSet rs = ps.executeQuery();
			if(!rs.next())  {
				msg.add("Ticket is not found.");
			} else {
				String css = rs.getString("class");
				if (css.equals(economy)) {
					%>
					<p> There will be $50 fee applied to your account. <p> 
					<%
				} else {
					%>
					<p> There will be no fee. <p> 
					<%
				}
				%>
				<form action="processCancel2.jsp" method="post">	
                	<button type="submit" name="id" value=<%=rs.getInt("tID") %>>Cancel ticket</button>
        		</form>
				<%
			}
				
			ArrayList<String> errors = (ArrayList<String>) request.getAttribute("msg");
			if(errors != null) {
				for(String a: errors)
					out.println(a);
				request.setAttribute("msg", null);
	        con.close();
			}
			%>
			<form action="viewUpcomingReservations.jsp" method="post">	
            	<button type="submit" name="id">Return</button>
    		</form>
			<%
		}
	    catch (Exception ex) {
	    	msg = new ArrayList<>();
	    	msg.add("Something went wrong. Please try again.");
	    	msg.add(ex.toString());
			request.setAttribute("msg", msg);
			request.getRequestDispatcher("viewUpcomingReservations.jsp").forward(request, response);
	    }


			
	%>
	
	
	

</body>
</html>
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
			}
			else {
				//msg.add("Ticket is found");
			}
			
					
			if(msg.isEmpty()) {
				//Make an insert statement for the questions table:
				String cancel = "update ticket set isCancelled = 1 where tID = ?";
             	ps = con.prepareStatement(cancel);
             	ps.setInt(1, rs.getInt("tID"));
             	ps.executeUpdate();
				msg.add("Ticket has been cancelled!");
				request.setAttribute("msg", msg);
				request.getRequestDispatcher("processCancel.jsp").forward(request, response);
			}
			else {
				request.setAttribute("msg", msg);
				request.getRequestDispatcher("processCancel.jsp").forward(request, response);
			}
	        con.close();
		}
	    catch (Exception ex) {
	    	msg = new ArrayList<>();
	    	msg.add("Something went wrong. Please try again.");
	    	msg.add(ex.toString());
			request.setAttribute("msg", msg);
			request.getRequestDispatcher("processCancel.jsp").forward(request, response);
	    }


			
	%>
	
	
	

</body>
</html>
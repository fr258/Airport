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
	<%
	try {

		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();

		//Create a SQL statement
		Statement stmt = con.createStatement();

		PreparedStatement ps = con.prepareStatement("SELECT max(fnum) AS largest FROM flight");
        ResultSet rs = ps.executeQuery();
        int maxfnum = 0;
        
        if(!rs.next())
        {
        	maxfnum = 1;
        }
        else
        {
        	maxfnum = rs.getInt("largest")+1;
        }
        //System.out.println(maxfnum);
		//Get parameters from the HTML form at the index.jsp
		String arrivalApID = request.getParameter("arrivalApID");
		String departApID = request.getParameter("departApID");
		String aID = request.getParameter("aID");
		String acrID = request.getParameter("acrID");
		String arrivalTime = request.getParameter("arrivalTime");
		String departTime = request.getParameter("departureTime");
		boolean isDomestic =false;
		if(request.getParameter("isDomestic")!=null)
		{
			isDomestic = true;
		}
		//System.out.println("1:" + arrivalApID);
		//Make an insert statement for the Sells table:
		String insert = "INSERT INTO flight(fnum, arrivalApID, departApID, aID, acrID, departTime, arrivalTime, isDomestic)"
				+ "VALUES (?, ?,?,?,?,?,?,?)";
		//Create a Prepared SQL statement allowing you to introduce the parameters of the query
		 ps = con.prepareStatement(insert);

		//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
		ps.setInt(1, maxfnum);
		ps.setString(2, arrivalApID);
		ps.setString(3, departApID);
		ps.setString(4,aID);
		ps.setString(5,acrID);
		ps.setString(6,departTime);
		ps.setString(7,arrivalTime);
		ps.setBoolean(8,isDomestic);
		
		//Run the query against the DB
		ps.executeUpdate();
		//Run the query against the DB
		
		String s[] = request.getParameterValues("days");
		if(s!=null && s.length!=0)
		{
			insert = "INSERT INTO operatingDays(days, fnum, aID)"+ "VALUES(?,?,?)";
			ps= con.prepareStatement(insert);
			ps.setInt(2, maxfnum);
			ps.setString(3, aID);
			for(int i = 0; i<s.length; i++)
			{
				if(s[i].equals("Sunday")){ps.setInt(1,1);	ps.executeUpdate();	}
				if(s[i].equals("Monday")){ps.setInt(1,2);	ps.executeUpdate();	}
				if(s[i].equals("Tuesday")){ps.setInt(1,3);	ps.executeUpdate();	}
				if(s[i].equals("Wednesday")){ps.setInt(1,4);	ps.executeUpdate();	}
				if(s[i].equals("Thursday")){ps.setInt(1,5);	ps.executeUpdate();	}
				if(s[i].equals("Friday")){ps.setInt(1,6);	ps.executeUpdate();	}
				if(s[i].equals("Saturday")){ps.setInt(1,7);	ps.executeUpdate();	}
				System.out.println("inserted");
			}
		}
		
		//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
		con.close();
		out.print("insert succeeded");
		
	} catch (Exception ex) {
		out.print(ex);
		out.print("insert failed");
	}
	
	
	%>
</body>
</html>
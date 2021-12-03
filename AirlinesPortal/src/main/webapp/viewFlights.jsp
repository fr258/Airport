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
<%
	try {
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		Calendar c = Calendar.getInstance();
		c.setTime(new SimpleDateFormat("MM/dd/yyyy").parse(request.getParameter("departDate"))); 
		int departDay = c.get(Calendar.DAY_OF_WEEK);
		
		String origin = request.getParameter("originAirport");
		String dest = request.getParameter("destAirport");
		
		String getFlights = "select f.fnum fnum1, f.aID aID1, null fnum2, null aID2, null fnum3, null aID3 "
		        +"from flight f, operatingdays d "
		        +"where f.fnum = d.fnum "
		        +	"and f.aID = d.aID "
		        +	"and d.days = '"+departDay+"' "
		        +	"and f.departApID = '"+origin+"' "
		        +	"and f.arrivalApID = '"+dest+"' "

		        +"union "

		        +"select f1.fnum fnum1, f1.aID aID1, f2.fnum fnum2, f2.aID aID2, null fnum3, null aID3 "
		        +"from flight f1, operatingdays d, flight f2 "
		        +"where f1.fnum = d.fnum and f1.aID = d.aID "
				+	"and d.days = '"+departDay+"' "
		        +	"and f1.departApID = '"+origin+"' "
		        +	"and f1.arrivalApID = f2.departApID "
		        +	"and f2.arrivalApID = '"+dest+"' "

		        +"union "

		        +"select f1.fnum fnum1, f1.aID aID1, f2.fnum fnum2, f2.aID aID2, f3.fnum fnum3, f3.aID aID3 "
		        +"from flight f1, operatingdays d, flight f2, flight f3 "
		        +"where f1.fnum = d.fnum and f1.aID = d.aID "
		        + 	"and d.days = '"+departDay+"' "
		        +	"and f1.departApID = '"+origin+"' "
		        +	"and f1.arrivalApID = f2.departApID "
		        +	"and f2.arrivalApID = f3.departApID "
		        +	"and f3.arrivalApID = '"+dest+"' ";
		
		PreparedStatement ps = con.prepareStatement(getFlights);
        ResultSet rs = ps.executeQuery(); 
        
        //feel free to modify below here%>

        <h2> Search Results </h2>
        <table>
        	<tr>
				<td> <strong>fnum1</strong> </td> <td> <strong>aID1</strong> </td> 
				<td> <strong>fnum2</strong> </td> <td> <strong>aID2</strong> </td>
				<td> <strong>fnum3</strong> </td> <td> <strong>aID3</strong> </td>       
	        </tr>
        <%while(rs.next()) { %>
			<tr>
				<td> <%=rs.getString("fnum1")%> </td>  <td> <%=rs.getString("aID1")%> </td>    
		        <td> <%=rs.getString("fnum2")%> </td>  <td> <%=rs.getString("aID2")%> </td>  
		        <td> <%=rs.getString("fnum3")%> </td>  <td> <%=rs.getString("aID3")%> </td>   
	        </tr>
        <% } %>
        </table>

		

		
		
        <%con.close();
	}
    catch (Exception ex) {
    		out.print(ex);
    		out.print("select failed");
    }
%>
</body>
</html>
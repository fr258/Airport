<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,connection.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
 
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Edit Flight</title>
</head>
<body>
	<br>
		<% //NO MODIFYING FNUM OR AID BC THOSE ARE PKS
		
		ApplicationDB db1 = new ApplicationDB();	
		Connection con1 = db1.getConnection(); 
		Statement stmt1 = con1.createStatement();
		ResultSet result1 = stmt1.executeQuery("SELECT * FROM airport");
		Statement stmt4 = con1.createStatement();
		ResultSet result4 = stmt4.executeQuery("SELECT * FROM airport");
		Statement stmt3 = con1.createStatement();
		ResultSet result3 = stmt3.executeQuery("SELECT * FROM aircraft");
		
		Statement stmt7 = con1.createStatement();
		ResultSet result7 = stmt7.executeQuery("SELECT * FROM flight");
		String arrivalApID=""; String departApID=""; String acrID="";String departTime=""; String arrivalTime="";boolean isDomestic=false;
		String fn=""; String ad = "";
		boolean days[]=new boolean[7];
		
		while(result7.next())
		{
			if((result7.getString("fnum")+result7.getString("aID")).equals(request.getParameter("flight")))
			{
				fn = result7.getString("fnum");
				ad = result7.getString("aID");
				arrivalApID = result7.getString("arrivalApID");
				departApID = result7.getString("departApID");
				acrID = result7.getString("acrID");
				departTime = result7.getString("departTime");
				arrivalTime = result7.getString("arrivalTime");
				isDomestic = result7.getBoolean("isDomestic");
				
				Statement stmt8 = con1.createStatement();
				ResultSet result8 = stmt8.executeQuery("SELECT * FROM operatingDays WHERE fnum = '" +result7.getString("fnum")+ "' and aID= '"+ result7.getString("aID")+ "'" );//+ "VALUES(?,?)";
				
				//PreparedStatement ps = con1.prepareStatement(select);
				//ResultSet result8 = ps.executeQuery(); //stmt8.executeQuery("SELECT days FROM operatingDays WHERE fnum = '"+result7.getString("fnum") +"', aID= '"+result7.getString("aID")+"'");
				while(result8.next())
				{
					days[result8.getInt("days")-1]=true;
					System.out.println(result8.getInt("days")-1);
				}
				System.out.println("done days");
			}
		}
		
		%>
		
		<form method="post" action="repEditFlight.jsp">
		<table>
		<tr><td><input type = "hidden" name="fnum" value = <%=fn %>></td>
		</tr>
		<tr><td><input type = "hidden" name="aID" value = <%=ad %>></td>
		</tr>
		<tr>
		<td>Arrival Airport</td><td>
		<select name="arrivalApID" size=1>
			<% while(result1.next())
				{
				if(result1.getString("apID").equals(arrivalApID))
					{%>
				<option value= <%=result1.getString("apID")%> selected> <%=result1.getString("apname")%>
				<%}
				else
				{%>
					<option value= <%=result1.getString("apID")%> > <%=result1.getString("apname")%>
				<%}
				
				}
			%>
			</select></td></tr>
		<tr>
		<td>Departure Airport</td><td>
		<select name="departApID" size=1>
			<% while(result4.next())
				{
				if(result4.getString("apID").equals(departApID))
					{%>
				<option value= <%=result4.getString("apID")%> selected> <%=result4.getString("apname")%>
				<%}
				else
				{%>
					<option value= <%=result4.getString("apID")%> > <%=result4.getString("apname")%>
				<%}
				
				}
			%>
			</select></td></tr>
		<td>Aircraft</td><td>
		<select name="acrID" size=1>
			<% while(result3.next())
				{
				if(result3.getString("acrID").equals(acrID))
					{%>
				<option value= <%=result3.getString("acrID")%> selected> <%=result3.getString("acrID")%>
				<%}
				else
				{%>
					<option value= <%=result3.getString("acrID")%> > <%=result3.getString("acrID")%>
				<%}
				
				}
			%>
			</select></td></tr>
		<tr>
		<td>Departure Time hh:mm:ss</td><td><input type="time" name="departureTime" value=<%=departTime %>></td>
		</tr>
		<tr>
		<td>Arrival Time hh:mm:ss</td><td><input type="time" name="arrivalTime" value=<%=arrivalTime %>></td>
		</tr>
		<tr>
		<td>is Domestic <input type="checkbox" name="isDomestic" <%if(isDomestic){ %> checked <%} %>></td>
		</tr>
		<tr>
		<td><input type="checkbox" name="days" <%if(days[0]) {%> checked <%} %>>Sunday</td>
		<td><input type="checkbox" name="days" <%if(days[1]) {%> checked <%} %>>Monday</td>
		<td><input type="checkbox" name="days" <%if(days[2]) {%> checked <%} %>>Tuesday</td>
		<td><input type="checkbox" name="days" <%if(days[3]) {%> checked <%} %>>Wednesday</td>
		<td><input type="checkbox" name="days" <%if(days[4]) {%> checked <%} %>>Thursday</td>
		<td><input type="checkbox" name="days" <%if(days[5]) {%> checked <%} %>>Friday</td>
		<td><input type="checkbox" name="days" <%if(days[6]) {%> checked <%} %>>Saturday</td>
		</tr>
		</table>
		<br> 
		<input type="submit" value="Save Changes">
		</form>
		
	<br>
	
	<%
	if(request.getParameter("arrivalApID")!=null)
	{
		String fid = request.getParameter("fnum");
		String airlineid = request.getParameter("aID");
		 String arApID = request.getParameter("arrivalApID");if(arApID==null){arApID="";}
		 String dID = request.getParameter("departApID");if(dID==null){dID="";}
		 String acID = request.getParameter("acrID");if(acID==null){acID="0";}
		 String dTime = request.getParameter("departTime");if(dTime==null){dTime="00:00:00";}
		 String aTime = request.getParameter("arrivalTime");if(aTime==null){aTime="00:00:00";}
		 boolean dom=false;
		 if(request.getParameter("isDomestic")!=null)
			{
				dom = true;
			}
		 
		Statement stmt9 = con1.createStatement();
		String up = "UPDATE flight SET arrivalApID = ? ,departApID = ? , acrID = ? ,departTime = ? , arrivalTime = ? , isDomestic = ? WHERE fnum = ? and aID= ?" + "VALUES(?,?,?,?,?,?,?,?)";
		PreparedStatement ps1 = con1.prepareStatement(up);
		ps1.setString(1,arApID);
		ps1.setString(2, dID);
		ps1.setString(3,acID);
		ps1.setString(4,dTime);
		ps1.setString(5,aTime);
		ps1.setBoolean(6, dom);
		ps1.setString(7,fid);
		ps1.setString(8,airlineid);
		
	}
	
	
	
	%>
	<%con1.close();%>
</body>
</html>
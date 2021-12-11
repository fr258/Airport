<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" %>
<%@ page import="java.io.*,java.util.*,java.sql.*,connection.* " %>
<%@ page import="javax.servlet.http.*,javax.servlet.*,java.text.SimpleDateFormat"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Purchase Ticket</title>
</head>
<body>
	<%
		Connection con = (Connection)session.getAttribute("connection");
		String id = request.getParameter("id");
		
		PreparedStatement ps = con.prepareStatement("select * from results where id = "+session.getAttribute("id"));
		ResultSet rs = ps.executeQuery();
		rs.next();
		
		boolean needWaitingList = false;
		int[] freeSeats = {0, 0, 0};
		for(int i = 1; i <= 3; i++) { //max of 3 flights
			if(rs.getString("fnum"+i) != null) {
				ps = con.prepareStatement("select a.numSeats numseats "+
											"from aircraft a, flight f "+
												"where f.fnum = "+rs.getInt("fnum"+i)+" and "+
												"f.aID = '"+rs.getString("airline"+i)+"' and "+
												"f.acrID = a.acrID and "+
												"f.aID = a.aID"
										);
				ResultSet temp = ps.executeQuery(); 
				temp.next();
				int numseats = temp.getInt("numseats");
				String departDate = "";
				if(i==1)
					departDate = rs.getString("departTime");
				else
					departDate = rs.getString("departTime"+i);
				int fnum = rs.getInt("fnum"+i);
				String aID = rs.getString("airline"+i);
				
				ps = con.prepareStatement("select count(*) numSeatsTaken "+
											"from ticket t, includes i "+
											"where t.isCancelled = false and "+
											"i.date = '"+departDate+"' and "+
											"i.fnum = "+fnum+" and "+
											"i.aID = '"+aID+"' and "+
											"t.tID = i.tID"
										);
				temp = ps.executeQuery();
				temp.next();
				//out.println(temp.getInt("numTickets"));
				if(numseats <= temp.getInt("numSeatsTaken")) { //no free space on flight
					needWaitingList = true;
					break;
				}
				else { //there are free seats, find their seatnums
					ps = con.prepareStatement("drop table if exists nums");
					ps.executeUpdate();
					ps = con.prepareStatement("create temporary table nums (val int)");
					ps.executeUpdate();
					String numRange = "insert into nums values ";
					for(int b = 1; b <= numseats; b++)
						numRange += "("+b+"), ";
					numRange = numRange.substring(0, numRange.length()-2); //exclude last comma
					ps = con.prepareStatement(numRange);
					ps.executeUpdate();
					
					ps = con.prepareStatement("select min(val) freeSeat "+
												"from nums "+
												"where val not in "+
												"( "+
													"select i.seatnum "+
													"from includes i, ticket t "+
													"where i.date = '"+departDate+"' and "+ 
													"i.fnum = "+fnum+" and "+ 
													"i.tID = t.tID and "+ 
													"t.isCancelled = false and "+ 
													"i.aID = '"+aID+"' "+
												")"
											);
					temp = ps.executeQuery();
					temp.next();
					freeSeats[i-1] = temp.getInt("freeSeat");
					out.println("freeSeat: "+temp.getInt("freeSeat"));
				}
			}
			
		}
		if(needWaitingList) {

		}
		else { //make reservation
			for(int i = 0; i < 3; i++) {
				//out.println(freeSeats[i]);
				if(freeSeats[i]!=0) {
					ps = con.prepareStatement("select max(tID) max from ticket");
					ResultSet temp = ps.executeQuery();
					int max = 0;
					if(temp.next()) {
						max = temp.getInt("max");
					}
					ps = con.prepareStatement("select f.departApID departApID, f.arrivalApID arrivalApID "+
							"from aircraft a, flight f "+
								"where f.fnum = "+rs.getInt("fnum"+(i+1))+" and "+
								"f.aID = '"+rs.getString("airline"+(i+1))+"' and "+
								"f.acrID = a.acrID and "+
								"f.aID = a.aID"
						);
					temp = ps.executeQuery();
					temp.next();
	
					java.util.Date theDate = new java.util.Date();
					SimpleDateFormat format = new SimpleDateFormat("HH:mm:ss");
					String formatted = format.format(theDate);
					
					ps = con.prepareStatement("insert into ticket values ("+(max+1) + ", 30, "+"'"+formatted+"', '"+temp.getString("arrivalApID")+"', '"+temp.getString("departApID")+"', '"+(((String)session.getAttribute("class")).split(","))[0]+"', "+session.getAttribute("price")+", "+freeSeats[i]+", false, false, 'user')");                                
					ps.executeUpdate();
				}
			}
		}
		
		

		
	%>

</body>
</html>
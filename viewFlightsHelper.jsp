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
<!-- <p> in helper! </p> -->
<%
	try {
		Connection con = (Connection)session.getAttribute("connection");
		String departureDate = (String)request.getAttribute("departureDate");
		Integer departDay = (Integer)request.getAttribute("departDay");	
		String origin = (String)request.getAttribute("origin");
		String dest = (String)request.getAttribute("dest");
		
		
		request.setAttribute("helperCount", (Integer)(request.getAttribute("helperCount"))+1);
		

		
		String getFlights = 
					"select f.fnum fnum1, f.aID aID1, null fnum2, null aID2, null fnum3, null aID3, a1.apname depart, null stop1, null stop2, a2.apname arrive "+
			        "from flight f, operatingdays d, airport a1, airport a2 "+
			        "where f.fnum = d.fnum  "+
			            "and f.aID = d.aID "+
			            "and d.days = "+departDay+" "+
			            "and f.departApID = '"+origin+"' "+
			            "and f.arrivalApID = '"+dest+"' "+
			            "and a1.apID = f.departApID "+
			            "and a2.apID = f.arrivalApID "+
	
			        "union "+
	
			        "select f1.fnum fnum1, f1.aID aID1, f2.fnum fnum2, f2.aID aID2, null fnum3, null aID3, a1.apname depart, a2.apname stop1, null stop2, a3.apname arrive "+
			        "from flight f1, operatingdays d, flight f2, airport a1, airport a2, airport a3 "+
			        "where f1.fnum = d.fnum and f1.aID = d.aID "+
			            "and d.days = "+departDay+" "+
			            "and f1.departApID = '"+origin+"' "+
			            "and f1.arrivalApID = f2.departApID "+
			            "and f2.arrivalApID = '"+dest+"' "+
			            "and a1.apID = f1.departApID "+
			            "and a2.apID = f1.arrivalApID "+
			            "and a3.apID = f2.arrivalApID "+
	
			        "union "+
	
			        "select f1.fnum fnum1, f1.aID aID1, f2.fnum fnum2, f2.aID aID2, f3.fnum fnum3, f3.aID aID3, a1.apname depart, a2.apname stop1, a3.apname stop2,  a4.apname arrive "+
			        "from flight f1, operatingdays d, flight f2, flight f3, airport a1, airport a2, airport a3, airport a4 "+
			        "where f1.fnum = d.fnum and f1.aID = d.aID "+
			            "and d.days = "+departDay+" "+
			            "and f1.departApID = '"+origin+"' "+
			            "and f1.arrivalApID = f2.departApID "+
			            "and f2.arrivalApID = f3.departApID "+
			            "and f3.arrivalApID = '"+dest+"' "+
			            "and a1.apID = f1.departApID "+
			            "and a2.apID = f1.arrivalApID "+
			            "and a3.apID = f2.arrivalApID "+
			            "and a4.apID = f3.arrivalApID "+
			            "and a1.apID <> a2.apID "+
			            "and a2.apID <> a3.apID "+
			            "and a2.apID <> a4.apID "+
			            "and a1.apID <> a3.apID ";
		
		PreparedStatement ps = con.prepareStatement(getFlights);
        ResultSet rs = ps.executeQuery(); 
        
        while(rs.next()) { 
        	String tempQuery = "select departTime, arrivalTime from flight where fnum ="+rs.getInt("fnum1")+" and aID = '"+rs.getString("aID1")+"'";
    		ps = con.prepareStatement(tempQuery);
            ResultSet temprs = ps.executeQuery(); 
            temprs.next();

        	if(rs.getString("stop1") == null) { //no stops
        		String flightPath = rs.getString("depart")+" -> "+rs.getString("arrive");
        		java.util.Date datetimeDepart = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss").parse(departureDate+" "+temprs.getString("departTime"));
      			String datetimeDepartStr = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(datetimeDepart);
        		java.util.Date datetimeArrive = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss").parse(departureDate+" "+temprs.getString("arrivalTime"));
      			String datetimeArriveStr = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(datetimeArrive);
      			float price = flightPath.length() * (float)Math.sqrt(datetimeArrive.getTime())/50000;

      			ps = con.prepareStatement("select max(id) id from results");
      			ResultSet tempset = ps.executeQuery();
      			int id = (tempset.next()) ? tempset.getInt("id")+1 : 0;
      			
        		String insertQuery = "insert into results values ("+id+", '"+flightPath+"', '"+datetimeDepartStr+"', null, null, '"+datetimeArriveStr+"', "+ price+", 0,'"+rs.getString("aID1")+"',  null, null, "+rs.getInt("fnum1")+", null, null)";
        		ps = con.prepareStatement(insertQuery);
        		ps.executeUpdate();
        		
        	 }
        	else { //one or two stops 
        		String stop2 = (rs.getString("stop2") == null) ? "" : " -> "+rs.getString("stop2");
        		String tempQueryDays = "select days, departTime, arrivalTime "+
        								"from operatingdays d, flight f "+
        								"where d.fnum = "+rs.getInt("fnum2")+" and d.aID = '"+rs.getString("aID2")+"' "+
        								"and d.fnum = f.fnum and d.aID = f.aID";
        		PreparedStatement ps2 = con.prepareStatement(tempQueryDays);
                ResultSet temprsDays = ps2.executeQuery();
                
                java.util.Date flight2DepartTime = null;
                java.util.Date flight1ArrivalTime = null;
                int minDay = 7;
                boolean sameDay = false;
                String arriveTime = "";
                String flight2DepartTimeStr = "";
                
                int numDays = 0;
                
                if(temprsDays.next()) {
                	flight2DepartTimeStr = temprsDays.getString("departTime");
                   	flight2DepartTime = new SimpleDateFormat("hh:mm:ss").parse(flight2DepartTimeStr);
                	flight1ArrivalTime = new SimpleDateFormat("hh:mm:ss").parse(temprs.getString("arrivalTime"));
                	arriveTime = temprsDays.getString("arrivalTime");
                	numDays = temprsDays.getInt("days");
                	if(numDays == departDay)
                		sameDay = true;
                	if((numDays+6-departDay)%7 < minDay)
                		minDay = (numDays+6-departDay)%7;
                }
                while(temprsDays.next()) {
                	numDays = temprsDays.getInt("days");
                	if(numDays == departDay)
                		sameDay = true;
                	if((numDays+6-departDay)%7 < minDay)
                		minDay = (numDays+6-departDay)%7;
                }
 				boolean oneStop = rs.getString("stop2") == null;

             
              	if(minDay != 7) { //flight operates >=1 days 
              		String depart2Date = "";
              		if(sameDay && flight2DepartTime.after(flight1ArrivalTime)) {
              			depart2Date = departureDate;
              		}
              		else {
	             		SimpleDateFormat formatter = new SimpleDateFormat("MM/dd/yyyy");
	              		Calendar c1 = Calendar.getInstance();
						c1.setTime(formatter.parse(departureDate));
	             		c1.add(Calendar.DATE, minDay+1);
	              		depart2Date = formatter.format(c1.getTime());
              		}
              		
                	java.util.Date datetimeDepart = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss").parse(departureDate+" "+temprs.getString("departTime"));
              		String datetimeDepartStr = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(datetimeDepart);
              		java.util.Date datetimeDepart2 = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss").parse(depart2Date +" "+ flight2DepartTimeStr); 
              		String datetimeDepart2Str = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(datetimeDepart2);
              		
                    if(oneStop) {
                  		String flightPath = rs.getString("depart")+" -> "+rs.getString("stop1")+" -> "+rs.getString("arrive");
                  		
                    	//java.util.Date datetimeDepart = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss").parse(departureDate+" "+temprs.getString("departTime"));
                  		//String datetimeDepartStr = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(datetimeDepart);
                  		
                  		//java.util.Date datetimeDepart2 = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss").parse(depart2Date +" "+ flight2DepartTimeStr); 
                  		//String datetimeDepart2Str = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(datetimeDepart2);
                  		
                       	java.util.Date datetimeArrive = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss").parse(depart2Date +" "+ arriveTime);
                     	String datetimeArriveStr = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(datetimeArrive);
                  		float price = flightPath.length() * (float)Math.sqrt(datetimeArrive.getTime())/50000;		
                     	
                     	ps2 = con.prepareStatement("select max(id) id from results");
              			ResultSet tempset = ps2.executeQuery();
              			int id = (tempset.next()) ? tempset.getInt("id")+1 : 0;
              			
                		String insertQuery = "insert into results values ("+id+", '"+flightPath+"', '"+datetimeDepartStr+"', '"+datetimeDepart2Str+"', null, '"+datetimeArriveStr+"', "+ price+", 1, '"+rs.getString("aID1")+"', '"+rs.getString("aID2")+"', null, "+rs.getInt("fnum1")+", "+rs.getInt("fnum2")+ ", null)";
                    	PreparedStatement ps3 = con.prepareStatement(insertQuery);
                    	ps3.executeUpdate();
                      }
					else { //two stops 
						tempQueryDays = "select days, departTime, arrivalTime "+
			   								"from operatingdays d, flight f "+
			   								"where d.fnum = "+rs.getInt("fnum3")+" and d.aID = '"+rs.getString("aID3")+"' "+
			   								"and d.fnum = f.fnum and d.aID = f.aID";
		              	
		        		ps2 = con.prepareStatement(tempQueryDays);
		                ResultSet temprsDays2 = ps2.executeQuery();
		                
		                Calendar c = Calendar.getInstance();
		        		c.setTime(new SimpleDateFormat("MM/dd/yyyy").parse(depart2Date)); 
		        		int departDay2 = c.get(Calendar.DAY_OF_WEEK);
		        		//out.println("departDay2: "+departDay2);
		                
		                java.util.Date flight3DepartTime = null;
		                java.util.Date flight2ArrivalTime = null;
		                String arriveTime3 = "";
		                String flight3DepartTimeStr = "";
		                minDay = 7;
		                sameDay = false;
		                if(temprsDays2.next()) {
		                	flight3DepartTimeStr = temprsDays2.getString("departTime");
		                	arriveTime = temprsDays2.getString("arrivalTime");
		                   	flight3DepartTime = new SimpleDateFormat("hh:mm:ss").parse(flight3DepartTimeStr);
		                	flight2ArrivalTime = new SimpleDateFormat("hh:mm:ss").parse(arriveTime);
		                	numDays = temprsDays2.getInt("days");
		                	if(numDays == departDay2) {
		                		sameDay = true;
		                	}
		                	if((numDays+6-departDay2)%7 < minDay)
		                		minDay = (numDays+6-departDay2)%7;
		                	arriveTime3 = temprsDays2.getString("arrivalTime");
		                }
		                while(temprsDays2.next()) {
		                	numDays = temprsDays2.getInt("days");
		                	if(numDays == departDay2) {
		                		sameDay = true;
		                	}
		                	if((numDays+6-departDay2)%7 < minDay)
		                		minDay = (numDays+6-departDay2)%7;
		                }
		              
			             if(minDay != 7) { //flight operates >=1 days 
	              			String depart3Date = "";
		              		if(sameDay && flight3DepartTime.after(flight2ArrivalTime)) {
		              			depart3Date = depart2Date;
		              		}
		              		else {
			             		SimpleDateFormat formatter = new SimpleDateFormat("MM/dd/yyyy");
			              		Calendar c1 = Calendar.getInstance();
								c1.setTime(formatter.parse(depart2Date));
			             		c1.add(Calendar.DATE, minDay+1);
			              		depart3Date = formatter.format(c1.getTime());
		              		}
		
		                  	String flightPath = rs.getString("depart")+" -> "+rs.getString("stop1")+" -> "+rs.getString("stop2")+" -> "+rs.getString("arrive");
		                  	
		                    //java.util.Date datetimeDepart = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss").parse(departureDate+" "+temprs.getString("departTime"));
		                  	//String datetimeDepartStr = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(datetimeDepart);
		                  	
		                  	java.util.Date datetimeDepart3 = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss").parse(depart3Date +" "+ flight3DepartTimeStr); 
                  			String datetimeDepart3Str = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(datetimeDepart3);
		                  	
		                    java.util.Date datetimeArrive = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss").parse(depart3Date +" "+ arriveTime);
		                    String datetimeArriveStr = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(datetimeArrive);
		                    float price = flightPath.length() * (float)Math.sqrt(datetimeArrive.getTime())/50000;	
		                     			
		                    ps2 = con.prepareStatement("select max(id) id from results");
		          			ResultSet tempset = ps2.executeQuery();
		          			int id = (tempset.next()) ? tempset.getInt("id")+1 : 0;
		          			
		            		String insertQuery = "insert into results values ("+id+", '"+flightPath+"', '"+datetimeDepartStr+"', '"+datetimeDepart2Str+"', '"+datetimeDepart3Str+"', '"+datetimeArriveStr+"', "+ price+", 2, '"+rs.getString("aID1")+"', '"+rs.getString("aID2")+"', '"+rs.getString("aID3")+"', "+rs.getInt("fnum1")+", "+rs.getInt("fnum2")+ ", "+rs.getInt("fnum3")+")";
		                    PreparedStatement ps3 = con.prepareStatement(insertQuery);
		                    ps3.executeUpdate();

              			}  //end minDay != 7 second stop
					} //end two stops
        	
        		}//end minDay != 7 first stop
	        } //end else one or two stops 
	

		

		} //end while
		
        request.getRequestDispatcher("viewFlights.jsp").include(request, response);
		
	}
    catch (Exception ex) {
    		out.print(ex);
    		//ex.printStackTrace();
    }

%>
</body>
</html>
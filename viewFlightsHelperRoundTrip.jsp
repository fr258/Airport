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
		Connection con = (Connection)session.getAttribute("connection");
		String returnDate = (String)request.getAttribute("returnDate");
		Integer returnDay = (Integer)request.getAttribute("returnDay");	
		String origin = (String)request.getAttribute("dest");
		String dest = (String)request.getAttribute("origin");
		
		request.setAttribute("helperCount", (Integer)(request.getAttribute("helperCount"))+1);
		
		String getFlights = 
					"select f.fnum fnum1, f.aID aID1, null fnum2, null aID2, null fnum3, null aID3, a1.apname depart, null stop1, null stop2, a2.apname arrive "+
			        "from flight f, operatingdays d, airport a1, airport a2 "+
			        "where f.fnum = d.fnum  "+
			            "and f.aID = d.aID "+
			            "and d.days = "+returnDay+" "+
			            "and f.departApID = '"+origin+"' "+
			            "and f.arrivalApID = '"+dest+"' "+
			            "and a1.apID = f.departApID "+
			            "and a2.apID = f.arrivalApID "+
	
			        "union "+
	
			        "select f1.fnum fnum1, f1.aID aID1, f2.fnum fnum2, f2.aID aID2, null fnum3, null aID3, a1.apname depart, a2.apname stop1, null stop2, a3.apname arrive "+
			        "from flight f1, operatingdays d, flight f2, airport a1, airport a2, airport a3 "+
			        "where f2.fnum = d.fnum and f2.aID = d.aID "+
			            "and d.days = "+returnDay+" "+
			            "and f1.departApID = '"+origin+"' "+
			            "and f1.arrivalApID = f2.departApID "+
			            "and f2.arrivalApID = '"+dest+"' "+
			            "and a1.apID = f1.departApID "+
			            "and a2.apID = f1.arrivalApID "+
			            "and a3.apID = f2.arrivalApID "+
	
			        "union "+
	
			        "select f1.fnum fnum1, f1.aID aID1, f2.fnum fnum2, f2.aID aID2, f3.fnum fnum3, f3.aID aID3, a1.apname depart, a2.apname stop1, a3.apname stop2,  a4.apname arrive "+
			        "from flight f1, operatingdays d, flight f2, flight f3, airport a1, airport a2, airport a3, airport a4 "+
			        "where f3.fnum = d.fnum and f3.aID = d.aID "+
			            "and d.days = "+returnDay+" "+
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
        	//out.println("A");
        	String tempQuery = "select departTime, arrivalTime from flight where fnum ="+rs.getInt("fnum1")+" and aID = '"+rs.getString("aID1")+"'";
    		ps = con.prepareStatement(tempQuery);
            ResultSet temprs = ps.executeQuery(); 
            temprs.next();

        	if(rs.getString("stop1") == null) { //no stops
        		//out.println("no stops");
        		String flightPath = rs.getString("depart")+" -> "+rs.getString("arrive");
        		java.util.Date datetimeDepart = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss").parse(returnDate+" "+temprs.getString("departTime"));
      			String datetimeDepartStr = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(datetimeDepart);
        		java.util.Date datetimeArrive = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss").parse(returnDate+" "+temprs.getString("arrivalTime"));
      			String datetimeArriveStr = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(datetimeArrive);
      			float price = flightPath.length() * (float)Math.sqrt(datetimeArrive.getTime())/50000;

      			ps = con.prepareStatement("select max(id) id from resultsReturn");
      			ResultSet tempset = ps.executeQuery();
      			int id = (tempset.next()) ? tempset.getInt("id")+1 : 0;
      			
        		String insertQuery = "insert into resultsReturn values ("+id+", '"+flightPath+"', '"+datetimeDepartStr+"', null, null, '"+datetimeArriveStr+"', "+ price+", 0,'"+rs.getString("aID1")+"',  null, null, "+rs.getInt("fnum1")+", null, null)";
        		ps = con.prepareStatement(insertQuery);
        		ps.executeUpdate();
        		
        	 }
        	 else { //one or two stops
        		 int oldDay = 0;
        	 	 String oldDate = "";
        	 	 //String datetimeDepart1Str = "";
        	 	 String datetimeDepart2Str = "";
        	 	 String datetimeDepart3Str = "";
        	 	 String twoStopsArriveTime = "";
        		 if(rs.getString("stop2") != null) {//two stops 
            		//out.println("two stops");
             		String tempQueryDays = "select days, departTime, arrivalTime "+
             								"from operatingdays d, flight f "+
             								"where d.fnum = "+rs.getInt("fnum2")+" and d.aID = '"+rs.getString("aID2")+"' "+
             								"and d.fnum = f.fnum and d.aID = f.aID";
             		
             		 PreparedStatement ps2 = con.prepareStatement(tempQueryDays);
                     ResultSet temprsDays = ps2.executeQuery();
                     
                     java.util.Date flight3DepartTime = null;
                     java.util.Date flight2ArrivalTime = null;
                     int minDay = 7;
                     boolean sameDay = false;
                     String flight2DepartTimeStr = "";
                     String flight3DepartTimeStr = "";
                     
                     int numDays = 0;
                     
                     if(temprsDays.next()) {
                      	ps2 = con.prepareStatement("select arrivalTime, departTime "+
 					 								"from operatingdays d, flight f "+
 					 								"where d.fnum = "+rs.getInt("fnum3")+" and d.aID = '"+rs.getString("aID3")+"' "+
 					 								"and d.fnum = f.fnum and d.aID = f.aID"
  												);
                      	ResultSet tempSet = ps2.executeQuery();
                      	tempSet.next();
                      	
                    	flight2DepartTimeStr = temprsDays.getString("departTime");
                     	flight3DepartTimeStr = tempSet.getString("departTime");
                     	
                        flight3DepartTime = new SimpleDateFormat("hh:mm:ss").parse(flight3DepartTimeStr);
                     	flight2ArrivalTime = new SimpleDateFormat("hh:mm:ss").parse(temprs.getString("arrivalTime"));
                     	

                     	
                     	twoStopsArriveTime = tempSet.getString("arrivalTime");
                     	
                     	numDays = temprsDays.getInt("days");
                     	//out.println("|numDays:"+numDays+",crunched:"+((6-numDays+returnDay)%7)+"|");
                     	if(numDays == returnDay)
                     		sameDay = true;
                     	if((6-numDays+returnDay)%7 < minDay)
                     		minDay = (6-numDays+returnDay)%7;
                     }
                     while(temprsDays.next()) {
                     	numDays = temprsDays.getInt("days");
                     	//out.println("|numDays:"+numDays+",crunched:"+((6-numDays+returnDay)%7)+"|");
                     	if(numDays == returnDay) {
                     		//out.println("sameDay:"+numDays);
                     		sameDay = true;
                     	}
                     	
                     	if((6-numDays+returnDay)%7 < minDay)
                     		minDay = (6-numDays+returnDay)%7;
                     }
                  
                   	if(minDay != 7) { //flight operates >=1 days 
                   		//out.println("minday is "+minDay);
                   		String depart2Date = "";
                   		if(sameDay && flight3DepartTime.after(flight2ArrivalTime)) {
                   			depart2Date = returnDate;
                   			//out.println("same day");
                   		}
                   		else {
     	             		SimpleDateFormat formatter = new SimpleDateFormat("MM/dd/yyyy");
     	              		Calendar c1 = Calendar.getInstance();
     						c1.setTime(formatter.parse(returnDate));
     	             		c1.add(Calendar.DATE, -minDay-1);
     	              		depart2Date = formatter.format(c1.getTime());
     	              		//out.println("depart2Date: "+depart2Date);
                   		}
                   		
                     	java.util.Date datetime2Depart = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss").parse(depart2Date+" "+ flight2DepartTimeStr);
                   		datetimeDepart2Str = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(datetime2Depart);
                   		java.util.Date datetime3Depart = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss").parse(returnDate +" "+ flight3DepartTimeStr); 
                   		 datetimeDepart3Str = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(datetime3Depart);
                   		
                   		String flightPath = rs.getString("depart")+" -> "+rs.getString("stop1")+" -> "+rs.getString("stop2")+" -> "+rs.getString("arrive");
                   		
                        java.util.Date datetimeArrive = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss").parse(returnDate +" "+ twoStopsArriveTime);
                      	String datetimeArriveStr = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(datetimeArrive);
                   		float price = flightPath.length() * (float)Math.sqrt(datetimeArrive.getTime())/50000;		
                      	
                      	ps2 = con.prepareStatement("select max(id) id from resultsreturn");
               			ResultSet tempset = ps2.executeQuery();
               			int id = (tempset.next()) ? tempset.getInt("id")+1 : 0;
               			
                     	oldDay = returnDay;
                     	oldDate = returnDate;
                     	returnDay = returnDay - minDay - 1;
                     	returnDate = depart2Date; 
        		 	}
        		} //end two stops 
        		 
        		String tempQueryDays = "select days, departTime, arrivalTime "+
        								"from operatingdays d, flight f "+
        								"where d.fnum = "+rs.getInt("fnum1")+" and d.aID = '"+rs.getString("aID1")+"' "+
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
                  	ps2 = con.prepareStatement("select arrivalTime, departTime "+
					 								"from operatingdays d, flight f "+
					 								"where d.fnum = "+rs.getInt("fnum2")+" and d.aID = '"+rs.getString("aID2")+"' "+
					 								"and d.fnum = f.fnum and d.aID = f.aID"
												);
                  	ResultSet tempSet = ps2.executeQuery();
                  	tempSet.next();
                	flight2DepartTimeStr = tempSet.getString("departTime");
                	
                   	flight2DepartTime = new SimpleDateFormat("hh:mm:ss").parse(flight2DepartTimeStr);
                	flight1ArrivalTime = new SimpleDateFormat("hh:mm:ss").parse(temprs.getString("arrivalTime"));
                	arriveTime = temprsDays.getString("arrivalTime");
                	numDays = temprsDays.getInt("days");
                	if(numDays == returnDay)
                		sameDay = true;
                	if((6-numDays+returnDay)%7 < minDay)
                		minDay = (6-numDays+returnDay)%7;
                }
                while(temprsDays.next()) {
                	numDays = temprsDays.getInt("days");
                	if(numDays == returnDay) {
                		sameDay = true;
                	}
                	
                	if((6-numDays+returnDay)%7 < minDay)
                		minDay = (6-numDays+returnDay)%7;
                }
 				boolean oneStop = rs.getString("stop2") == null;

             
              	if(minDay != 7) { //flight operates >=1 days 
              		//out.println("minday is "+minDay);
              		String depart1Date = "";
              		if(sameDay && flight2DepartTime.after(flight1ArrivalTime)) {
              			depart1Date = returnDate;
              		}
              		else {
	             		SimpleDateFormat formatter = new SimpleDateFormat("MM/dd/yyyy");
	              		Calendar c1 = Calendar.getInstance();
						c1.setTime(formatter.parse(returnDate));
	             		c1.add(Calendar.DATE, -minDay-1);
	              		depart1Date = formatter.format(c1.getTime());
	              		//out.println("depart1Date: "+depart1Date);
              		}
              		
                	java.util.Date datetimeDepart = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss").parse(depart1Date+" "+temprs.getString("departTime"));
                	
                	if(datetimeDepart.after(new java.util.Date())) {
                		if(rs.getString("stop2") == null) {
		              		String datetimeDepartStr = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(datetimeDepart);
		              		
		              		java.util.Date datetimeDepart2 = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss").parse(returnDate +" "+ flight2DepartTimeStr); 
		              		datetimeDepart2Str = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(datetimeDepart2);
		              		
		              		String flightPath = rs.getString("depart")+" -> "+rs.getString("stop1")+" -> "+rs.getString("arrive");
		              		
		                   	java.util.Date datetimeArrive = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss").parse(returnDate +" "+ arriveTime);
		                 	String datetimeArriveStr = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(datetimeArrive);
		              		float price = flightPath.length() * (float)Math.sqrt(datetimeArrive.getTime())/50000;		
		                 	
		                 	ps2 = con.prepareStatement("select max(id) id from resultsreturn");
		          			ResultSet tempset = ps2.executeQuery();
		          			int id = (tempset.next()) ? tempset.getInt("id")+1 : 0;
	
		            		String insertQuery = "insert into resultsreturn values ("+id+", '"+flightPath+"', '"+datetimeDepartStr+"', '"+datetimeDepart2Str+"', null, '"+datetimeArriveStr+"', "+ price+", 1, '"+rs.getString("aID1")+"', '"+rs.getString("aID2")+"', null, "+rs.getInt("fnum1")+", "+rs.getInt("fnum2")+ ", null)";
		                	PreparedStatement ps3 = con.prepareStatement(insertQuery);
		                	ps3.executeUpdate();
                		}
                		else {
		              		String datetimeDepartStr = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(datetimeDepart);
		              		//java.util.Date datetimeDepart2 = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss").parse(oldDate +" "+ flight2DepartTimeStr); 
		              		//String datetimeDepart2Str = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(datetimeDepart2);
		              		String flightPath = rs.getString("depart")+" -> "+rs.getString("stop1")+" -> "+rs.getString("stop2")+" -> "+rs.getString("arrive");
		              		
		                   	java.util.Date datetimeArrive = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss").parse(oldDate +" "+ twoStopsArriveTime);
		                 	String datetimeArriveStr = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(datetimeArrive);
		              		float price = flightPath.length() * (float)Math.sqrt(datetimeArrive.getTime())/50000;		
		                 	
		                 	ps2 = con.prepareStatement("select max(id) id from resultsreturn");
		          			ResultSet tempset = ps2.executeQuery();
		          			int id = (tempset.next()) ? tempset.getInt("id")+1 : 0;
	
		            		String insertQuery = "insert into resultsreturn values ("+id+", '"+flightPath+"', '"+datetimeDepartStr+"', '"+datetimeDepart2Str+"', '"+datetimeDepart3Str+"', '"+datetimeArriveStr+"', "+ price+", 1, '"+rs.getString("aID1")+"', '"+rs.getString("aID2")+"', null, "+rs.getInt("fnum1")+", "+rs.getInt("fnum2")+ ", null)";
		                	PreparedStatement ps3 = con.prepareStatement(insertQuery);
		                	ps3.executeUpdate();	
                		}
                	}


        	
        		}//end minDay != 7 first stop
	        }  //end else one or two stops 
	

		

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
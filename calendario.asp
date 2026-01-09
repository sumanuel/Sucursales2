<%
              
         
		 today = date
		 today = dateadd("m", 1, today)
		 'response.Write(dateadd("m", 1, today) & "<br/>")
		 Response.Write("today: " & today & "<br/>")
		    
         todays_day = day(today)
		 Response.Write("todays_day: " & todays_day & "<br/>")
		 
         todays_month = month(today)
		 Response.Write("todays_month :" & todays_month & "<br/>")
		     
         todays_year = year(today)
		 Response.Write("todays_year: " & todays_year & "<br/>")         
         
         month_names = Array("Enero", _
                             "Febrero", _
                             "Marzo", _
                             "Abril", _
                             "Mayo", _
                             "Junio", _
                             "Julio", _
                             "Agosto", _
                             "Septiembre", _
                             "Octubre", _
                             "Noviembre", _
                             "Diciembre")                                      
                  
         this_month = datevalue(todays_month & "/1/" & todays_year)     
		 Response.Write("this_month: " & this_month & "<br/>")
		                       
         next_month = datevalue(dateadd("m", 1, todays_month &  "/1/" & todays_year))
		 Response.Write("next_month (mal): " & next_month & "<br/>")
         
         'Find out when this month starts and ends.         
         first_week_day = weekday(this_month) - 1
		 Response.Write("first_week_day: " & first_week_day & "<br/>")                  
         
         days_in_this_month = datediff("d", this_month, next_month)                  
		 Response.Write("days_in_this_month: " & days_in_this_month & "<br/><br/>")
                          
         calendar_html = "<table style=""background-color:666699; color:ffffff;"">"
         
         calendar_html = calendar_html & _
                         "<tr><td colspan=""7"" align=""center"" style=""background-color:9999cc; color:000000;""> &lt;&lt;&nbsp;" & _
                         month_names(todays_month - 1) & " " & todays_year & " &nbsp;&gt;&gt;</td></tr>"
                           
         calendar_html = calendar_html & "<tr>"
          
         'Fill the first week of the month with the appropriate number of blanks.       
         for week_day = 0 to first_week_day - 1            
             calendar_html = calendar_html & "<td style=""background-color:9999cc; color:000000;"">&nbsp;</td>"   
         next
            
         week_day = first_week_day
         for day_counter = 1 to days_in_this_month           
             week_day = week_day mod 7
            
             if week_day = 0 then
                calendar_html = calendar_html & "</tr><tr>"
             end if
            
             'Do something different for the current day.
             if todays_day = day_counter then
                calendar_html = calendar_html & "<td align=""center""><b>" & day_counter & "</b></td>"
             else
                calendar_html = calendar_html & _
                                "<td align=""center"" style=""background-color:9999cc; color:000000;"">&nbsp;" & _
                                day_counter & "&nbsp;</td>"
             end if
            
             week_day = week_day + 1
         next
            
         calendar_html = calendar_html & "</tr>"
         calendar_html = calendar_html & "</table>"
                   
         f_calendar = calendar_html
		 
		 response.Write(f_calendar)
%>


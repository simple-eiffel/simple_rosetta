note
	description: "[
		Rosetta Code: Date format
		https://rosettacode.org/wiki/Date_format

		Display the current date in two formats.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Date_format"

class
	DATE_FORMAT

create
	make

feature {NONE} -- Initialization

	make
			-- Display date in different formats.
		local
			d: DATE
		do
			create d.make_now

			-- Format 1: "2007-11-10" (ISO 8601)
			print ("Format 1 (ISO 8601): " + iso_format (d) + "%N")

			-- Format 2: "Sunday, November 10, 2007"
			print ("Format 2 (Long): " + long_format (d) + "%N")
		end

feature {NONE} -- Formatting

	iso_format (d: DATE): STRING
			-- Return date in YYYY-MM-DD format.
		do
			Result := d.year.out + "-" + padded (d.month) + "-" + padded (d.day)
		end

	long_format (d: DATE): STRING
			-- Return date in "Weekday, Month Day, Year" format.
		do
			Result := day_name (d.day_of_the_week) + ", "
			Result.append (month_name (d.month) + " ")
			Result.append (d.day.out + ", ")
			Result.append (d.year.out)
		end

	day_name (day_of_week: INTEGER): STRING
			-- Return name of day (1=Sunday, 7=Saturday).
		do
			inspect day_of_week
			when 1 then Result := "Sunday"
			when 2 then Result := "Monday"
			when 3 then Result := "Tuesday"
			when 4 then Result := "Wednesday"
			when 5 then Result := "Thursday"
			when 6 then Result := "Friday"
			when 7 then Result := "Saturday"
			else Result := "Unknown"
			end
		end

	month_name (month: INTEGER): STRING
			-- Return name of month.
		do
			inspect month
			when 1 then Result := "January"
			when 2 then Result := "February"
			when 3 then Result := "March"
			when 4 then Result := "April"
			when 5 then Result := "May"
			when 6 then Result := "June"
			when 7 then Result := "July"
			when 8 then Result := "August"
			when 9 then Result := "September"
			when 10 then Result := "October"
			when 11 then Result := "November"
			when 12 then Result := "December"
			else Result := "Unknown"
			end
		end

	padded (n: INTEGER): STRING
			-- Return n as zero-padded 2-digit string.
		do
			if n < 10 then
				Result := "0" + n.out
			else
				Result := n.out
			end
		end

end

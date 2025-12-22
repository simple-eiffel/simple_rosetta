note
	description: "[
		Rosetta Code: System time
		https://rosettacode.org/wiki/System_time

		Get the current system time.
	]"
	author: "Eiffel Solution"
	rosetta_task: "System_time"

class
	SYSTEM_TIME

create
	make

feature {NONE} -- Initialization

	make
			-- Display current system time.
		local
			dt: SIMPLE_DATE_TIME
			d: DATE
			t: TIME
		do
			-- Current date and time
			create dt.make_now
			print ("Current date/time: " + dt.out + "%N")

			-- Current date only
			create d.make_now
			print ("Current date: " + d.out + "%N")
			print ("  Year: " + d.year.out + "%N")
			print ("  Month: " + d.month.out + "%N")
			print ("  Day: " + d.day.out + "%N")

			-- Current time only
			create t.make_now
			print ("%NCurrent time: " + t.out + "%N")
			print ("  Hour: " + t.hour.out + "%N")
			print ("  Minute: " + t.minute.out + "%N")
			print ("  Second: " + t.second.out + "%N")

			-- Formatted output
			print ("%NFormatted: " + d.year.out + "-")
			print (padded (d.month) + "-" + padded (d.day) + " ")
			print (padded (t.hour) + ":" + padded (t.minute) + ":" + padded (t.second) + "%N")
		end

feature {NONE} -- Helpers

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

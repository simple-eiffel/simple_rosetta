note
	description: "[
		Rosetta Code: Day of the week
		https://rosettacode.org/wiki/Day_of_the_week

		Find which years Christmas falls on a Sunday.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Day_of_the_week"

class
	DAY_OF_WEEK

create
	make

feature {NONE} -- Initialization

	make
			-- Find years when December 25 falls on Sunday.
		local
			year: INTEGER
		do
			print ("Years when Christmas (Dec 25) falls on Sunday:%N")
			print ("=============================================%N%N")

			from year := 2008 until year > 2121 loop
				if day_of_week (year, 12, 25) = 0 then
					print (year.out + "%N")
				end
				year := year + 1
			end
		end

feature -- Calculation

	day_of_week (year, month, day: INTEGER): INTEGER
			-- Day of week for given date (0=Sunday, 1=Monday, ..., 6=Saturday).
			-- Uses Zeller's congruence.
		require
			valid_year: year >= 1
			valid_month: month >= 1 and month <= 12
			valid_day: day >= 1 and day <= 31
		local
			q, m, k, j, h: INTEGER
		do
			q := day
			-- Adjust for January/February
			if month < 3 then
				m := month + 12
				k := (year - 1) \\ 100
				j := (year - 1) // 100
			else
				m := month
				k := year \\ 100
				j := year // 100
			end

			-- Zeller's formula for Gregorian calendar
			h := (q + ((13 * (m + 1)) // 5) + k + (k // 4) + (j // 4) - (2 * j)) \\ 7

			-- Convert from Zeller's (0=Sat) to standard (0=Sun)
			Result := ((h + 6) \\ 7)
		ensure
			valid_result: Result >= 0 and Result <= 6
		end

	day_name (dow: INTEGER): STRING
			-- Name of day of week.
		require
			valid_dow: dow >= 0 and dow <= 6
		do
			inspect dow
			when 0 then Result := "Sunday"
			when 1 then Result := "Monday"
			when 2 then Result := "Tuesday"
			when 3 then Result := "Wednesday"
			when 4 then Result := "Thursday"
			when 5 then Result := "Friday"
			when 6 then Result := "Saturday"
			else
				Result := "Unknown"
			end
		end

end

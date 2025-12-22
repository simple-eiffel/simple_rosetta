note
	description: "[
		Rosetta Code: Leap year
		https://rosettacode.org/wiki/Leap_year

		Determine if a year is a leap year in the Gregorian calendar.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Leap_year"

class
	LEAP_YEAR

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate leap year detection.
		local
			test_years: ARRAY [INTEGER]
			i, year: INTEGER
		do
			test_years := <<1900, 1994, 1996, 1997, 2000, 2004, 2100>>

			print ("Leap Year Detection%N")
			print ("==================%N%N")

			from i := test_years.lower until i > test_years.upper loop
				year := test_years [i]
				print (year.out + ": ")
				if is_leap_year (year) then
					print ("LEAP YEAR%N")
				else
					print ("not a leap year%N")
				end
				i := i + 1
			end
		end

feature -- Query

	is_leap_year (year: INTEGER): BOOLEAN
			-- Is `year` a leap year in Gregorian calendar?
			-- A year is a leap year if:
			--   divisible by 4 AND
			--   (not divisible by 100 OR divisible by 400)
		do
			Result := (year \\ 4 = 0) and ((year \\ 100 /= 0) or (year \\ 400 = 0))
		ensure
			definition: Result = ((year \\ 4 = 0) and ((year \\ 100 /= 0) or (year \\ 400 = 0)))
		end

	days_in_february (year: INTEGER): INTEGER
			-- Number of days in February for given year.
		do
			if is_leap_year (year) then
				Result := 29
			else
				Result := 28
			end
		ensure
			valid_days: Result = 28 or Result = 29
			leap_has_29: is_leap_year (year) implies Result = 29
			non_leap_has_28: not is_leap_year (year) implies Result = 28
		end

	days_in_year (year: INTEGER): INTEGER
			-- Number of days in given year.
		do
			if is_leap_year (year) then
				Result := 366
			else
				Result := 365
			end
		ensure
			valid_days: Result = 365 or Result = 366
		end

end

note
	description: "[
		Rosetta Code: Leap year
		https://rosettacode.org/wiki/Leap_year
		
		Determine if a year is a leap year.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	rosetta_task: "Leap_year"

class
	LEAP_YEAR_CHECK

create
	make

feature {NONE} -- Initialization

	make
		do
			test (1900)
			test (2000)
			test (2020)
			test (2021)
			test (2024)
		end

feature -- Testing

	test (year: INTEGER)
		do
			print (year.out + " is ")
			if is_leap_year (year) then
				print ("a leap year%N")
			else
				print ("not a leap year%N")
			end
		end

	is_leap_year (year: INTEGER): BOOLEAN
			-- Is `year' a leap year?
		do
			Result := (year \\ 4 = 0 and year \\ 100 /= 0) or (year \\ 400 = 0)
		end

end

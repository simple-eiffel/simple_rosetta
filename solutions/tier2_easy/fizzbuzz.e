note
	description: "[
		Rosetta Code: FizzBuzz
		https://rosettacode.org/wiki/FizzBuzz
		
		Classic FizzBuzz programming task.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel - Modern Eiffel libraries"
	rosetta_task: "FizzBuzz"

class
	FIZZBUZZ

create
	make

feature {NONE} -- Initialization

	make
		local
			i: INTEGER
		do
			from i := 1 until i > 100 loop
				if i \ 15 = 0 then
					print ("FizzBuzz")
				elseif i \ 3 = 0 then
					print ("Fizz")
				elseif i \ 5 = 0 then
					print ("Buzz")
				else
					print (i.out)
				end
				if i \ 10 = 0 then
					print ("%N")
				else
					print (" ")
				end
				i := i + 1
			end
		end

end

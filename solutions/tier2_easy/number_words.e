note
	description: "[
		Rosetta Code: Number names
		https://rosettacode.org/wiki/Number_names

		Convert numbers to words.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Number_names"
	tier: "2"

class
	NUMBER_WORDS

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate number to words.
		do
			print ("Number Names%N")
			print ("============%N%N")

			demo (0)
			demo (1)
			demo (13)
			demo (42)
			demo (100)
			demo (123)
			demo (1000)
			demo (1234)
			demo (1000000)
		end

feature -- Demo

	demo (a_n: INTEGER)
			-- Show number in words.
		do
			print (a_n.out + " -> " + to_words (a_n) + "%N")
		end

feature -- Conversion

	to_words (a_n: INTEGER): STRING
			-- Convert number to English words.
		local
			l_n, l_billions, l_millions, l_thousands, l_remainder: INTEGER
		do
			l_n := a_n
			if l_n = 0 then
				Result := "zero"
			elseif l_n < 0 then
				Result := "negative " + to_words (-l_n)
			else
				create Result.make (100)

				l_billions := l_n // 1000000000
				l_n := l_n \\ 1000000000
				l_millions := l_n // 1000000
				l_n := l_n \\ 1000000
				l_thousands := l_n // 1000
				l_remainder := l_n \\ 1000

				if l_billions > 0 then
					Result.append (hundreds_to_words (l_billions) + " billion")
				end
				if l_millions > 0 then
					if not Result.is_empty then Result.append (" ") end
					Result.append (hundreds_to_words (l_millions) + " million")
				end
				if l_thousands > 0 then
					if not Result.is_empty then Result.append (" ") end
					Result.append (hundreds_to_words (l_thousands) + " thousand")
				end
				if l_remainder > 0 then
					if not Result.is_empty then Result.append (" ") end
					Result.append (hundreds_to_words (l_remainder))
				end
			end
		ensure
			result_exists: Result /= Void
		end

feature {NONE} -- Helpers

	ones: ARRAY [STRING]
		once
			Result := <<"", "one", "two", "three", "four", "five",
			            "six", "seven", "eight", "nine", "ten",
			            "eleven", "twelve", "thirteen", "fourteen", "fifteen",
			            "sixteen", "seventeen", "eighteen", "nineteen">>
		end

	tens: ARRAY [STRING]
		once
			Result := <<"", "", "twenty", "thirty", "forty", "fifty",
			            "sixty", "seventy", "eighty", "ninety">>
		end

	hundreds_to_words (a_n: INTEGER): STRING
		local
			l_h, l_t, l_o: INTEGER
		do
			create Result.make (50)
			l_h := a_n // 100
			l_t := (a_n \\ 100) // 10
			l_o := a_n \\ 10

			if l_h > 0 then
				Result.append (ones [l_h + 1] + " hundred")
			end
			if a_n \\ 100 > 0 then
				if not Result.is_empty then Result.append (" ") end
				if a_n \\ 100 < 20 then
					Result.append (ones [(a_n \\ 100) + 1])
				else
					Result.append (tens [l_t + 1])
					if l_o > 0 then
						Result.append ("-" + ones [l_o + 1])
					end
				end
			end
		end

end
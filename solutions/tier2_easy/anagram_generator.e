note
	description: "[
		Rosetta Code: Anagram generator
		https://rosettacode.org/wiki/Anagram_generator

		Generate anagrams of a given string.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Anagram_generator"
	tier: "2"

class
	ANAGRAM_GENERATOR

create
	make

feature {NONE} -- Initialization

	make
			-- Generate anagrams.
		do
			print ("Anagrams of 'abc':%N")
			generate_and_print ("abc")

			print ("%NAnagrams of 'ab':%N")
			generate_and_print ("ab")

			print ("%NAnagrams of 'a':%N")
			generate_and_print ("a")
		end

feature -- Generation

	generate_and_print (a_str: STRING)
			-- Generate and print all anagrams.
		local
			l_anagrams: ARRAYED_LIST [STRING]
		do
			l_anagrams := generate_anagrams (a_str)
			across l_anagrams as l_a loop
				print ("  " + l_a + "%N")
			end
			print ("Total: " + l_anagrams.count.out + "%N")
		end

	generate_anagrams (a_str: STRING): ARRAYED_LIST [STRING]
			-- Generate all permutations of `a_str'.
		require
			str_exists: a_str /= Void
		do
			create Result.make (factorial (a_str.count))
			permute (a_str.twin, 1, a_str.count, Result)
		ensure
			result_exists: Result /= Void
		end

feature {NONE} -- Algorithm

	permute (a_str: STRING; a_left, a_right: INTEGER; a_result: ARRAYED_LIST [STRING])
			-- Generate permutations using Heap's algorithm.
		local
			l_i: INTEGER
		do
			if a_left = a_right then
				a_result.extend (a_str.twin)
			else
				from l_i := a_left until l_i > a_right loop
					swap (a_str, a_left, l_i)
					permute (a_str, a_left + 1, a_right, a_result)
					swap (a_str, a_left, l_i)
					l_i := l_i + 1
				end
			end
		end

	swap (a_str: STRING; a_i, a_j: INTEGER)
			-- Swap characters at positions i and j.
		local
			l_temp: CHARACTER
		do
			l_temp := a_str [a_i]
			a_str [a_i] := a_str [a_j]
			a_str [a_j] := l_temp
		end

	factorial (a_n: INTEGER): INTEGER
			-- Factorial of n.
		do
			if a_n <= 1 then
				Result := 1
			else
				Result := a_n * factorial (a_n - 1)
			end
		end

end

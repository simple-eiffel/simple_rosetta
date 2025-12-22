note
	description: "[
		Rosetta Code: String concatenation
		https://rosettacode.org/wiki/String_concatenation

		Concatenate two strings.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "String_concatenation"
	tier: "1"

class
	STRING_CONCATENATION

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate string concatenation.
		local
			l_s1, l_s2, l_result: STRING
		do
			print ("String Concatenation%N")
			print ("====================%N%N")

			l_s1 := "Hello, "
			l_s2 := "World!"

			-- Using + operator
			l_result := l_s1 + l_s2
			print ("Using '+': " + l_result + "%N")

			-- String literal concatenation
			print ("Literal: " + "Hello, " + "World!" + "%N")

			-- Multiple concatenations
			print ("Chain: " + "A" + "B" + "C" + "D" + "%N")
		end

feature -- Operations

	concat (a_first, a_second: STRING): STRING
			-- Concatenate two strings.
		require
			first_exists: a_first /= Void
			second_exists: a_second /= Void
		do
			Result := a_first + a_second
		ensure
			result_exists: Result /= Void
			correct_length: Result.count = a_first.count + a_second.count
		end

end
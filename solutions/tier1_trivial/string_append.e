note
	description: "[
		Rosetta Code: String append
		https://rosettacode.org/wiki/String_append

		Append one string to another.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "String_append"
	tier: "1"

class
	STRING_APPEND

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate string appending.
		local
			l_s1, l_s2: STRING
		do
			print ("String Append%N")
			print ("=============%N%N")

			-- Method 1: Using + operator (creates new string)
			l_s1 := "Hello"
			l_s2 := l_s1 + ", World!"
			print ("Using '+': " + l_s2 + "%N")

			-- Method 2: Using append (modifies in place)
			l_s1 := "Hello"
			l_s1.append (", World!")
			print ("Using 'append': " + l_s1 + "%N")

			-- Method 3: Using append_string
			l_s1 := "Hello"
			l_s1.append_string (", World!")
			print ("Using 'append_string': " + l_s1 + "%N")

			-- Append character
			l_s1 := "Hello"
			l_s1.append_character ('!')
			print ("Using 'append_character': " + l_s1 + "%N")
		end

feature -- Operations

	concatenate (a_first, a_second: STRING): STRING
			-- Create new string from two strings.
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
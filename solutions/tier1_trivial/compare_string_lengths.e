note
	description: "[
		Rosetta Code: Compare length of two strings
		https://rosettacode.org/wiki/Compare_length_of_two_strings

		Compare and report the lengths of two strings.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Compare_length_of_two_strings"
	tier: "1"

class
	COMPARE_STRING_LENGTHS

create
	make

feature {NONE} -- Initialization

	make
			-- Compare lengths of two strings.
		local
			l_s1, l_s2: STRING
		do
			l_s1 := "abcd"
			l_s2 := "123456789"

			compare_and_print (l_s1, l_s2)
			compare_and_print ("short", "longer string")
			compare_and_print ("equal", "sized")
		end

feature -- Comparison

	compare_and_print (a_s1, a_s2: STRING)
			-- Compare lengths and print result.
		require
			s1_exists: a_s1 /= Void
			s2_exists: a_s2 /= Void
		local
			l_longer, l_shorter: STRING
		do
			if a_s1.count > a_s2.count then
				l_longer := a_s1
				l_shorter := a_s2
			elseif a_s2.count > a_s1.count then
				l_longer := a_s2
				l_shorter := a_s1
			else
				print ("%"" + a_s1 + "%" (len " + a_s1.count.out + ") and %"" + a_s2 + "%" (len " + a_s2.count.out + ") have equal length%N")
				l_longer := a_s1
				l_shorter := a_s1
			end

			if a_s1.count /= a_s2.count then
				print ("%"" + l_longer + "%" (len " + l_longer.count.out + ") is longer than %"" + l_shorter + "%" (len " + l_shorter.count.out + ")%N")
			end
		end

end

note
	description: "[
		Rosetta Code: Special characters
		https://rosettacode.org/wiki/Special_characters

		Document special characters and escape sequences.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Special_characters"
	tier: "2"

class
	SPECIAL_CHARACTERS

create
	make

feature {NONE} -- Initialization

	make
			-- Display Eiffel special characters.
		do
			print ("Eiffel Special Characters and Escape Sequences%N")
			print ("==============================================%N%N")

			print ("Percent codes in strings:%N")
			print ("  %%N - Newline%N")
			print ("  %%T - Tab:%TLike this%N")
			print ("  %%%% - Percent sign: %%%N")
			print ("  %%%" + "%"" + " - Double quote%N")
			print ("  %%' - Single quote: '%'%N")
			print ("  %%R - Carriage return%N")
			print ("  %%B - Backspace%N")
			print ("  %%F - Form feed%N")
			print ("  %%U - Null character%N")
			print ("  %%/code/ - Unicode by decimal code%N%N")

			print ("Verbatim strings:%N")
			print ("  %"[  ]%" for aligned verbatim strings%N")
			print ("  %"{  }%" for non-aligned verbatim strings%N%N")

			print ("Comment styles:%N")
			print ("  -- Single line comment%N")
			print ("  -- No multi-line comment syntax%N%N")

			print ("Other special syntax:%N")
			print ("  $ - Current object reference%N")
			print ("  ~ - Object equality (same_type and is_equal)%N")
			print ("  /= - Object inequality%N")
			print ("  := - Assignment%N")
			print ("  ?= - Assignment attempt%N")
			print ("  :: - Type constraint%N")
		end

end

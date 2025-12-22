note
	description: "[
		Rosetta Code: CamelCase and snake_case
		https://rosettacode.org/wiki/CamelCase_and_snake_case

		Convert between CamelCase and snake_case.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "CamelCase_and_snake_case"
	tier: "2"

class
	CAMEL_CASE

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate case conversion.
		do
			print ("CamelCase and snake_case%N")
			print ("========================%N%N")

			print ("To CamelCase:%N")
			demo_to_camel ("the_quick_brown_fox")
			demo_to_camel ("hello_world")
			demo_to_camel ("already_camel")

			print ("%NTo snake_case:%N")
			demo_to_snake ("TheQuickBrownFox")
			demo_to_snake ("HelloWorld")
			demo_to_snake ("already_snake")
		end

feature -- Demo

	demo_to_camel (a_str: STRING)
		do
			print ("  '" + a_str + "' -> '" + to_camel_case (a_str) + "'%N")
		end

	demo_to_snake (a_str: STRING)
		do
			print ("  '" + a_str + "' -> '" + to_snake_case (a_str) + "'%N")
		end

feature -- Conversions

	to_camel_case (a_str: STRING): STRING
			-- Convert snake_case to CamelCase.
		require
			str_exists: a_str /= Void
		local
			l_i: INTEGER
			l_cap_next: BOOLEAN
		do
			create Result.make (a_str.count)
			l_cap_next := True
			from l_i := 1 until l_i > a_str.count loop
				if a_str [l_i] = '_' then
					l_cap_next := True
				elseif l_cap_next then
					Result.append_character (a_str [l_i].as_upper)
					l_cap_next := False
				else
					Result.append_character (a_str [l_i].as_lower)
				end
				l_i := l_i + 1
			end
		ensure
			result_exists: Result /= Void
		end

	to_snake_case (a_str: STRING): STRING
			-- Convert CamelCase to snake_case.
		require
			str_exists: a_str /= Void
		local
			l_i: INTEGER
			l_c: CHARACTER
		do
			create Result.make (a_str.count + 10)
			from l_i := 1 until l_i > a_str.count loop
				l_c := a_str [l_i]
				if l_c >= 'A' and l_c <= 'Z' then
					if l_i > 1 then
						Result.append_character ('_')
					end
					Result.append_character (l_c.as_lower)
				else
					Result.append_character (l_c)
				end
				l_i := l_i + 1
			end
		ensure
			result_exists: Result /= Void
		end

end
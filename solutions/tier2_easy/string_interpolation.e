note
	description: "[
		Rosetta Code: String interpolation (included)
		https://rosettacode.org/wiki/String_interpolation_(included)

		Include variable values in strings.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "String_interpolation_(included)"
	tier: "2"

class
	STRING_INTERPOLATION

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate string interpolation.
		local
			l_name: STRING
			l_age: INTEGER
			l_template, l_result: STRING
		do
			print ("String Interpolation%N")
			print ("====================%N%N")

			l_name := "Mary"
			l_age := 25

			-- Simple concatenation
			print ("Using concatenation:%N")
			print ("  " + l_name + " is " + l_age.out + " years old.%N%N")

			-- Template substitution
			print ("Using template substitution:%N")
			l_template := "{name} is {age} years old."
			l_result := substitute (l_template, <<"name", "age">>, <<l_name, l_age.out>>)
			print ("  " + l_result + "%N%N")

			-- Positional substitution
			print ("Using positional substitution:%N")
			l_template := "$1 is $2 years old."
			l_result := substitute_positional (l_template, <<l_name, l_age.out>>)
			print ("  " + l_result + "%N")
		end

feature -- Substitution

	substitute (a_template: STRING; a_names, a_values: ARRAY [STRING]): STRING
			-- Substitute {name} placeholders with values.
		require
			template_exists: a_template /= Void
			names_exist: a_names /= Void
			values_exist: a_values /= Void
			same_count: a_names.count = a_values.count
		local
			l_i: INTEGER
		do
			Result := a_template.twin
			from l_i := a_names.lower until l_i > a_names.upper loop
				Result.replace_substring_all ("{" + a_names [l_i] + "}", a_values [l_i])
				l_i := l_i + 1
			end
		ensure
			result_exists: Result /= Void
		end

	substitute_positional (a_template: STRING; a_values: ARRAY [STRING]): STRING
			-- Substitute $1, $2, etc. with values.
		require
			template_exists: a_template /= Void
			values_exist: a_values /= Void
		local
			l_i: INTEGER
		do
			Result := a_template.twin
			from l_i := a_values.lower until l_i > a_values.upper loop
				Result.replace_substring_all ("$" + l_i.out, a_values [l_i])
				l_i := l_i + 1
			end
		ensure
			result_exists: Result /= Void
		end

end
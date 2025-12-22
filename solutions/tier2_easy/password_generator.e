note
	description: "[
		Rosetta Code: Password generator
		https://rosettacode.org/wiki/Password_generator

		Generate random passwords with configurable requirements.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Password_generator"
	tier: "2"

class
	PASSWORD_GENERATOR

create
	make

feature {NONE} -- Initialization

	make
			-- Generate sample passwords.
		do
			create random.make
			random.start

			print ("Password Generator%N")
			print ("==================%N%N")

			print ("5 passwords of length 8:%N")
			generate_passwords (5, 8)

			print ("%N5 passwords of length 12:%N")
			generate_passwords (5, 12)

			print ("%N5 passwords of length 16 (no similar chars):%N")
			generate_passwords_safe (5, 16)
		end

feature -- Generation

	generate_passwords (a_count, a_length: INTEGER)
			-- Generate `a_count' passwords of `a_length'.
		local
			l_i: INTEGER
		do
			from l_i := 1 until l_i > a_count loop
				print ("  " + generate_password (a_length) + "%N")
				l_i := l_i + 1
			end
		end

	generate_passwords_safe (a_count, a_length: INTEGER)
			-- Generate passwords without visually similar characters.
		local
			l_i: INTEGER
		do
			from l_i := 1 until l_i > a_count loop
				print ("  " + generate_password_safe (a_length) + "%N")
				l_i := l_i + 1
			end
		end

	generate_password (a_length: INTEGER): STRING
			-- Generate password with at least one of each character type.
		require
			valid_length: a_length >= 4
		local
			l_i, l_pos: INTEGER
		do
			create Result.make (a_length)

			-- Ensure at least one of each type
			Result.append_character (random_from (Lowercase))
			Result.append_character (random_from (Uppercase))
			Result.append_character (random_from (Digits))
			Result.append_character (random_from (Special))

			-- Fill rest randomly
			from l_i := 5 until l_i > a_length loop
				Result.append_character (random_from (All_chars))
				l_i := l_i + 1
			end

			-- Shuffle
			shuffle (Result)
		ensure
			correct_length: Result.count = a_length
		end

	generate_password_safe (a_length: INTEGER): STRING
			-- Generate password without similar characters (0O, 1lI).
		require
			valid_length: a_length >= 4
		do
			create Result.make (a_length)
			Result.append_character (random_from (Safe_lowercase))
			Result.append_character (random_from (Safe_uppercase))
			Result.append_character (random_from (Safe_digits))
			Result.append_character (random_from (Special))

			from until Result.count >= a_length loop
				Result.append_character (random_from (Safe_all))
			end

			shuffle (Result)
		end

feature {NONE} -- Helpers

	random_from (a_chars: STRING): CHARACTER
			-- Random character from `a_chars'.
		local
			l_idx: INTEGER
		do
			random.forth
			l_idx := (random.item \\ a_chars.count) + 1
			Result := a_chars [l_idx]
		end

	shuffle (a_str: STRING)
			-- Fisher-Yates shuffle in place.
		local
			l_i, l_j: INTEGER
			l_temp: CHARACTER
		do
			from l_i := a_str.count until l_i <= 1 loop
				random.forth
				l_j := (random.item \\ l_i) + 1
				l_temp := a_str [l_i]
				a_str [l_i] := a_str [l_j]
				a_str [l_j] := l_temp
				l_i := l_i - 1
			end
		end

	random: RANDOM

	Lowercase: STRING = "abcdefghijklmnopqrstuvwxyz"
	Uppercase: STRING = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	Digits: STRING = "0123456789"
	Special: STRING = "!@#$%%^&*"
	All_chars: STRING = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%%^&*"

	Safe_lowercase: STRING = "abcdefghjkmnpqrstuvwxyz"
	Safe_uppercase: STRING = "ABCDEFGHJKMNPQRSTUVWXYZ"
	Safe_digits: STRING = "23456789"
	Safe_all: STRING = "abcdefghjkmnpqrstuvwxyzABCDEFGHJKMNPQRSTUVWXYZ23456789!@#$%%^&*"

end

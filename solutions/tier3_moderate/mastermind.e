note
	description: "[
		Rosetta Code: Mastermind
		https://rosettacode.org/wiki/Mastermind

		Code-breaking game with colored pegs.
	]"

class
	MASTERMIND

create
	make, make_default

feature -- Initialization

	make (a_code_length: INTEGER; a_num_colors: INTEGER)
			-- Create game with specified parameters
		require
			valid_length: a_code_length >= 2 and a_code_length <= 8
			valid_colors: a_num_colors >= 2 and a_num_colors <= 10
		do
			code_length := a_code_length
			num_colors := a_num_colors
			create secret_code.make_filled (0, 1, code_length)
			create random.make
			max_guesses := 10
		ensure
			length_set: code_length = a_code_length
			colors_set: num_colors = a_num_colors
		end

	make_default
			-- Standard 4 pegs, 6 colors
		do
			make (4, 6)
		end

feature -- Access

	code_length: INTEGER
	num_colors: INTEGER
	max_guesses: INTEGER
	secret_code: ARRAY [INTEGER]
	guesses_made: INTEGER

feature -- Operations

	new_game
			-- Generate new secret code
		local
			i: INTEGER
		do
			random.set_seed ((create {TIME}.make_now).seconds)
			from i := 1 until i > code_length loop
				random.forth
				secret_code [i] := random.item \\ num_colors + 1
				i := i + 1
			end
			guesses_made := 0
		end

	new_game_with_code (code: ARRAY [INTEGER])
			-- Set specific secret code
		require
			valid_length: code.count = code_length
			valid_colors: across code as c all c >= 1 and c <= num_colors end
		do
			secret_code := code.twin
			guesses_made := 0
		end

	evaluate (guess: ARRAY [INTEGER]): TUPLE [exact: INTEGER; color_only: INTEGER]
			-- Evaluate guess: exact = right color right place, color_only = right color wrong place
		require
			valid_length: guess.count = code_length
			valid_colors: across guess as c all c >= 1 and c <= num_colors end
		local
			exact, color_only: INTEGER
			secret_used, guess_used: ARRAY [BOOLEAN]
			i, j: INTEGER
		do
			create secret_used.make_filled (False, 1, code_length)
			create guess_used.make_filled (False, 1, code_length)

			-- Count exact matches
			from i := 1 until i > code_length loop
				if guess [i] = secret_code [i] then
					exact := exact + 1
					secret_used [i] := True
					guess_used [i] := True
				end
				i := i + 1
			end

			-- Count color-only matches
			from i := 1 until i > code_length loop
				if not guess_used [i] then
					from j := 1 until j > code_length loop
						if not secret_used [j] and guess [i] = secret_code [j] then
							color_only := color_only + 1
							secret_used [j] := True
							j := code_length + 1  -- Break
						end
						j := j + 1
					end
				end
				i := i + 1
			end

			guesses_made := guesses_made + 1
			Result := [exact, color_only]
		end

	is_correct (guess: ARRAY [INTEGER]): BOOLEAN
			-- Is this guess correct?
		require
			valid_length: guess.count = code_length
		local
			i: INTEGER
		do
			Result := True
			from i := 1 until i > code_length or not Result loop
				if guess [i] /= secret_code [i] then
					Result := False
				end
				i := i + 1
			end
		end

feature -- AI Solver

	solve_simple: ARRAYED_LIST [ARRAY [INTEGER]]
			-- Solve using simple elimination (Knuth-style)
		local
			possible: ARRAYED_LIST [ARRAY [INTEGER]]
			guess, best: ARRAY [INTEGER]
			feedback: TUPLE [exact: INTEGER; color_only: INTEGER]
			found: BOOLEAN
		do
			create Result.make (max_guesses)
			possible := all_codes

			-- Start with initial guess
			guess := initial_guess
			Result.extend (guess)
			feedback := evaluate (guess)

			from until found or guesses_made >= max_guesses loop
				if feedback.exact = code_length then
					found := True
				else
					-- Eliminate impossible codes
					eliminate_inconsistent (possible, guess, feedback)

					if possible.count > 0 then
						-- Pick first remaining possibility
						best := possible.first
						Result.extend (best)
						guess := best
						feedback := evaluate (guess)
					else
						found := True  -- Error condition
					end
				end
			end
		end

feature {NONE} -- Implementation

	random: RANDOM

	initial_guess: ARRAY [INTEGER]
			-- Good initial guess (e.g., 1122 for 4 pegs)
		local
			i, half: INTEGER
		do
			create Result.make_filled (0, 1, code_length)
			half := code_length // 2
			from i := 1 until i > code_length loop
				if i <= half then
					Result [i] := 1
				else
					if num_colors >= 2 then
						Result [i] := 2
					else
						Result [i] := num_colors
					end
				end
				i := i + 1
			end
		end

	all_codes: ARRAYED_LIST [ARRAY [INTEGER]]
			-- Generate all possible codes using recursive enumeration
		local
			total: INTEGER
		do
			total := integer_power (num_colors, code_length)
			create Result.make (total)
			enumerate_codes (Result, create {ARRAY [INTEGER]}.make_filled (0, 1, code_length), 1)
		end

	integer_power (base, exp: INTEGER): INTEGER
			-- Compute base^exp for non-negative exp
		require
			non_negative_exp: exp >= 0
		local
			i: INTEGER
		do
			Result := 1
			from i := 1 until i > exp loop
				Result := Result * base
				i := i + 1
			end
		end

	enumerate_codes (list: ARRAYED_LIST [ARRAY [INTEGER]]; prefix: ARRAY [INTEGER]; pos: INTEGER)
			-- Enumerate all codes recursively
		local
			color: INTEGER
		do
			if pos > code_length then
				list.extend (prefix.twin)
			else
				from color := 1 until color > num_colors loop
					prefix [pos] := color
					enumerate_codes (list, prefix, pos + 1)
					color := color + 1
				end
			end
		end

	eliminate_inconsistent (possible: ARRAYED_LIST [ARRAY [INTEGER]]; guess: ARRAY [INTEGER]; feedback: TUPLE [exact: INTEGER; color_only: INTEGER])
			-- Remove codes that wouldn't give same feedback
		local
			test_feedback: TUPLE [exact: INTEGER; color_only: INTEGER]
		do
			from possible.start until possible.after loop
				test_feedback := compute_feedback (possible.item, guess)
				if test_feedback.exact /= feedback.exact or test_feedback.color_only /= feedback.color_only then
					possible.remove
				else
					possible.forth
				end
			end
		end

	compute_feedback (secret, guess: ARRAY [INTEGER]): TUPLE [exact: INTEGER; color_only: INTEGER]
			-- Compute feedback without modifying game state
		local
			exact, color_only: INTEGER
			secret_used, guess_used: ARRAY [BOOLEAN]
			i, j: INTEGER
		do
			create secret_used.make_filled (False, 1, code_length)
			create guess_used.make_filled (False, 1, code_length)

			from i := 1 until i > code_length loop
				if guess [i] = secret [i] then
					exact := exact + 1
					secret_used [i] := True
					guess_used [i] := True
				end
				i := i + 1
			end

			from i := 1 until i > code_length loop
				if not guess_used [i] then
					from j := 1 until j > code_length loop
						if not secret_used [j] and guess [i] = secret [j] then
							color_only := color_only + 1
							secret_used [j] := True
							j := code_length + 1
						end
						j := j + 1
					end
				end
				i := i + 1
			end

			Result := [exact, color_only]
		end

feature -- Output

	code_to_string (code: ARRAY [INTEGER]): STRING
			-- Convert code to string representation
		do
			create Result.make (code_length)
			across code as c loop
				Result.append_integer (c)
			end
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			game: MASTERMIND
			guess: ARRAY [INTEGER]
			feedback: TUPLE [exact: INTEGER; color_only: INTEGER]
		do
			print ("Mastermind Demo:%N%N")

			create game.make_default
			game.new_game_with_code (<<1, 2, 3, 4>>)
			print ("Secret code: " + game.code_to_string (game.secret_code) + "%N%N")

			-- Manual guesses
			guess := <<1, 1, 1, 1>>
			feedback := game.evaluate (guess)
			print ("Guess: " + game.code_to_string (guess) + " -> Exact: " + feedback.exact.out + ", Color: " + feedback.color_only.out + "%N")

			guess := <<1, 2, 2, 2>>
			feedback := game.evaluate (guess)
			print ("Guess: " + game.code_to_string (guess) + " -> Exact: " + feedback.exact.out + ", Color: " + feedback.color_only.out + "%N")

			guess := <<1, 2, 3, 4>>
			feedback := game.evaluate (guess)
			print ("Guess: " + game.code_to_string (guess) + " -> Exact: " + feedback.exact.out + ", Color: " + feedback.color_only.out + "%N")
			print ("Solved in " + game.guesses_made.out + " guesses!%N")
		end

end

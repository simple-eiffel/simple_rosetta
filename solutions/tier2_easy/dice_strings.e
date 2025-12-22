note
	description: "[
		Rosetta Code: Dice game probabilities
		https://rosettacode.org/wiki/Dice_game_probabilities

		Calculate dice roll outcomes and probabilities.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Dice_game_probabilities"
	tier: "2"

class
	DICE_STRINGS

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate dice probabilities.
		do
			print ("Dice Roll Probabilities%N")
			print ("=======================%N%N")

			print ("Rolling 2d6 (two six-sided dice):%N")
			print ("  Possible sums: 2 to 12%N")
			print ("  Sum=7 combinations: 6 out of 36%N%N")

			print ("Probability of player 1 (9d4) beating player 2 (6d6):%N")
			print ("  ~" + probability_win (9, 4, 6, 6).out + "%%%N")
		end

feature -- Calculations

	probability_win (a_dice1, a_sides1, a_dice2, a_sides2: INTEGER): REAL_64
			-- Probability that player 1 beats player 2.
		local
			l_dist1, l_dist2: ARRAY [REAL_64]
			l_prob: REAL_64
			l_i, l_j: INTEGER
		do
			l_dist1 := dice_distribution (a_dice1, a_sides1)
			l_dist2 := dice_distribution (a_dice2, a_sides2)

			from l_i := l_dist1.lower until l_i > l_dist1.upper loop
				from l_j := l_dist2.lower until l_j > l_dist2.upper loop
					if l_i > l_j then
						l_prob := l_prob + l_dist1 [l_i] * l_dist2 [l_j]
					end
					l_j := l_j + 1
				end
				l_i := l_i + 1
			end

			Result := l_prob * 100.0
		end

	dice_distribution (a_dice, a_sides: INTEGER): ARRAY [REAL_64]
			-- Probability distribution for sum of dice.
		local
			l_counts: ARRAY [INTEGER]
			l_total, l_min, l_max: INTEGER
			l_i, l_j, l_k: INTEGER
			l_new_counts: ARRAY [INTEGER]
		do
			l_min := a_dice
			l_max := a_dice * a_sides
			create l_counts.make_filled (0, 0, 0)
			l_counts [0] := 1

			from l_i := 1 until l_i > a_dice loop
				create l_new_counts.make_filled (0, 0, l_i * a_sides)
				from l_j := l_counts.lower until l_j > l_counts.upper loop
					from l_k := 1 until l_k > a_sides loop
						l_new_counts [l_j + l_k] := l_new_counts [l_j + l_k] + l_counts [l_j]
						l_k := l_k + 1
					end
					l_j := l_j + 1
				end
				l_counts := l_new_counts
				l_i := l_i + 1
			end

			l_total := (a_sides ^ a_dice).truncated_to_integer

			create Result.make_filled (0.0, l_min, l_max)
			from l_i := l_min until l_i > l_max loop
				Result [l_i] := l_counts [l_i] / l_total
				l_i := l_i + 1
			end
		end

end
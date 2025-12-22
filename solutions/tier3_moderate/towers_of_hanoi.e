note
	description: "[
		Rosetta Code: Towers of Hanoi
		https://rosettacode.org/wiki/Towers_of_Hanoi

		Solve the Towers of Hanoi puzzle using recursion.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Towers_of_Hanoi"

class
	TOWERS_OF_HANOI

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate Towers of Hanoi solution.
		do
			move_count := 0
			print ("Towers of Hanoi with 4 disks:%N")
			print ("============================%N%N")
			hanoi (4, 'A', 'C', 'B')
			print ("%NTotal moves: " + move_count.out + "%N")
		end

feature -- Solution

	hanoi (n: INTEGER; source, target, auxiliary: CHARACTER)
			-- Move n disks from source to target using auxiliary.
		require
			positive_disks: n >= 0
		do
			if n > 0 then
				-- Move n-1 disks from source to auxiliary
				hanoi (n - 1, source, auxiliary, target)

				-- Move disk n from source to target
				print ("Move disk " + n.out + " from " + source.out + " to " + target.out + "%N")
				move_count := move_count + 1

				-- Move n-1 disks from auxiliary to target
				hanoi (n - 1, auxiliary, target, source)
			end
		end

feature -- Access

	move_count: INTEGER
			-- Number of moves made.

feature -- Analysis

	minimum_moves (n: INTEGER): INTEGER
			-- Minimum number of moves required for n disks.
			-- Formula: 2^n - 1
		require
			non_negative: n >= 0
		do
			Result := (2 ^ n).truncated_to_integer - 1
		ensure
			correct_formula: Result = (2 ^ n).truncated_to_integer - 1
		end

end

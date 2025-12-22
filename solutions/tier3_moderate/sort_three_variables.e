note
	description: "[
		Rosetta Code: Sort three variables
		https://rosettacode.org/wiki/Sort_three_variables

		Sort three variables without using arrays/lists.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Sort_three_variables"

class
	SORT_THREE_VARIABLES

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate sorting three variables.
		local
			x, y, z: INTEGER
			a, b, c: STRING
		do
			-- Integer example
			print ("=== Sorting Integers ===%N")
			x := 77444
			y := -12
			z := 0
			print ("Before: x=" + x.out + " y=" + y.out + " z=" + z.out + "%N")
			sort_three_integers (x, y, z)

			-- String example
			print ("%N=== Sorting Strings ===%N")
			a := "lions, tigers, and"
			b := "bears, oh my!"
			c := "(from the 'Wizard of OZ')"
			print ("Before:%N  a=%"" + a + "%"%N  b=%"" + b + "%"%N  c=%"" + c + "%"%N")
			sort_three_strings (a, b, c)
		end

feature -- Sorting

	sort_three_integers (x, y, z: INTEGER)
			-- Sort and display three integers.
		local
			a, b, c, temp: INTEGER
		do
			a := x
			b := y
			c := z

			-- Simple comparison-based sort
			if a > b then
				temp := a
				a := b
				b := temp
			end
			if b > c then
				temp := b
				b := c
				c := temp
			end
			if a > b then
				temp := a
				a := b
				b := temp
			end

			print ("After:  x=" + a.out + " y=" + b.out + " z=" + c.out + "%N")
		ensure
			-- a <= b <= c
		end

	sort_three_strings (x, y, z: STRING)
			-- Sort and display three strings.
		local
			a, b, c, temp: STRING
		do
			a := x
			b := y
			c := z

			-- Simple comparison-based sort
			if a > b then
				temp := a
				a := b
				b := temp
			end
			if b > c then
				temp := b
				b := c
				c := temp
			end
			if a > b then
				temp := a
				a := b
				b := temp
			end

			print ("After:%N  a=%"" + a + "%"%N  b=%"" + b + "%"%N  c=%"" + c + "%"%N")
		ensure
			-- a <= b <= c
		end

end

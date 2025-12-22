note
	description: "[
		Rosetta Code: Anagrams
		https://rosettacode.org/wiki/Anagrams

		Detect if two strings are anagrams of each other.
	]"
	author: "Eiffel Solution"
	rosetta_task: "Anagrams"

class
	ANAGRAM

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate anagram detection.
		do
			print ("Anagram Detection%N")
			print ("=================%N%N")

			-- Test pairs
			test_anagram ("listen", "silent")
			test_anagram ("triangle", "integral")
			test_anagram ("apple", "papel")
			test_anagram ("hello", "world")
			test_anagram ("rat", "tar")
			test_anagram ("Astronomer", "Moon starer")
			test_anagram ("The eyes", "They see")

			-- Generate anagram signature
			print ("%NAnagram signatures (sorted letters):%N")
			print ("  'listen' -> '" + anagram_signature ("listen") + "'%N")
			print ("  'silent' -> '" + anagram_signature ("silent") + "'%N")
		end

feature -- Anagram Detection

	is_anagram (s1, s2: STRING): BOOLEAN
			-- Are s1 and s2 anagrams (ignoring case and spaces)?
		local
			sig1, sig2: STRING
		do
			sig1 := anagram_signature (s1)
			sig2 := anagram_signature (s2)
			Result := sig1.same_string (sig2)
		ensure
			symmetric: Result = is_anagram (s2, s1)
		end

	anagram_signature (s: STRING): STRING
			-- Canonical form of s for anagram comparison.
			-- Returns sorted lowercase letters only.
		local
			i: INTEGER
			c: CHARACTER
			chars: ARRAYED_LIST [CHARACTER]
		do
			-- Extract and lowercase letters
			create chars.make (s.count)
			from i := 1 until i > s.count loop
				c := s.item (i)
				if c.is_alpha then
					chars.extend (c.as_lower)
				end
				i := i + 1
			end

			-- Sort characters
			sort_characters (chars)

			-- Build result string
			create Result.make (chars.count)
			from i := 1 until i > chars.count loop
				Result.append_character (chars.i_th (i))
				i := i + 1
			end
		end

	is_anagram_by_count (s1, s2: STRING): BOOLEAN
			-- Are s1 and s2 anagrams? Uses character counting method.
		local
			counts: ARRAY [INTEGER]
			i: INTEGER
			c: CHARACTER
			code: INTEGER
		do
			-- Count characters (a-z = indices 1-26)
			create counts.make_filled (0, 1, 26)

			-- Add counts from s1
			from i := 1 until i > s1.count loop
				c := s1.item (i).as_lower
				if c.is_alpha then
					code := c.code - ('a').code + 1
					counts [code] := counts [code] + 1
				end
				i := i + 1
			end

			-- Subtract counts from s2
			from i := 1 until i > s2.count loop
				c := s2.item (i).as_lower
				if c.is_alpha then
					code := c.code - ('a').code + 1
					counts [code] := counts [code] - 1
				end
				i := i + 1
			end

			-- Check all counts are zero
			Result := True
			from i := 1 until i > 26 or not Result loop
				if counts [i] /= 0 then
					Result := False
				end
				i := i + 1
			end
		end

feature {NONE} -- Helpers

	sort_characters (chars: ARRAYED_LIST [CHARACTER])
			-- Simple bubble sort for characters.
		local
			i, j: INTEGER
			temp: CHARACTER
			swapped: BOOLEAN
		do
			from
				i := 1
				swapped := True
			until
				i >= chars.count or not swapped
			loop
				swapped := False
				from j := 1 until j > chars.count - i loop
					if chars.i_th (j) > chars.i_th (j + 1) then
						temp := chars.i_th (j)
						chars.put_i_th (chars.i_th (j + 1), j)
						chars.put_i_th (temp, j + 1)
						swapped := True
					end
					j := j + 1
				end
				i := i + 1
			end
		end

	test_anagram (s1, s2: STRING)
			-- Test and display anagram result.
		do
			print ("%"" + s1 + "%" and %"" + s2 + "%": ")
			if is_anagram (s1, s2) then
				print ("YES - Anagrams!%N")
			else
				print ("NO%N")
			end
		end

end

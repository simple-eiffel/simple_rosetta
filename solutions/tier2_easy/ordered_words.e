note
	description: "[
		Rosetta Code: Ordered words
		https://rosettacode.org/wiki/Ordered_words

		Find words where letters are in alphabetical order.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Ordered_words"
	tier: "2"

class
	ORDERED_WORDS

create
	make

feature {NONE} -- Initialization

	make
			-- Find and display ordered words.
		local
			l_words: ARRAY [STRING]
			l_ordered: ARRAYED_LIST [STRING]
			l_max_len: INTEGER
		do
			-- Sample word list (in real implementation, read from dictionary)
			l_words := <<"a", "ab", "abc", "bac", "almost", "abhors", "accent", "accept", "access",
				"begins", "begot", "bellow", "below", "chimps", "chips", "choppy">>

			create l_ordered.make (10)

			across l_words as l_w loop
				if is_ordered (l_w) then
					l_ordered.extend (l_w)
					if l_w.count > l_max_len then
						l_max_len := l_w.count
					end
				end
			end

			print ("Ordered words found: " + l_ordered.count.out + "%N")
			print ("Longest ordered word length: " + l_max_len.out + "%N")
			print ("Ordered words:%N")
			across l_ordered as l_w loop
				if l_w.count = l_max_len then
					print ("  " + l_w + " (longest)%N")
				else
					print ("  " + l_w + "%N")
				end
			end
		end

feature -- Analysis

	is_ordered (a_word: STRING): BOOLEAN
			-- Are letters in `a_word' in ascending alphabetical order?
		require
			word_exists: a_word /= Void
		local
			l_i: INTEGER
			l_lower: STRING
		do
			Result := True
			l_lower := a_word.as_lower
			from l_i := 1 until l_i >= l_lower.count or not Result loop
				if l_lower [l_i] > l_lower [l_i + 1] then
					Result := False
				end
				l_i := l_i + 1
			end
		end

end

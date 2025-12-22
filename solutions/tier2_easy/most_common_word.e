note
	description: "[
		Rosetta Code: Word frequency
		https://rosettacode.org/wiki/Word_frequency

		Find the most common words in text.
	]"
	author: "Simple Eiffel"
	see_also: "https://github.com/simple-eiffel"
	rosetta_task: "Word_frequency"
	tier: "2"

class
	MOST_COMMON_WORD

create
	make

feature {NONE} -- Initialization

	make
			-- Demonstrate word frequency.
		local
			l_text: STRING
			l_freq: HASH_TABLE [INTEGER, STRING]
		do
			print ("Word Frequency%N")
			print ("==============%N%N")

			l_text := "the quick brown fox jumps over the lazy dog the fox was quick"
			print ("Text: " + l_text + "%N%N")

			l_freq := word_frequency (l_text)
			print ("Word frequencies:%N")
			print_top_words (l_freq, 5)
		end

feature -- Counting

	word_frequency (a_text: STRING): HASH_TABLE [INTEGER, STRING]
			-- Count frequency of each word.
		require
			text_exists: a_text /= Void
		local
			l_words: LIST [STRING]
			l_word: STRING
		do
			create Result.make (100)
			l_words := a_text.as_lower.split (' ')
			across l_words as l_w loop
				l_word := clean_word (l_w)
				if not l_word.is_empty then
					if Result.has (l_word) then
						Result [l_word] := Result [l_word] + 1
					else
						Result [l_word] := 1
					end
				end
			end
		ensure
			result_exists: Result /= Void
		end

feature {NONE} -- Helpers

	clean_word (a_word: STRING): STRING
			-- Remove punctuation from word.
		local
			l_i: INTEGER
			l_c: CHARACTER
		do
			create Result.make (a_word.count)
			from l_i := 1 until l_i > a_word.count loop
				l_c := a_word [l_i]
				if (l_c >= 'a' and l_c <= 'z') or (l_c >= '0' and l_c <= '9') then
					Result.append_character (l_c)
				end
				l_i := l_i + 1
			end
		end

	print_top_words (a_freq: HASH_TABLE [INTEGER, STRING]; a_n: INTEGER)
			-- Print top n words by frequency.
		local
			l_sorted: ARRAYED_LIST [TUPLE [word: STRING; cnt: INTEGER]]
			l_i, l_j: INTEGER
			l_temp: TUPLE [word: STRING; cnt: INTEGER]
		do
			create l_sorted.make (a_freq.count)
			across a_freq as l_entry loop
				l_sorted.extend ([@l_entry.key, l_entry])
			end

			-- Simple bubble sort by count descending
			from l_i := 1 until l_i >= l_sorted.count loop
				from l_j := l_i + 1 until l_j > l_sorted.count loop
					if l_sorted [l_j].cnt > l_sorted [l_i].count then
						l_temp := l_sorted [l_i]
						l_sorted [l_i] := l_sorted [l_j]
						l_sorted [l_j] := l_temp
					end
					l_j := l_j + 1
				end
				l_i := l_i + 1
			end

			from l_i := 1 until l_i > a_n.min (l_sorted.count) loop
				print ("  " + l_sorted [l_i].word + ": " + l_sorted [l_i].cnt.out + "%N")
				l_i := l_i + 1
			end
		end

end
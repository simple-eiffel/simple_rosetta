note
	description: "Parser for Rosetta Code wiki markup"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	WIKI_PARSER

create
	default_create

feature -- Parsing

	extract_description (wiki_content: STRING): STRING
			-- Extract task description from `wiki_content'.
			-- Description is text before first language header.
		require
			content_not_empty: not wiki_content.is_empty
		local
			header_pos: INTEGER
		do
			header_pos := wiki_content.substring_index ("=={{header|", 1)
			if header_pos > 1 then
				Result := wiki_content.substring (1, header_pos - 1)
				Result := clean_wiki_markup (Result)
			else
				create Result.make_empty
			end
		ensure
			result_attached: Result /= Void
		end

	extract_languages (wiki_content: STRING): ARRAYED_LIST [STRING]
			-- Extract all language names from `wiki_content'.
		require
			content_not_empty: not wiki_content.is_empty
		local
			regex: SIMPLE_REGEX
			matches: SIMPLE_REGEX_MATCH_LIST
			i: INTEGER
			lang: STRING_32
		do
			create Result.make (20)
			create regex.make

			regex.compile (Header_pattern)
			if regex.is_compiled then
				matches := regex.matches (wiki_content)
				from i := 1 until i > matches.count loop
					if attached matches.item (i).group (1) as g then
						lang := g.to_string_32
						if not Result.has (lang.to_string_8) then
							Result.extend (lang.to_string_8)
						end
					end
					i := i + 1
				end
			end
		ensure
			result_attached: Result /= Void
		end

	extract_solutions (wiki_content: STRING): ARRAYED_LIST [TUPLE [language: STRING; code: STRING]]
			-- Extract all language solutions from `wiki_content'.
		require
			content_not_empty: not wiki_content.is_empty
		local
			regex: SIMPLE_REGEX
			matches: SIMPLE_REGEX_MATCH_LIST
			current_language: STRING
			current_pos, next_pos: INTEGER
			section_content, code: STRING
			i, j: INTEGER
			positions: ARRAYED_LIST [TUPLE [lang: STRING; pos: INTEGER]]
		do
			create Result.make (20)
			create regex.make
			create positions.make (20)

			regex.compile (Header_pattern)
			if regex.is_compiled then
				matches := regex.matches (wiki_content)

				-- Collect all header positions
				from i := 1 until i > matches.count loop
					if attached matches.item (i).group (1) as g then
						positions.extend ([g.to_string_8, matches.item (i).start_position])
					end
					i := i + 1
				end

				-- Extract code between headers
				from j := 1 until j > positions.count loop
					if attached {STRING} positions.i_th (j).lang as lang then
						current_language := lang
					else
						create current_language.make_empty
					end
					if attached {INTEGER} positions.i_th (j).pos as p then
						current_pos := p
					else
						current_pos := 1
					end

					-- Find end of header line
					current_pos := wiki_content.index_of ('%N', current_pos)
					if current_pos = 0 then
						current_pos := wiki_content.count + 1
					else
						current_pos := current_pos + 1
					end

					-- Find next header or end
					if j < positions.count then
						if attached {INTEGER} positions.i_th (j + 1).pos as np then
							next_pos := np
						else
							next_pos := wiki_content.count + 1
						end
					else
						next_pos := wiki_content.count + 1
					end

					-- Extract section
					if current_pos < next_pos then
						section_content := wiki_content.substring (current_pos, next_pos - 1)
						code := extract_code_from_section (section_content)
						if not code.is_empty then
							Result.extend ([current_language, code])
						end
					end

					j := j + 1
				end
			end
		ensure
			result_attached: Result /= Void
		end

	extract_eiffel_solution (wiki_content: STRING): detachable STRING
			-- Extract Eiffel code from `wiki_content', if present.
		require
			content_not_empty: not wiki_content.is_empty
		local
			solutions: ARRAYED_LIST [TUPLE [language: STRING; code: STRING]]
			i: INTEGER
		do
			solutions := extract_solutions (wiki_content)
			from i := 1 until i > solutions.count loop
				if attached {STRING} solutions.i_th (i).language as lang then
					if lang.same_string ("Eiffel") then
						if attached {STRING} solutions.i_th (i).code as co then
							Result := co
						end
					end
				end
				i := i + 1
			end
		end

	has_eiffel (wiki_content: STRING): BOOLEAN
			-- Does `wiki_content' contain an Eiffel section?
		require
			content_not_empty: not wiki_content.is_empty
		do
			Result := wiki_content.has_substring ("=={{header|Eiffel}}==")
		end

feature {NONE} -- Implementation

	extract_code_from_section (section: STRING): STRING
			-- Extract code blocks from wiki `section'.
		local
			start_tag, end_tag: INTEGER
			tag_end: INTEGER
			found: BOOLEAN
		do
			create Result.make_empty

			-- Try <syntaxhighlight ...>
			if not found then
				start_tag := section.substring_index ("<syntaxhighlight", 1)
				if start_tag > 0 then
					tag_end := section.index_of ('>', start_tag)
					if tag_end > 0 then
						end_tag := section.substring_index ("</syntaxhighlight>", tag_end)
						if end_tag > tag_end then
							Result := section.substring (tag_end + 1, end_tag - 1)
							Result := trim_code (Result)
							found := True
						end
					end
				end
			end

			-- Try <lang ...>
			if not found then
				start_tag := section.substring_index ("<lang", 1)
				if start_tag > 0 then
					tag_end := section.index_of ('>', start_tag)
					if tag_end > 0 then
						end_tag := section.substring_index ("</lang>", tag_end)
						if end_tag > tag_end then
							Result := section.substring (tag_end + 1, end_tag - 1)
							Result := trim_code (Result)
							found := True
						end
					end
				end
			end

			-- Try <pre>
			if not found then
				start_tag := section.substring_index ("<pre>", 1)
				if start_tag > 0 then
					end_tag := section.substring_index ("</pre>", start_tag + 5)
					if end_tag > start_tag then
						Result := section.substring (start_tag + 5, end_tag - 1)
						Result := trim_code (Result)
					end
				end
			end
		end

	clean_wiki_markup (text: STRING): STRING
			-- Remove wiki markup from `text'.
		do
			Result := text.twin
			Result := remove_wiki_links (Result)
			Result.replace_substring_all ("'''", "")
			Result.replace_substring_all ("''", "")
			Result.replace_substring_all ("<br>", "%N")
			Result.replace_substring_all ("<br/>", "%N")
			Result.replace_substring_all ("<br />", "%N")
			Result.left_adjust
			Result.right_adjust
		end

	remove_wiki_links (text: STRING): STRING
			-- Remove [[link]] and [[link|display]] from text.
		local
			i, start_pos, pipe_pos, end_pos: INTEGER
		do
			Result := text.twin
			from i := 1 until i > Result.count - 3 loop
				if i + 1 <= Result.count and then Result.substring (i, i + 1).same_string ("[[") then
					start_pos := i
					end_pos := Result.substring_index ("]]", i + 2)
					if end_pos > 0 then
						pipe_pos := Result.index_of ('|', i + 2)
						if pipe_pos > 0 and pipe_pos < end_pos then
							Result := Result.substring (1, start_pos - 1) +
							          Result.substring (pipe_pos + 1, end_pos - 1) +
							          Result.substring (end_pos + 2, Result.count)
						else
							Result := Result.substring (1, start_pos - 1) +
							          Result.substring (i + 2, end_pos - 1) +
							          Result.substring (end_pos + 2, Result.count)
						end
					else
						i := i + 1
					end
				else
					i := i + 1
				end
			end
		end

	trim_code (code: STRING): STRING
			-- Trim leading/trailing whitespace from code.
		do
			Result := code.twin
			Result.left_adjust
			Result.right_adjust
		end

feature {NONE} -- Constants

	Header_pattern: STRING = "=={{header\|([^}]+)}}=="
			-- Regex pattern for language headers

end

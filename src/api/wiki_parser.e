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

	extract_description (a_wiki_content: STRING): STRING
			-- Extract task description from `wiki_content'.
			-- Description is text before first language header.
		require
			content_not_empty: not a_wiki_content.is_empty
		local
			l_header_pos: INTEGER
		do
			l_header_pos := a_wiki_content.substring_index ("=={{header|", 1)
			if l_header_pos > 1 then
				Result := a_wiki_content.substring (1, l_header_pos - 1)
				Result := clean_wiki_markup (Result)
			else
				create Result.make_empty
			end
		ensure
			result_attached: Result /= Void
		end

	extract_languages (a_wiki_content: STRING): ARRAYED_LIST [STRING]
			-- Extract all language names from `wiki_content'.
		require
			content_not_empty: not a_wiki_content.is_empty
		local
			l_regex: SIMPLE_REGEX
			l_matches: SIMPLE_REGEX_MATCH_LIST
			i: INTEGER
			l_lang: STRING_32
		do
			create Result.make (20)
			create l_regex.make

			l_regex.compile (Header_pattern)
			if l_regex.is_compiled then
				l_matches := l_regex.matches (a_wiki_content)
				from i := 1 until i > l_matches.count loop
					if attached l_matches.item (i).group (1) as al_g then
						l_lang := al_g.to_string_32
						if not Result.has (l_lang.to_string_8) then
							Result.extend (l_lang.to_string_8)
						end
					end
					i := i + 1
				end
			end
		ensure
			result_attached: Result /= Void
		end

	extract_solutions (a_wiki_content: STRING): ARRAYED_LIST [TUPLE [language: STRING; code: STRING]]
			-- Extract all language solutions from `wiki_content'.
		require
			content_not_empty: not a_wiki_content.is_empty
		local
			l_regex: SIMPLE_REGEX
			l_matches: SIMPLE_REGEX_MATCH_LIST
			l_current_language: STRING
			current_pos, next_pos: INTEGER
			section_content, code: STRING
			i, j: INTEGER
			l_positions: ARRAYED_LIST [TUPLE [lang: STRING; pos: INTEGER]]
		do
			create Result.make (20)
			create l_regex.make
			create l_positions.make (20)

			l_regex.compile (Header_pattern)
			if l_regex.is_compiled then
				l_matches := l_regex.matches (a_wiki_content)

				-- Collect all header positions
				from i := 1 until i > l_matches.count loop
					if attached l_matches.item (i).group (1) as al_g then
						l_positions.extend ([al_g.to_string_8, l_matches.item (i).start_position])
					end
					i := i + 1
				end

				-- Extract code between headers
				from j := 1 until j > l_positions.count loop
					if attached {STRING} l_positions.i_th (j).lang as al_lang then
						l_current_language := al_lang
					else
						create l_current_language.make_empty
					end
					if attached {INTEGER} l_positions.i_th (j).pos as al_p then
						current_pos := al_p
					else
						current_pos := 1
					end

					-- Find end of header line
					current_pos := a_wiki_content.index_of ('%N', current_pos)
					if current_pos = 0 then
						current_pos := a_wiki_content.count + 1
					else
						current_pos := current_pos + 1
					end

					-- Find next header or end
					if j < l_positions.count then
						if attached {INTEGER} l_positions.i_th (j + 1).pos as al_np then
							next_pos := al_np
						else
							next_pos := a_wiki_content.count + 1
						end
					else
						next_pos := a_wiki_content.count + 1
					end

					-- Extract section
					if current_pos < next_pos then
						section_content := a_wiki_content.substring (current_pos, next_pos - 1)
						code := extract_code_from_section (section_content)
						if not code.is_empty then
							Result.extend ([l_current_language, code])
						end
					end

					j := j + 1
				end
			end
		ensure
			result_attached: Result /= Void
		end

	extract_eiffel_solution (a_wiki_content: STRING): detachable STRING
			-- Extract Eiffel code from `wiki_content', if present.
		require
			content_not_empty: not a_wiki_content.is_empty
		local
			l_solutions: ARRAYED_LIST [TUPLE [language: STRING; code: STRING]]
			i: INTEGER
		do
			l_solutions := extract_solutions (a_wiki_content)
			from i := 1 until i > l_solutions.count loop
				if attached {STRING} l_solutions.i_th (i).language as al_lang then
					if al_lang.same_string ("Eiffel") then
						if attached {STRING} l_solutions.i_th (i).code as al_co then
							Result := al_co
						end
					end
				end
				i := i + 1
			end
		end

	has_eiffel (a_wiki_content: STRING): BOOLEAN
			-- Does `wiki_content' contain an Eiffel section?
		require
			content_not_empty: not a_wiki_content.is_empty
		do
			Result := a_wiki_content.has_substring ("=={{header|Eiffel}}==")
		end

feature {NONE} -- Implementation

	extract_code_from_section (a_section: STRING): STRING
			-- Extract code blocks from wiki `section'.
		local
			start_tag, end_tag: INTEGER
			l_tag_end: INTEGER
			l_found: BOOLEAN
		do
			create Result.make_empty

			-- Try <syntaxhighlight ...>
			if not l_found then
				start_tag := a_section.substring_index ("<syntaxhighlight", 1)
				if start_tag > 0 then
					l_tag_end := a_section.index_of ('>', start_tag)
					if l_tag_end > 0 then
						end_tag := a_section.substring_index ("</syntaxhighlight>", l_tag_end)
						if end_tag > l_tag_end then
							Result := a_section.substring (l_tag_end + 1, end_tag - 1)
							Result := trim_code (Result)
							l_found := True
						end
					end
				end
			end

			-- Try <lang ...>
			if not l_found then
				start_tag := a_section.substring_index ("<lang", 1)
				if start_tag > 0 then
					l_tag_end := a_section.index_of ('>', start_tag)
					if l_tag_end > 0 then
						end_tag := a_section.substring_index ("</lang>", l_tag_end)
						if end_tag > l_tag_end then
							Result := a_section.substring (l_tag_end + 1, end_tag - 1)
							Result := trim_code (Result)
							l_found := True
						end
					end
				end
			end

			-- Try <pre>
			if not l_found then
				start_tag := a_section.substring_index ("<pre>", 1)
				if start_tag > 0 then
					end_tag := a_section.substring_index ("</pre>", start_tag + 5)
					if end_tag > start_tag then
						Result := a_section.substring (start_tag + 5, end_tag - 1)
						Result := trim_code (Result)
					end
				end
			end
		end

	clean_wiki_markup (a_text: STRING): STRING
			-- Remove wiki markup from `text'.
		do
			Result := a_text.twin
			Result := remove_wiki_links (Result)
			Result.replace_substring_all ("'''", "")
			Result.replace_substring_all ("''", "")
			Result.replace_substring_all ("<br>", "%N")
			Result.replace_substring_all ("<br/>", "%N")
			Result.replace_substring_all ("<br />", "%N")
			Result.left_adjust
			Result.right_adjust
		end

	remove_wiki_links (a_text: STRING): STRING
			-- Remove [[link]] and [[link|display]] from text.
		local
			i, start_pos, pipe_pos, end_pos: INTEGER
		do
			Result := a_text.twin
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

	trim_code (a_code: STRING): STRING
			-- Trim leading/trailing whitespace from code.
		do
			Result := a_code.twin
			Result.left_adjust
			Result.right_adjust
		end

feature {NONE} -- Constants

	Header_pattern: STRING = "=={{header\|([^}]+)}}=="
			-- Regex pattern for language headers

end

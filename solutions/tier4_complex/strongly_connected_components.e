note
	description: "[
		Rosetta Code: Tarjan's strongly connected components
		https://rosettacode.org/wiki/Tarjan

		Find all strongly connected components in a directed graph
		using Tarjan's algorithm. O(V+E) complexity.
	]"

class
	STRONGLY_CONNECTED_COMPONENTS

create
	make

feature {NONE} -- Initialization

	make (vertex_count: INTEGER)
			-- Create graph with vertex_count vertices
		require
			positive: vertex_count > 0
		do
			num_vertices := vertex_count
			create adjacency.make_filled (Void, 0, vertex_count - 1)
			across 0 |..| (vertex_count - 1) as i loop
				adjacency [i] := create {ARRAYED_LIST [INTEGER]}.make (5)
			end
		end

feature -- Graph Construction

	add_edge (from_v, to_v: INTEGER)
			-- Add directed edge
		require
			valid_from: from_v >= 0 and from_v < num_vertices
			valid_to: to_v >= 0 and to_v < num_vertices
		do
			if attached adjacency [from_v] as adj then
				adj.extend (to_v)
			end
		end

feature -- Algorithm

	find_sccs: ARRAY [ARRAY [INTEGER]]
			-- Find all strongly connected components using Tarjan's algorithm
		local
			index_counter: INTEGER
			indices: ARRAY [INTEGER]
			low_link: ARRAY [INTEGER]
			on_stack: ARRAY [BOOLEAN]
			stack: ARRAYED_LIST [INTEGER]
			result_list: ARRAYED_LIST [ARRAY [INTEGER]]
			v: INTEGER
		do
			index_counter := 0
			create indices.make_filled (-1, 0, num_vertices - 1)
			create low_link.make_filled (0, 0, num_vertices - 1)
			create on_stack.make_filled (False, 0, num_vertices - 1)
			create stack.make (num_vertices)
			create result_list.make (10)

			from v := 0 until v >= num_vertices loop
				if indices [v] = -1 then
					strongconnect (v, index_counter, indices, low_link, on_stack, stack, result_list)
				end
				v := v + 1
			end

			Result := result_list.to_array
		end

feature -- Access

	num_vertices: INTEGER

feature {NONE} -- Implementation

	adjacency: ARRAY [detachable ARRAYED_LIST [INTEGER]]

	strongconnect (v: INTEGER; index_counter: INTEGER; indices, low_link: ARRAY [INTEGER];
			on_stack: ARRAY [BOOLEAN]; stack: ARRAYED_LIST [INTEGER];
			result_list: ARRAYED_LIST [ARRAY [INTEGER]])
			-- Tarjan's strongconnect procedure
		local
			w: INTEGER
			scc: ARRAYED_LIST [INTEGER]
			idx: INTEGER
		do
			idx := index_counter
			indices [v] := idx
			low_link [v] := idx
			stack.extend (v)
			on_stack [v] := True

			if attached adjacency [v] as adj then
				across adj as neighbor loop
					w := neighbor
					if indices [w] = -1 then
						strongconnect (w, idx + 1, indices, low_link, on_stack, stack, result_list)
						low_link [v] := low_link [v].min (low_link [w])
					elseif on_stack [w] then
						low_link [v] := low_link [v].min (indices [w])
					end
				end
			end

			-- If v is a root node, pop stack and generate SCC
			if low_link [v] = indices [v] then
				create scc.make (5)
				from until stack.is_empty or else stack.last = v loop
					w := stack.last
					stack.finish
					stack.remove
					on_stack [w] := False
					scc.extend (w)
				end
				if not stack.is_empty then
					w := stack.last
					stack.finish
					stack.remove
					on_stack [w] := False
					scc.extend (w)
				end
				result_list.extend (scc.to_array)
			end
		end

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			graph: STRONGLY_CONNECTED_COMPONENTS
			sccs: ARRAY [ARRAY [INTEGER]]
			i: INTEGER
		do
			print ("Strongly Connected Components (Tarjan's Algorithm) Demo:%N%N")

			create graph.make (8)
			graph.add_edge (0, 1)
			graph.add_edge (1, 2)
			graph.add_edge (2, 0)
			graph.add_edge (3, 1)
			graph.add_edge (3, 2)
			graph.add_edge (3, 4)
			graph.add_edge (4, 3)
			graph.add_edge (4, 5)
			graph.add_edge (5, 2)
			graph.add_edge (5, 6)
			graph.add_edge (6, 5)
			graph.add_edge (7, 4)
			graph.add_edge (7, 6)
			graph.add_edge (7, 7)

			sccs := graph.find_sccs

			print ("Found " + sccs.count.out + " strongly connected components:%N")
			from i := 1 until i > sccs.count loop
				print ("  SCC " + i.out + ": {")
				across sccs [i] as v loop
					print (v.out)
					if not (@ v.target_index = sccs [i].upper) then
						print (", ")
					end
				end
				print ("}%N")
				i := i + 1
			end
		end

end

note
	description: "[
		Rosetta Code: Graph colouring
		https://rosettacode.org/wiki/Graph_colouring

		Assign colors to vertices such that no adjacent vertices
		share the same color. Greedy algorithm.
	]"

class
	GRAPH_COLORING

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

	add_edge (v1, v2: INTEGER)
			-- Add undirected edge between v1 and v2
		require
			valid_v1: v1 >= 0 and v1 < num_vertices
			valid_v2: v2 >= 0 and v2 < num_vertices
		do
			if attached adjacency [v1] as adj then
				adj.extend (v2)
			end
			if attached adjacency [v2] as adj then
				adj.extend (v1)
			end
		end

feature -- Algorithm

	greedy_coloring: ARRAY [INTEGER]
			-- Assign colors using greedy algorithm
			-- Returns array where Result[v] is color of vertex v
		local
			colors: ARRAY [INTEGER]
			available: ARRAY [BOOLEAN]
			v, neighbor, color: INTEGER
		do
			create colors.make_filled (-1, 0, num_vertices - 1)
			create available.make_filled (True, 0, num_vertices - 1)

			-- First vertex gets color 0
			colors [0] := 0

			from v := 1 until v >= num_vertices loop
				-- Reset available colors
				from color := 0 until color >= num_vertices loop
					available [color] := True
					color := color + 1
				end

				-- Mark colors of adjacent vertices as unavailable
				if attached adjacency [v] as adj then
					across adj as n loop
						neighbor := n
						if colors [neighbor] >= 0 then
							available [colors [neighbor]] := False
						end
					end
				end

				-- Find first available color
				from color := 0 until color >= num_vertices or available [color] loop
					color := color + 1
				end

				colors [v] := color
				v := v + 1
			end

			Result := colors
		end

	chromatic_number_upper_bound: INTEGER
			-- Upper bound on chromatic number (greedy coloring uses at most this many)
		local
			colors: ARRAY [INTEGER]
		do
			colors := greedy_coloring
			across colors as c loop
				Result := Result.max (c + 1)
			end
		end

feature -- Validation

	is_valid_coloring (colors: ARRAY [INTEGER]): BOOLEAN
			-- Is the coloring valid (no adjacent vertices same color)?
		local
			v: INTEGER
		do
			Result := True
			from v := 0 until v >= num_vertices or not Result loop
				if attached adjacency [v] as adj then
					across adj as n loop
						if colors [v] = colors [n] then
							Result := False
						end
					end
				end
				v := v + 1
			end
		end

feature -- Access

	num_vertices: INTEGER

feature {NONE} -- Implementation

	adjacency: ARRAY [detachable ARRAYED_LIST [INTEGER]]

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			graph: GRAPH_COLORING
			colors: ARRAY [INTEGER]
			color_names: ARRAY [STRING]
		do
			print ("Graph Coloring Demo:%N%N")

			-- Petersen graph has chromatic number 3
			create graph.make (10)
			-- Outer pentagon
			graph.add_edge (0, 1)
			graph.add_edge (1, 2)
			graph.add_edge (2, 3)
			graph.add_edge (3, 4)
			graph.add_edge (4, 0)
			-- Inner pentagram
			graph.add_edge (5, 7)
			graph.add_edge (7, 9)
			graph.add_edge (9, 6)
			graph.add_edge (6, 8)
			graph.add_edge (8, 5)
			-- Spokes
			graph.add_edge (0, 5)
			graph.add_edge (1, 6)
			graph.add_edge (2, 7)
			graph.add_edge (3, 8)
			graph.add_edge (4, 9)

			print ("Petersen Graph (10 vertices):%N")
			colors := graph.greedy_coloring

			color_names := <<"Red", "Green", "Blue", "Yellow", "Orange", "Purple", "Cyan", "Magenta", "Brown", "Pink">>

			across 0 |..| 9 as v loop
				print ("  Vertex " + v.out + ": Color " + colors [v].out)
				if colors [v] < color_names.count then
					print (" (" + color_names [colors [v] + 1] + ")")
				end
				print ("%N")
			end

			print ("%NColors used: " + graph.chromatic_number_upper_bound.out + "%N")
			print ("Valid coloring: " + graph.is_valid_coloring (colors).out + "%N")
		end

end

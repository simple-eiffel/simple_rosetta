note
	description: "[
		Rosetta Code: Floyd-Warshall algorithm
		https://rosettacode.org/wiki/Floyd-Warshall_algorithm

		Find shortest paths between all pairs of vertices.
		O(V^3) time complexity.
	]"

class
	FLOYD_WARSHALL

create
	make

feature {NONE} -- Initialization

	make (vertex_count: INTEGER)
			-- Create graph with vertex_count vertices
		require
			positive: vertex_count > 0
		local
			i: INTEGER
			row_dist: ARRAY [REAL_64]
			row_next: ARRAY [INTEGER]
		do
			num_vertices := vertex_count
			create dist.make_filled (create {ARRAY [REAL_64]}.make_empty, 0, vertex_count - 1)
			create next_vertex.make_filled (create {ARRAY [INTEGER]}.make_empty, 0, vertex_count - 1)

			-- Initialize distance matrix
			from i := 0 until i >= vertex_count loop
				create row_dist.make_filled (Infinity, 0, vertex_count - 1)
				create row_next.make_filled (-1, 0, vertex_count - 1)
				dist [i] := row_dist
				next_vertex [i] := row_next
				dist [i] [i] := 0
				i := i + 1
			end
		end

feature -- Constants

	Infinity: REAL_64 = 1.0e308
			-- Representation of infinity

feature -- Graph Construction

	add_edge (from_v, to_v: INTEGER; weight: REAL_64)
			-- Add directed edge
		require
			valid_from: from_v >= 0 and from_v < num_vertices
			valid_to: to_v >= 0 and to_v < num_vertices
		do
			dist [from_v] [to_v] := weight
			next_vertex [from_v] [to_v] := to_v
		end

feature -- Algorithm

	compute
			-- Run Floyd-Warshall algorithm
		local
			k, i, j: INTEGER
			new_dist: REAL_64
		do
			from k := 0 until k >= num_vertices loop
				from i := 0 until i >= num_vertices loop
					from j := 0 until j >= num_vertices loop
						if dist [i] [k] < Infinity and dist [k] [j] < Infinity then
							new_dist := dist [i] [k] + dist [k] [j]
							if new_dist < dist [i] [j] then
								dist [i] [j] := new_dist
								next_vertex [i] [j] := next_vertex [i] [k]
							end
						end
						j := j + 1
					end
					i := i + 1
				end
				k := k + 1
			end
			computed := True
		ensure
			is_computed: computed
		end

feature -- Query

	distance (from_v, to_v: INTEGER): REAL_64
			-- Shortest distance from from_v to to_v
		require
			computed: computed
			valid_from: from_v >= 0 and from_v < num_vertices
			valid_to: to_v >= 0 and to_v < num_vertices
		do
			Result := dist [from_v] [to_v]
		end

	path (from_v, to_v: INTEGER): ARRAY [INTEGER]
			-- Shortest path from from_v to to_v
		require
			computed: computed
			valid_from: from_v >= 0 and from_v < num_vertices
			valid_to: to_v >= 0 and to_v < num_vertices
		local
			result_list: ARRAYED_LIST [INTEGER]
			curr: INTEGER
		do
			create result_list.make (num_vertices)
			if next_vertex [from_v] [to_v] /= -1 then
				curr := from_v
				from until curr = to_v loop
					result_list.extend (curr)
					curr := next_vertex [curr] [to_v]
				end
				result_list.extend (to_v)
			end
			Result := result_list.to_array
		end

	has_negative_cycle: BOOLEAN
			-- Does graph contain a negative cycle?
		require
			computed: computed
		local
			i: INTEGER
		do
			from i := 0 until i >= num_vertices or Result loop
				if dist [i] [i] < 0 then
					Result := True
				end
				i := i + 1
			end
		end

feature -- Access

	num_vertices: INTEGER
	computed: BOOLEAN

feature {NONE} -- Implementation

	dist: ARRAY [ARRAY [REAL_64]]
	next_vertex: ARRAY [ARRAY [INTEGER]]

feature -- Demo

	demo
			-- Standard Rosetta Code demo
		local
			graph: FLOYD_WARSHALL
			i, j: INTEGER
		do
			print ("Floyd-Warshall Algorithm Demo:%N%N")

			create graph.make (4)
			graph.add_edge (0, 2, -2)
			graph.add_edge (1, 0, 4)
			graph.add_edge (1, 2, 3)
			graph.add_edge (2, 3, 2)
			graph.add_edge (3, 1, -1)

			graph.compute

			print ("Distance matrix:%N")
			from i := 0 until i >= 4 loop
				from j := 0 until j >= 4 loop
					if graph.distance (i, j) >= graph.Infinity then
						print ("INF ")
					else
						print (graph.distance (i, j).truncated_to_integer.out + "   ")
					end
					j := j + 1
				end
				print ("%N")
				i := i + 1
			end

			print ("%NPaths:%N")
			print ("1 -> 3: ")
			across graph.path (1, 3) as v loop
				print (v.out + " ")
			end
			print ("%N")
			print ("0 -> 3: ")
			across graph.path (0, 3) as v loop
				print (v.out + " ")
			end
			print ("%N")
		end

end

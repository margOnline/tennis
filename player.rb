class Player
	attr_accessor :points, :games, :sets
	def initialize(fname,lname)
		@points = 0
		@games = 0
		@sets = 0
		@fname = fname
		@lname = lname
	end

	def fullname
		@fname + ' ' + @lname
	end

	def score
		'Sets:' + @sets.to_s + ' Games:' + @games.to_s + ' Points:' + @points.to_s
	end

	def games_sets
		'Sets:' + @sets.to_s + ' Games:' + @games.to_s
	end
end
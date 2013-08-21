# v.2 - incorporates game and set scoring as well as point scoring
# 2 classes - Player holds play info and scores; Match contains methods to handle the scoring

class Player
	attr_accessor :points, :games, :sets, :p_winner, :role
	def initialize(fname,lname,role)
		@points = 0
		@games = 0
		@sets = 0
		@p_winner = false
		@fname = fname
		@lname = lname
		@role = role
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

class Match
	attr_accessor :game_over, :set_over, :match_over
	@@score = %w(0 15 30 40 advantage game)
	def initialize
		@game_over = @set_over = @match_over = false
	end
	
	def play(player1, player2)
		display_points(player1, player2)
		until match_over?(player1, player2)
			is_break_point?(player1, player2)
			point_winner = play_point(player1, player2)
			change_score(player1, player2, point_winner)
			display_score(player1, player2)
		end
	end
	
	def play_point(player1, player2)
		prompt(player1, player2)
		point_winner = gets.chomp
		set_point_winner(player1, player2, point_winner)
	end
	
	def change_score(player1,player2,point_winner)
		if is_advantage?(player1,player2) 
			is_advantage(player1,player2,point_winner) 
		elsif is_30_40?(player1,player2)
			is_30_40(player1,player2,point_winner)
		else
			increment_score(player1,player2)	
		end	
	
		if is_game?(player1, player2)
				@game_over = true
				player1.points = 0
				player2.points = 0
				player1.p_winner ? player1.games += 1 : player1.games += 0
				player2.p_winner ? player2.games += 1 : player2.games += 0
				player1.role = player1.role == 'server' ? 'receiver' : 'server'
				player2.role = player2.role == 'server' ? 'receiver' : 'server'
				if is_tiebreak?(player1, player2)
					play_tiebreak(player1, player2)
				end
				if is_set?(player1, player2)
					@set_over = true
					player1.points = player2.points = player1.games = player2.games = 0
					player1.p_winner ? player1.sets += 1 : player1.sets += 0
					player2.p_winner ? player2.sets += 1 : player2.sets += 0
				end
				if match_over?(player1, player2)
					match_over(player1, player2)
				end
		end
	end
		
	def is_advantage?(player1,player2)
		return player1.points == 4 || player2.points == 4 ? true : false
	end
	
	def is_30_40?(player1,player2)
		(player1.points == 3 || player2.points == 3) && (player1.points - player2.points).abs == 1 ? true : false
	end
	
	def is_break_point?(player1,player2)
		
	end
	
	def increment_score(player1,player2)
		if player1.p_winner
			player1.points += 1
		else
			player2.points += 1
		end
	end

	def is_deuce?(player1,player2)
		return player1.points == 4 && player2.points == 4 ? true : false
	end

	def is_30_40(player1,player2,point_winner)
		case point_winner
			when '1' 
				if player1.points  > player2.points
					player1.points = 5 
				else
					player1.points += 1
				end
			when '2'
				if player2.points  > player1.points
					player2.points = 5 
				else
					player2.points += 1
				end
		end
	end
	
	def is_advantage(player1,player2,point_winner)
		case point_winner
			when '1' 
				if player1.points  > player2.points
					player1.points += 1 
				else
					player2.points -= 1
				end
			
			when '2'
				if player2.points > player1.points
					player2.points += 1
				else
					player1.points -= 1
				end
		end
	end
	
	def is_game?(player1, player2)
		if (player1.points == 4 || player2.points == 4)
			(player1.points - player2.points).abs >= 2 ? true : false
		elsif (player1.points == 5 || player2.points == 5)
			(player1.points - player2.points).abs >= 2 ? true : false
		else
			return false
		end
	end
	
	def is_tiebreak?(player1, player2)
		 player1.games == 6 && player2.games == 6 ? true : false
	end
	
	def play_tiebreak(player1, player2)
		until (player1.points >= 7 || player2.points >= 7) && ((player1.points - player2.points).abs == 2)
			play_point(player1, player2)
			increment_score(player1,player2)
			display_tb_score(player1, player2)
		end
		player1.p_winner ? player1.games += 1 : player1.games += 0
		player2.p_winner ? player2.games += 1 : player2.games += 0
	end
	
	def is_set?(player1, player2)
		((player1.games == 6 || player2.games == 6) && (player1.games - player2.games).abs >= 2) || (player1.games == 7 || player2.games == 7) ? true : false
	end
	
	def match_over?(player1, player2)
		player1.sets == 2 || player2.sets == 2 ? true : false
	end
	
	def match_over(player1, player2)
		match_winner = player1.p_winner == true ? player1 : player2
		puts "*************************************************"
		puts "GAME, SET AND MATCH: #{match_winner.fullname}!"
		puts "*************************************************"
		display_score(player1, player2)
	end
	
	def set_point_winner(player1, player2, point_winner)
		case point_winner
			when '1' 
				player1.p_winner = true
				player2.p_winner  = false
			
			when '2' 
				player1.p_winner = false
				player2.p_winner  = true
		end
		return point_winner
	end 
	
	def prompt(player1, player2)
		puts "> who won the point? #{player1.fullname} 1 or #{player2.fullname} 2"
	end
	
	def display_score(player1, player2)
		if @game_over 
			puts "#{player1.fullname}: #{player1.games_sets}"
			puts "#{player2.fullname}: #{player2.games_sets}"
			@game_over = false
			@set_over = false
		else
			display_points(player1, player2)
		end
	end
	
	def display_points(player1, player2)
		puts "#{player1.fullname}: #{@@score[player1.points]}"
		puts "#{player2.fullname}: #{@@score[player2.points]}"
	end
	
	def display_tb_score(player1, player2)
		puts "#{player1.fullname}: #{player1.points}"
		puts "#{player2.fullname}: #{player2.points}"
	end
end


puts "Player 1 first name: "
p1_fname = gets.chomp
puts "Player 1 surname: "
p1_lname = gets.chomp
puts "Player 2 first name: "
p2_fname = gets.chomp
puts "Player 2 surname: "
p2_lname = gets.chomp
puts "Who won the toss, Player 1 or Player 2?"
p1_role = gets.chomp == 1 ? 'server' : 'receiver'
p2_role = gets.chomp == 2 ? 'server' : 'receiver'
p1 = Player.new(p1_fname, p1_lname, p1_role)
p2 = Player.new(p2_fname, p2_lname, p2_role)
final = Match.new

final.play(p1,p2)
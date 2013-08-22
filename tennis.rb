# v.2 - incorporates refactoring suggestions and naming conventions suggested by Evegeny, 21 Aug 2013:
# 			changed the score array to a constant in Match class
#				to keep track of the player who won the point, used a reference to one of the player instances
# v.1 - incorporates game and set scoring as well as point scoring
# 2 classes - Player holds play info and scores; Match contains methods to handle the scoring

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

class Match
	attr_accessor :game_over, :set_over, :match_over, :point_winning_player, :server
	
  SCORE = %w(0 15 30 40 advantage game)

	def initialize(server)
    @server = server
		@game_over = @set_over = @match_over = false
		puts "Let the match begin!"
		puts "#{@server.fullname} to serve first."
	end
	
	def play(player1, player2)
		display_points(player1, player2)
		until match_over?(player1, player2)
			break_point?(player1, player2)
			@point_winning_player = play_point(player1, player2)
			change_score(player1, player2, @point_winning_player)
			display_score(player1, player2)
		end
	end

private
def play_point(player1, player2)
		prompt(player1, player2)
		point_winner = gets.chomp
    @point_winning_player = point_winner == '1' ? player1 : player2
	end
	
	def change_score(player1,player2,point_winning_player)
		if advantage?(player1,player2) 
			is_advantage(player1,player2,@point_winning_player) 
		elsif is_30_40?(player1,player2)
			is_30_40(player1,player2,@point_winning_player)
		else
			increment_score(@point_winning_player)	
		end	
	
		if game?(player1, player2)
			game_over(player1,player2,@point_winning_player)
		end
	end
		
	def advantage?(player1,player2)
		player1.points == 4 || player2.points == 4 
	end
	
	def is_30_40?(player1,player2)
		(player1.points == 3 || player2.points == 3) && (player1.points - player2.points).abs == 1
	end
	
	def break_point?(player1,player2)
		
	end
	
	def increment_score(point_winning_player)
  		@point_winning_player.points += 1
	end

	def deuce?(player1,player2)
		player1.points == 4 && player2.points == 4
	end
	def game?(player1, player2)
		if (player1.points == 4 || player2.points == 4)
			(player1.points - player2.points).abs >= 2 ? true : false
		elsif (player1.points == 5 || player2.points == 5)
			(player1.points - player2.points).abs >= 2 ? true : false
		else
			return false
		end
	end

	def is_30_40(player1,player2,point_winning_player)
    point_losing_player = player1 == @point_winning_player ? player2 : player1
		if @point_winning_player.points > point_losing_player.points
			point_winning_player.points = 5 
		else
			@point_winning_player.points += 1
		end
	end
	
	def is_advantage(player1,player2,point_winning_player)
    point_losing_player = player1 == @point_winning_player ? player2 : player1
    if @point_winning_player.points > point_losing_player.points
      @point_winning_player.points += 1
    else
      point_losing_player.points -= 1
    end
	end

	def game_over(player1,player2,point_winning_player)
		@game_over = true
		#swap who is serving at the end of each game
		@server = @server == player1 ? player2 : player1
		player1.points = player2.points = 0
		@point_winning_player.games += 1
		determine_next_step(player1,player2,point_winning_player)
		#code to go here to change the role of the players (server/receiver) 
		#for enhanced score display purposes
	end

	def determine_next_step(player1,player2,point_winning_player)
		if tiebreak?(player1, player2)
			display_score(player1, player2)
			introduce_tiebreak
			play_tiebreak(player1, player2, @point_winning_player)
		end

		if set?(player1, player2)
			@set_over = true
			player1.points = player2.points = player1.games = player2.games = 0
			@point_winning_player.sets += 1
			if not match_over?(player1, player2)
				intro_new_set
			end
		end

		if match_over?(player1, player2)
			match_over(player1, player2,@point_winning_player)
		end
	end


	def tiebreak?(player1, player2)
		 player1.games == 6 && player2.games == 6 
	end
	
		until (player1.points >= 7 || player2.points >= 7) && ((player1.points - player2.points).abs >= 2)
			play_point(player1, player2)
			increment_score(@point_winning_player)
			display_tiebreak_score(player1, player2)
		end
		@point_winning_player.games += 1
		@game_over = true
		display_score(player1,player2)
	end
	
	def set?(player1, player2)
		((player1.games == 6 || player2.games == 6) && (player1.games - player2.games).abs >= 2) || (player1.games == 7 || player2.games == 7) 
	end
	
	def match_over?(player1, player2)
		player1.sets == 2 || player2.sets == 2 
	end
	
	def match_over(player1, player2,point_winning_player)
		puts "*************************************************"
		puts "GAME, SET AND MATCH: #{@point_winning_player.fullname}!"
		puts "*************************************************"
		display_score(player1, player2)
	end
	
	def set_point_winner(point_winning_player)
    	point_winner = @point_winning_player = point_winner == 1 ? player1 : player2
	end 
	
	def prompt(player1, player2)
		print "Who won the point? #{player1.fullname} (1) or #{player2.fullname} (2)\n> "
	end
	
  def set_game_flags
    @game_over = @set_over = false
  end

	def display_score(player1, player2)
		if @game_over
			puts "#{player1.fullname}: #{player1.games_sets}"
			puts "#{player2.fullname}: #{player2.games_sets}"
			puts "#{@server.fullname} to serve."
		  set_game_flags
		else
			display_points(player1, player2)
		end
	end
	
	def display_points(player1, player2)
		puts "#{player1.fullname}: #{SCORE[player1.points]}"
		puts "#{player2.fullname}: #{SCORE[player2.points]}"
	end
	
	def display_tiebreak_score(player1, player2)
		puts "#{player1.fullname}: #{player1.points}"
		puts "#{player2.fullname}: #{player2.points}"
	end

	def intro_new_set
		puts '------------------------------'
		puts 'NEW SET: to serve'
		puts '------------------------------'
	end

	def introduce_tiebreak
		puts '------------------------------'
		puts 'A tiebreak will now be played.'
		puts '------------------------------'
	end

end

puts "MARGO'S TENNIS SCORING"
print "Player 1 first name:  "
p1_fname = gets.chomp
print "Player 1 last name:   "
p1_lname = gets.chomp
print "Player 2 first name:  "
p2_fname = gets.chomp
print "Player 2 last name:   "
p2_lname = gets.chomp
player1 = Player.new(p1_fname, p1_lname)
player2 = Player.new(p2_fname, p2_lname)
print "Who won the toss, Player (1) or Player (2)?\n> "
server = gets.chomp == '1' ? player1 : player2
final = Match.new(server)

final.play(player1,player2)
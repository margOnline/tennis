# v.2 - incorporates refactoring suggestions and naming conventions suggested by Evegeny, 21 Aug 2013
# v.2 - incorporates game and set scoring as well as point scoring
# 2 classes - Player holds play info and scores; Match contains methods to handle the scoring
#require 'byebug'
#another comment to commit
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
		@game_over, @set_over, @match_over = false
	end
	
	def play(player1, player2)
		display_points(player1, player2)
    # byebug
		until match_over?(player1, player2)
			break_point?(player1, player2)
			@point_winning_player = play_point(player1, player2)
			change_score(player1, player2, @point_winning_player)
			display_score(player1, player2)
		end
	end
	
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

	def is_30_40(player1,player2,point_winning_player)
     point_losing_player = player1 == @point_winning_player ? player2 : player1
     #byebug
     # puts "point_losing_player = #{point_losing_player.fullname} with #{point_losing_player.points} points and 
     # point_winning_player = #{point_winning_player.fullname} with #{point_winning_player.points} points"
		if @point_winning_player.points > point_losing_player.points
					point_winning_player.points = 5 
					#byebug
		else
			@point_winning_player.points += 1
		end
		# puts "point_losing_player = #{point_losing_player.fullname} with #{point_losing_player.points} points and 
  #    point_winning_player = #{point_winning_player.fullname} with #{point_winning_player.points} points"
	end
	
	def is_advantage(player1,player2,point_winning_player)
    point_losing_player = player1 == @point_winning_player ? player2 : player1
    if @point_winning_player.points > point_losing_player.points
      @point_winning_player.points += 1
    else
      point_losing_player.points -= 1
    end
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
	
	def game_over(player1,player2,point_winning_player)
		@game_over = true
		player1.points = player2.points = 0
		@point_winning_player.games += 1
		
		#code to go here to change the role of the players (server/receiver) 
		#for enhanced score display purposes
		
		if tiebreak?(player1, player2)
			play_tiebreak(player1, player2, @point_winning_player)
		end

		if set?(player1, player2)
			@set_over = true
			player1.points = player2.points = player1.games = player2.games = 0
			@point_winning_player.sets += 1
		end

		if match_over?(player1, player2)
			match_over(player1, player2,@point_winning_player)
		end
		
	end
	def tiebreak?(player1, player2)
		 player1.games == 6 && player2.games == 6 
	end
	
	def play_tiebreak(player1, player2, point_winning_player)
		until (player1.points >= 7 || player2.points >= 7) && ((player1.points - player2.points).abs >= 2)
			play_point(player1, player2)
			increment_score(@point_winning_player)
			display_tiebreak_score(player1, player2)
		end
		@point_winning_player.games += 1
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
		puts "> who won the point? #{player1.fullname} (1) or #{player2.fullname} (2)"
	end
	
  def set_game_flags
    @game_over, @set_over = false
  end

	def display_score(player1, player2)
		if @game_over 
			puts "#{player1.fullname}: #{player1.games_sets}"
			puts "#{player2.fullname}: #{player2.games_sets}"
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
end

puts "Player 1 first name: "
p1_fname = gets.chomp
puts "Player 1 surname: "
p1_lname = gets.chomp
puts "Player 2 first name: "
p2_fname = gets.chomp
puts "Player 2 surname: "
p2_lname = gets.chomp
player1 = Player.new(p1_fname, p1_lname)
player2 = Player.new(p2_fname, p2_lname)
puts "Who won the toss, Player 1 or Player 2?"
server = gets.chomp
server == '1' ? player1 : player2
final = Match.new(server)

final.play(player1,player2)
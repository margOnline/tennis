require "./player.rb"
require "./match.rb"
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
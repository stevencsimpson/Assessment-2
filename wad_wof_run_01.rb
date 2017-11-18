# Ruby code file - All your code should be located between the comments provided.

# Add any additional gems and global variables here
require 'sinatra'
require 'pp'

set :logging, :true
set :port, 8080
set :static, true
set :public_folder, "static"
set :views, "views"
enable :sessions

# The file where you are to write code to pass the tests must be present in the same folder.
# See http://rspec.codeschool.com/levels/1 for help about RSpec
require "#{File.dirname(__FILE__)}/wad_wof_gen_01"

# Main program
module WOF_Game
	@input = STDIN
	@output = STDOUT
	g = Game.new(@input, @output)
	playing = true
	input = ""
	menu = ""
	guess = ""
	secret = ""
	filename = "wordfile.txt"
	turn = 0
	win = 0
	game = ""
	words = 0
	def self.getg
		g
	end
	g.start
	game = @input.gets.chomp
	if game == "1"
		@output.puts "Command line game"
	elsif game == "2"
		@output.puts "Web-based game"
	else
		@output.puts "Invalid input! No game selected."
		exit
	end

	if game == "1"
	# Any code added to command line game should be added below.

	l = -> { #Lambda that contains basically the whole game.
		if g.callmenu == 'Play'
		until g.getturnsleft == 0
			word = g.getsecretword
			print word.gsub(/\p{Upper}/, '_').upcase + "\r\n What's your guess?  (Input 9 to save and return to menu)"
			n = g.getguess
			g.storeguess(n)
			if word.include? n
				word.gsub!(n, n.downcase)
			elsif n == "9"
				g.save
				l.call
				break
			end
			g.incrementturn
			unless word.gsub(/\p{Upper}/, '_').include? "_"
				puts "Congratulations! You win!"
				g.win
				puts "Play again? (1)Yes (2)No"
				input = @input.gets.chomp
				if input == "1"
					g.resetgame
					g.callmenu
				elsif input == "2"
					exit
				else
					puts "Unknown input! Exiting..."
					exit
				end
			end
		end
		if g.getturnsleft == 0
			puts "You lost! Try again? (1)Yes (2)No"
			input = @input.gets.chomp
			if input == "1"
				g.resetgame
				g.callmenu
			elsif input == "2"
				exit
			else
				puts "Unknown input! Exiting..."
				exit
			end
		end
	end
	}
	l.call

	while g.repeat == 1
		l.call
	end

	# Any code added to command line game should be added above.

		exit	# Does not allow command-line game to run code below relating to web-based version
	end
end
# End modules

# Sinatra routes
	# Any code added to web-based game should be added below.
	GOES = 5
	def init
		@wordtable = []
		@secretword = ""
		$turn = 0
		@winner = 0
		@guess = ""
		@repeat = 0
	end

	def readwordfile(filename)
		@wordtable = []
		words = 0
		file = File.open(filename)
		file.each do |line|
			words += 1
			@wordtable.push(line.chomp)
	  end
		file.close
		return words
	end

	def gensecretword
		n = @wordtable.length
		n = rand(n)
		return @wordtable[n].upcase
	end

	def setsecretword(s)
		@secretword = s
	end

	def getsecretword
		return @secretword
	end

	def createtemplate
		return @secretword.gsub(/\p{Upper}/, '_')
	end

	def incrementturn
		$turn += 1
	end

	def getturnsleft
		@turnsleft = GOES - $turn.to_i
		return @turnsleft
	end

	def win
		@winner += 1
	end

	def save
		a = {
			:wordtable => @wordtable,
			:turn => @turn,
			:secretword => @secretword,
			:resulta => @resulta,
			:resultb => @resultb,
			:winner => @winner,
			:guess => @guess,
			:template => @template
		}
		File.open("save.dat", "w") do |file|
			file.print Marshal.dump(a)
		end
	end

	def loadsave
		a = Marshal.load(File.read('save.dat'))
		@wordtable = a[:wordtable]
		@turn = a[:turn]
		@secretword = a[:secretword]
		@resulta = a[:resulta]
		@resultb = a[:resultb]
		@winner = a[:winner]
		@guess = a[:guess]
		@template = a[:template]
	end

	def newword
		readwordfile("wordfile.txt")
		setsecretword(gensecretword)
	end

# init

get '/' do
	init
	newword
	session[:word] = getsecretword
	erb :index
end

get '/play' do
	@word = session[:word]
	unless @word.gsub(/\p{Upper}/, '_').include? "_"
		redirect '/win'
	end
	if getturnsleft == 0
		redirect '/lose'
	end
	erb :play
end

put '/play' do
	guess = "#{params[:guess]}".chomp.upcase
	@word = session[:word]
	if @word.include? guess
		@word.gsub!(guess, guess.downcase)
	end
	session[:word] = @word
	incrementturn
	redirect '/play'
end

get '/win' do
	erb :win
end

get '/lose' do
	erb :lose
end
	# Any code added to web-based game should be added above.

# End program

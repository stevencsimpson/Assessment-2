# Ruby code file - All your code should be located between the comments provided.

# Main class module
module WOF_Game
	# Input and output constants processed by subprocesses. MUST NOT change.
	GOES = 5

	class Game
		attr_reader :template, :wordtable, :input, :output, :turn, :turnsleft, :winner, :secretword, :played, :score, :resulta, :resultb, :guess
		attr_writer :template, :wordtable, :input, :output, :turn, :turnsleft, :winner, :secretword, :played, :score, :resulta, :resultb, :guess

		def initialize(input, output)
			@input = input
			@output = output
			@played = 0
			@score = 0
		end

		def getguess
			guess = @input.gets.chomp.upcase
		end

		def storeguess(guess)
			if guess != ""
				@resulta = @resulta.to_a.push "#{guess}"
			end
		end

		# Any code/methods aimed at passing the RSpect tests should be added below.

	def start
		output.puts 'Welcome to WOF!'
		output.puts "Created by: #{created_by} (#{student_id})"
		output.puts 'Starting game...'
		output.puts 'Enter 1 to run the game in the command-line window or 2 to run it in a web browser'
	end

	def displaymenu
		output.puts "Menu: (1) Play | (2) New | (3) Analysis | (9) Exit"
	end

	def created_by
		@myname = "Petar Petrov and Steven Simpson"
		return @myname
	end

	def student_id
		@student_id = '55170258 and 51767842'
		return @student_id
	end

	def resetgame
		@wordtable = []
		@secretword = ""
		@turn = 0
		@resulta = []
		@resultb = []
		@winner = 0
		@guess = ""
		@template = "[]"
		@repeat = 0
	end


	def callmenu
		displaymenu
		menu = @input.gets.chomp
		if menu == "1"
			loadsave
			return 'Play'
		elsif menu == "2"
			resetgame
			readwordfile("wordfile.txt")
			setsecretword(gensecretword)
			return 'Play'
		elsif menu == "3"
			loadsave
			puts "Turn: #{@turn}, Secret word: #{getsecretword.upcase}, Current state: #{getsecretword.gsub(/\p{Upper}/, '_').upcase}, Times won: #{@winner}"
			@repeat = 1
		elsif menu == "9"
			exit
		end
	end

	def repeat
		return @repeat
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
		@turn += 1
	end

	def getturnsleft
		@turnsleft = GOES - @turn.to_i
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

		# Any code/methods aimed at passing the RSpect tests should be added above.

	end
end

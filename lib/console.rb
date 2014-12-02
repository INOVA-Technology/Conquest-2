class Console
	class << self
		def start(y, max_messages)
			@@max_messages = max_messages
			@@win = Curses::Window.new(@@max_messages, 0, y, 0)
			@@messages = []
		end

		def write(message)
			message = message.to_s
			@@messages.unshift(message)
			@@messages.pop if @@messages.length > @@max_messages
			draw
		end

		def log(message)
			return unless ARGV[0] == "-d"
			write("Log: " + message.to_s)
		end

		def draw
			@@win.clear
			@@messages.each_with_index do |m, i|
				@@win.setpos(i, 0)
				@@win << m.to_s
			end
			@@win.refresh
		end

		def close
			@@win.close
		end
	end
end
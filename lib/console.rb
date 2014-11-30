class Console
	class << self
		def start(y, max_messages)
			@@max_messages = max_messages
			@@win = Curses::Window.new(@@max_messages, 80, y, 0)
			@@messages = []
		end

		def log(message, dev = false)
			message = message.to_s
			if dev
				if ARGV[0] == "-d"
					message = "Log: " + message
				else
					return
				end
			end
			@@messages.unshift(message)
			@@messages.pop if @@messages.length > @@max_messages
			draw
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
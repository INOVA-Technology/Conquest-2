class Console
	class << self
		def start(y, max_messages)
			@@max_messages = max_messages
			@@win = Curses::Window.new(@@max_messages, 80, y, 0)
			@@messages = []
		end

		def log(message, dev = false)
			@@win.clear
			if dev
				if ARGV[0] == "-d"
					message = "Log: " + message
				else
					return
				end
			end
			@@messages.unshift(message)
			@@messages.pop if @@messages.length > @@max_messages
			@@messages.each_with_index do |m, i|
				@@win.setpos(i, 0)
				@@win << m.to_s
			end
			@@win.refresh
		end
	end
end
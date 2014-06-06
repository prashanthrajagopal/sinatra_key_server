### Worker thread runs every second to release blocked and unused keys

class BackgroundJob
	def initialize
		STDERR.puts "#{Time.now} - Background job initialized"
		Thread.new do
			while true do
				release_blocked_keys
				release_unused_keys
				sleep 1
			end
		end
	end

	def release_unused_keys
		if $key_list["available"] != []
			$key_list["available"].each do |key|
				if Time.now - $time_keeper[key] >= 300.0
					STDERR.puts "#{Time.now} - DELETING #{key}"
					$key_list["available"].delete key
					$time_keeper.delete key
					STDERR.puts "KEY LIST - #{$key_list.inspect}"
					STDERR.puts "TIME KEEPER - #{$time_keeper.inspect}"
				end
			end
		end
	end

	def release_blocked_keys
		if $key_list["blocked"] != []
			$key_list["blocked"].each do |key|
				if Time.now - $time_keeper[key] >= 60.0
					STDERR.puts "#{Time.now} - RELEASING #{key}"
					$key_list["available"] << key
					$key_list["blocked"].delete(key)
					$time_keeper[key] = Time.now
					STDERR.puts "KEY LIST - #{$key_list.inspect}"
					STDERR.puts "TIME KEEPER - #{$time_keeper.inspect}"
				end
			end
		end
	end
end
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
				end
			end
		end
	end

	def release_blocked_keys
		if $key_list["blocked"] != []
			$key_list["blocked"].each do |key|
				if Time.now - $time_keeper[key] >= 60.0
					STDERR.puts "#{Time.now} - RELEASING #{key}"
					unblock(key)
					$time_keeper[key] = Time.now
				end
			end
		end
	end
end
require_relative './bg_job'

class Server
	def initialize
		BackgroundJob.new
	end

	def generate_key
		key = `$(which openssl) rand -base64 32`.chomp.gsub('/','')
		$key_list["available"] << key
		$time_keeper[key] = Time.now
		STDERR.puts "#{Time.now} - Key Generated - #{key}"
		return true
	end

	def get_key
		if $key_list["available"] != []
			key = $key_list["available"].last
			$key_list["blocked"] << key
			$key_list["available"].delete(key)
			$time_keeper[key] = Time.now
			STDERR.puts "#{Time.now} - Returning for get_key - #{key}"
		end
		return key
	end

	def unblock(key)
		status = false
		if($key_list["blocked"] != [] || $key_list["blocked"].include?(key))
			$key_list["available"] << key
			$key_list["blocked"].delete(key)
			status = true
		end
		STDERR.puts "#{Time.now} - #{status} Returning for Unblock - #{key}"
		return status
	end

	def delete(key)
		status = false
		if($key_list["blocked"].include?(key))
			$key_list["blocked"].delete(key)
			$time_keeper.delete(key)
			status = true
		elsif($key_list["available"].include?(key))
			$key_list["available"].delete key
			$time_keeper.delete(key)
			status = true
		end
		STDERR.puts "#{Time.now} - #{status} Returning for delete - #{key}"
		return status
	end

	def keep_alive(key)
		status = false
		if($key_list["blocked"].include?(key))
			time_keeper[key] = Time.now
			status = true
		end
		STDERR.puts "#{Time.now} - #{status} Returning for Keep Alive - #{key}"
		STDERR.puts "****************************************\n#{$key_list.inspect}\n****************************************\n"
		STDERR.puts "#{$time_keeper.inspect}\n****************************************\n"
		return status
	end

	
end
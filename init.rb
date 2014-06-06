require_relative './server'

class KeyServer < Sinatra::Application
	s = Server.new

	get '/generate' do
		if s.generate_key
			"Key Generated Successfully"
		end
	end

	get '/get' do
		key = s.get_key
		ret = if key
			key
		else
			"Key not Found"
		end
	end

	get '/unblock' do
		if s.unblock(params[:key])
			"Key Unblocked"
		else
			"Key not Found"
		end
	end

	get '/delete' do
		if s.delete(params[:key])
			"Key Deleted"
		else
			"Key not Found"
		end
	end

	get '/keep_alive' do
		if s.keep_alive(params[:key])
			"Successful"
		else
			"Key not Found"
		end
	end
end
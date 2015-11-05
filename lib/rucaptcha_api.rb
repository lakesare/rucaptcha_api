require 'rest-client'
require 'nokogiri'

require "rucaptcha_api/version"
require "rucaptcha_api/errors"
require "rucaptcha_api/stats"


RucaptchaApi.class_eval do
	include Errors
	include Stats

	BASE_URI = 'http://rucaptcha.com'

	attr_reader :rucaptcha_key

	def initialize rucaptcha_key
		@rucaptcha_key = rucaptcha_key
	end

	def send_captcha_for_solving path_to_captcha, params: {}

		final_params = {
			key:      @rucaptcha_key,
			file:     File.new(path_to_captcha)
		}.merge params #either add or override defaults
		
		response = RestClient.post "#{BASE_URI}/in.php", final_params #"OK|179055170"

		if captcha_id = response.scan(/\AOK\|([0-9]+)\Z/).flatten[0] #either nil or '179055170' 
			captcha_id
		else
			inspect__send_captcha_for_solving__errors response, path_to_captcha
		end
	end

	def get_solved_captcha captcha_id
		get_link = BASE_URI + "/res.php?key=#{@rucaptcha_key}&action=get&id=#{captcha_id}"
		response = RestClient.get get_link
		if response == 'CAPCHA_NOT_READY'
			sleep 5
			get_solved_captcha captcha_id
		elsif solved_captcha = response.scan(/\AOK\|(\w+)\Z/).flatten[0]
			solved_captcha
		else
			inspect__get_solved_captcha__errors response, captcha_id
		end
	end


end



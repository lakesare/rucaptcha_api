require 'spec_helper'

describe RucaptchaApi do
	before(:context) do
		rucaptcha_key = 'before running the tests, please find out your key'
		@api = RucaptchaApi.new rucaptcha_key
		@path_to_captcha = File.expand_path 'spec/captchas/1.png'
	end

	it 'has a version number' do
		expect(RucaptchaApi::VERSION).not_to be nil
	end

	it 'sends captcha for solving and gets solved captcha' do
		options = {language: 2} #2 = на капче только латинские буквы
		captcha_id = @api.send_captcha_for_solving @path_to_captcha, params: options
		expect(captcha_id).to match(/\d+/)


		solved_captcha = @api.get_solved_captcha captcha_id
		expect(solved_captcha).to eq('3yk4p')
	end

	describe Errors do
		it 'raises error on wrong @rucaptcha_key' do
			wrong_rucapctha_key = 'very_wrong_key'
			wrong_api = RucaptchaApi.new wrong_rucapctha_key
			expect {wrong_api.send_captcha_for_solving @path_to_captcha}.to raise_error("ERROR_KEY_DOES_NOT_EXIST\nexplanation: Использован несуществующий key\nkey: #{wrong_rucapctha_key}")
		end
	end

	describe Stats do
		it 'gets balance' do
			expect(@api.balance).to match(/[\d\.]+/)
		end

		it 'gets captcha cost' do
			expect(@api.captcha_cost '218356487').to be_a(String)
			# check with newer captcha_id and parse it on #capctha_cost
		end

		it 'gets stats for specified date' do
			expect(@api.stats_for date: '2013-11-27').to be_a(String)
		  # date in wrong format?
		end

		it 'gets rucaptcha stats' do
			expect(RucaptchaApi.rucaptcha_stats).to be_a(Hash)
		end

	end

end

module Stats

	def self.included(base)
		base.extend ClassMethods
	end
		
	# Узнать баланс аккаунта. Баланс указывается в Российских рублях
	def balance
		rucaptcha_balance_link = BASE_URI + "/res.php?key=#{@rucaptcha_key}&action=getbalance"
		RestClient.get rucaptcha_balance_link
	end

	# Запрос статуса и стоимости распознования данной капчи. Цена указывается в рублях
	def captcha_cost captcha_id
		rucaptcha_cost_link = BASE_URI + "/res.php?key=#{@rucaptcha_key}&action=get2&id=#{captcha_id}"
		RestClient.get rucaptcha_cost_link
	end

	# получить статистику использования аккаунта в XML за указанную дату
	# => string with xml
	def stats_for date: '2013-11-27'
		rucaptcha_stats_for_date_link = BASE_URI + "/res.php?key=#{@rucaptcha_key}&action=getstats&date=#{date}"
		RestClient.get rucaptcha_stats_for_date_link
	end


	module ClassMethods
		# waiting: количество работников ожидающих капчу.
		# load: процент загрузки работников
		# minbid: текущая ставка за распознание капчи. В рублях
		# averageRecognitionTime: среднее время (в секундах) за которое в данный момент разгадываются капчи
		def rucaptcha_stats
			rucaptcha_stats_link = BASE_URI + "/load.php"
			response = RestClient.get rucaptcha_stats_link

			doc = Nokogiri::XML response
			{ 
				waiting: doc.at_css('waiting').text, 
				load: doc.css('load').text, 
				minbid: doc.at_css('minbid').text, 
				average_recognition_time: doc.at_css('averageRecognitionTime').text
			}

		end
	end



end
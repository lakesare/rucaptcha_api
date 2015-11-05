module Errors
	def inspect__send_captcha_for_solving__errors response, path_to_captcha
		raise response + "\n" + case response
		when 'ERROR_WRONG_USER_KEY'
			"explanation: Не верный формат параметра key, должно быть 32 символа\nkey: #{@rucaptcha_key}"
		when 'ERROR_KEY_DOES_NOT_EXIST'
			"explanation: Использован несуществующий key\nkey: #{@rucaptcha_key}"
		when 'ERROR_ZERO_BALANCE'
			'explanation: Баланс Вашего аккаунта нулевой'
		when 'ERROR_NO_SLOT_AVAILABLE'
			'explanation: Текущая ставка распознования выше, чем максимально установленная в настройках Вашего аккаунта. Либо на сервере скопилась очередь и работники не успевают её разобрать, повторите загрузку через 5 секунд.'
		when 'ERROR_ZERO_CAPTCHA_FILESIZE'
			"explanation: Размер капчи меньше 100 Байт\n#{path_to_captcha}'s size:' #{File.new(path_to_captcha).size} bytes"
		when 'ERROR_TOO_BIG_CAPTCHA_FILESIZE'
			"explanation: Размер капчи более 100 КБайт\n#{path_to_captcha}'s size:' #{File.new(path_to_captcha).size/1024} kilobytes"
		when 'ERROR_WRONG_FILE_EXTENSION'
			"explanation: Ваша капча имеет неверное расширение, допустимые расширения jpg,jpeg,gif,png\nyour kaptcha extension: #{File.extname path_to_captcha},\npath to your captcha: #{path_to_captcha}"
		when 'ERROR_IMAGE_TYPE_NOT_SUPPORTED'
			"explanation: Сервер не может определить тип файла капчи\npath to your captcha: #{path_to_captcha}"
		when 'ERROR_IP_NOT_ALLOWED'
			'explanation: В Вашем аккаунте настроено ограничения по IP с которых можно делать запросы. И IP, с которого пришёл данный запрос не входит в список разрешённых.'
		when 'IP_BANNED'
			"explanation: IP-адрес, с которого пришёл запрос заблокирован из-за частых обращений с различными неверными ключами. Блокировка снимается через час\nTime.now: #{Time.now}"
		end
	end


	def inspect__get_solved_captcha__errors response, captcha_id
		raise response + "\n" + case response
		when 'ERROR_KEY_DOES_NOT_EXIST'
			"explanation: Вы использовали неверный key в запросе\nkey: #{@rucaptcha_key}"
		when 'ERROR_WRONG_ID_FORMAT'
			"explanation: Неверный формат ID капчи. ID должен содержать только цифры\ncaptcha id: #{captcha_id}"
		when 'ERROR_CAPTCHA_UNSOLVABLE'
			'explanation: Капчу не смогли разгадать 3 разных работника. Списанные средства за это изображение возвращаются обратно на баланс'
		when 'ERROR_WRONG_CAPTCHA_ID'
			'explanation: Вы пытаетесь получить ответ на капчу или пожаловаться на капчу, которая была загружена более 15 минут назад'
		when 'ERROR_BAD_DUPLICATES'
			'explanation: Ошибка появляется при включённом 100%м распознании. Было использовано максимальное количество попыток, но необходимое количество одинаковых ответов не было набрано'
		end
	end


	# Пожаловаться на неправильно расшифрованную капчу
	def complain captcha_id
		rucaptcha_complain_link = BASE_URI + "/res.php?key=#{@rucaptcha_key}&action=reportbad&id=#{captcha_id}"
		response = RestClient.get rucaptcha_complain_link
		response == 'OK_REPORT_RECORDED' ? true : response
	end





end
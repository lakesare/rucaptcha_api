



require 'rucaptcha_api'
rucaptcha_key = '5d01e7jk4d9c64a784b25d38840d1407'
api = RucaptchaApi.new rucaptcha_key
path_to_captcha = File.expand_path 'var/captchas/1.png'
captcha_id = api.send_captcha_for_solving path_to_captcha, params: {phrase: 1}
solved_captcha = api.get_solved_captcha captcha_id 
p solved_captcha #=> "3yk4p"







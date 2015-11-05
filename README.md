## RucaptchaApi

This gem facilitates interaction with https://rucaptcha.com/api-rucaptcha API.

### Installation

`gem 'rucaptcha_api'`

### Usage

```ruby
rucaptcha_key = '5d01e7jk4d9c64a784b25d38840d1407' #for example. get your own 'captcha KEY' from https://rucaptcha.com/setting page after you registered.
api = RucaptchaApi.new rucaptcha_key

path_to_captcha = File.expand_path 'var/captchas/1.png' #path to image of your captcha (only accepts jpg,jpeg,gif,png)

captcha_id = api.send_captcha_for_solving path_to_captcha, params: {phrase: 1} #you send captcha for solving, and you get its id as a resonse so that you can later look up its solution when it's ready. 
#params here are optional, and you can find possible params in API docs: https://rucaptcha.com/api-rucaptcha

```

<table border="1" cellpadding="1" cellspacing="1" style="width:900px">
	<thead>
		<tr>
			<th scope="col">POST параметр</th>
			<th scope="col">возможные значения</th>
			<th scope="col">описание параметра</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>phrase</td>
			<td>0;1</td>
			<td><strong>0</strong> = одно слово (значение по умлочанию)<br>
			<strong>1</strong> = капча имеет два слова</td>
		</tr>
		<tr>
			<td>regsense</td>
			<td>0;1</td>
			<td><strong>0</strong> = регистр ответа не имеет значения (значение по умолчанию )<br>
			<strong>1</strong> = регистр ответа имеет значение</td>
		</tr>
		<tr>
			<td>question</td>
			<td>0;1</td>
			<td><strong>0</strong> = параметр не задействован (значение по умолчанию )<br>
			<strong>1</strong> = на изображении задан вопрос, работник должен написать ответ</td>
		</tr>
		<tr>
			<td>numeric</td>
			<td>0;1;2;3</td>
			<td>
			<p><strong>0</strong> = параметр не задействован (значение по умолчанию)<br>
			<strong>1</strong> = капча состоит только из цифр<br>
			<strong>2</strong> = Капча состоит только из букв<br>
			<strong>3</strong> = Капча состоит либо только из цифр, либо только из букв.</p>
			</td>
		</tr>
		<tr>
			<td>calc</td>
			<td>0;1</td>
			<td><strong>0</strong> = параметр не задействован (значение по умолчанию)<br>
			<strong>1</strong> = работнику нужно совершить математическое действие с капчи</td>
		</tr>
		<tr>
			<td>min_len</td>
			<td>0..20</td>
			<td>
			<p><strong>0</strong> = параметр не задействован (значение по умолчанию)<br>
			<strong>1..20 </strong>= минимальное количество знаков в ответе</p>
			</td>
		</tr>
		<tr>
			<td>max_len</td>
			<td>1..20</td>
			<td><strong>0</strong> = параметр не задействован (значение по умолчанию)<br>
			<strong>1..20 </strong>= максимальное количество знаков в ответе</td>
		</tr>
		<tr>
			<td>is_russian</td>
			<td>0;1</td>
			<td>
			<p>параметр больше не используется, т.к. он означал "слать данную капчу русским исполнителям", а в системе находятся только русскоязычные исполнители. Смотрите новый параметр language, однозначно обозначающий язык капчи</p>
			</td>
		</tr>
		<tr>
			<td>soft_id</td>
			<td>&nbsp;</td>
			<td>ID разработчика приложения. Разработчику приложения отчисляется 10% от всех капч, пришедших из его приложения.</td>
		</tr>
		<tr>
			<td>language</td>
			<td>0;1;2</td>
			<td>
			<strong>0</strong> = параметр не задействован (значение по умолчанию)<br>
			<strong>1</strong> = на капче только кириллические буквы<br>
			<strong>2</strong> = на капче только латинские буквы<br>
			</td>
		</tr>
		<tr>
			<td>header_acao</td>
			<td>0;1</td>
			<td><strong>0</strong> = значение по умолчанию<br>
			<strong>1</strong> = in.php передаст Access-Control-Allow-Origin: * параметр в заголовке ответа. (Необходимо для кросс-доменных AJAX запросов в браузерных приложениях. Работает также для res.php.)</td>
		</tr>
		<tr>
			<td>textinstructions</td>
			<td>TEXT</td>
			<td>Текст, который будет показан работнику. Может содержать в себе инструкции по разгадке капчи. Ограничение - 140 символов. Текст необходимо слать в кодировке UTF-8.</td>
		</tr>
		<tr>
			<td>textcaptcha </td>
			<td>TEXT</td>
			<td>Текстовая капча. Картинка при этом не загружается, работник получает только текст и вводит ответ на этот текст. Ограничение - 140 символов. Текст необходимо слать в кодировке UTF-8.</td>
		</tr>
	</tbody>
</table>


```ruby
#after you sent your captcha for solving and got captcha_id, you can find solved captcha with:
solved_captcha = @api.get_solved_captcha captcha_id #=> Yi7yu8, for example
#in case if it's not ready yet, this method will automatically wait for 5 seconds and then resend the request for solved captcha.
```
in case your captcha wasn't properly solved, you can complain on it with `api.complain captcha_id`.

###Methods to get statistics
`api.balance #=> 95.03` - Узнать баланс аккаунта. Баланс указывается в Российских рублях. 
`api.captcha_cost captcha_id` - Запрос статуса и стоимости распознования данной капчи. Цена указывается в рублях.  
`api.stats_for date: '2013-11-27' # => string with xml` - получить статистику использования аккаунта в XML за указанную дату.  
`RucaptchaApi.rucaptcha_stats # => {waiting: ..., ...}` - waiting: количество работников ожидающих капчу. load: процент загрузки работников. minbid: текущая ставка за распознание капчи. В рублях. averageRecognitionTime: среднее время (в секундах) за которое в данный момент разгадываются капчи





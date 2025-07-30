/proc/send2announcement_webhook(title, text, sender_override = null, color_override = null)
	// Получаем Discord webhook URL из конфига (или хардкод для теста)
	var/webhook_url = CONFIG_GET(string/round_announce_webhook_url)
	if (!webhook_url)
		return

	var/color_code = 0x3498DB
	if (color_override)
		switch(LOWER_TEXT(color_override))
			if ("green")   color_code = 0x57F287
			if ("blue")    color_code = 0x3498DB
			if ("pink")    color_code = 0xE91E63
			if ("yellow")  color_code = 0xFEE75C
			if ("orange")  color_code = 0xFAA61A
			if ("red")     color_code = 0xED4245
			if ("purple")  color_code = 0x9B59B6
			if ("default") color_code = 0x3498DB

	if (title == null || title == "")
		title = "Attention"

	// Формируем embed для Discord
	var/embed = list(
		"title" = title,
		"description" = text,
		"color" = color_code
	)
	if (sender_override)
		embed["author"] = list("name" = sender_override)

	var/webhook_info = list("embeds" = list(embed), "attachments" = list())

	// Заголовки
	var/list/headers = list()
	headers["Content-Type"] = "application/json"

	// Отправка через rust-g
	var/datum/http_request/request = new()
	request.prepare(
		RUSTG_HTTP_METHOD_POST,
		webhook_url,
		json_encode(webhook_info),
		headers,
		"tmp/discord_announce_response.json"
	)
	request.begin_async()

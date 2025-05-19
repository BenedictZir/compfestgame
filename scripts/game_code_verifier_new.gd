extends Node


signal request_failed(error_message: String)
signal game_code_succeed(response_messages: String)
signal game_code_failed(error_message: String)

const GAME_CODE = "WHACK_A_VIM"  # TODO: Replace with your actual X-Gamecode
const SIGNATURE_SECRET = "A8242CBD53FA129D9B1FCB72753AE"  # TODO: Replace with your actual secret key
const URL := "https://lever.compfest.id/v1/token" # TODO: Change based on environment (dev, production), this one is for development

var user_playground_id: String
var attempt_id: String

var _http_request: HTTPRequest


func _ready():
	_http_request = HTTPRequest.new()
	add_child(_http_request)
	_http_request.request_completed.connect(_on_request_completed)


func verify_game_code(code: String):
	var now := Time.get_datetime_dict_from_system(true)
	
	var timestamp := "%d-%02d-%02dT%02d:%02d:%02dZ" % [now.year, now.month, now.day, now.hour, now.minute, now.second]
	var request_dict := {
		"token": code,
		"arcadeCode": GAME_CODE
	}
	var request_body := JSON.stringify(request_dict)
	var body_raw := request_body.to_utf8_buffer()
	var signature := await generate_signature(body_raw, timestamp)
	
	#print(request_body)
	
	var headers := [
		"Content-Type: application/json",
		"X-Timestamp: " + timestamp,
		"X-Signature: " + signature
	]
	
	var error := _http_request.request(URL, headers, HTTPClient.METHOD_POST, request_body)
	if error != OK:
		request_failed.emit(error)
	#print(timestamp)
	#print(headers)


func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	var result_body := body.get_string_from_utf8()
	
	#print(result_body,1)
	
	if result_body.is_empty() or result_body.begins_with("<!DOCTYPE html>"):
		game_code_failed.emit("Request Error")
		return
	
	var response: Dictionary = JSON.parse_string(result_body)
	response_code=response.code
	#print(response_code)
	
	if response_code == 200 or response_code == 201:
		user_playground_id = response.data.username
		#print(user_playground_id)
		attempt_id = response.data.attemptId
		#print(attempt_id)
		game_code_succeed.emit(response.message)
	else:
		game_code_failed.emit(response.message)


func generate_signature(body: PackedByteArray, timestamp: String) -> String:
	var hash_body := sha256(body)
	var hex_hash := hash_body.hex_encode()
		
	var signature_base := "POST:/v1/token:%s:%s" % [hex_hash, timestamp]
	#print(signature_base)
	
	# HMAC-SHA512 implementation
	var block_size := 128
	var key := SIGNATURE_SECRET.to_utf8_buffer()
	
	if key.size() > block_size:
		key = SHA512.sha512(key)
	
	if key.size() < block_size:
		key.resize(block_size)
	
	var o_key_pad := PackedByteArray()
	var i_key_pad := PackedByteArray()
	
	for i in range(block_size):
		o_key_pad.append(0x5c ^ key[i])
		i_key_pad.append(0x36 ^ key[i])
	
	var inner := i_key_pad + signature_base.to_utf8_buffer()
	var inner_hash := SHA512.sha512(inner)
	
	var outer := o_key_pad + inner_hash
	var signature := SHA512.sha512(outer)
	
	return Marshalls.raw_to_base64(signature)


func generate_signature_request(body: PackedByteArray, timestamp: String) -> String:
	var hash_body := sha256(body)
	var hex_hash := hash_body.hex_encode().to_lower()
	var base_signature := "POST:/v1/token:%s:%s" % [hex_hash, timestamp]
	
	var payload := {
		"inputString" : base_signature,
		"secretKey" : SIGNATURE_SECRET,
		"algo" : "SHA-512",
		"outputFormat" : "Base64"
	}
	
	# TODO: SHA512 failed handling
	return await SHA512Request.sha512_base64(payload)


func sha256(data: PackedByteArray) -> PackedByteArray:
	var ctx := HashingContext.new()
	ctx.start(HashingContext.HASH_SHA256)
	ctx.update(data)
	return ctx.finish()

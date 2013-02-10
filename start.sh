#!/bin/sh
erl -sname websocket_erlang -pa ebin -pa deps/*/ebin -s nodehalla_websocket \
	-eval "io:format(\"~n~nRadi!:~n\")." \
	-eval "io:format(\"* Websockets: http://localhost:8080/websocket~n\")." \

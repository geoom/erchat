-module(nodehalla_websocket).
-behaviour(application).
-export([start/0, start/2, stop/1]).

start() ->
	application:start(gproc),
	application:start(cowboy),
	application:start(nodehalla_websocket).

start(_Type, _Args) ->
	Dispatch = [
		{'_', [
			{[<<"websocket">>], websocket_handler, []}
		]}
	],
	cowboy:start_listener(my_http_listener, 100,
		cowboy_tcp_transport, [{port, 8080}],
		cowboy_http_protocol, [{dispatch, Dispatch}]
	),
	nodehalla_websocket_sup:start_link().

stop(_State) ->
	ok.

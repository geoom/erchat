-module(websocket_handler).
-behaviour(cowboy_http_handler).
-behaviour(cowboy_http_websocket_handler).
-export([init/3, handle/2, terminate/2]).
-export([websocket_init/3, websocket_handle/3,
	websocket_info/3, websocket_terminate/3]).

-define(WSKey, ivan).

init({_Any, http}, Req, []) ->
    io:format("init:"),
	case cowboy_http_req:header('Upgrade', Req) of
		{undefined, Req2} -> {ok, Req2, undefined};
		{<<"websocket">>, _Req2} -> {upgrade, protocol, cowboy_http_websocket};
		{<<"WebSocket">>, _Req2} -> {upgrade, protocol, cowboy_http_websocket}
	end.

handle(Req, State) ->
    io:format("Handle:"),
	{ok, Req, State}.

terminate(_Req, _State) ->
	ok.


websocket_init(_Any, Req, []) ->
    io:format("we_init: ~p", [self()]),
	gproc:reg({p, l, ?WSKey}),
	%%self() ! tick,
	self() ! tack,
	Req2 = cowboy_http_req:compact(Req),
	{ok, Req2, undefined, hibernate}.

%% ove funkcije se pozivaciju kada server primi neku poruku od klijenta
websocket_handle({text, Msg}, Req, State) ->
	broadcastMessage(Msg),
	{ok, Req, State};
websocket_handle(_Any, Req, State) ->
	{ok, Req, State}.


%% ove funkcije se pozivaju u svrhu handlanja poruka koje su poslane od strane procesa unutar servera
websocket_info(tick, Req, State) ->
	{reply, {text, <<"prva poruka">>}, Req, State, hibernate};

websocket_info(tack, Req, State) ->
 	broadcastMessage("Novi korisnik se pridruzio\n"),
	{ok, Req, State, hibernate};

websocket_info(Info, Req, State) ->
    case Info of
        {_PID,?WSKey,Msg} ->
                {reply, {text, Msg}, Req, State, hibernate};
        _ -> 
                        {ok, Req, State, hibernate}
    end;

websocket_info(_Info, Req, State) ->
	{ok, Req, State, hibernate}.

broadcastMessage(Message)-> gproc:send({p, l, ?WSKey}, {self(), ?WSKey, Message}), 
							ok.

websocket_terminate(_Reason, _Req, _State) ->
	ok.

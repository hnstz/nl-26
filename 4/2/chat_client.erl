-module(chat_client).
-export([start/0, receive_loop/1]).

start() ->
    {ok, Socket} = gen_tcp:connect("127.0.0.1", 8080, [binary, {packet, 0}, {active, true}]),
    io:format("Успешное подключение! Вводите сообщения:~n"),
    Pid = spawn(fun() -> receive_loop(Socket) end),
    gen_tcp:controlling_process(Socket, Pid),
    input_loop(Socket).

input_loop(Socket) ->
    Line = io:get_line("> "),
    case Line of
        "exit\n" -> gen_tcp:close(Socket);
        eof -> gen_tcp:close(Socket);
        _ ->
            gen_tcp:send(Socket, list_to_binary(Line)),
            input_loop(Socket)
    end.

receive_loop(Socket) ->
    receive
        {tcp, Socket, Data} ->
            io:format("~n[Кто-то]: ~s> ", [Data]),
            receive_loop(Socket);
        {tcp_closed, Socket} ->
            io:format("~nСервер отключился.~n"),
            init:stop();
        {tcp_error, Socket, _} ->
            io:format("~nОшибка соединения.~n"),
            init:stop()
    end.
% erlc chat_server.erl chat_client.erl

% erl -noshell -s chat_server start

% erl -noshell -s chat_client start
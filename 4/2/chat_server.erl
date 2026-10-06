-module(chat_server).
-export([start/0, accept_loop/2, room_loop/1, client_handler/2]).

start() ->
    {ok, ListenSocket} = gen_tcp:listen(8080, [binary, {packet, 0}, {active, true}, {reuseaddr, true}]),
    io:format("Сервер запущен на порту 8080.~n"),
    RoomPid = spawn(fun() -> room_loop([]) end),
    accept_loop(ListenSocket, RoomPid).

accept_loop(ListenSocket, RoomPid) ->
    {ok, Socket} = gen_tcp:accept(ListenSocket),
    HandlerPid = spawn(fun() -> client_handler(Socket, RoomPid) end),
    gen_tcp:controlling_process(Socket, HandlerPid),
    RoomPid ! {join, Socket},
    accept_loop(ListenSocket, RoomPid).

room_loop(Sockets) ->
    receive
        {join, Socket} ->
            room_loop([Socket | Sockets]);
        {leave, Socket} ->
            room_loop(lists:delete(Socket, Sockets));
        {broadcast, SenderSocket, Data} ->
            lists:foreach(fun(S) ->
                if S =/= SenderSocket -> gen_tcp:send(S, Data);
                   true -> ok
                end
            end, Sockets),
            room_loop(Sockets)
    end.

client_handler(Socket, RoomPid) ->
    receive
        {tcp, Socket, Data} ->
            RoomPid ! {broadcast, Socket, Data},
            client_handler(Socket, RoomPid);
        {tcp_closed, Socket} ->
            RoomPid ! {leave, Socket};
        {tcp_error, Socket, _Reason} ->
            RoomPid ! {leave, Socket}
    end.
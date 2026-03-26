-module(server).
-export([start/0, stop/0]).
-include("user.hrl").

start() ->
    register(?MODULE, spawn(fun() -> init() end)).

stop() ->
    ?MODULE ! stop.

init() ->
    process_flag(trap_exit, true),
    io:format("Server starts and waits for messages.~n"),
    loop([]).

loop(List) ->
    receive
        {join, Username, Pid} ->
            case check_if_user_exists(Username, List) of
                true ->
                    Pid ! {error, "Username already taken. Please choose another one."},
                    loop(List);
                false ->
                    io:format("User ~s joins.~n", [Username]),
                    link(Pid),
                    NewUser = #user{name = Username, pid = Pid},
                    notify_all(List, {info, Username, "has joined the room"}),
                    Pid ! ack,
                    loop([NewUser | List])
            end;
        
        {send_message, Pid, Username, Message} ->
            case check_if_user_exists(Username, List) of
                true ->
                    notify_all(List, Pid, {message, Username, Message}),
                    loop(List);
                false ->
                    io:format("User ~s doesn't exist.~n", [Username]),
                    loop(List)
            end;
        
        {leave, Pid} ->
            case remove_user_by_pid(Pid, List, []) of
                {not_found, List} ->
                    loop(List);
                {removed, RemovedUser, NewList} ->
                    notify_all(NewList, {info, RemovedUser#user.name, "has disconnected"}),
                    loop(NewList)
            end;

        {'EXIT', Pid, _Reason} ->
            case remove_user_by_pid(Pid, List, []) of
                {not_found, List} ->
                    loop(List);
                {removed, RemovedUser, NewList} ->
                    notify_all(NewList, {info, RemovedUser#user.name, "has disconnected"}),
                    loop(NewList)
            end;

        stop ->
            io:format("Server has stopped and no longer accepts messages.~n")
    end.

check_if_user_exists(_, []) ->
    false;
check_if_user_exists(Username, [#user{name = Username}| _]) ->
    true;
check_if_user_exists(Username, [_ | Tail]) ->
    check_if_user_exists(Username, Tail).

notify_all([], _) ->
    ok;
notify_all([#user{pid = Pid} | Tail], Message) ->
    Pid ! Message,
    notify_all(Tail, Message).

notify_all([], _, _) ->
    ok;
notify_all([#user{pid = PidExclude} | Tail], PidExclude, Message) ->
    notify_all(Tail, PidExclude, Message);
notify_all([#user{pid = UsersPid} | Tail], PidExclude, Message) ->
    UsersPid ! Message,
    notify_all(Tail, PidExclude, Message).

remove_user_by_pid(_, [], List) ->
    {not_found, lists:reverse(List)};
remove_user_by_pid(Pid, [#user{pid = Pid} = User | Tail], List) ->
    {removed, User, lists:reverse(List) ++ Tail};
remove_user_by_pid(Pid, [Head | Tail], List) ->
    remove_user_by_pid(Pid, Tail, [Head | List]).
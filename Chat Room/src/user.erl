-module(user).
-export([join/1, send_message/2, leave/1]).

join(Username) ->
    spawn(fun() -> init(Username) end).

init(Username) ->
    io:format("User ~s joins.~n", [Username]),
    server ! {join, Username, self()},
    loop(Username).

loop(Username) ->
    receive
        ack ->
            loop(Username);

        {error, Reason} ->
            io:format("Join failed for User ~s: ~s~n", [Username, Reason]);

        {info, User, Text} ->
            io:format("Server tells User ~s: \"User ~s ~s.\"~n", [Username, User, Text]),
            loop(Username);

        {message, _, Text} ->
            io:format("Server sends \"~s\" to User ~s.~n", [Text, Username]),
            loop(Username);

        {send, Text} ->
            io:format("User ~s sends: \"~s\"~n", [Username, Text]),
            server ! {send_message, self(), Username, Text},
            loop(Username);

        leave ->
            io:format("User ~s crashes/exits.~n", [Username]),
            server ! {leave, self()},
            exit(normal)
    end.

send_message(Pid, Text) ->
    Pid ! {send, Text}.

leave(Pid) ->
    Pid ! leave.
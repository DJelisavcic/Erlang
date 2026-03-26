-module(user).
-export([join/1, send_message/2, leave/1]).

join(Username) ->
    spawn(fun() -> init(Username) end).

init(Username) ->
    server ! {join, Username, self()},
    loop(Username).

loop(Username) ->
    receive
        ack ->
            loop(Username);

        {error, Reason} ->
            io:format("Join failed for User ~s: ~s~n", [Username, Reason]);

        {info, User, Message} ->
            io:format("Server tells User ~s: \"User ~s ~s.\"~n", [Username, User, Message]),
            loop(Username);

        {message, _, Message} ->
            io:format("Server sends \"~s\" to User ~s.~n", [Message, Username]),
            loop(Username);

        {send, Message} ->
            io:format("User ~s sends: \"~s\"~n", [Username, Message]),
            server ! {send_message, self(), Username, Message},
            loop(Username);

        leave ->
            io:format("User ~s crashes/exits.~n", [Username]),
            server ! {leave, self()},
            exit(normal)
    end.

send_message(Pid, Message) ->
    Pid ! {send, Message}.

leave(Pid) ->
    Pid ! leave.
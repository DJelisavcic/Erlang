-module(cli).
-export([run/0]).

run() ->
    List = db:createDB(),
    showMenu(List).

showMenu(List) ->
    io:format("--------------------------------------------------------------------~n"),
    io:format("Menu:~n"),
    io:format("1) View All:~n"),
    io:format("2) Filter~n"),
    io:format("3) Stats~n"),
    io:format("4) Dispatch~n"),
    io:format("5) Exit~n"),

    {ok, [Option]} = io:fread("", "~d"),
    showMenu(Option, List).


showMenu(1, List) ->
    logic:viewAll(List),
    showMenu(List);
showMenu(2, List) ->
    io:format("Not implemented~n"),
    showMenu(List);
showMenu(3, List) ->
    io:format("Not implemented~n"),
    showMenu(List);
showMenu(4, List) ->
    io:format("Not implemented~n"),
    showMenu(List);
showMenu(5, _) ->
    io:format("Exiting app~n");
showMenu(_, List) ->
    io:format("Invalid option~n"),
    showMenu(List).


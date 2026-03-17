-module(cli).
-export([run/0]).

run() ->
    List = db:createDB(),
    showMenu(List).

showMenu(List) ->
    io:format("--------------------------------------------------------------------~n"),
    io:format("Menu:~n"),
    io:format("1) View All:~n"),
    io:format("2) Filter By City~n"),
    io:format("3) Stats~n"),
    io:format("4) Dispatch~n"),
    io:format("5) Exit~n"),
    
    case io:fread("", "~d") of
    {ok, [Option]} ->
        showMenu(Option, List);
    {error, _} ->
        io:format("Invalid input! Please enter a number.~n"),
        showMenu(List)
end.

showMenu(1, List) ->
    logic:viewAll(List),
    showMenu(List);
showMenu(2, List) ->
    logic:filterByDestination(List),
    showMenu(List);
showMenu(3, List) ->
    try logic:getStats(List)
    catch
        throw:irregular_weight ->
            io:format("Error: Irregular weight value in DB~n")
    end,
    showMenu(List);
showMenu(4, List) ->
    NewList = logic:dispatchAll(List),
    showMenu(NewList);
showMenu(5, _) ->
    io:format("Exiting app~n");
showMenu(_, List) ->
    io:format("Invalid option~n"),
    showMenu(List).


-module(cli).
-export([run/0]).

run() ->
    List = db:create_db(),
    show_menu(List).

show_menu(List) ->
    % io:format("--------------------------------------------------------------------~n"),
    % io:format("Menu:~n"),
    % io:format("1) View all:~n"),
    % io:format("2) Filter by city~n"),
    % io:format("3) Stats~n"),
    % io:format("4) Dispatch~n"),
    % io:format("5) Add shipment~n"),
    % io:format("6) Update shipment status~n"),
    % io:format("7) Delete shipment~n"),
    % io:format("8) Delete all shipments~n"),
    % io:format("9) Exit~n"),
    io:format("~n 1. View All | 2. Filter | 3. Stats | 4. Dispatch | 5. Add Shipment | 6. Update Shipment Status | 7. Delete Shipment | 8. Delete All | 9. Exit~n"),
    io:format("Selection > "),
    
    case io:fread("", "~d") of
        {ok, [Option]} ->
            show_menu(Option, List);
        {error, _} ->
            io:format("Invalid input! Please enter a number.~n"),
            show_menu(List)
    end.

show_menu(1, List) ->
    logic:view_all(List),
    show_menu(List);
show_menu(2, List) ->
    logic:filter_by_destination(List),
    show_menu(List);
show_menu(3, List) ->
    try logic:get_stats(List)
    catch
        throw:irregular_weight ->
            io:format("Error: Irregular weight value in DB~n")
    end,
    show_menu(List);
show_menu(4, List) ->
    show_menu(logic:dispatch_all(List));
show_menu(5, List) ->
    show_menu(model:add_shipment(List));
show_menu(6, List) ->
    show_menu(model:update_shipment_status(List));
show_menu(7, List) ->
    show_menu(model:delete_shipment(List));
show_menu(8, List) ->
    show_menu(model:delete_all(List));
show_menu(9, _) ->
    io:format("Exiting app~n");
show_menu(_, List) ->
    io:format("Invalid option~n"),
    show_menu(List).


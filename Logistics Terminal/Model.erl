-module(model).
-export([add_shipment/1, delete_all/1, delete_shipment/1, update_shipment_status/1]).


add_shipment(List) ->
    Weight = get_weight(List),
    Destination = get_destination(List),
    if 
        List == [] ->
            lists:append(List, [{shipment, 1, Weight, Destination, pending}]);
        List =/= [] ->
            {_,ID,_,_,_} = lists:last(List),
            lists:append(List, [{shipment, ID + 1, Weight, Destination, pending}])
    end.

get_weight(List) ->
    io:format("Enter weight: ~n"),
    case io:fread("", "~d") of
        {ok, [Weight]} ->
            if 
                Weight > 0 ->
                    Weight;
                Weight =< 0 ->
                    io:format("Invalid input! Please enter weight larger than 0.~n"),
                    get_weight(List)
            end;        
        {error, _} ->
            io:format("Invalid input! Please enter a number.~n"),
            get_weight(List)
    end.


get_destination(List)->
    City = string:trim(io:get_line("Enter city:")),
    case logic:valid_city(City) of
        true ->
            City;
        false ->
            io:format("Invalid city name. Use only alphabet letters. ~n"),
            get_destination(List)
    end.


delete_all(List) ->
    if 
        List == [] ->
            io:format("Nothing to delete. Database is empty.~n"),
            [];
        List =/= [] ->
            io:format("Action: Deleting all shipments.~n"),
            delete_all(List, [])
    end.

delete_all([], _)->
    [];
delete_all(List, _)->
    delete_all(lists:droplast(List), []).


delete_shipment([])->
    io:format("Nothing to delete. Database is empty.~n"),
    []; 
delete_shipment(List)->
    io:format("Action: Deleting shipment by ID:~n"),
    ID = get_id(List),
    lists:keydelete(ID, 2, List).

get_id(List)->
    io:format("Enter ID for shipment:~n"),
    case io:fread("", "~d") of
        {ok, [ID]} ->
            if 
                ID > 0 ->
                    ID;
                ID =< 0 ->
                    io:format("Invalid input! Please enter number larger than 0.~n"),
                    get_id(List)
            end;
        {error, _} ->
            io:format("Invalid input! Please enter a number.~n"),
            get_id(List)
    end.


update_shipment_status([]) ->
    io:format("Nothing to update. Database is empty.~n"),
    [];
update_shipment_status(List) ->
    ID = get_id(List),
    NewList = lists:keyfind(ID, 2, List),
    if 
        NewList == false ->
            io:format("Shipment with entered ID doesn't exist!~n"),
            List;
        true->
            Status0 = string:trim(io:get_line("Choose new status for shipment: pending | in_transit | delivered  ")),
            Status = string:to_lower(Status0),

            if 
                (Status == "pending") orelse 
                (Status == "in_transit") orelse 
                (Status == "delivered") -> 
                    {_,_,Weight, Destination, _} = NewList,
                    lists:keyreplace(ID, 2, List, {shipment, ID, Weight, Destination, list_to_atom(Status)});
                true ->
                    io:format("Invalid input! Please choose valid status.~n"),
                    update_shipment_status(List)
            end
    end.


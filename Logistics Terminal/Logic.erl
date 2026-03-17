-module(logic).
-export([view_all/1, filter_by_destination/1, dispatch_all/1, get_stats/1, valid_city/1]).

view_all(List) ->
     if 
        List == [] ->
            io:format("Database is empty.~n");
        List =/= [] ->
            io:format("Action: Display all shipments.~n"),
            view_all(List, [])
    end.

view_all([], _) ->
    io:format("~n");
view_all([Head|Tail], _) ->
    {_,Id, Weight, Destination, Status} = Head,
    io:format("--------------------------------------------------------------------~n"),
    io:format("Shipment ID: ~p~n",[Id]),
    io:format("Shipment weight in kg: ~p~n",[Weight]),
    io:format("Shipment destination: ~p~n",[Destination]),
    io:format("Shipment status: ~p~n",[Status]),
    view_all(Tail, []).


valid_city(City)->
    lists:all(fun(C) -> 
        (C >= $A andalso C =< $Z) 
        orelse (C >= $a andalso C =< $z) 
        orelse C == $\s end, City
    ).

filter_by_destination(List)->
     if 
        List == [] ->
            io:format("Database is empty.~n");
        List =/= [] ->
            City = string:trim(io:get_line("Enter city:")),
            case valid_city(City) of
                true ->
                    filter_by_destination(List,string:to_lower(City));
                false ->
                    io:format("Invalid city name. Use only alphabet letters~n"),
                    filter_by_destination(List)
            end       
    end.
   
    
filter_by_destination([], _) ->
    io:format("~n");
filter_by_destination([{_,Id, Weight, Destination, Status}|Tail], DestinationFilter) ->
    LowerCaseDestination = string:to_lower(Destination),
    case LowerCaseDestination == DestinationFilter of
        true ->
            io:format("--------------------------------------------------------------------~n"),
            io:format("Shipment ID: ~p~n",[Id]),
            io:format("Shipment weight in kg: ~p~n",[Weight]),
            io:format("Shipment destination: ~p~n",[Destination]),
            io:format("Shipment status: ~p~n",[Status]),
            filter_by_destination(Tail, DestinationFilter);
        false ->
            filter_by_destination(Tail, DestinationFilter)
        end;
filter_by_destination([_|Tail], DestinationFilter) ->
    filter_by_destination(Tail, DestinationFilter).

    
dispatch_all(List)->
    if 
        List == [] ->
            io:format("Database is empty.~n"),
            [];
        List =/= [] ->
            io:format("Action: All pending shipments moved to 'in_transit'.~n"),
            dispatch_all(List, [])
    end.
    

dispatch_all([], Dispatched)->
    lists:reverse(Dispatched);
dispatch_all([{Shipment,Id, Weight, Destination, Status}|Tail], Dispatched) when Status == pending ->
    NewHead = {Shipment, Id, Weight, Destination, in_transit},
    dispatch_all(Tail, [NewHead|Dispatched]);
dispatch_all([Head|Tail], Dispatched) ->
    dispatch_all(Tail, [Head|Dispatched]).

 
 get_stats(List) ->
    calculate_total_pending_weight(List, 0),
    count_shipments_currently_delivered(List, 0).

calculate_total_pending_weight([], Sum) ->
    io:format("Stats: Total pending weight: ~pkg | ",[Sum]);
calculate_total_pending_weight([{_,_, Weight, _, Status}|Tail], Sum) when Status == pending ->
    if 
        Weight >0 -> 
            calculate_total_pending_weight(Tail, Sum + Weight);
        Weight =< 0 ->
            throw(irregular_weight)
    end;
calculate_total_pending_weight([_|Tail], Sum)->
    calculate_total_pending_weight(Tail, Sum).

count_shipments_currently_delivered([], Count)->
    io:format("Total Delivered: ~p~n",[Count]);
count_shipments_currently_delivered([{_,_,_,_, Status}|Tail], Count) when Status == delivered ->
    count_shipments_currently_delivered(Tail, Count + 1);
count_shipments_currently_delivered([_|Tail], Count) ->
    count_shipments_currently_delivered(Tail, Count).
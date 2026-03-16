-module(logic).
-export([viewAll/1, filterByDestination/1, dispatchAll/1, getStats/1]).

viewAll([]) ->
    io:format("~n");
viewAll([Head|Tail]) ->
    {_,Id, Weight, Destination, Status} = Head,
    io:format("--------------------------------------------------------------------~n"),
    io:format("Shipment ID: ~p~n",[Id]),
    io:format("Shipment Weight in KG: ~p~n",[Weight]),
    io:format("Shipment Destination: ~p~n",[Destination]),
    io:format("Shipment Status: ~p~n",[Status]),
    viewAll(Tail).

validCity(City)->
    lists:all(fun(C) -> 
        (C >= $A andalso C =< $Z) 
        orelse (C >= $a andalso C =< $z) 
        orelse C == $ end, City
    ).

filterByDestination(List)->
    City = string:trim(io:get_line("Enter city:")),
    case validCity(City) of
        true ->
            filterByDestination(List,string:lowercase(City));
        false ->
            io:format("Invalid city name. Use only alphabet letters~n"),
            filterByDestination(List)
        end.
    

filterByDestination([], _) ->
    io:format("~n");
filterByDestination([{_,Id, Weight, Destination, Status}|Tail], DestinationFilter) ->
    LowerCaseDestination = string:lowercase(Destination),
    case LowerCaseDestination == DestinationFilter of
        true ->
            io:format("--------------------------------------------------------------------~n"),
            io:format("Shipment ID: ~p~n",[Id]),
            io:format("Shipment Weight in KG: ~p~n",[Weight]),
            io:format("Shipment Destination: ~p~n",[Destination]),
            io:format("Shipment Status: ~p~n",[Status]),
            filterByDestination(Tail, DestinationFilter);
        false ->
            filterByDestination(Tail, DestinationFilter)
        end;
filterByDestination([_|Tail], DestinationFilter) ->
    filterByDestination(Tail, DestinationFilter).


dispatchAll(List)->
    dispatchAll(List, []).
dispatchAll([], Dispatched)->
    lists:reverse(Dispatched);
dispatchAll([{Shipment,Id, Weight, Destination, Status}|Tail], Dispatched) when Status == pending ->
    NewHead = {Shipment, Id, Weight, Destination, in_transit},
    dispatchAll(Tail, [NewHead|Dispatched]);
dispatchAll([_Head|Tail], Dispatched) ->
    dispatchAll(Tail, [_Head|Dispatched]).

 getStats(List) ->
    calculateTotalPendingWeight(List, 0),
    countShipmentsCurrentlyDelivered(List, 0).

calculateTotalPendingWeight([], Sum) ->
    io:format("Total sum of all pending shipments: ~p~n",[Sum]);
calculateTotalPendingWeight([{_,Id, Weight, Destination, Status}|Tail], Sum) when Status == pending ->
    if 
        Weight >=0 -> 
            calculateTotalPendingWeight(Tail, Sum + Weight);
        Weight < 0 ->
            error("Irregular Weight value in DB")
    end;
calculateTotalPendingWeight([_|Tail], Sum)->
    calculateTotalPendingWeight(Tail, Sum).

countShipmentsCurrentlyDelivered([], Count)->
    io:format("Number of shipments being delivered: ~p~n",[Count]);
countShipmentsCurrentlyDelivered([{_,Id, Weight, Destination, Status}|Tail], Count) when Status == delivered ->
    countShipmentsCurrentlyDelivered(Tail, Count + 1);
countShipmentsCurrentlyDelivered([_|Tail], Count) ->
    countShipmentsCurrentlyDelivered(Tail, Count).
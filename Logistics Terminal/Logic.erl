-module(logic).
-export([viewAll/1]).

viewAll(List)->
    viewAllHelper(List).

viewAllHelper([]) ->
    io:format("~n");
viewAllHelper([Head|Tail]) ->
    {_,Id, Weight, Destination, Status} = Head,
    io:format("--------------------------------------------------------------------~n"),
    io:format("Shipment ID: ~p~n",[Id]),
    io:format("Shipment Weight in KG: ~p~n",[Weight]),
    io:format("Shipment Destination: ~p~n",[Destination]),
    io:format("Shipment Status: ~p~n",[Status]),
    viewAll(Tail).
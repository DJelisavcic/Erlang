-module(db).
-export([createDB/0]).

createDB() ->
    List = [
        %shipment, ID, Weight in Kg, Destination, Shipment status
        {shipment, 1, 1230.7, "Belgrade", pending},
        {shipment, 2, 8200.2, "Novi Sad", in_transit},
        {shipment, 3, 15000.3, "Nis", delivered},
        {shipment, 4, 6700, "Kragujevac", pending},
        {shipment, 5, 2000.3, "Subotica", in_transit},
        {shipment, 6, 4000.9, "Zrenjanin", delivered},
        {shipment, 7, 900, "Pancevo", pending},
        {shipment, 8, 7000.4, "Leskovac", delivered},
        {shipment, 9, 11111.1, "Uzice", pending},
        {shipment, 10, 1300.8, "Belgrade", in_transit}
    ].

        % {shipment, 1, 1230.7, "Belgrade", pending},
        % {shipment, 2, 8200.2, "Novi Sad", in_transit},
        % {shipment, 3, 15000.3, "Nis", delivered},
        % {shipment, 4, 6700, "Kragujevac", pending},
        % {shipment, 5, 2000.3, "Subotica", in_transit},
        % {shipment, 6, 4000.9, "Zrenjanin", delivered},
        % {shipment, 7, 900, "Pancevo", pending},
        % {shipment, 8, 7000.4, "Leskovac", delivered},
        % {shipment, 9, 11111.1, "Uzice", pending},
        % {shipment, 10, 1300.8, "Belgrade", in_transit}
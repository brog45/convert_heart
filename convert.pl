:- use_module(library(http/json)).

kgs_to_lbs(Kgs, Lbs) :-
    Lbs is Kgs * 2.205.

stamp_to_date(Stamp, Date) :-
    stamp_date_time(Stamp, DateTime, local),
    DateTime =.. [date, Year, Month, Day|_],
    Date = Year-Month-Day.

file_json(File, JsonDict) :-
    setup_call_cleanup(open(File, read, Fd, []),
        json_read_dict(Fd, JsonDict), 
        close(Fd)).

file_weights(File, Weights) :-
    file_json(File, JsonDict),
    JsonDict >:< _{ data_weight: Weights }.

mapweight(Old, weight{ date: Date, weight: Lbs }) :-
    Old >:< _{ datetime: DateTime, value: Kgs },
    kgs_to_lbs(Kgs, Lbs),
    stamp_to_date(DateTime, Date).

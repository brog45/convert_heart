:- use_module(library(http/json)).

kgs_to_lbs(Kgs, Lbs) :-
    Lbs is Kgs * 2.205.

heartdatetime_to_date(HeartDateTime, Date) :-
    Stamp is HeartDateTime / 1000,
    stamp_date_time(Stamp, DateTime, local),
    format_time(atom(Date), '%Y-%m-%d', DateTime).

file_json(File, JsonDict) :-
    setup_call_cleanup(open(File, read, Fd, []),
        json_read_dict(Fd, JsonDict), 
        close(Fd)).

convert_weight(Old, weight{ date: Date, weight: Lbs }) :-
    Old >:< _{ datetime: DateTime, value: Kgs },
    kgs_to_lbs(Kgs, Lbs),
    heartdatetime_to_date(DateTime, Date).

file_row(_, row('Date', 'Weight')).
file_row(File, row(Date, Lbs)) :-
    file_json(File, JsonDict), 
    !, JsonDict >:< _{ data_weight: OldWeights },
    member(W1, OldWeights),
    convert_weight(W1, W2),
    W2 >:< weight{ date: Date, weight: Lbs }.

convert_backup() :-
    setup_call_cleanup(open('weight.csv', write, Out),
        forall(file_row('heart_backup.dat', Row),
               csv_write_stream(Out, [Row], [])),
        close(Out)).

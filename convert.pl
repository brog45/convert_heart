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

convert_weight(Old, row(Date, Lbs)) :-
    Old >:< _{ datetime: DateTime, value: Kgs },
    kgs_to_lbs(Kgs, Lbs),
    heartdatetime_to_date(DateTime, Date).

json_weight(_, row('Date', 'Weight')).
json_weight(JsonDict, row(Date, Lbs)) :-
    JsonDict >:< _{ data_weight: OldWeights },
    member(W1, OldWeights),
    convert_weight(W1, row(Date, Lbs)).

export_weights(JsonDict) :-
    setup_call_cleanup(open('weight.csv', write, Fd),
        forall(json_weight(JsonDict, Row),
               csv_write_stream(Fd, [Row], [])),
        close(Fd)).

json_bp(_, row('Date', 'Systolic', 'Diastolic', 'Rate', 'Comment')).
json_bp(JsonDict, row(Date, Systolic, Diastolic, Rate, Comment)) :-
    JsonDict >:< _{ data_bp: BPs },
    member(BP, BPs),
    BP >:< _{ datetime: DateTime, sys: Systolic, dia: Diastolic, rate: Rate, comment: Comment },
    heartdatetime_to_date(DateTime, Date).

export_bps(JsonDict) :-
    setup_call_cleanup(open('blood_pressure.csv', write, Fd),
        forall(json_bp(JsonDict, Row),
               csv_write_stream(Fd, [Row], [])),
        close(Fd)).

convert_backup :-
    file_json('heart_backup.dat', JsonDict),
    export_weights(JsonDict),
    export_bps(JsonDict).

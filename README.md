# heart_convert

> Extract blood pressure and weight data from the `heart_backup.dat` file.

The Android app "Heart" (or was it "Heart Mint?") by now-defunct [3qubits](https://github.com/3qubits) was a nice, simple app for tracking health data. Unfortunately, after several years, it has stopped graphing my data. I don't want to lose several years of data, so I wrote this Prolog program to read extract and convert the data I want to CSV format.

## Prerequisites

This code was written for [SWI-Prolog](https://www.swi-prolog.org) version 7.7.15. It should work with more recent versions, but it uses dicts, a SWI-Prolog extension introduced in version 7.

## Usage

Use SWI-Prolog to consult `convert.pl` and query the goal `convert_backup`. Here's what that looks like from the command-line:

```sh
$ dir
total 64
-rw-rw-r-- 1 brog45 brog45  1599 Aug 15 19:19 convert.pl
-rw-rw-r-- 1 brog45 brog45 54743 Aug 13 20:44 heart_backup.dat
-rw-rw-r-- 1 brog45 brog45   602 Aug 16 18:00 README.md
$ swipl -s convert.pl -g convert_backup -g halt
$ dir
total 76
-rw-rw-r-- 1 brog45 brog45  1431 Aug 16 18:02 blood_pressure.csv
-rw-rw-r-- 1 brog45 brog45  1599 Aug 15 19:19 convert.pl
-rw-rw-r-- 1 brog45 brog45 54743 Aug 13 20:44 heart_backup.dat
-rw-rw-r-- 1 brog45 brog45   602 Aug 16 18:00 README.md
-rw-rw-r-- 1 brog45 brog45  7898 Aug 16 18:02 weight.csv
$
```

Here's what that looks like in an interactive Prolog session:

```sh
$ dir
total 64
-rw-rw-r-- 1 brog45 brog45  1599 Aug 15 19:19 convert.pl
-rw-rw-r-- 1 brog45 brog45 54743 Aug 13 20:44 heart_backup.dat
-rw-rw-r-- 1 brog45 brog45   602 Aug 16 18:00 README.md
$ swipl -q
?- [convert].
true.

?- convert_backup.
true.

?- halt.
$ dir
total 76
-rw-rw-r-- 1 brog45 brog45  1431 Aug 16 18:07 blood_pressure.csv
-rw-rw-r-- 1 brog45 brog45  1599 Aug 15 19:19 convert.pl
-rw-rw-r-- 1 brog45 brog45 54743 Aug 13 20:44 heart_backup.dat
-rw-rw-r-- 1 brog45 brog45   602 Aug 16 18:00 README.md
-rw-rw-r-- 1 brog45 brog45  7898 Aug 16 18:07 weight.csv
$ 
```

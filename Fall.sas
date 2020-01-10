proc import datafile = 'C:/スポトロジーSAS/1年目追跡データ.xlsx'
out = year1
dbms = xlsx
replace;
run;

data fall1;
set year1 (keep=subjid visitdat aeyn_fall aefact_fall aefact_walk aefact_room aefact_sports aefact_other aedat_fall);
aeyn_fall1=input(aeyn_fall, best.); drop aeyn_fall;
aefact_walk1=input(aefact_walk, best.); drop aefact_walk;
aefact_room1=input(aefact_room, best.); drop aefact_room;
aefact_sports1=input(aefact_sports, best.); drop aefact_sports;
aefact_other1=input(aefact_other, best.); drop aefact_other;
rename aeyn_fall1=aeyn_fall aefact_walk1=aefact_walk aefact_room1=aefact_room aefact_sports1=aefact_sports aefact_other1=aefact_other;
format visitdat yymmdds10.;
where subjid ^= . and aefact_fall ^= '';
run;

proc import datafile = 'C:/スポトロジーSAS/2年目追跡データ.xlsx'
out = year2
dbms = xlsx
replace;
run;

data fall2;
set year2 (keep=subjid visitdat aeyn_fall aefact_fall aefact_walk aefact_room aefact_sports aefact_other aedat_fall);
aeyn_fall1=input(aeyn_fall, best.); drop aeyn_fall;
aefact_walk1=input(aefact_walk, best.); drop aefact_walk;
aefact_room1=input(aefact_room, best.); drop aefact_room;
aefact_sports1=input(aefact_sports, best.); drop aefact_sports;
aefact_other1=input(aefact_other, best.); drop aefact_other;
rename aeyn_fall1=aeyn_fall aefact_walk1=aefact_walk aefact_room1=aefact_room aefact_sports1=aefact_sports aefact_other1=aefact_other;
format visitdat yymmdds10.;
where subjid ^= . and aefact_fall ^= '';
run;

proc import datafile = 'C:/スポトロジーSAS/3年目追跡データ.xlsx'
out = year3
dbms = xlsx
replace;
run;

data fall3;
set year3 (keep=subjid visitdat aeyn_fall aefact_fall aefact_walk aefact_room aefact_sports aefact_other aedat_fall);
aeyn_fall1=input(aeyn_fall, best.); drop aeyn_fall;
aefact_walk1=input(aefact_walk, best.); drop aefact_walk;
aefact_room1=input(aefact_room, best.); drop aefact_room;
aefact_sports1=input(aefact_sports, best.); drop aefact_sports;
aefact_other1=input(aefact_other, best.); drop aefact_other;
rename aeyn_fall1=aeyn_fall aefact_walk1=aefact_walk aefact_room1=aefact_room aefact_sports1=aefact_sports aefact_other1=aefact_other;
format visitdat yymmdds10.;
where subjid ^= . and aefact_fall ^= '';
run;

data fall123;
format aefact_fall $char100. aedat_fall $char100.;
set fall1 fall2 fall3;
run;

proc sort data=fall123;
by subjid visitdat;
run;

data fall123;
set fall123;
by subjid;
if first.subjid then num=0;
num+1;
run;

data fall123 (rename=(num=aenum_fall));
retain subjid visitdat num aeyn_fall aefact_fall aefact_walk aefact_room aefact_sports aefact_other aedat_fall;
set fall123;
run;

filename export "C:/スポトロジーSAS/Fall.csv" encoding="utf-8";
proc export
  data=fall123
  dbms=csv
  outfile=export
  replace;
run;

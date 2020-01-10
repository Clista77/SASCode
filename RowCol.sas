proc import datafile = 'C:/スポトロジーSAS/1年目追跡データ.xlsx'
out = year1
dbms = xlsx
replace;
getnames=yes;
datarow=4;
run;

data year1a (rename=(how=pehow_1w time=petim_1w));
set year1 (keep=subjid visitdat visitnotdone petype_1w pehow_1w petim_1w);
how = input(pehow_1w, best.); drop pehow_1w;
time = input(petim_1w, best.); drop petim_1w;
format visitdat yymmdds10.;
where petype_1w ^= '';
run;

data year1b (rename=(petype_1w_1=petype_1w how=pehow_1w time=petim_1w));
set year1 (keep=subjid visitdat visitnotdone petype_1w_1 pehow_1w_1 petim_1w_1);
how = input(pehow_1w_1, best.); drop pehow_1w_1;
time = input(petim_1w_1, best.); drop petim_1w_1;
format visitdat yymmdds10.;
where petype_1w_1 ^= '';
run;

data year1c (rename=(petype_1w_2=petype_1w how=pehow_1w time=petim_1w));
set year1 (keep=subjid visitdat visitnotdone petype_1w_2 pehow_1w_2 petim_1w_2);
how = input(pehow_1w_2, best.); drop pehow_1w_2;
time = input(petim_1w_2, best.); drop petim_1w_2;
format visitdat yymmdds10.;
where petype_1w_2 ^= '';
run;

data year1abc;
set year1a year1b year1c;
run;

proc import datafile = 'C:/スポトロジーSAS/2年目追跡データ.xlsx'
out = year2
dbms = xlsx
replace;
getnames=yes;
datarow=4;
run;

data year2a (rename=(how=pehow_1w time=petim_1w));
set year2 (keep=subjid visitdat visitnotdone petype_1w pehow_1w petim_1w);
how = input(pehow_1w, best.); drop pehow_1w;
time = input(petim_1w, best.); drop petim_1w;
format visitdat yymmdds10.;
where petype_1w ^= '';
run;

data year2b (rename=(petype_1w_1=petype_1w how=pehow_1w time=petim_1w));
set year2 (keep=subjid visitdat visitnotdone petype_1w_1 pehow_1w_1 petim_1w_1);
how = input(pehow_1w_1, best.); drop pehow_1w_1;
time = input(petim_1w_1, best.); drop petim_1w_1;
format visitdat yymmdds10.;
where petype_1w_1 ^= '';
run;

data year2c (rename=(petype_1w_2=petype_1w how=pehow_1w time=petim_1w));
set year2 (keep=subjid visitdat visitnotdone petype_1w_2 pehow_1w_2 petim_1w_2);
how = input(pehow_1w_2, best.); drop pehow_1w_2;
time = input(petim_1w_2, best.); drop petim_1w_2;
format visitdat yymmdds10.;
where petype_1w_2 ^= '';
run;

data year2abc;
set year2a year2b year2c;
run;

proc import datafile = 'C:/スポトロジーSAS/3年目追跡データ.xlsx'
out = year3
dbms = xlsx
replace;
getnames=yes;
datarow=4;
run;

data year3a (rename=(how=pehow_1w time=petim_1w));
set year3 (keep=subjid visitdat visitnotdone petype_1w pehow_1w petim_1w);
how = input(pehow_1w, best.); drop pehow_1w;
time = input(petim_1w, best.); drop petim_1w;
format visitdat yymmdds10.;
where petype_1w ^= '';
run;

data year3b (rename=(petype_1w_1=petype_1w how=pehow_1w time=petim_1w));
set year3 (keep=subjid visitdat visitnotdone petype_1w_1 pehow_1w_1 petim_1w_1);
how = input(pehow_1w_1, best.); drop pehow_1w_1;
time = input(petim_1w_1, best.); drop petim_1w_1;
format visitdat yymmdds10.;
where petype_1w_1 ^= '';
run;

data year3c (rename=(petype_1w_2=petype_1w how=pehow_1w time=petim_1w));
set year3 (keep=subjid visitdat visitnotdone petype_1w_2 pehow_1w_2 petim_1w_2);
how = input(pehow_1w_2, best.); drop pehow_1w_2;
time = input(petim_1w_2, best.); drop petim_1w_2;
format visitdat yymmdds10.;
where petype_1w_2 ^= '';
run;

data year3abc;
set year3a year3b year3c;
run;

proc sort data=year1abc;
by subjid visitdat;
run;

proc sort data=year2abc;
by subjid visitdat;
run;

proc sort data=year3abc;
by subjid visitdat;
run;

data year123abc;
set year1abc year2abc year3abc;
by subjid;
if first.subjid then num=0;
num+1;
run;

data year123abc (rename=(num=penum_mets));
format subjid visitdat visitnotdone num petype_1w pehow_1w petim_1w;
set year123abc;
run;

filename ex "C:/スポトロジーSAS/追跡データ.csv" encoding="utf-8";
proc export 
  data=year123abc
  dbms=csv
  outfile=ex
  replace;
run;

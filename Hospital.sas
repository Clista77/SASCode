proc import datafile = 'C:/スポトロジーSAS/1年目追跡データ.xlsx'
out = year1
dbms = xlsx
replace;
run;

data hospital1;
set year1 (keep=subjid visitdat saeyn_hosptal saefact_hospital saefact_01 saefact_02 saefact_03 saefact_04 saefact_05 saefact_06 saefact_07	saefact_08	saefact_09	saefact_10	saefact_other	saedat_hospital);
saeyn_hosptal1=input(saeyn_hosptal, best.); drop saeyn_hosptal;
rename saeyn_hosptal1=saeyn_hosptal;
format visitdat yymmdds10.;
where subjid ^= . and saefact_hospital ^= '';
run;

proc import datafile = 'C:/スポトロジーSAS/2年目追跡データ.xlsx'
out = year2
dbms = xlsx
replace;
run;

data hospital2;
set year2 (keep=subjid visitdat saeyn_hosptal saefact_hospital saefact_01 saefact_02 saefact_03 saefact_04 saefact_05 saefact_06 saefact_07	saefact_08	saefact_09	saefact_10	saefact_other	saedat_hospital);
saeyn_hosptal1=input(saeyn_hosptal, best.); drop saeyn_hosptal;
rename saeyn_hosptal1=saeyn_hosptal;
format visitdat yymmdds10.;
where subjid ^= . and saefact_hospital ^= '';
run;

proc import datafile = 'C:/スポトロジーSAS/3年目追跡データ.xlsx'
out = year3
dbms = xlsx
replace;
run;

data hospital3;
set year3 (keep=subjid visitdat saeyn_hosptal saefact_hospital saefact_01 saefact_02 saefact_03 saefact_04 saefact_05 saefact_06 saefact_07	saefact_08	saefact_09	saefact_10	saefact_other	saedat_hospital);
saeyn_hosptal1=input(saeyn_hosptal, best.); drop saeyn_hosptal;
rename saeyn_hosptal1=saeyn_hosptal;
format visitdat yymmdds10.;
where subjid ^= . and saefact_hospital ^= '';
run;

data hospital123;
set hospital1 hospital2 hospital3;
run;

proc sort data=hospital123;
by subjid visitdat;
run;

data hospital123;
set hospital123;
by subjid;
if first.subjid then num=0;
num+1;
run;

data hospital123 (rename=(num=saenum_hosptal));
retain subjid visitdat num saeyn_hosptal saefact_hospital saefact_01 saefact_02 saefact_03 saefact_04 saefact_05 saefact_06 saefact_07	saefact_08	saefact_09	saefact_10	saefact_other	saedat_hospital;
set hospital123;
run;

filename export "C:/スポトロジーSAS/Hospital.csv" encoding="utf-8";
proc export
  data=hospital123
  dbms=csv
  outfile=export
  replace;
run;

proc import datafile = 'C:/IQR/DemoData.xlsx'
out = demo
dbms = xlsx
replace;
run;

data demo;
set demo;
where VAR2 ^= '';
VAR2323=input(VAR23,best.);
run;

proc sort data=demo nodupkey out=prog1 dupout=prog2;
by VAR4;
run;

proc sort data=demo nodupkey out=hosp1 dupout=hosp2;
by VAR5;
run;

proc sort data=demo nodupkey out=pref1 dupout=pref2;
by VAR2;
run;

proc means data=prog1 Q1 Median Q3 N NMiss;
var VAR20 VAR18;
run;

proc means data=prog1 Q1 Median Q3 N NMiss;
var VAR2323;
run;

proc freq data=prog1;
table VAR25;
run;

proc freq data=hosp1;
table VAR22 VAR12 VAR14;
run;

proc means data=hosp1 Q1 Median Q3 N NMiss;
var VAR30 VAR29;
run;

proc freq data=hosp1;
table VAR27;
run;

proc means data=pref1 Q1 Median Q3 N NMiss;
var VAR17 VAR3;
run;

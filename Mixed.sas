proc import datafile = 'C:/IQR/DemoData.xlsx'
out = demo
dbms = xlsx
replace;
run;

data demo1;
set demo;
keep VAR2 VAR18 VAR20;
if VAR2 in ('“Œ‹“s', '‹“s•{', '‘åã•{', '•Ÿ‰ªŒ§');
run;

proc mixed data=demo1 method=ML;
class VAR2;
model VAR20=VAR18 / s;
random Int;
run;

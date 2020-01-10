proc import datafile = 'C:/スポトロジーSAS/1年目追跡データ.xlsx'
out = year1
dbms = xlsx
replace;
run;

data bone1;
set year1(keep=subjid visitdat aeyn_bone aeloc aeloc_head aeloc_01 aeloc_02 aeloc_03 aeloc_04 aeloc_05 aeloc_06 aeloc_07 aeloc_08 aeloc_09 aeloc_10 aeloc_other aedat_bone);
aeyn_bone1=input(aeyn_bone, best.); drop aeyn_bone;
aeloc_other1=input(aeloc_other, best.); drop aeloc_other;
aedat_bone1=put(aedat_bone, 10.); drop aedat_bone;
rename aeyn_bone1=aeyn_bone aeloc_other1=aeloc_other aedat_bone1=aedat_bone;
format visitdat yymmdds10.;
where subjid ^= . and aeloc ^= '';
run;

proc import datafile = 'C:/スポトロジーSAS/2年目追跡データ.xlsx'
out = year2
dbms = xlsx
replace;
run;

data bone2;
set year2(keep=subjid visitdat aeyn_bone aeloc aeloc_head aeloc_01 aeloc_02 aeloc_03 aeloc_04 aeloc_05 aeloc_06 aeloc_07 aeloc_08 aeloc_09 aeloc_10 aeloc_other aedat_bone);
aeyn_bone1=input(aeyn_bone, best.); drop aeyn_bone;
aeloc_other1=input(aeloc_other, best.); drop aeloc_other;
rename aeyn_bone1=aeyn_bone aeloc_other1=aeloc_other;
format aedat_bone $char10.;
format visitdat yymmdds10.;
where subjid ^= . and aeloc ^= '';
run;

proc import datafile = 'C:/スポトロジーSAS/3年目追跡データ.xlsx'
out = year3
dbms = xlsx
replace;
run;

data bone3;
set year3(keep=subjid visitdat aeyn_bone aeloc aeloc_head aeloc_01 aeloc_02 aeloc_03 aeloc_04 aeloc_05 aeloc_06 aeloc_07 aeloc_08 aeloc_09 aeloc_10 aeloc_other aedat_bone);
aeyn_bone1=input(aeyn_bone, best.); drop aeyn_bone;
aeloc_other1=input(aeloc_other, best.); drop aeloc_other;
rename aeyn_bone1=aeyn_bone aeloc_other1=aeloc_other;
format aedat_bone $char10.;
format visitdat yymmdds10.;
where subjid ^= . and aeloc ^= '';
run;

data bone123;
set bone1 bone2 bone3;
run;

proc sort data=bone123;
by subjid visitdat;
run;

data bone123;
set bone123;
by subjid;
if first.subjid then num=0;
num+1;
run;

data bone123;
retain subjid visitdat aenum_bone aeyn_bone aeloc aeloc_head aeloc_01 aeloc_02 aeloc_03 aeloc_04 aeloc_05 aeloc_06 aeloc_07 aeloc_08 aeloc_09 aeloc_10 aeloc_other aedat_bone;
set bone123;
rename num=aenum_bone;
run;

filename export "C:/スポトロジーSAS/Bone.csv" encoding="utf-8";
proc export
  data=bone123
  dbms=csv
  outfile=export
  replace;
run;

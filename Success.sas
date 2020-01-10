proc import datafile = '//10.110.150.26/disk1/180 STAR-ACS/データマネジメント/督促テスト/登録日.csv'
 out = start
 dbms = csv
 replace;
run;

proc import datafile = '//10.110.150.26/disk1/180 STAR-ACS/データマネジメント/督促テスト/1年次実施日.csv'
 out = year1
 dbms = csv
 replace;
run;

proc import datafile = '//10.110.150.26/disk1/180 STAR-ACS/データマネジメント/督促テスト/2年次実施日.csv'
 out = year2
 dbms = csv
 replace;
run;

proc import datafile = '//10.110.150.26/disk1/180 STAR-ACS/データマネジメント/督促テスト/クエリ.csv'
 out = query
 dbms = csv
 replace;
run;

data start1;
set start;
format date yymmdds10.;
where intnx('month', date, 15, 'sameday') < today();
run;

proc sql;
create table visit1 as
select * from start1
where id not in (select id from year1);
quit;

proc print data=visit1;
where date^=.;
run;

data start2;
set start;
format date yymmdds10.;
where intnx('month', date, 27, 'sameday') < today();
run;

data year1a;
set year1;
format date yymmdds10.;
where censor=1;
run;

data year2a;
set year2;
format date yymmdds10.;
run;

proc sql;
create table x2 as
select * from start2
where id in (select id from year1a);
quit;

proc sql;
create table visit2 as
select * from x2
where id not in (select id from year2a);
quit;

proc print data=visit2;
where date^=.;
run;

data query1;
set query;
date=scan(date, 1);
format date yymmdds10.;
where today() > intnx('month', date, 2, 'sameday');
run;

proc print data=query1;
where date^=.;
run;

proc export 
  data=visit1 
  dbms=xlsx 
  outfile="visit1.xlsx" 
  replace;
run;

proc export 
  data=visit2
  dbms=xlsx 
  outfile="visit2.xlsx" 
  replace;
run;

proc export 
  data=query1
  dbms=xlsx 
  outfile="query1.xlsx" 
  replace;
run;

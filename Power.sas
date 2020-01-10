proc sql;
select count(*) into : nouniq
from heart2;
quit;

%let nouniq = %eval(&nouniq);

proc sql;
select count(*)  into : error
from heart1
where doctor contains '間違';
quit;

%let error = %eval(&error);

proc sql;
select count(*)  into : error2
from heart3
where doctor contains '間違';
quit;

%let exclusion = %eval(&nouniq+&error2);

proc sql;
select count(*) into : okay
from heart4;
quit;

%let okay = %eval(&okay);

proc sql;
select count(*) into : okay
from heart4;
quit;

%let okay = %eval(&okay);

proc sort data=heart1 nodupkey out=nodup;
by facility;
run;

proc sql;
select count(*) into : nodup
from nodup;
quit;

%let nodup = %eval(&nodup);

proc sql;
select count(*)  into : male
from heart4
where gender = '男性';
quit;

proc sql;
select count(*)  into : female
from heart4
where gender = '女性';
quit;

proc sql;
select count(*)  into : nogender
from heart4
where gender = '';
quit;

%let male = %eval(&male);
%let female = %eval(&female);
%let nogender = %eval(&nogender);

proc means data=heart4 noprint;
var age;
output out=avg  mean=avg;
run;

data avg;
set avg;
call symput('avg',avg);
run;

%let avg = %sysfunc(round(&avg, 0.1));

proc sql;
select count(*)  into : agemissing
from heart4
where age = .;
quit;

%let agemissing = %eval(&agemissing);

proc sql;
select count(*)  into : first
from heart4
where count = '初回';
quit;

proc sql;
select count(*)  into : second
from heart4
where count contains '回目';
quit;

proc sql;
select count(*)  into : nocount
from heart4
where count = '';
quit;

%let first = %eval(&first);
%let second = %eval(&second);
%let nocount = %eval(&nocount);

proc sql;
select count(*)  into : admission
from heart4
where department = '入院';
quit;

proc sql;
select count(*)  into : outpatient
from heart4
where department = '外来';
quit;

proc sql;
select count(*)  into : nodepartment
from heart4
where department = '';
quit;

%let admission = %eval(&admission);
%let outpatient = %eval(&outpatient);
%let nodepartment = %eval(&nodepartment);

proc sql;
select count(*)  into : phase1
from heart4
where phase = 'Phase  Ⅰ';
quit;

proc sql;
select count(*)  into : phase2
from heart4
where phase = 'Phase  Ⅱ';
quit;

proc sql;
select count(*)  into : phase3
from heart4
where phase = 'Phase  Ⅲ';
quit;

proc sql;
select count(*)  into : nophase
from heart4
where phase = '';
quit;

%let phase1 = %eval(&phase1);
%let phase2 = %eval(&phase2);
%let phase3 = %eval(&phase3);
%let nophase = %eval(&nophase);

data phase1;
set heart4;
where phase = 'Phase  Ⅰ';
run;

proc sql;
select count(*)  into : change2
from phase1
where phasechange = 'Ⅱへ移行有り';
quit;

proc sql;
select count(*)  into : notchange2
from phase1
where phasechange = 'Ⅱへ移行無し';
quit;

proc sql;
select count(*)  into : notset
from phase1
where phasechange = '未設定';
quit;

proc sql;
select count(*)  into : nophasechange
from phase1
where phasechange = '';
quit;

%let change2 = %eval(&change2);
%let notchange2 = %eval(&notchange2);
%let notset = %eval(&notset);
%let nophasechange = %eval(&nophasechange);

ods powerpoint  layout = TitleSlide
   file = "c:/folder/sample.pptx";
proc odstext ;
   p "心臓リハビリテーション学会"  / style=presentationtitle;
   p "DM作成資料" / style=presentationtitle2;
run;

ods powerpoint layout = TitleAndContent;
title "条件";
proc odstext;
p "";
list;
item "症例番号が重複している&nouniq.例を除外" / style=[fontsize=24pt];
item "責任医師名に間違いデータ、間違えデータと記載のある&error.症例を除外" / style=[fontsize=24pt];
item "症例番号の重複と、間違え（い）データは重複している症例があるため、計&exclusion.例を除外。残&okay.例" / style=[fontsize=24pt];
end;
run;

ods powerpoint layout = TitleAndContent;
title "中間結果（1）";
proc odstext;
p "登録数			             &okay.例";
p "登録施設数	            &nodup.施設";
p "男性/女性		          &male./&female.例(未記入&nogender.例）";
p "年齢		                   平均&avg.歳（0～100歳） (未記入&agemissing.例）";
p "初回/2回以上　	          &first./&second.例（未記入&nocount.例）";
p "入院/外来		          &admission./&outpatient.例（未記入&nodepartment.例）";
p "PhaseⅠ/Ⅱ/Ⅲ           &phase1./&phase2./&phase3.例（未記入&nophase.例）";
p "PhaseⅠからⅡに移行  有&change2./無&notchange2.例/未設定&notset.例（未記入&nophasechange.例）";
run;

ods powerpoint layout = TitleAndContent;
title "中間結果（2）";
proc odstext;
p '心大血管疾患リハ保険適応病名' / style=[color=steelblue];
run;
proc sgplot data=heart4;
vbar insurance / fillattrs=(color=steelblue) barwidth=0.5 datalabel;
xaxis display=(nolabel noticks) values=('急性心筋梗塞' '狭心症' '開心術後' '慢性心不全' '大血管疾患' '末梢動脈疾患' '不明');
yaxis display=(nolabel noticks) grid;
run;

ods powerpoint layout = TitleAndContent;
title "中間結果（3）";
proc odstext;
p '基礎疾患' / style=[color=lightred];
run;
proc sgplot data=heart5;
vbar disease / fillattrs=(color=lightred) barwidth=0.5 datalabel;
xaxis display=(nolabel noticks) values=('STEMI' 'NSTEMI' 'UAP' 'OMI' 'EAP' 'SMI' 'ICM' 'DCM' 'HCM' 'HHD' 'AS' 'AR'
                                                      'MS' 'MR' 'TR' 'PS' 'TAA' 'AAA' 'AD' '先天性疾患' 'PAD' 'PH' 'AF' 'AS(TAVI)' 'PE/DVT'
                                                      'Takostubo' 'CKD' '人工弁不全' '心筋炎' 'その他');
yaxis display=(nolabel noticks) grid;
run;

ods powerpoint layout = TitleAndContent;
title "中間結果（4）";
proc odstext;
p '心大血管疾患リハ保険適応病名' / style=[color=steelblue];
run;
proc sgplot data=heart6;
vbar insurance / fillattrs=(color=steelblue) barwidth=0.5 datalabel;
xaxis display=(nolabel noticks) values=('急性心筋梗塞' '狭心症' '開心術後' '慢性心不全' '大血管疾患' '末梢動脈疾患' '不明');
yaxis display=(nolabel noticks) grid;
run;

ods powerpoint layout = TitleAndContent;
title "中間結果（5）";
proc odstext;
p '基礎疾患' / style=[color=lightred];
run;
proc sgplot data=heart6;
vbar disease / fillattrs=(color=lightred) barwidth=0.5 datalabel;
xaxis display=(nolabel noticks) values=('STEMI' 'NSTEMI' 'UAP' 'OMI' 'EAP' 'SMI' 'ICM' 'DCM' 'HCM' 'HHD' 'AS' 'AR'
                                                      'MS' 'MR' 'TR' 'PS' 'TAA' 'AAA' 'AD' '先天性疾患' 'PAD' 'PH' 'AF' 'AS(TAVI)' 'PE/DVT'
                                                      'Takostubo' 'CKD' '人工弁不全' '心筋炎' 'その他');
yaxis display=(nolabel noticks) grid;
run;

ods powerpoint close;

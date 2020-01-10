proc import datafile = 'C:/�S�����nSAS/�S�����n.xlsx'
out = heart
dbms = xlsx
replace;
run;

data heart1(rename=(uniq=id));
retain facility uniq gender age count depart phase phasechange insurance doctor disease;
set heart;
code1 = put(code, best3.); drop code;
id1 = put(id, best10.); drop id;
code2 = cats('000',code1); drop code1;
id2 = cats('0000000000',id1); drop id1;
code3 = substr(code2, length(code2)-2, length(code2)); drop code2;
id3 = substr(id2, length(id2)-9, length(id2)); drop id2;
uniq = cats(code3, id3); drop code3 id3;
run;

proc sort data=heart1 nouniquekey out=heart2 uniqueout=heart3;
by id;
run;

data heart4;
set heart3;
if insurance='' then insurance='�s��';
if index(insurance, '�ǐ�����') then insurance='������������';
where doctor not contains '�Ԉ�';
run;

data heart5;
set heart4;
if disease='' then delete;
if disease='AS"(TAVI)"' then disease='AS(TAVI)';
if disease='AS�iTAVI�j' then disease='AS(TAVI)';
if disease='AS(TAVI)' then disease='AS(TAVI)';
if disease='AS�iTAVI)' then disease='AS(TAVI)';
if disease='AMI' then disease='���̑�';
if disease='ACS' then disease='���̑�';
if disease='ASO' then disease='PAD';
if disease='CHF' then disease='���̑�';
if disease='EPA' then disease='EAP';
if disease='HOCM' then disease='HCM';
if disease='AAD' then disease='AD';
if index(disease, '�𗣐�') then disease='AD';
if disease='DA' then disease='AD';
if disease='Takotsubo' then disease='Takostubo';
if disease='takostubo' then disease='Takostubo';
if disease='takotsubo' then disease='Takostubo';
if disease='TCM' then disease='Takostubo';
if index(disease, '������') then disease='Takostubo';
if disease='TIC' then disease='���̑�';
if disease='PE' then disease='PE/DVT';
if index(disease, 'myocar') then disease='�S�؉�';
if disease='af' then disease='AF';
if disease='eAP' then disease='EAP';
if disease='uAP' then disease='UAP';
run;

data heart6;
set heart4;
where phase='Phase  �U' or phasechange='�U�ֈڍs�L��';
run;

data heart7;
set heart5;
where phase='Phase  �U' or phasechange='�U�ֈڍs�L��';
run;

proc sql noprint;
select count(*) into : nouniq
from heart2;
quit;

%let nouniq = %eval(&nouniq);

proc sql noprint;
select count(*)  into : error
from heart1
where doctor contains '�Ԉ�';
quit;

%let error = %eval(&error);

proc sql noprint;
select count(*)  into : error2
from heart3
where doctor contains '�Ԉ�';
quit;

%let exclusion = %eval(&nouniq+&error2);

proc sql noprint;
select count(*) into : okay
from heart4;
quit;

%let okay = %eval(&okay);

proc sql noprint;
select count(*) into : okay
from heart4;
quit;

%let okay = %eval(&okay);

proc sort data=heart1 nodupkey out=nodup;
by facility;
run;

proc sql noprint;
select count(*) into : nodup
from nodup;
quit;

%let nodup = %eval(&nodup);

proc sql noprint;
select count(*)  into : male
from heart4
where gender = '�j��';
quit;

proc sql noprint;
select count(*)  into : female
from heart4
where gender = '����';
quit;

proc sql noprint;
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

proc sql noprint;
select count(*)  into : agemissing
from heart4
where age = .;
quit;

%let agemissing = %eval(&agemissing);

proc sql noprint;
select count(*)  into : first
from heart4
where count = '����';
quit;

proc sql noprint;
select count(*)  into : second
from heart4
where count contains '���';
quit;

proc sql noprint;
select count(*)  into : nocount
from heart4
where count = '';
quit;

%let first = %eval(&first);
%let second = %eval(&second);
%let nocount = %eval(&nocount);

proc sql noprint;
select count(*)  into : admission
from heart4
where department = '���@';
quit;

proc sql noprint;
select count(*)  into : outpatient
from heart4
where department = '�O��';
quit;

proc sql noprint;
select count(*)  into : nodepartment
from heart4
where department = '';
quit;

%let admission = %eval(&admission);
%let outpatient = %eval(&outpatient);
%let nodepartment = %eval(&nodepartment);

proc sql noprint;
select count(*)  into : phase1
from heart4
where phase = 'Phase  �T';
quit;

proc sql noprint;
select count(*)  into : phase2
from heart4
where phase = 'Phase  �U';
quit;

proc sql noprint;
select count(*)  into : phase3
from heart4
where phase = 'Phase  �V';
quit;

proc sql noprint;
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
where phase = 'Phase  �T';
run;

proc sql noprint;
select count(*)  into : change2
from phase1
where phasechange = '�U�ֈڍs�L��';
quit;

proc sql noprint;
select count(*)  into : notchange2
from phase1
where phasechange = '�U�ֈڍs����';
quit;

proc sql noprint;
select count(*)  into : notset
from phase1
where phasechange = '���ݒ�';
quit;

proc sql noprint;
select count(*)  into : nophasechange
from phase1
where phasechange = '';
quit;

%let change2 = %eval(&change2);
%let notchange2 = %eval(&notchange2);
%let notset = %eval(&notset);
%let nophasechange = %eval(&nophasechange);

ods powerpoint  layout = TitleSlide
file = "c:/�S�����nSAS/�S�����nPPT.pptx";
proc odstext ;
p "�S�����n�r���e�[�V�����w��"  / style=presentationtitle;
p "DM�쐬����" / style=presentationtitle2;
run;

ods powerpoint layout = TitleAndContent;
title "����";
proc odstext;
p "";
list;
item "�Ǘ�ԍ����d�����Ă���&nouniq.������O" / style=[fontsize=24pt];
item "�ӔC��t���ɊԈႢ�f�[�^�A�ԈႦ�f�[�^�ƋL�ڂ̂���&error.�Ǘ�����O" / style=[fontsize=24pt];
item "�Ǘ�ԍ��̏d���ƁA�ԈႦ�i���j�f�[�^�͏d�����Ă���ǗႪ���邽�߁A�v&exclusion.������O�B�c&okay.��" / style=[fontsize=24pt];
end;
run;

ods powerpoint layout = TitleAndContent;
title "���Ԍ��ʁi1�j";
proc odstext;
p "�o�^��			             &okay.��";
p "�o�^�{�ݐ�	            &nodup.�{��";
p "�j��/����		          &male./&female.��(���L��&nogender.��j";
p "�N��		                   ����&avg.�΁i0�`100�΁j (���L��&agemissing.��j";
p "����/2��ȏ�@	          &first./&second.��i���L��&nocount.��j";
p "���@/�O��		          &admission./&outpatient.��i���L��&nodepartment.��j";
p "Phase�T/�U/�V           &phase1./&phase2./&phase3.��i���L��&nophase.��j";
p "Phase�T����U�Ɉڍs  �L&change2./��&notchange2.��/���ݒ�&notset.��i���L��&nophasechange.��j";
run;

ods powerpoint layout = TitleAndContent;
title "���Ԍ��ʁi2�j";
proc odstext;
p '�S�匌�ǎ������n�ی��K���a��' / style=[color=steelblue];
run;
proc sgplot data=heart4;
vbar insurance / fillattrs=(color=steelblue) barwidth=0.5 datalabel;
xaxis display=(nolabel noticks) values=('�}���S�؍[��' '���S��' '�J�S�p��' '�����S�s�S' '�匌�ǎ���' '������������' '�s��');
yaxis display=(nolabel noticks) grid;
run;

ods powerpoint layout = TitleAndContent;
title "���Ԍ��ʁi3�j";
proc odstext;
p '��b����' / style=[color=lightred];
run;
proc sgplot data=heart5;
vbar disease / fillattrs=(color=lightred) barwidth=0.5 datalabel;
xaxis display=(nolabel noticks) values=('STEMI' 'NSTEMI' 'UAP' 'OMI' 'EAP' 'SMI' 'ICM' 'DCM' 'HCM' 'HHD' 'AS' 'AR'
                                                      'MS' 'MR' 'TR' 'PS' 'TAA' 'AAA' 'AD' '��V������' 'PAD' 'PH' 'AF' 'AS(TAVI)' 'PE/DVT'
                                                      'Takostubo' 'CKD' '�l�H�ٕs�S' '�S�؉�' '���̑�');
yaxis display=(nolabel noticks) grid;
run;

ods powerpoint layout = TitleAndContent;
title "���Ԍ��ʁi4�j";
proc odstext;
p '�S�匌�ǎ������n�ی��K���a��' / style=[color=steelblue];
run;
proc sgplot data=heart6;
vbar insurance / fillattrs=(color=steelblue) barwidth=0.5 datalabel;
xaxis display=(nolabel noticks) values=('�}���S�؍[��' '���S��' '�J�S�p��' '�����S�s�S' '�匌�ǎ���' '������������' '�s��');
yaxis display=(nolabel noticks) grid;
run;

ods powerpoint layout = TitleAndContent;
title "���Ԍ��ʁi5�j";
proc odstext;
p '��b����' / style=[color=lightred];
run;
proc sgplot data=heart7;
vbar disease / fillattrs=(color=lightred) barwidth=0.5 datalabel;
xaxis display=(nolabel noticks) values=('STEMI' 'NSTEMI' 'UAP' 'OMI' 'EAP' 'SMI' 'ICM' 'DCM' 'HCM' 'HHD' 'AS' 'AR'
                                                      'MS' 'MR' 'TR' 'PS' 'TAA' 'AAA' 'AD' '��V������' 'PAD' 'PH' 'AF' 'AS(TAVI)' 'PE/DVT'
                                                      'Takostubo' 'CKD' '�l�H�ٕs�S' '�S�؉�' '���̑�');
yaxis display=(nolabel noticks) grid;
run;

ods powerpoint close;

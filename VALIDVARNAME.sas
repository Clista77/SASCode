proc import datafile = 'C:/�S�����nSAS/�S�����n1'
out = heart
dbms = xlsx
replace;
run;

OPTIONS VALIDVARNAME=ANY ;
data h1;
set heart;
rename
'�{�ݖ�'n=facility
'�{�݃R�[�h'n=code
'���ҊǗ��ԍ�'n=id
'����'n=gender
'�J�n���N��'n=age
'���{�ݓo�^��'n=count
'���@�O�����'n=department
'�t�F�[�Y'n=phase
'�t�F�[�Y�ڍs'n=phasechange
'�S�匌�ǎ������n�ی��K���a��'n=insurance
'�S����t��'n=doctor
'��b����'n=disease;
run;

data heart1 (keep=facility id gender age count department phase phasechange insurance doctor disease);
set h1;
code1 = put(code, 3.); drop code;
id1 = put(id, 10.); drop id;
code2 = cats('000',code1); drop code1;
id2 = cats('0000000000',id1); drop id1;
code3 = substr(code2, length(code2)-2, length(code2)); drop code2;
id3 = substr(id2, length(id2)-9, length(id2)); drop id2;
uniq = cats(code3, id3); drop code3 id3;
rename uniq=id;
run;

proc print data=heart1(obs=10);
run;

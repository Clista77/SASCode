proc import datafile = 'C:/心臓リハSAS/心臓リハ1'
out = heart
dbms = xlsx
replace;
run;

OPTIONS VALIDVARNAME=ANY ;
data h1;
set heart;
rename
'施設名'n=facility
'施設コード'n=code
'患者管理番号'n=id
'性別'n=gender
'開始時年齢'n=age
'自施設登録回数'n=count
'入院外来種別'n=department
'フェーズ'n=phase
'フェーズ移行'n=phasechange
'心大血管疾患リハ保険適応病名'n=insurance
'担当医師名'n=doctor
'基礎疾患'n=disease;
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

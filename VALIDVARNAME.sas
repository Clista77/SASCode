proc import datafile = 'C:/SnSAS/Sn1'
out = heart
dbms = xlsx
replace;
run;

OPTIONS VALIDVARNAME=ANY ;
data h1;
set heart;
rename
'{Ý¼'n=facility
'{ÝR[h'n=code
'³ÒÇÔ'n=id
'«Ê'n=gender
'JnNî'n=age
'©{Ýo^ñ'n=count
'ü@OíÊ'n=department
'tF[Y'n=phase
'tF[YÚs'n=phasechange
'SåÇ¾³nÛ¯Ka¼'n=insurance
'Sãt¼'n=doctor
'îb¾³'n=disease;
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

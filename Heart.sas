proc import datafile = 'C:/心臓リハSAS/心臓リハ.xlsx'
out = heart
dbms = xlsx
replace;
run;

data heart1;
retain uniq gender age count depart phase phasechange insurance doctor disease;
set heart;
code1 = put(code, best3.); drop code;
id1 = put(id, best10.); drop id;
code2 = cats('000',code1); drop code1;
id2 = cats('0000000000',id1); drop id1;
code3 = substr(code2, length(code2)-2, length(code2)); drop code2;
id3 = substr(id2, length(id2)-9, length(id2)); drop id2;
uniq = cats(code3, id3); drop code3 id3;
rename uniq=id;
run;

proc sort data=heart1 nouniquekey out=heart2 uniqueout=heart3;
by id;
run;

data heart4;
set heart3;
if insurance='' then insurance='不明';
if index(insurance, '閉塞性動脈') then insurance='末梢動脈疾患';
where doctor not contains '間違';
run;

title color=steelblue '心大血管疾患リハ保険適応病名';
proc sgplot data=heart4;
vbar insurance / fillattrs=(color=steelblue) barwidth=0.5 datalabel;
xaxis display=(nolabel noticks) values=('急性心筋梗塞' '狭心症' '開心術後' '慢性心不全' '大血管疾患' '末梢動脈疾患' '不明');
yaxis display=(nolabel noticks) grid;
run;

data heart5;
set heart4;
if disease='' then delete;
if disease='AS"(TAVI)"' then disease='AS(TAVI)';
if disease='AS（TAVI）' then disease='AS(TAVI)';
if disease='AS(TAVI)' then disease='AS(TAVI)';
if disease='AS（TAVI)' then disease='AS(TAVI)';
if disease='AMI' then disease='その他';
if disease='ACS' then disease='その他';
if disease='ASO' then disease='PAD';
if disease='CHF' then disease='その他';
if disease='EPA' then disease='EAP';
if disease='HOCM' then disease='HCM';
if disease='AAD' then disease='AD';
if index(disease, '解離性') then disease='AD';
if disease='DA' then disease='AD';
if disease='Takotsubo' then disease='Takostubo';
if disease='takostubo' then disease='Takostubo';
if disease='takotsubo' then disease='Takostubo';
if disease='TCM' then disease='Takostubo';
if index(disease, 'たこつぼ') then disease='Takostubo';
if disease='TIC' then disease='その他';
if disease='PE' then disease='PE/DVT';
if index(disease, 'myocar') then disease='心筋炎';
if disease='af' then disease='AF';
if disease='eAP' then disease='EAP';
if disease='uAP' then disease='UAP';
run;

title color='lightred' '基礎疾患';
proc sgplot data=heart5;
vbar disease / fillattrs=(color=lightred) barwidth=0.5 datalabel;
xaxis display=(nolabel noticks) values=('STEMI' 'NSTEMI' 'UAP' 'OMI' 'EAP' 'SMI' 'ICM' 'DCM' 'HCM' 'HHD' 'AS' 'AR'
                                                      'MS' 'MR' 'TR' 'PS' 'TAA' 'AAA' 'AD' '先天性疾患' 'PAD' 'PH' 'AF' 'AS(TAVI)' 'PE/DVT'
                                                      'Takostubo' 'CKD' '人工弁不全' '心筋炎' 'その他');
yaxis display=(nolabel noticks) grid;
run;

data heart6;
set heart4;
where phase='Phase  Ⅱ' or phasechange='Ⅱへ移行有り';
run;

data heart7;
set heart5;
where phase='Phase  Ⅱ' or phasechange='Ⅱへ移行有り';
run;

title color=steelblue '心大血管疾患リハ保険適応病名';
proc sgplot data=heart6;
vbar insurance / fillattrs=(color=steelblue) barwidth=0.5 datalabel;
xaxis display=(nolabel noticks) values=('急性心筋梗塞' '狭心症' '開心術後' '慢性心不全' '大血管疾患' '末梢動脈疾患' '不明');
yaxis display=(nolabel noticks) grid;
run;

title color=lightred '基礎疾患';
proc sgplot data=heart7;
vbar disease / fillattrs=(color=lightred) barwidth=0.5 datalabel;
xaxis display=(nolabel noticks) values=('STEMI' 'NSTEMI' 'UAP' 'OMI' 'EAP' 'SMI' 'ICM' 'DCM' 'HCM' 'HHD' 'AS' 'AR'
                                                      'MS' 'MR' 'TR' 'PS' 'TAA' 'AAA' 'AD' '先天性疾患' 'PAD' 'PH' 'AF' 'AS(TAVI)' 'PE/DVT'
                                                      'Takostubo' 'CKD' '人工弁不全' '心筋炎' 'その他');
yaxis display=(nolabel noticks) grid;
run;

proc import datafile = 'C:/�S�����nSAS/�S�����n.xlsx'
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
if insurance='' then insurance='�s��';
if index(insurance, '�ǐ�����') then insurance='������������';
where doctor not contains '�Ԉ�';
run;

title color=steelblue '�S�匌�ǎ������n�ی��K���a��';
proc sgplot data=heart4;
vbar insurance / fillattrs=(color=steelblue) barwidth=0.5 datalabel;
xaxis display=(nolabel noticks) values=('�}���S�؍[��' '���S��' '�J�S�p��' '�����S�s�S' '�匌�ǎ���' '������������' '�s��');
yaxis display=(nolabel noticks) grid;
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

title color='lightred' '��b����';
proc sgplot data=heart5;
vbar disease / fillattrs=(color=lightred) barwidth=0.5 datalabel;
xaxis display=(nolabel noticks) values=('STEMI' 'NSTEMI' 'UAP' 'OMI' 'EAP' 'SMI' 'ICM' 'DCM' 'HCM' 'HHD' 'AS' 'AR'
                                                      'MS' 'MR' 'TR' 'PS' 'TAA' 'AAA' 'AD' '��V������' 'PAD' 'PH' 'AF' 'AS(TAVI)' 'PE/DVT'
                                                      'Takostubo' 'CKD' '�l�H�ٕs�S' '�S�؉�' '���̑�');
yaxis display=(nolabel noticks) grid;
run;

data heart6;
set heart4;
where phase='Phase  �U' or phasechange='�U�ֈڍs�L��';
run;

data heart7;
set heart5;
where phase='Phase  �U' or phasechange='�U�ֈڍs�L��';
run;

title color=steelblue '�S�匌�ǎ������n�ی��K���a��';
proc sgplot data=heart6;
vbar insurance / fillattrs=(color=steelblue) barwidth=0.5 datalabel;
xaxis display=(nolabel noticks) values=('�}���S�؍[��' '���S��' '�J�S�p��' '�����S�s�S' '�匌�ǎ���' '������������' '�s��');
yaxis display=(nolabel noticks) grid;
run;

title color=lightred '��b����';
proc sgplot data=heart7;
vbar disease / fillattrs=(color=lightred) barwidth=0.5 datalabel;
xaxis display=(nolabel noticks) values=('STEMI' 'NSTEMI' 'UAP' 'OMI' 'EAP' 'SMI' 'ICM' 'DCM' 'HCM' 'HHD' 'AS' 'AR'
                                                      'MS' 'MR' 'TR' 'PS' 'TAA' 'AAA' 'AD' '��V������' 'PAD' 'PH' 'AF' 'AS(TAVI)' 'PE/DVT'
                                                      'Takostubo' 'CKD' '�l�H�ٕs�S' '�S�؉�' '���̑�');
yaxis display=(nolabel noticks) grid;
run;

Set verify off
set pagesize 0
set echo off
set trims on
set lines 700
set linesize 200
set termout off
set wrap off
set feedback off
set  serveroutput on size 1000000
set pages 1000

exec dbms_output.enable(null);

spool LoanDet.lst

Declare
vAcid                       varchar2(50);
CUSTOMER_HOST_ID            varchar2(100);
FINACLE_HOST_ID             varchar2(100);
ACCOUNT_NUMBER              varchar2(100);
ACCOUNT_TITLE               varchar2(200);
vcustType                   varchar2(100);
vschm_type                   varchar2(100);
SBU_CODE                    varchar2(100);
SBU                         varchar2(100);
PRODUCT_CODE                varchar2(100);
STATUS_CODE                 varchar2(100);
STATUS_REASON_TXT           varchar2(100);
STATUS_DTTM                 date;
ACCOUNT_OPEN_DTTM           date;
ACCOUNT_CLOSE_DTTM          date;
FREEZE_TYPE_CODE            varchar2(100);
PAYBACK_MONTHS          varchar2(100);
ACCOUNT_FROZEN_DTTM         date;
NON_PERFORMING_IND          varchar2(100);
lAcid                   varchar2(100);
INTEREST_TYPE_CODE          varchar2(100) := NULL;
LOAN_START_DTTM   date;
NUM_OF_REPAY        number;
LOAN_APPROVED_AMT	number;
LOAN_PRINCIPAL_AMT	NUMBER;
REPAY_ACCT_NUM		VARCHAR2(100);
INSTALLMENT_AMT       number;
INSTALLMENT_AMT_BS1      number;
BRANCH_CODE                 varchar2(100);
CRNCY_CODE                  varchar2(100);
Joint_Ind                   varchar2(100);
frezCode_ind                varchar2(100);
MATURITY_DTTM      date;
SYSTEM_SOURCE_CD	varchar2(100);
LAST_UPDATE_DATE	date;
DISBURSED_DTTM	date;
DISBURSED_AMT		number;
intRate				number;
vrate			number := 1;
PURPOSE_OF_LOAN_CD VARCHAR2(100); 
PURPOSE_OF_LOAN_TXT VARCHAR2(500);
PRODUCT_GROUP_CD VARCHAR2(50) := NULL;
DEBT_TYPE_CD VARCHAR2(50):= NULL;
LOAN_MORATORIUM_MONTH_NUM VARCHAR2(50):= NULL;
HAS_BANK_INSURANCE_IND VARCHAR2(50):= NULL;
HAS_COLLATERAL_IND VARCHAR2(50):= NULL;
LOAN_REPHASEMENT_DTTM DATE;
LOAN_REPHASEMENT_REASON_TXT VARCHAR2(500) := NULL;
LOAN_CANCELLATION_DTTM VARCHAR2(50) := NULL;
LOAN_CANCELLATION_REASON VARCHAR2(50) := NULL;
DOWN_PAYMENT_AMT NUMBER := '0.00';
RESTRUCTURE_DTTM DATE;
LOAN_RESTRUCTURE_CNT VARCHAR2(50);
AMOUNT_OF_LN_RESTRUC VARCHAR2(50) := NULL;
TAKE_OVER_LOAN_IND VARCHAR2(50) := NULL;
TAKE_OVER_LOAN_DTTM VARCHAR2(50) := NULL;
INDIV_MONTHLY_INC_AMT NUMBER := '0.00';
RECORD_ID VARCHAR2(50) := NULL;
LOAN_PAYMENT_FREQ_CD	varchar2(100);
non_perform_cd		varchar2(100);
TOTAL_COUNT              number;
REMARKS              varchar2(100);

	

CURSOR replace1 IS
select distinct g.acid,g.cif_id,g.cif_id,g.foracid,g.acct_name,g.schm_code,g.sol_id,g.acct_cls_flg,NULL,g.acct_cls_date,
g.acct_opn_date,g.acct_cls_date,g.frez_code,LAST_FREZ_DATE,g.acct_crncy_code,'FIN001',g.clr_bal_amt*1,
(select db_stat_date from tbaadm.gct) LAST_UPDATE_DATE,
(select custom.LOAN_RATE(g.acid) from dual) intRate,
(select foracid from tbaadm.gam a where a.acid = (select op_acid from tbaadm.lam where acid = g.acid) and a.entity_cre_flg='Y' and a.del_flg='N') REPAY_ACCT_NUM,
(select dis_shdl_date from tbaadm.lam where acid = g.acid and entity_cre_flg = 'Y') DISBURSED_DTTM,
(select dis_amt from tbaadm.lam where acid = g.acid and entity_cre_flg = 'Y') DISBURSED_AMT,
(select CASE WHEN length(free_code_1) = 5 THEN substr(free_code_1,0,4) 
ELSE free_code_1 END from tbaadm.fcftt m where m.acid = g.acid) SBU_CODE,
(select PURPOSE_OF_ADVN from tbaadm.gac where acid=g.acid) PURPOSE_OF_LOAN_CD,
(select CASE WHEN MAIN_CLASSIFICATION_USER = '001' THEN 'N' ELSE 'Y' END from tbaadm.acd where b2k_id = g.acid and rownum < 2) NON_PERFORMING_IND,
(select CASE WHEN cust_type_code = 'JONT' THEN 'Y' ELSE 'N' END from tbaadm.cmg where cif_id = g.cif_id) Joint_Ind,
(select CASE WHEN LAST_FREZ_DATE is null THEN 'N' ELSE 'Y' END from tbaadm.gam where acid = g.acid) frezCode_ind,
(select round((rep_perd_mths + (nvl(rep_perd_days,0)/30)),1) from tbaadm.lam lam where lam.acid = g.acid and entity_cre_flg='Y' and del_flg='N') PAYBACK_MONTHS,
(select max(REP_SHDL_DATE) from tbaadm.lam where lam.acid = g.acid and entity_cre_flg='Y' and del_flg='N') LOAN_REPHASEMENT_DTTM,
(select max(RESHDL_DATE) from tbaadm.lrh where acid = g.acid and entity_cre_flg='Y' and del_flg='N') RESTRUCTURE_DTTM,
(select max(SHDL_NUM) from tbaadm.lrh where acid = g.acid and entity_cre_flg='Y' and del_flg='N') LOAN_RESTRUCTURE_CNT,
(select max(lim_exp_date) from tbaadm.lht WHERE acid = g.acid and entity_cre_flg='Y') MATURITY_DTTM,
(select max(flow_start_date) from tbaadm.lrs WHERE acid = g.acid AND rownum = 1 and entity_cre_flg='Y') LOAN_START_DTTM,
(select sum(NUM_OF_FLOWS) from tbaadm.lrs WHERE acid = g.acid and entity_cre_flg='Y') NUM_OF_REPAY, 
(select lr_freq_type from tbaadm.lrs WHERE acid = g.acid and rownum = 1 and entity_cre_flg='Y') LOAN_PAYMENT_FREQ_CD,
(select l.dis_amt from tbaadm.lam l WHERE l.acid = g.acid and l.entity_cre_flg='Y') LOAN_APPROVED_AMT,
(select sum(r.flow_amt) from tbaadm.lrs r where acid=g.acid and (r.flow_id in ('INDEM','PRDEM') OR r.flow_id = 'EIDEM') and r.shdl_num =(select max(shdl_num) from tbaadm.lrs where acid=g.acid and last_rec_flg='Y') and r.entity_cre_flg = 'Y') INSTALLMENT_AMT_BS1
from tbaadm.gam g,tbaadm.lam l
where g.acid = l.acid
and g.foracid not like 'ZZ%'
and (g.acct_cls_date is null or g.acct_cls_date between sysdate - 90 and sysdate);

Begin

 begin
 delete CUSTOM.MASTER_LOAN_DETAILS_TBL;
 commit;
 end;

	open replace1;
            loop
		fetch replace1 into vAcid,CUSTOMER_HOST_ID,FINACLE_HOST_ID,ACCOUNT_NUMBER,ACCOUNT_TITLE,PRODUCT_CODE,BRANCH_CODE,STATUS_CODE,STATUS_REASON_TXT,
STATUS_DTTM,ACCOUNT_OPEN_DTTM,ACCOUNT_CLOSE_DTTM,FREEZE_TYPE_CODE,ACCOUNT_FROZEN_DTTM,CRNCY_CODE,SYSTEM_SOURCE_CD,LOAN_PRINCIPAL_AMT,LAST_UPDATE_DATE,intRate,
REPAY_ACCT_NUM,DISBURSED_DTTM,DISBURSED_AMT,SBU_CODE,PURPOSE_OF_LOAN_CD,NON_PERFORMING_IND,Joint_Ind,frezCode_ind,PAYBACK_MONTHS,LOAN_REPHASEMENT_DTTM,RESTRUCTURE_DTTM,
LOAN_RESTRUCTURE_CNT,MATURITY_DTTM,LOAN_START_DTTM,NUM_OF_REPAY,LOAN_PAYMENT_FREQ_CD,LOAN_APPROVED_AMT,INSTALLMENT_AMT_BS1;
exit when replace1%notfound;


Begin
select ref_desc 
into PURPOSE_OF_LOAN_TXT 
from tbaadm.rct
where ref_code = PURPOSE_OF_LOAN_CD
and ref_rec_type = '41';
exception
when no_data_found then
PURPOSE_OF_LOAN_TXT := ' ';
end;


begin
select distinct var_crncy_units 
into vrate
from tbaadm.rth 
where var_crncy_code = 'NGN'
and fxd_crncy_code = CRNCY_CODE 
and ratecode = (select report_rate_code from tbaadm.gct)
and rtlist_date=(select max(rtlist_date) from tbaadm.rth x 
                            where tbaadm.rth.ratecode=x.ratecode 
                            and tbaadm.rth.fxd_crncy_code=x.fxd_crncy_code 
                            and tbaadm.rth.var_crncy_code=x.var_crncy_code
                            and rtlist_date >=(select to_date(sysDate,'dd-mm-yyyy') from dual) and rcre_time=(select max(rcre_time) from tbaadm.rth y where x.ratecode=y.ratecode and x.fxd_crncy_code=y.fxd_crncy_code and x.var_crncy_code=y.var_crncy_code
and y.rtlist_date >= (select to_date(sysDate,'dd-mm-yyyy') from dual)));
exception
when no_data_found then
vrate := 1;
end;

/*
begin 
select m.op_acid,dis_shdl_date,dis_amt
into lAcid,DISBURSED_DTTM,DISBURSED_AMT
from tbaadm.lam m
where m.acid = vAcid
and m.entity_cre_flg = 'Y';
exception
when no_data_found then
DISBURSED_AMT := '0.00';
end;

Begin
select b.cust_type_code 
into vcustType 
from crmuser.cmg b
where b.cif_id = CUSTOMER_HOST_ID
and b.del_flg = 'N'
and b.entity_cre_flg = 'Y';
exception
when no_data_found then
null;
end; 

Begin
select free_code_1 
into SBU_CODE 
from tbaadm.fcftt
where acid=vAcid;
exception
when no_data_found then
null;
end; 

Begin
select PURPOSE_OF_ADVN  
into PURPOSE_OF_LOAN_CD 
from tbaadm.gac
where acid=vAcid;
exception
when no_data_found then
null;
end;

BEGIN
select distinct MAIN_CLASSIFICATION_USER 
into non_perform_cd
from tbaadm.acd
where b2k_id = vAcid
and entity_cre_flg = 'Y'
and del_flg = 'N'
and rownum < 2;
Exception
WHEN No_DATA_Found Then
null;
END;

begin
IF (non_perform_cd = '001') THEN
NON_PERFORMING_IND := 'N';
ELSE
NON_PERFORMING_IND := 'Y';
END IF;
end;


begin
IF (vcustType = 'JONT') THEN
Joint_Ind := 'Y';
ELSE
Joint_Ind := 'N';
END IF;
end;

begin
IF (FREEZE_TYPE_CODE is null) THEN
frezCode_ind := 'N';
ELSE
frezCode_ind := 'Y';
END IF;
end;

Begin
select rep_perd_mths + (nvl(rep_perd_days,0)/30) 
into PAYBACK_MONTHS 
from tbaadm.lam lam
where lam.acid = vAcid
and entity_cre_flg='Y'
and del_flg='N';
exception
when no_data_found then
PAYBACK_MONTHS := 0;
End;

Begin
select max(REP_SHDL_DATE)
into LOAN_REPHASEMENT_DTTM
from tbaadm.lam
where lam.acid = vAcid
and entity_cre_flg='Y'
and del_flg='N';
exception
when no_data_found then
LOAN_REPHASEMENT_DTTM := ' ';
End;

Begin
select max(RESHDL_DATE)
into RESTRUCTURE_DTTM
from tbaadm.lrh
where acid = vAcid
and entity_cre_flg='Y'
and del_flg='N';
exception
when no_data_found then
RESTRUCTURE_DTTM := ' ';
End;

Begin
select max(SHDL_NUM)
into LOAN_RESTRUCTURE_CNT
from tbaadm.lrh
where acid = vAcid
and entity_cre_flg='Y'
and del_flg='N';
exception
when no_data_found then
LOAN_RESTRUCTURE_CNT := 0;
End;

Begin
select max(lim_exp_date) 
into MATURITY_DTTM 
from tbaadm.lht
WHERE acid = vAcid
and entity_cre_flg='Y';
exception
when no_data_found then
MATURITY_DTTM := ' ';
end; 

/*
Begin
select INT_TABLE_CODE 
into INTEREST_TYPE_CODE 
from tbaadm.idt
WHERE entity_id = vAcid
and rownum = 1
and entity_cre_flg='Y';
exception
when no_data_found then
null;
end;


Begin
select sum(r.flow_amt)
into INSTALLMENT_AMT_BS1
from tbaadm.lrs r
where acid=vAcid
and (r.flow_id in ('INDEM','PRDEM') OR r.flow_id = 'EIDEM')
and r.shdl_num =(select max(shdl_num) from tbaadm.lrs where acid=vAcid and last_rec_flg='Y')
and r.entity_cre_flg = 'Y';
exception
when no_data_found then
INSTALLMENT_AMT_BS1 := '0.00';
End;


Begin
select max(flow_start_date)
into LOAN_START_DTTM 
from tbaadm.lrs
WHERE acid = vAcid
AND rownum = 1
and entity_cre_flg='Y';
exception
when no_data_found then
LOAN_START_DTTM := ' ';
end;  

Begin
select sum(NUM_OF_FLOWS)
into NUM_OF_REPAY
from tbaadm.lrs
WHERE acid = vAcid
and entity_cre_flg='Y';
exception
when no_data_found then
NUM_OF_REPAY := 0;
end; 

Begin
select lr_freq_type 
into LOAN_PAYMENT_FREQ_CD
from tbaadm.lrs
WHERE acid = vAcid
and rownum = 1
and entity_cre_flg='Y';
exception
when no_data_found then
LOAN_PAYMENT_FREQ_CD := ' ';
end; 

begin
select foracid 
into REPAY_ACCT_NUM
from tbaadm.gam a  
where a.acid = lAcid
and a.entity_cre_flg='Y'
and a.del_flg='N';
exception
when no_data_found then
REPAY_ACCT_NUM := ' ';
end; 

Begin
select l.dis_amt 
into LOAN_APPROVED_AMT 
from tbaadm.lam l
WHERE l.acid = vAcid
and l.entity_cre_flg='Y';
exception
when no_data_found then
LOAN_APPROVED_AMT := 0;
end;

begin
select custom.LOAN_RATE(vAcid)
into intRate
from dual;
exception
when no_data_found then
intRate := '0.00';
end;

begin
if length(SBU_CODE) = 5 then
sbu := substr(SBU_CODE,0,4);
elsif length(SBU_CODE) = 4 then
sbu := substr(SBU_CODE,0,3);
else
sbu := SBU_CODE;
end if;
end;
*/

begin
INSTALLMENT_AMT := INSTALLMENT_AMT_BS1 * vrate;
end;

insert into CUSTOM.MASTER_LOAN_DETAILS_TBL values (RECORD_ID,CUSTOMER_HOST_ID,FINACLE_HOST_ID,ACCOUNT_NUMBER,ACCOUNT_TITLE,PURPOSE_OF_LOAN_CD,PURPOSE_OF_LOAN_TXT,Joint_Ind,SBU_CODE,PRODUCT_GROUP_CD,PRODUCT_CODE,DEBT_TYPE_CD,BRANCH_CODE,STATUS_CODE,STATUS_REASON_TXT,STATUS_DTTM ,DISBURSED_DTTM,ACCOUNT_CLOSE_DTTM,ACCOUNT_OPEN_DTTM,LOAN_START_DTTM,frezCode_ind,ACCOUNT_FROZEN_DTTM,CRNCY_CODE,NON_PERFORMING_IND,MATURITY_DTTM ,LOAN_MORATORIUM_MONTH_NUM,INTEREST_TYPE_CODE,intRate,HAS_BANK_INSURANCE_IND,HAS_COLLATERAL_IND,LOAN_PAYMENT_FREQ_CD,LOAN_APPROVED_AMT,DISBURSED_AMT,NUM_OF_REPAY,PAYBACK_MONTHS,INSTALLMENT_AMT,INSTALLMENT_AMT_BS1,REPAY_ACCT_NUM,LOAN_REPHASEMENT_DTTM,LOAN_REPHASEMENT_REASON_TXT,LOAN_CANCELLATION_DTTM,LOAN_CANCELLATION_REASON,DOWN_PAYMENT_AMT,DISBURSED_AMT,RESTRUCTURE_DTTM,LOAN_RESTRUCTURE_CNT,AMOUNT_OF_LN_RESTRUC,TAKE_OVER_LOAN_IND,TAKE_OVER_LOAN_DTTM,INDIV_MONTHLY_INC_AMT,SYSTEM_SOURCE_CD,LAST_UPDATE_DATE);

end loop;
close replace1;
insert into custom.RecordDetails(select LAST_UPDATE_DATE,'LD01','LOAN DETAILS',count(*),0 from CUSTOM.MASTER_LOAN_DETAILS_TBL group by LAST_UPDATE_DATE);
commit;
End;
/
spool off


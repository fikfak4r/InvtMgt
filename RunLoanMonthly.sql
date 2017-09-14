SET serveroutput on size 1000000
SET verify off
SET feedback off
SET termout off
SET linesize 1000
SET pages 1000
SET pagesize 0
SET trims on
SET numformat 999999999999999.99

exec dbms_output.enable(null);

spool MonthLoan.lst

DECLARE
vAcid varchar2(20);
CUSTOMER_HOST_ID varchar2(15);
ACCOUNT_NUMBER varchar2(20);
FINACLE_HOST_ID varchar2(17);
int_rate NUMBER(9,4);
DISBURSED_AMT NUMBER;
TOTAL_PAID_PRIN_AMT NUMBER;
DISBURSED_DTTM Date;
OVERDUE_DTTM_NUM Date;
LAST_MISSED_INSTALLMENT_DTTM Date;
TERM_IN_MONTHS number;
TOTAL_OUTSTANDING_AMT number;
TOTAL_PRIN_OUTSTANDING_AMT number;
TOTAL_OUTSTANDING_AMT_BS1 number;
TOTAL_PRIN_OUTSTANDING_AMT_BS1 number;
TOTAL_PAID_INTEREST_AMT number;
LAST_PAYMENT_AMT number;
LAST_PAYMENT_AMT_BS1 number;
PAYMENT_HOLIDAY_PERIOD varchar2(15);
NEXT_PAYMENT_AMT number;
INTEREST_AMT number;
int_amt number;
start_date date;
year varchar2(15);
month varchar2(35);
start_dttm1 varchar2(20);
end_dttm1 varchar2(20);
start_dttm varchar2(15); ---:= '01-aug-2016'; --to_date('&&1','dd-mm-yyyy'); 
end_dttm varchar2(15); ---:= '31-aug-2016'; --to_date('&&1','dd-mm-yyyy');
LAST_PAYMENT_DATE DATE;
NEXT_PAYMENT_DUE_DATE DATE;
NEXT_INT_DUE_DATE DATE;
ACCRUED_CHARGES_OTHER_AMT 	number := '0.00';
ACCRUED_INTEREST_AMT  		number;
DELINQUENT_AMT				number;
TOTAL_PASTDUE_AMT			number;
NEXT_PAYMENT_DATE			DATE;
NEXT_INT_DATE			DATE;
DEBIT_DATE					DATE;
Total_debited				number;
Principal					number;
Interest					number;
vcrncy					varchar2(15);
vrate					number;
SOURCE_SYSTEM_CD			varchar2(15);
TOTAL_PRIN_AMT              number; 
NON_TRANSACTIVE_IND       varchar2(50);
TOTAL_DEBIT_MOVEMENT		number;
TOTAL_DEBIT_MOVEMENT_BS1	number;
TOTAL_CREDIT_MOVEMENT		number;
TOTAL_CREDIT_MOVEMENT_BS1	number;
LOAN_IND			varchar2(15);
LAST_BALLOON_PAYMENT_DTTM	DATE;
ACCRUED_INT_INCOME_AMT		NUMBER := '0.00';
ACCRUED_INT_INCOME_AMT_BS1	NUMBER := '0.00';
ACCRUED_CHARGES_AMT		NUMBER;
ACCRUED_CHARGES_AMT_BS1		NUMBER;
TAKE_OVER_LOAN_IND		varchar2(15);
TAKE_OVER_LOAN_DTTM		DATE;
TOTAL_DEBIT_CNT 		NUMBER;
TOTAL_CREDIT_CNT		NUMBER;
ACCRUED_LOAN_FEES_AMT		NUMBER := '0.00';
ACCRUED_LOAN_FEES_AMT_BS1	NUMBER := '0.00';
TOTAL_PAID_AMT			NUMBER;
DISBURSED_AMT_BS1		NUMBER;
TOTAL_PAID_AMT_BS1		NUMBER;
TOTAL_PAID_PRIN_AMT_BS1		NUMBER;
INTEREST_AMT_BS1		NUMBER;
ACCRUED_CHG_OTH_AMT_BS1		NUMBER := '0.00';
ACCRUED_INT_AMT_BS1		NUMBER;
TOTAL_PASTDUE_AMT_BS1		NUMBER;
TOTAL_PAID_INT_AMT_BS1		NUMBER;
TOTAL_PRIN_AMT_BS1			NUMBER;
TOTAL_PASTDUE_INSTALL_CNT 	NUMBER;
LAST_INT_INSTALL_BS1			NUMBER;
LAST_PRIN_INSTALL_BS1		NUMBER;
LAST_CHRG_INSTALL_BS1		NUMBER;
LAST_PRIN_INSTALL		NUMBER;
LAST_INT_INSTALL		NUMBER;
LAST_CHRG_INSTALL		NUMBER;
ForeClosureCharge			NUMBER;
PendingAdvisoryFee		NUMBER;
PendingInterestDemand		NUMBER;
PrincipalOutstanding		NUMBER;
LatePaymentPenalFee		NUMBER;
CurrentAccruedInterest		NUMBER;


cursor loandt is 
select distinct g.acid,g.foracid ACCOUNT_NUMBER,g.cif_id CUSTOMER_HOST_ID,g.cif_id FINACLE_HOST_ID,round((l.rep_perd_mths + (nvl(l.rep_perd_days,0)/30)),1) TERM_IN_MONTHS,
(l.DIS_AMT*c.var_crncy_units) DISBURSED_AMT,l.DIS_AMT DISBURSED_AMT_BS1,l.DIS_SHDL_DATE DISBURSED_DTTM,g.acct_crncy_code,g.clr_bal_amt*-1,
l.CUM_NORM_INT_AMT INTEREST_AMT_BS1,(l.CUM_NORM_INT_AMT*c.var_crncy_units) INTEREST_AMT,'FIN001' SOURCE_SYSTEM_CD,c.var_crncy_units vrate,
(select db_stat_date from tbaadm.gct) start_date,
(SELECT EXTRACT(YEAR FROM TO_DATE(TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, -1))))) FROM dual) year,
(select to_char(to_date(TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, -1)))), 'Month') from dual) month,
(select custom.LOAN_RATE(g.acid) from dual) int_rate,
(select max(last_adj_date) from tbaadm.ldt where acid = g.acid and dmd_date between (SELECT TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM') FROM DUAL) and (SELECT TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, -1)))  FROM DUAL)) LAST_PAYMENT_DATE,
(SELECT count(*) FROM TBAADM.HTD WHERE acid = g.acid AND part_tran_type = 'D' AND tran_date between (SELECT TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM') FROM DUAL) and (SELECT TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, -1)))  FROM DUAL) AND del_flg ='N' and pstd_flg = 'Y') TOTAL_DEBIT_CNT,
(SELECT count(*) FROM TBAADM.HTD WHERE acid = g.acid AND part_tran_type = 'C' AND tran_date between (SELECT TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM') FROM DUAL) and (SELECT TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, -1)))  FROM DUAL) AND del_flg ='N' and pstd_flg = 'Y') TOTAL_CREDIT_CNT,
(SELECT nvl(sum(tran_amt),0) FROM TBAADM.HTD WHERE acid = g.acid AND part_tran_type = 'C' AND tran_date between (SELECT TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM') FROM DUAL) and (SELECT TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, -1)))  FROM DUAL) AND del_flg ='N' and pstd_flg = 'Y') TOTAL_CREDIT_MOVEMENT_BS1,
(SELECT nvl(sum(tran_amt),0) FROM TBAADM.HTD WHERE acid = g.acid AND part_tran_type = 'D' AND tran_date between (SELECT TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM') FROM DUAL) and (SELECT TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, -1)))  FROM DUAL) AND del_flg ='N' and pstd_flg = 'Y') TOTAL_DEBIT_MOVEMENT_BS1,
(select max(DMD_EFF_DATE) from tbaadm.ldt where acid = g.acid and (LAST_ADJ_DATE is null or LAST_ADJ_DATE > DMD_OVDU_DATE)) LAST_MISSED_INSTALLMENT_DTTM,
(select nvl(sum(tran_amt),0) from tbaadm.htd where acid = g.acid and value_date in (select max(value_date) from TBAADM.htd where acid = g.acid) and tran_particular like '%Repayment%' and tran_date between (SELECT TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM') FROM DUAL) and (SELECT TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, -1)))  FROM DUAL)) LAST_PAYMENT_AMT_BS1,
(select nvl(sum(dmd_amt),0) from tbaadm.ldt where acid = g.acid and dmd_flow_id = 'PNDEM' and dmd_date between (SELECT TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM') FROM DUAL) and (SELECT TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, -1)))  FROM DUAL)) ACCRUED_CHARGES_AMT_BS1,
(select max(DMD_OVDU_DATE) from tbaadm.ldt where acid = g.acid and dmd_date between (SELECT TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM') FROM DUAL) and (SELECT TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, -1)))  FROM DUAL)) OVERDUE_DTTM_NUM, 
(select nvl(sum(NRML_ACCRUED_AMOUNT_DR),0) from tbaadm.eit where entity_id = g.acid and entity_type='ACCNT') ACCRUED_INT_AMT_BS1,
(select nvl(sum(r.flow_amt),0) from tbaadm.lrs r where acid=g.acid and (r.flow_id = 'EIDEM' or r.flow_id in ('INDEM','PRDEM')) and r.shdl_num =(select max(shdl_num) from tbaadm.lrs where acid=g.acid and last_rec_flg='Y') and r.flow_amt > 0 and r.del_flg = 'N' and r.entity_cre_flg = 'Y') NEXT_PAYMENT_AMT,
(select max(LR_FREQ_HLDY_STAT) from tbaadm.lrs where acid=g.acid and del_flg = 'N' and entity_cre_flg = 'Y' and next_dmd_date BETWEEN (SELECT TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM') FROM DUAL) and (SELECT TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, -1)))  FROM DUAL)) PAYMENT_HOLIDAY_PERIOD,
(select nvl(sum(dmd_amt * decode(dmd_flow_id,'PRDEM',1,0)),0) from tbaadm.ldt where acid = g.acid and dmd_date between (SELECT TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM') FROM DUAL) and (SELECT TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, -1)))  FROM DUAL)) TOTAL_PAID_PRIN_AMT_BS1,
(select nvl(sum(dmd_amt * decode(dmd_flow_id,'INDEM',1,0)),0) from tbaadm.ldt where acid =g.acid and dmd_date between (SELECT TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM') FROM DUAL) and (SELECT TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, -1)))  FROM DUAL)) TOTAL_PAID_INT_AMT_BS1,
(select nvl(sum(dmd_amt),0) from tbaadm.ldt where acid = g.acid and tot_adj_amt = 0 and dmd_date between (SELECT TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM') FROM DUAL) and (SELECT TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, -1)))  FROM DUAL)) DELINQUENT_AMT,
(select nvl(sum(dmd_amt),0) from tbaadm.ldt where acid = g.acid and DMD_OVDU_DATE < (select db_stat_date from tbaadm.gct) and dmd_date between (SELECT TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM') FROM DUAL) and (SELECT TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, -1)))  FROM DUAL)) TOTAL_PASTDUE_AMT_BS1,
(select max(next_dmd_date) from tbaadm.lrs where acid = g.acid and del_flg = 'N' and entity_cre_flg = 'Y') NEXT_PAYMENT_DATE,
(select max(next_int_dmd_date) from tbaadm.lrs where acid = g.acid and del_flg = 'N' and entity_cre_flg = 'Y') NEXT_INT_DATE,
(select max(next_int_dmd_date)+10 from tbaadm.lrs where acid = g.acid and del_flg = 'N' and entity_cre_flg = 'Y') NEXT_INT_DUE_DATE,
(select max(next_dmd_date)+10 from tbaadm.lrs where acid = g.acid and del_flg = 'N') NEXT_PAYMENT_DUE_DATE,(SELECT TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, -1)))  FROM DUAL),
(select distinct count(*) from tbaadm.ldt where acid = g.acid and (LAST_ADJ_DATE is null or LAST_ADJ_DATE > DMD_OVDU_DATE)) TOTAL_PASTDUE_INSTALL_CNT
from (select distinct fxd_crncy_code,var_crncy_units from tbaadm.rth where var_crncy_code = 'NGN' and ratecode = (select report_rate_code from tbaadm.gct)
and rtlist_date=(select max(rtlist_date) from tbaadm.rth x where tbaadm.rth.ratecode=x.ratecode and tbaadm.rth.fxd_crncy_code=x.fxd_crncy_code and tbaadm.rth.var_crncy_code=x.var_crncy_code
and rtlist_date >=to_date((SELECT TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM') FROM DUAL)) and rcre_time=(select max(rcre_time) from tbaadm.rth y where x.ratecode=y.ratecode and x.fxd_crncy_code=y.fxd_crncy_code and x.var_crncy_code=y.var_crncy_code
and y.rtlist_date >= to_date((SELECT TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM') FROM DUAL)))) union all select 'NGN', 1 from dual) c,tbaadm.gam g,tbaadm.lam l
where g.acid = l.acid
and g.del_flg = 'N'
and l.del_flg = 'N'
and g.acct_crncy_code = c.fxd_crncy_code
and l.entity_cre_flg = 'Y'
and g.entity_cre_flg = 'Y'
and g.foracid not like 'ZZ%'
and g.acct_opn_date <= (select TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, -1))) FROM DUAL)
and (g.acct_cls_date is null or g.acct_cls_date between (select TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, -2))) FROM DUAL) and (select TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, -1))) FROM DUAL))
group by g.acid,g.foracid,g.cust_id,g.cif_id,(l.rep_perd_mths + (nvl(l.rep_perd_days,0)/30)),l.DIS_AMT,(l.DIS_AMT*c.var_crncy_units),l.DIS_SHDL_DATE,
g.acct_crncy_code,g.clr_bal_amt,l.CUM_NORM_INT_AMT,(l.CUM_NORM_INT_AMT*c.var_crncy_units),c.var_crncy_units;

BEGIN

--begin
--delete CUSTOM.LOAN_MONTHLY_TBL;
--commit;
 --end;

open loandt;
loop
FETCH loandt into vAcid, ACCOUNT_NUMBER, CUSTOMER_HOST_ID, FINACLE_HOST_ID, TERM_IN_MONTHS, DISBURSED_AMT,DISBURSED_AMT_BS1,DISBURSED_DTTM,vcrncy,TOTAL_PRIN_OUTSTANDING_AMT_BS1,
INTEREST_AMT_BS1,INTEREST_AMT,SOURCE_SYSTEM_CD,vrate,start_date,year,month,int_rate,LAST_PAYMENT_DATE,TOTAL_DEBIT_CNT,TOTAL_CREDIT_CNT,TOTAL_CREDIT_MOVEMENT_BS1,TOTAL_DEBIT_MOVEMENT_BS1,
LAST_MISSED_INSTALLMENT_DTTM,LAST_PAYMENT_AMT_BS1,ACCRUED_CHARGES_AMT_BS1,OVERDUE_DTTM_NUM,ACCRUED_INT_AMT_BS1,NEXT_PAYMENT_AMT,PAYMENT_HOLIDAY_PERIOD,TOTAL_PAID_PRIN_AMT_BS1,TOTAL_PAID_INT_AMT_BS1,
DELINQUENT_AMT,TOTAL_PASTDUE_AMT_BS1,NEXT_PAYMENT_DATE,NEXT_INT_DATE,NEXT_INT_DUE_DATE,NEXT_PAYMENT_DUE_DATE,end_dttm,TOTAL_PASTDUE_INSTALL_CNT;
exit when loandt%notfound;

begin
select nvl(sum(TOT_ADJ_AMT),0)
into LAST_CHRG_INSTALL_BS1
from tbaadm.ldt 
where acid = vAcid 
and last_adj_date in (select max(last_adj_date) from TBAADM.ldt where acid = vAcid and dmd_flow_id = 'PNDEM')
and last_adj_date is not null 
and dmd_flow_id = 'PNDEM';
exception
when no_data_found then
LAST_CHRG_INSTALL_BS1 := 0;
end;

begin
select nvl(sum(TOT_ADJ_AMT),0) 
into LAST_INT_INSTALL_BS1
from tbaadm.ldt 
where acid = vAcid 
and last_adj_date in (select max(last_adj_date) from TBAADM.ldt where acid = vAcid and dmd_flow_id = 'INDEM')
and last_adj_date is not null 
and dmd_flow_id = 'INDEM';
exception
when no_data_found then
LAST_INT_INSTALL_BS1 := 0;
end;

begin
select case when months_between (sysdate,ADD_MONTHS( acct_opn_date, 1 )) <=6 then 0.04 * abs(clr_bal_amt)
when months_between (sysdate,ADD_MONTHS( acct_opn_date, 1 ))  between 6 and 18 then 0.02 * abs(clr_bal_amt)
when months_between (sysdate,ADD_MONTHS( acct_opn_date, 1 ))  > 18 then 0.01 * abs(clr_bal_amt)
end as ForeClosureCharge,
abs(clr_bal_amt) PrincipalOutstanding, 
(select nvl(sum(dmd_amt)-sum(tot_adj_amt),0) from tbaadm.ldt where acid = (select acid from tbaadm.gam where foracid = g.foracid) and del_flg = 'N' and dmd_flow_id = 'INDEM')  PendingInterestDemand, 
(select nvl(sum(dmd_amt)-sum(tot_adj_amt),0) from tbaadm.ldt where acid = (select acid from tbaadm.gam where foracid = g.foracid) and del_flg = 'N' and dmd_flow_id = 'PNDEM')  LatePaymentPenalFee,
(select  nvl((SUM(ADVFEE + VAT)),0)  from custom.advfeesp where loanacct = ACCOUNT_NUMBER and process_flg not in ('Y','N')) PendingAdvisoryFee,
(PENAL_BOOKED_AMOUNT_DR - PENAL_INTEREST_AMOUNT_DR) + (NRML_BOOKED_AMOUNT_DR - NRML_INTEREST_AMOUNT_DR) CurrentAccruedInterest
into ForeClosureCharge,PrincipalOutstanding,PendingInterestDemand,LatePaymentPenalFee,PendingAdvisoryFee,CurrentAccruedInterest
from tbaadm.eit, tbaadm.gam g
where g.foracid = ACCOUNT_NUMBER
and eit.entity_id = g.acid
group by g.acid,foracid,acct_opn_date,acct_name,clr_bal_amt,LAST_INT_DR_TRAN_DATE,PENAL_BOOKED_AMOUNT_DR,PENAL_INTEREST_AMOUNT_DR,NRML_BOOKED_AMOUNT_DR,NRML_INTEREST_AMOUNT_DR;
exception
when no_data_found then
ForeClosureCharge := 0;
PrincipalOutstanding := 0;
PendingInterestDemand := 0;
LatePaymentPenalFee := 0;
CurrentAccruedInterest := 0;
end;

begin
select nvl(sum(TOT_ADJ_AMT),0)
into LAST_PRIN_INSTALL_BS1 
from tbaadm.ldt 
where acid = vAcid 
and last_adj_date in (select max(last_adj_date) from TBAADM.ldt where acid = vAcid and dmd_flow_id = 'PRDEM')
and last_adj_date is not null 
and dmd_flow_id = 'PRDEM';
exception
when no_data_found then
LAST_PRIN_INSTALL_BS1 := 0;
end;

begin
if (NEXT_INT_DATE > NEXT_PAYMENT_DATE) then
NEXT_PAYMENT_DATE := NEXT_INT_DATE;
else
NEXT_PAYMENT_DATE := NEXT_PAYMENT_DATE;
end if;
end;

begin
if (NEXT_INT_DUE_DATE > NEXT_PAYMENT_DUE_DATE) then
NEXT_PAYMENT_DUE_DATE := NEXT_INT_DUE_DATE;
else
NEXT_PAYMENT_DUE_DATE := NEXT_PAYMENT_DUE_DATE;
end if;
end;

begin
if (TOTAL_CREDIT_CNT = 0 and TOTAL_DEBIT_CNT = 0) then
NON_TRANSACTIVE_IND := 'Y';
else
NON_TRANSACTIVE_IND := 'N';
end if;
end;

begin
if (DELINQUENT_AMT > 0) then
LOAN_IND := 'Y';
else
LOAN_IND := 'N';
end if;
end;

begin
TOTAL_PAID_AMT_BS1 := DISBURSED_AMT - TOTAL_OUTSTANDING_AMT;
TOTAL_CREDIT_MOVEMENT := TOTAL_CREDIT_MOVEMENT_BS1 * vrate;
TOTAL_PAID_AMT := (DISBURSED_AMT - TOTAL_OUTSTANDING_AMT) * vrate;
TOTAL_PAID_PRIN_AMT := TOTAL_PAID_PRIN_AMT_BS1 * vrate;
TOTAL_OUTSTANDING_AMT_BS1 := round((ForeClosureCharge + PrincipalOutstanding + PendingInterestDemand + LatePaymentPenalFee + PendingAdvisoryFee + CurrentAccruedInterest),2);
TOTAL_OUTSTANDING_AMT := round(((ForeClosureCharge + PrincipalOutstanding + PendingInterestDemand + LatePaymentPenalFee + PendingAdvisoryFee + CurrentAccruedInterest) * vrate),2);
TOTAL_PRIN_OUTSTANDING_AMT := TOTAL_PRIN_OUTSTANDING_AMT_BS1 * vrate;
TOTAL_PAID_INTEREST_AMT := TOTAL_PAID_INT_AMT_BS1 * vrate;
TOTAL_DEBIT_MOVEMENT := TOTAL_DEBIT_MOVEMENT_BS1 * vrate;
ACCRUED_CHARGES_AMT := ACCRUED_CHARGES_AMT_BS1 * vrate;
ACCRUED_INTEREST_AMT := ACCRUED_INT_AMT_BS1 * vrate;
TOTAL_PASTDUE_AMT := TOTAL_PASTDUE_AMT_BS1 * vrate;
TOTAL_PRIN_AMT := TOTAL_PRIN_AMT_BS1 * vrate;
LAST_PAYMENT_AMT := LAST_PAYMENT_AMT_BS1 * vrate;
LAST_PRIN_INSTALL := LAST_PRIN_INSTALL_BS1 * vrate;
LAST_INT_INSTALL := LAST_INT_INSTALL_BS1 * vrate;
LAST_CHRG_INSTALL := LAST_CHRG_INSTALL_BS1 * vrate;
end;

insert into CUSTOM.LOAN_MONTHLY_TBL values (CUSTOMER_HOST_ID,FINACLE_HOST_ID,ACCOUNT_NUMBER,TERM_IN_MONTHS,DISBURSED_AMT,DISBURSED_AMT_BS1,
DISBURSED_DTTM,TOTAL_PASTDUE_AMT,TOTAL_PASTDUE_AMT_BS1,INTEREST_AMT,INTEREST_AMT_BS1,year,month,
TOTAL_OUTSTANDING_AMT,TOTAL_OUTSTANDING_AMT_BS1,TOTAL_PRIN_OUTSTANDING_AMT,TOTAL_PRIN_OUTSTANDING_AMT_BS1,TOTAL_PAID_PRIN_AMT,
TOTAL_PAID_PRIN_AMT_BS1,TOTAL_PAID_INTEREST_AMT,TOTAL_PAID_INT_AMT_BS1,end_dttm,int_rate,LAST_MISSED_INSTALLMENT_DTTM,
TOTAL_PAID_AMT,TOTAL_PAID_AMT_BS1,LAST_PAYMENT_AMT,LAST_PAYMENT_AMT_BS1,PAYMENT_HOLIDAY_PERIOD,NEXT_PAYMENT_AMT,
OVERDUE_DTTM_NUM,LAST_PAYMENT_DATE,ACCRUED_CHARGES_OTHER_AMT,ACCRUED_CHG_OTH_AMT_BS1,ACCRUED_INTEREST_AMT,TOTAL_PASTDUE_INSTALL_CNT,
ACCRUED_INT_AMT_BS1,DELINQUENT_AMT,NEXT_PAYMENT_DATE,TOTAL_DEBIT_MOVEMENT,TOTAL_DEBIT_MOVEMENT_BS1,TOTAL_CREDIT_MOVEMENT,
TOTAL_CREDIT_MOVEMENT_BS1,LOAN_IND,LAST_BALLOON_PAYMENT_DTTM,ACCRUED_INT_INCOME_AMT,ACCRUED_INT_INCOME_AMT_BS1,
ACCRUED_CHARGES_AMT,ACCRUED_CHARGES_AMT_BS1,TAKE_OVER_LOAN_IND,TAKE_OVER_LOAN_DTTM,TOTAL_DEBIT_CNT,TOTAL_CREDIT_CNT,
NEXT_PAYMENT_DUE_DATE,ACCRUED_LOAN_FEES_AMT,ACCRUED_LOAN_FEES_AMT_BS1,NON_TRANSACTIVE_IND,SOURCE_SYSTEM_CD,end_dttm,
LAST_PRIN_INSTALL,LAST_PRIN_INSTALL_BS1,LAST_INT_INSTALL,LAST_INT_INSTALL_BS1,LAST_CHRG_INSTALL,LAST_CHRG_INSTALL_BS1);

end loop;
close loandt;
commit;
End;
/
spool off
exit


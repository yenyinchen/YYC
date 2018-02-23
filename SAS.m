CP + carma + prism

proc sql;
create table jury_cap as 
select 
APLCTN_RTNTN_NB,
POLICYNUMBER,
UNIQUEPLACEMENTCOUNT,
case when UNIQUEPLACEMENTCOUNT in ("1","2") then "1-2"
     when UNIQUEPLACEMENTCOUNT = "3" then "3"
	 when UNIQUEPLACEMENTCOUNT in ("4", "5", "6", "7", "8", "9", "10", "11", "12", "15", "17") then "4+"
	 else "NULL" end as Jury_group,
EFFECTIVEDATE,
COUNTS,
EE,
IL,
case when IL <25000 then IL
else 25000 end as IL_cap,
EP,
COUNTS_PD,
EE_PD,
EP_PD,
IL_PD,
case when IL_PD <25000 then IL_PD
else 25000 end as IL_PDcap,
COUNTS_PIP,
EE_PIP,
IL_PIP,
case when IL_PIP <25000 then IL_PIP
else 25000 end as IL_PIPcap,
EP_PIP,
CAT_IL,
case when CAT_IL <25000 then CAT_IL
else 25000 end as CAT_ILcap,
RTD_ST_CD,
ACNTG_BGN_DT,
APLCTN_RTNTN_SQNC_KY,
PLCY_CMPNY_CD,
RTD_TR_CD,
MDL_DSPSTN_CD,
Current_dspstn,
Current_dspstn2,
case when MDL_DSPSTN_CD ='DP1' then 1
     when MDL_DSPSTN_CD = 'NOA' then 0
     else . end as DP1_hit,
case when Current_dspstn2 ='DP1' then 1
     when Current_dspstn2 = 'NOA' then 0
     else . end as DP1_hit_rescore,
MDL_DSPSTN_DT,

TTL_SCR_WT1_NB,
TTL_SCR_WT2_NB,
Current_Scr1,
Current_Scr2,

RSK_SGMT_CD,
INTL_APLCTN_SRC_CD,
APLCTN_SRC_CD,
STRIKE_CT,
INVALID_CURR_INS_X,
NONE_NEEDED_X,
CUSTOM_X,
LEN_LOSS_X,
CREDIT_X,
VINPREFILL_X,
PIPLOSS_X,
INVALID_VIN_X,
JURY_X,
BRDTITLE_X,
TITLETRANS_X,
POTDAMDT_X,
OTHERPROBLEM_X,
SLS_KY,
QT_ST,
last_st,
QT_DT,
last_dt,
MDS_DT,
QT_PRM_AM,
last_prm,
TTL_PRM_AM,
lst_qt_increase,
bound_increase,

education,
yr_licensed,
No_of_vhcl,
Occupation,
Current_Insurance,
No_at_fault_accident,
No_convictions,
No_occurence,
yr_current_insurence,
No_drvr
from jury_v1
;
quit;

proc contents order=varnum data=jury_cap out=meta (keep=name);
run;



/*=================================================================*/
/*                     Group by Jury Group                         */
/*=================================================================*/
PROC SQL;
select 
sum(il_cap)/sum(ep) 
,sum(il)/sum(ep) 
,sum(counts_pd)/sum(ee_pd)
,sum(counts_pip)/sum(ee_pip)
,sum(ep)
into 
:LR_cap_totalaverage
, :LR_totalaverage
, :PD_Freq_total
, :PIP_Freq_total 
, :total_EP
from jury_cap
;
quit;

%Put &LR_cap_totalaverage; /*0.648874*/
%put &LR_totalaverage;     /*0.775974*/
%Put &PD_Freq_total;
%Put &PIP_Freq_total;




/*---------------------------------------------------------------------------------*/
/*                 By group                                                        */
/*----------------------------------------------------------------------------------*/
proc sql;
create table strike_group_cap as
select Jury_group, count(APLCTN_RTNTN_NB) as rtntn_count

, sum(EP) as total_premium format Dollar12.0
, sum(EP)/&total_EP as EP_percent
, sum(IL) as IL
, sum(EP) as EP
, sum(IL)/sum(EP) as LR  
/*, calculated LR/ &LR_totalaverage as LRR  */
, sum(IL_cap)/sum(EP) as LR_cap  
/*, calculated LR_cap/ &LR_cap_totalaverage as LRR_cap */

, sum(IL_PD) /sum(EP_PD) as PD_LR
, sum(IL_PDcap) /sum(EP_PD) as PD_LR_cap

, sum(IL_PIP) / sum(EP_PIP) as PIP_LR
, sum(IL_PIPcap) / sum(EP_PIP) as PIP_LR_cap

, sum(EE) as EE
, calculated EE/ calculated rtntn_count as EE_RtntnCount_Ratio

, SUM(EE_PD) as EE_PD
, calculated EE_PD/ calculated rtntn_count as EEPD_RtntnCount_Ratio
, SUM(EE_PD)/sum(EE) as EEPD_EE_Ratio

, sum(EE_PIP) as EE_PIP 
, calculated EE_PIP/ calculated rtntn_count as EEPIP_RtntnCount_Ratio
, SUM(EE_PIP)/sum(EE) as EEPIP_EE_Ratio

, sum(COUNTS_PD)/sum(EE_PD) as PD_freq 
, calculated PD_freq/ &PD_Freq_total AS PD_Relativity 
, sum(counts_PIP)/sum(EE_PIP) as PIP_freq 
, calculated PIP_freq/ &PIP_Freq_total as PIP_Relativity 
, median(ttl_scr_wt1_nb) as median_score1
, median(ttl_scr_wt2_nb) as median_score2
, avg(ttl_scr_wt1_nb) as avg_score_1 
, avg(ttl_scr_wt2_nb) as avg_score_2 

/*----DP1 group ---*/
, avg( MDL_DSPSTN_CD ='DP1') as DP1_percent
, avg( Current_dspstn2 ='DP1') as DP1_rescore_percent

, avg( INTL_APLCTN_SRC_CD='ANBA') as ANBA_percent 
, avg( INTL_APLCTN_SRC_CD='MAIS') as MAIS_percent 

/*----Risk group ---*/
, avg(RSK_SGMT_CD = "B") as B_percent
, avg(RSK_SGMT_CD = "C") as C_percent
, avg(RSK_SGMT_CD = "D") as D_percent
, avg(RSK_SGMT_CD = "NULL") as NULL_percent

/*----Premium ---*/
, avg(qt_st = last_st) as state_chng 

, sum(QT_PRM_AM) / sum(LAST_PRM) as frst_last_qt 
, sum(LAST_PRM) / sum(TTL_PRM_AM) as lst_mds_qt  

, median( last_dt - qt_dt) as med_diff_lst_first
, median( mds_dt - last_dt ) as med_diff_mds_last
, avg(last_dt - qt_dt) as avg_diff_lst_first
, avg( mds_dt - last_dt ) as avg_diff_mds_last

, sum(QT_PRM_AM) /  calculated rtntn_count as AVG_FrstQuotePremium
, sum(last_prm) /  calculated rtntn_count as AVG_LstQuotePremium
, sum(TTL_PRM_AM) /  calculated rtntn_count as AVG_MdsPremium

/*----CP Strike ---*/
,avg(strike_ct) as strk_ct

,avg(input(invalid_curr_ins_X, 7.2)) as invalid_curr_ins_X 
,avg(input(none_needed_X, 7.2)) as none_needed_X  
,avg(input(custom_X, 7.2)) as custom_X  
,avg(input(len_loss_X, 7.2)) as len_loss_X  
,avg(input(credit_X, 7.2)) as credit_X  
,avg(input(vinprefill_X, 7.2)) as vinprefill_X  
,avg(input(piploss_X, 7.2)) as piploss_X 
,avg(input(invalid_vin_X, 7.2)) as invalid_vin_X  
,avg(input(brdtitle_X, 7.2)) as brdtitle_X  
,avg(input(titletrans_X, 7.2)) as titletrans_X  
,avg(input(potdamdt_X, 7.2)) as potdamdt_X  
,avg(input(otherproblem_X, 7.2)) as otherproblem_X  
/*----------------*/



/* CARMA */
, avg(education>1) as edu_chng 
, avg(yr_licensed>1) as yr_licnese_chng 
, avg(No_of_vhcl>1) as no_of_vhcl_chng 
, avg(Occupation>1) as occupation_chng 
, avg(Current_Insurance>1) as current_insurance_chng 
, avg(No_at_fault_accident>1) as No_at_fault_accident_chng 
, avg(No_convictions>1) as No_convictions_chng
, avg(No_occurence>1) as No_occurence_chng 
, avg(yr_current_insurence>1) as yr_current_insurence_chng 
, avg(No_drvr>1) as no_drvr_chng 


/*, avg(education>2) as edu_chng2*/
/*, avg(yr_licensed>2) as yr_licnese_chng2 */
/*, avg(No_of_vhcl>2) as no_of_vhcl_chng2 */
/*, avg(Occupation>2) as occupation_chng2 */
/*, avg(Current_Insurance>2) as current_insurance_chng2 */
/*, avg(No_at_fault_accident>2) as No_at_fault_accident_chng2 */
/*, avg(No_convictions>2) as No_convictions_chng2*/
/*, avg(No_occurence>2) as No_occurence_chng2 */
/*, avg(yr_current_insurence>2) as yr_current_insurence_chng2 */
/*, avg(No_drvr>2) as no_drvr_chng2 */
from jury_cap   /*jury_group_cap*/
group by Jury_group
;
quit;

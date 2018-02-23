CP + carma + prism
/*---------------------------*/
/*1 jury sas pull            */
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



/*-------------------------------------------*/
/* 2. R part                                 */
/*------------------------------------------*/

#1 LR vs avg score1
ggplot(data = Q) + geom_point(mapping = aes(x=avg_score_1, y=LR, color=Jury_group  ))
ggplot(Q , 
       aes(x=avg_score_1, y=LR, color=Jury_group  ))  + 
  geom_point(size=4) + 
  theme(axis.title = element_text(size=16, colour="darkred"), 
        axis.text = element_text(size=14, colour="blue")) + 
#  scale_y_continuous(limits = c(0,1.2), breaks=seq(0,1.2,0.15) ) +
  scale_x_continuous(limits = c(0,60), breaks=seq(0,60,10) ) +
  theme( plot.title = element_text(color="black", size=21, face="bold"),
         legend.text = element_text(size =14)) +
  theme(legend.title = element_text(size = 14)) + 
ggtitle("avg score1 vs LR")
#2 PD_LR vs PIP_LR
ggplot(data = Q) + geom_point(mapping = aes(x=PD_LR, y=PIP_LR, color=Jury_group  ))
ggplot(Q , 
       aes(x=PD_LR, y=PIP_LR, color=Jury_group  ))  + 
  geom_point(size=4) + 
  theme(axis.title = element_text(size=16, colour="darkred"), 
        axis.text = element_text(size=14, colour="blue")) + 
  scale_y_continuous(limits = c(0,1.2)  ) +
  scale_x_continuous(limits = c(0,0.8)  ) +
  theme( plot.title = element_text(color="black", size=21, face="bold"),
         legend.text = element_text(size =14)) +
  theme(legend.title = element_text(size = 14)) + 
  ggtitle("PIP_LR vs PD_LR")

#3 PD_freq vs PIP_freq
ggplot(data = Q) + geom_point(mapping = aes(x=PD_freq, y=PIP_freq, color=Jury_group  ))
ggplot(Q , 
       aes(x=PD_freq, y=PIP_freq, color=Jury_group  ))  + 
  geom_point(size=4) + 
  theme(axis.title = element_text(size=16, colour="darkred"), 
        axis.text = element_text(size=14, colour="blue")) + 
  scale_y_continuous(limits = c(0,0.07)  ) +
  scale_x_continuous(limits = c(0,0.09)  ) +
  theme( plot.title = element_text(color="black", size=21, face="bold"),
         legend.text = element_text(size =14)) +
  theme(legend.title = element_text(size = 14)) + 
  ggtitle("PD_freq vs PIP_freq")


#4 LR vs DP1_percent
ggplot(data = Q) + geom_point(mapping = aes(x=DP1_percent, y=LR, color=Jury_group  ))

ggplot(Q , 
       aes(x=DP1_percent, y=LR, color=Jury_group  ))  + 
  geom_point(size=4) + 
  theme(axis.title = element_text(size=16, colour="darkred"), 
        axis.text = element_text(size=13, colour="blue")) + 
  scale_y_continuous(limits = c(0,1.2)  ) +
  scale_x_continuous(limits = c(0,0.0002)  ) +
  theme( plot.title = element_text(color="black", size=21, face="bold"),
         legend.text = element_text(size =14)) +
  theme(legend.title = element_text(size = 14)) + 
  ggtitle("LR vs DP1_percent")

#5 avg_score_1 vs avg_score_2
ggplot(data = Q) + geom_point(mapping = aes(x=avg_score_1, y=avg_score_2, color=Jury_group  ))
ggplot(Q , 
       aes(x=avg_score_1, y=avg_score_2, color=Jury_group  ))  + 
  geom_point(size=4) + 
  theme(axis.title = element_text(size=16, colour="darkred"), 
        axis.text = element_text(size=13, colour="blue")) + 
  scale_y_continuous(limits = c(-50,0)  ) +
  scale_x_continuous(limits = c(0,60)  ) +
  theme( plot.title = element_text(color="black", size=21, face="bold"),
         legend.text = element_text(size =14)) +
  theme(legend.title = element_text(size = 14)) + 
  ggtitle("avg_score_1 vs avg_score_2")



#===================================================================#
# Section 1B 3Q16~3Q17 Stike
#===================================================================#
x <- read.xlsx("\\\\chnas01\\URC\\URC-Private\\Fraud\\USERS\\Yen-Yin\\Jury count_OCT2017\\raw_j.xlsx",  sheetName = "whole")
x <- fread("\\\\chnas01\\URC\\URC-Private\\Fraud\\USERS\\Yen-Yin\\Jury count_OCT2017\\STRIKE_GROUP_CAP.csv", sep = ",", header= TRUE)

names(x)
#1 LR vs avg score1
#1-A LR
ggplot(x ,aes(x=avg_score_1, y=LR, color=Jury_group  ))  + 
  geom_point(size=4) + 
  theme(axis.title = element_text(size=16, colour="darkred"), 
        axis.text = element_text(size=14, colour="blue")) + 
  theme( plot.title = element_text(color="black", size=21, face="bold"),
         legend.text = element_text(size =14)) +
  theme(legend.title = element_text(size = 14)) + 
  ggtitle("avg score1 vs LR")

ggplot(x , 
       aes(x=avg_score_1, y=LR, color=Jury_group  ))  + 
  geom_point(size=4) + 
  theme(axis.title = element_text(size=16, colour="darkred"), 
        axis.text = element_text(size=14, colour="blue")) + 
  scale_y_continuous(limits = c(0,1.0), breaks=seq(0,1.0,0.1) ) +
  scale_x_continuous(limits = c(0,60), breaks=seq(0,60,10) ) +
  theme( plot.title = element_text(color="black", size=21, face="bold"),
         legend.text = element_text(size =14)) +
  theme(legend.title = element_text(size = 14)) + 
  ggtitle("avg score1 vs LR")


#1-B CAP vs Np CAP
ggplot(x ,aes(x=avg_score_1, y=LR_cap, color=Jury_group  ))  + 
  geom_point(size=4) + 
  theme(axis.title = element_text(size=16, colour="darkred"), 
        axis.text = element_text(size=14, colour="blue")) +
  scale_y_continuous(limits = c(0.59,0.85), breaks=seq(0.59,0.85,0.03) ) +
  scale_x_continuous(limits = c(0,60), breaks=seq(0,60,10) ) +
  theme( plot.title = element_text(color="black", size=21, face="bold"),
         legend.text = element_text(size =14)) +
  theme(legend.title = element_text(size = 14)) + 
  ggtitle("avg score1 vs LR_cap")

ggplot(x ,aes(x=avg_score_1, y=LR, color=Jury_group  ))  + 
  geom_point(size=4) + 
  theme(axis.title = element_text(size=16, colour="darkred"), 
        axis.text = element_text(size=14, colour="blue")) +
  scale_y_continuous(limits = c(0.59,0.85), breaks=seq(0.59,0.85,0.03) ) +
  scale_x_continuous(limits = c(0,60), breaks=seq(0,60,10) ) +
  theme( plot.title = element_text(color="black", size=21, face="bold"),
         legend.text = element_text(size =14)) +
  theme(legend.title = element_text(size = 14)) + 
  ggtitle("avg score1 vs LR")

#2 PD_LR vs PIP_LR
ggplot(data = x) + geom_point(mapping = aes(x=PD_LR, y=PIP_LR, color=Jury_group  ))
ggplot(x , 
       aes(x=PD_LR, y=PIP_LR, color=Jury_group  ))  + 
  geom_point(size=4) + 
  theme(axis.title = element_text(size=16, colour="darkred"), 
        axis.text = element_text(size=14, colour="blue")) + 
  scale_y_continuous(limits = c(0,1.2)  ) +
  scale_x_continuous(limits = c(0,0.8)  ) +
  theme( plot.title = element_text(color="black", size=21, face="bold"),
         legend.text = element_text(size =14)) +
  theme(legend.title = element_text(size = 14)) + 
  ggtitle("PIP_LR vs PD_LR")

#3 PD_freq vs PIP_freq
ggplot(data = x) + geom_point(mapping = aes(x=PD_freq, y=PIP_freq, color=Jury_group  ))
ggplot(x , 
       aes(x=PD_freq, y=PIP_freq, color=Jury_group  ))  + 
  geom_point(size=4) + 
  theme(axis.title = element_text(size=16, colour="darkred"), 
        axis.text = element_text(size=14, colour="blue")) + 
  scale_y_continuous(limits = c(0,0.07)  ) +
  scale_x_continuous(limits = c(0,0.092)  ) +
  theme( plot.title = element_text(color="black", size=21, face="bold"),
         legend.text = element_text(size =14)) +
  theme(legend.title = element_text(size = 14)) + 
  ggtitle("PD_freq vs PIP_freq")


#4 LR vs DP1_percent
ggplot(data = x) + geom_point(mapping = aes(x=DP1_percent, y=LR, color=Jury_group  ))

ggplot(x , 
       aes(x=DP1_percent, y=LR, color=Jury_group  ))  + 
  geom_point(size=4) + 
  theme(axis.title = element_text(size=16, colour="darkred"), 
        axis.text = element_text(size=13, colour="blue")) + 
  scale_y_continuous(limits = c(0,1.25)  ) +
  scale_x_continuous(limits = c(0,0.016)  ) +
  theme( plot.title = element_text(color="black", size=21, face="bold"),
         legend.text = element_text(size =14)) +
  theme(legend.title = element_text(size = 14)) + 
  ggtitle("LR vs DP1_percent")

#5 avg_score_1 vs avg_score_2
ggplot(data = x) + geom_point(mapping = aes(x=avg_score_1, y=avg_score_2, color=Jury_group  ))
ggplot(x , 
       aes(x=avg_score_1, y=avg_score_2, color=Jury_group  ))  + 
  geom_point(size=4) + 
  theme(axis.title = element_text(size=16, colour="darkred"), 
        axis.text = element_text(size=13, colour="blue")) + 
  scale_y_continuous(limits = c(-50,0)  ) +
  scale_x_continuous(limits = c(0,60)  ) +
  theme( plot.title = element_text(color="black", size=21, face="bold"),
         legend.text = element_text(size =14)) +
  theme(legend.title = element_text(size = 14)) + 
  ggtitle("avg_score_1 vs avg_score_2")




#===================================================================#
# Section 1C 3Q16~3Q17 CARMA Analysis
#===================================================================#

#1 o_convictions_chng  vs No_occurence_chng
ggplot(x , 
       aes(x=No_convictions_chng, y=No_occurence_chng, color=Jury_group  ))  + 
  geom_point(size=4) + 
  theme(axis.title = element_text(size=16, colour="darkred"), 
        axis.text = element_text(size=14, colour="blue")) + 
  scale_y_continuous(limits = c(0,0.18), breaks=seq(0,0.18,0.03) ) +
  scale_x_continuous(limits = c(0,0.3), breaks=seq(0,0.3,0.06) ) +
  theme( plot.title = element_text(color="black", size=21, face="bold"),
         legend.text = element_text(size =14)) +
  theme(legend.title = element_text(size = 14))
#scale_y_continuous(breaks=(0, max(x$No_occurence_chng) +0.01, 0.03))


#2 no_of_vhcl_chng vs no_drvr_chng

ggplot(data = x) + geom_point(mapping = aes(x=no_of_vhcl_chng, y=no_drvr_chng, color=Jury_group  ))

ggplot(x , 
       aes(x=No_convictions_chng, y=No_occurence_chng, color=Jury_group  ))  + 
  geom_point(size=4) + 
  theme(axis.title = element_text(size=16, colour="darkred"), 
        axis.text = element_text(size=14, colour="blue")) + 
  scale_y_continuous(limits = c(0,0.18), breaks=seq(0,0.18,0.03) ) +
  scale_x_continuous(limits = c(0,0.3), breaks=seq(0,0.3,0.06) ) +
  theme( plot.title = element_text(color="black", size=21, face="bold"),
         legend.text = element_text(size =14)) +
  theme(legend.title = element_text(size = 14))








#===================================================================#
# Section 2 CP Stike
#===================================================================# 
ggplot(y, aes(x = One_Two , y=reorder(Strike, One_Two))) +
  geom_point(size=3) + # Use a larger dot
  theme_bw() +
  theme(panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_line(colour="grey60", linetype="dashed"))


#1 Get the names, sorted first by group, then by value
nameorder <- y$Strike[order(ordered(y$group, levels=c("One_Two", "Three", "Four_plus", "NULL")), y$value)]

#2 Turn name into a factor, with levels in the order of nameorder
y$Strike <- factor(y$Strike, levels=nameorder)

#3 Draw plot

 ggplot(y, aes(x=value, y=Strike)) +
  geom_segment(aes(yend=Strike), xend=0, colour="grey50") +
  geom_point(size=3, aes(colour=group)) + 
  scale_colour_brewer(palette="Set1", limits=c("One_Two","Three", "Four_plus", "NULL"), guide=FALSE) +
  theme_bw() +
  theme(panel.grid.major.y = element_blank()) +
   
   
   
  facet_grid(factor(y$group, levels=c("One_Two", "Three", "Four_plus", "NULL"))~ ., scales="free_y", space="free_y") +
  ggtitle("CP Strike Comparison") +
   theme(axis.text.y=element_text(size=13, colour="black"),
         axis.text.x=element_text(size=14, colour="blue"),
         strip.text = element_text(face="bold", size=rel(1.3)))
   
 
 
 
 
 
 
 #----------------
 nameorder <- y$Strike[order(ordered(y$group, levels=c("One_Two", "Three", "Four_plus", "NULL")))]
 ggplot(y, aes(x=value, y=Strike)) +
   geom_segment(aes(yend=Strike), xend=0, colour="grey50") +
   geom_point(size=3, aes(colour=group)) + 
   scale_colour_brewer(palette="Set1", limits=c("One_Two","Three", "Four_plus", "NULL"), guide=FALSE) +
   theme_bw() +
   theme(panel.grid.major.y = element_blank()) +
   
   
   
   facet_grid(factor(y$group, levels=c("One_Two", "Three", "Four_plus", "NULL"))~ ., scales="free_y", space="free_y") +
   ggtitle("CP Strike Comparison") +
   theme(axis.text.y=element_text(size=13, colour="black"),
         axis.text.x=element_text(size=14, colour="blue"),
         strip.text = element_text(face="bold", size=rel(1.3)))
 
 
 
 #-----
#===================================================================#
# Section 3 Carma Change
#===================================================================# 
 
z <- read.xlsx("\\\\chnas01\\URC\\URC-Private\\Fraud\\USERS\\Yen-Yin\\Jury count_OCT2017\\raw_j.xlsx",  sheetName = "Sheet3")
  
 #1 Get the names, sorted first by group, then by value
 nameorder <- z$carma[order(ordered(z$group, levels=c("One_Two", "Three", "Four_plus", "NULL")), z$value)]
 #2 Turn name into a factor, with levels in the order of nameorder
 z$carma <- factor(z$carma, levels=nameorder)
 
 #3 Draw plot
 
 ggplot(z, aes(x=value, y=carma)) +
   geom_segment(aes(yend=carma), xend=0, colour="grey50") +
   geom_point(size=3, aes(colour=group)) + 
   scale_colour_brewer(palette="Set1", limits=c("One_Two","Three", "Four_plus", "NULL"), guide=FALSE) +
   theme_bw() +
   theme(panel.grid.major.y = element_blank()) +
   facet_grid(factor(z$group, levels=c("One_Two", "Three", "Four_plus", "NULL"))~ ., scales="free_y", space="free_y") +
   ggtitle("CARMA Change Comparison") +
   theme(axis.text.y=element_text(size=13, colour="black"),
         axis.text.x=element_text(size=14, colour="blue"),
         strip.text = element_text(face="bold", size=rel(1.3)))
    
    

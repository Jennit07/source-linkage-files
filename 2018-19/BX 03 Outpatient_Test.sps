﻿* Encoding: UTF-8.

*Tests for outpatient dataset.
get file = !file + 'outpatients_for_source-20'+!FY+'.zsav'.
*to check for records that are admitted more than 2 years and records that are discharged after the FY2016.

if record_keydate1 =record_keydate2 Flag=1.
exe.
select if Flag ne 1.
exe.

*To check aggregated data variations with the existing SLF 2016/17 data.
get file = !file + 'outpatients_for_source-20'+!FY+'.zsav'.

Dataset name SLFcurrent.
Compute Pre_Cost=sum(apr_cost,may_cost, jun_cost, jul_cost, aug_cost, sep_cost, oct_cost, nov_cost, dec_cost, jan_cost, feb_cost, mar_cost).
exe.
aggregate outfile=*
/break year
/no_records=n
/Total_Costs_net=Sum(cost_total_net).
exe.
Dataset name SLFcurrent.
Dataset activate  SLFcurrent.
alter type year(A6).


get file='/conf/hscdiip/01-Source-linkage-files/source-episode-file-20' +!FY+'.zsav'.
select if recid='00B'.
exe.

Dataset name SLFprevious.
Compute Pre_Cost=sum(apr_cost, may_cost, jun_cost, jul_cost, aug_cost, sep_cost, oct_cost, nov_cost, dec_cost, jan_cost, feb_cost, mar_cost).


aggregate outfile=*
/break year
/no_records=n
/Pre_cost=sum(Pre_cost)
/Total_Costs_net=Sum(cost_total_net).
exe.

alter type year(A6).
Compute year=!FY +'p'.
exe.
Dataset name SLFprevious.

add files file =SLFprevious
/file = SLFcurrent.
exe.

*Check % variations.
Compute Costs_difference=(((Total_Costs_net-lag(Total_Costs_net))/(lag(Total_Costs_net)))*100).
Compute no_records_difference=(((no_records-lag(no_records))/(lag(no_records)))*100).
exe.

*Flag differences with more than or equal to +/- 15%.
If ((100-Costs_difference) ge 115 or (100-Costs_difference) le 85) Flag_Costs_net_difference =1.
If ((100-no_records_difference) ge 115 or (100-no_records_difference) le 85) Flag_records_difference=1.  
exe.

*Close both datasets.
Dataset close SLFcurrent.
Dataset close SLFprevious.


﻿* Encoding: UTF-8.
*District Nursing tests.

get file = !File + "DN_for_source-20" + !FY + ".zsav".

Dataset name SLFcurrent.
Compute Pre_Cost=sum(apr_cost,may_cost, jun_cost, jul_cost, aug_cost, sep_cost, oct_cost, nov_cost, dec_cost, jan_cost, feb_cost, mar_cost).
exe.

aggregate outfile=*
/break year
/no_records=n
/Pre_Cost=sum(Pre_Cost)
/Total_Costs_net=Sum(cost_total_net).
exe.

alter type year(A6).
Dataset name SLFcurrent.

get file='/conf/hscdiip/01-Source-linkage-files/source-episode-file-201617.zsav'.
select if recid='DN'.
exe.
Dataset name SLFprevious.
Compute Pre_Cost=sum(apr_cost,may_cost, jun_cost, jul_cost, aug_cost, sep_cost, oct_cost, nov_cost, dec_cost, jan_cost, feb_cost, mar_cost).
exe.

aggregate outfile=*
/break year
/no_records=n
/Pre_Cost=sum(Pre_Cost)
/Total_Costs_net=Sum(cost_total_net).
exe.


Compute year='1617p'.
exe.
Dataset name SLFprevious.

add files file =SLFprevious
/file = SLFcurrent.
exe.

*Check % variations.
Compute Costs_difference=(((Total_Costs_net-lag(Total_Costs_net))/(lag(Total_Costs_net)))*100).
Compute Pre_cost_difference=(((Pre_cost-lag(Pre_cost))/(lag(Pre_cost)))*100).
Compute no_records_difference=(((no_records-lag(no_records))/(lag(no_records)))*100).
exe.

*Flag differences with more than or equal to +/- 15%.
If ((100-Costs_difference) ge 115 or (100-Costs_difference) le 85) Flag_Costs_net_difference =1.
If ((100-Pre_cost_difference) ge 115 or  (100-Pre_cost_difference) le 85) Flag_Pre_cost_difference=1.
if ((100-no_records_difference) ge 115 or (100-no_records_difference) le 85) Flag_records_difference=1.  
exe.

*Close both datasets.
Dataset close SLFcurrent.
Dataset close SLFprevious.











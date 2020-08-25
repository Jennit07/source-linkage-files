﻿* Encoding: UTF-8.

get file = !file + 'homelessness_for_source-20' + !FY + '.zsav'.


* Flag to count CHIs.
Recode CHI ("" = 0) (Else = 1) Into Has_CHI.

* Flags to count M/Fs.
Do if gender = 1.
    Compute Male = 1.
Else if gender = 2.
    Compute Female = 1.
End if.

*Flags to count SMRtype.
If SMRType = 'HL1-Main' HL1_Main = 1.
If SMRType = 'HL1-Other' HL1_Other = 1. 

* Flags to count missing values.
If sysmis(dob) No_DoB = 1.

*Flag to count hl1_sending_lca. 
If hl1_sending_lca = 'S12000033' Aberdeen_City = 1.
If hl1_sending_lca = 'S12000034' Aberdeenshire = 1.
If hl1_sending_lca = 'S12000041' Angus = 1.
If hl1_sending_lca = 'S12000035' Argyll_and_Bute = 1.
If hl1_sending_lca = 'S12000036' City_of_Edinburgh = 1.
If hl1_sending_lca = 'S12000005' Clackmannanshire = 1.
If hl1_sending_lca = 'S12000006' Dumfries_and_Galloway = 1.
If hl1_sending_lca = 'S12000042' Dundee_City = 1. 
If hl1_sending_lca = 'S12000008' East_Ayrshire = 1.
If hl1_sending_lca = 'S12000045' East_Dunbartonshire = 1.
If hl1_sending_lca = 'S12000010' East_Lothian = 1.
If hl1_sending_lca = 'S12000011' East_Renfrewshire = 1.
If hl1_sending_lca = 'S12000014' Falkirk = 1.
If hl1_sending_lca = 'S12000015' Fife = 1. 
If hl1_sending_lca = 'S12000046' Glasgow_City = 1. 
If hl1_sending_lca = 'S12000017' Highland = 1.
If hl1_sending_lca = 'S12000018' Inverclyde = 1.
If hl1_sending_lca = 'S12000019' Midlothian = 1.
If hl1_sending_lca = 'S12000020' Moray = 1. 
If hl1_sending_lca = 'S12000013' Na_h_Eileanan_Siar = 1.
If hl1_sending_lca = 'S12000021' North_Ayrshire = 1.
If hl1_sending_lca = 'S12000044' North_Lanarkshire = 1.
If hl1_sending_lca = 'S12000023' Orkney_Islands = 1.
If hl1_sending_lca = 'S12000024' Perth_and_Kinross = 1.
If hl1_sending_lca = 'S12000038' Renfrewshire = 1. 
If hl1_sending_lca = 'S12000026' Scottish_Borders = 1.
If hl1_sending_lca = 'S12000027' Shetland_Islands = 1.
If hl1_sending_lca = 'S12000028' South_Ayrshire = 1. 
If hl1_sending_lca = 'S12000029' South_Lanarkshire = 1.
If hl1_sending_lca = 'S12000030' Stirling = 1.
If hl1_sending_lca = 'S12000039' West_Dunbartonshire = 1.
If hl1_sending_lca = 'S12000040' West_Lothian = 1.

*Change missing hl1_sending_lca values to 0. 
Recode Aberdeen_City to West_Lothian (SYSMIS = 0).

* Flags to count missing values.
If sysmis(dob) No_DoB = 1.

* Get values for whole file.
Dataset Declare SLFnew.
aggregate outfile = SLFnew
    /break
    /n_CHIs = sum(Has_CHI)
    /n_Males n_Females = Sum(Male Female)
    /n_episodes = n
    /Earliest_start Earliest_end = Min(record_keydate1 record_keydate2)
    /Latest_start Latest_end  = Max(record_keydate1 record_keydate2)
    /n_HL1_Main = Sum(HL1_Main) 
    /n_HL1_Other = Sum(HL1_Other)
    /All_Aberdeen_City = Sum(Aberdeen_City)
    /All_Aberdeenshire = Sum(Aberdeenshire)
    /All_Angus = Sum(Angus)
    /All_Argyll_and_Bute = Sum(Argyll_and_Bute)
    /All_City_of_Edinburgh = Sum(City_of_Edinburgh)
    /All_Clackmannanshire = Sum(Clackmannanshire)
    /All_Dumfries_and_Galloway = Sum(Dumfries_and_Galloway)
    /All_Dundee_City = Sum(Dundee_City)
    /All_East_Ayrshire = Sum(East_Ayrshire) 
    /All_East_Dunbartonshire =Sum(East_Dunbartonshire)
    /All_East_Lothian = Sum(East_Lothian) 
    /All_East_Renfrewshire = Sum(East_Renfrewshire)
    /All_Falkirk = Sum(Falkirk)
    /All_Fife = Sum(Fife)
    /All_Glasgow_City = Sum(Glasgow_City)
    /All_Highland = Sum(Highland) 
    /All_Inverclyde = Sum(Inverclyde)
    /All_Midlothian = Sum(Midlothian)
    /All_Moray = Sum(Moray)
    /All_Na_h_Eileanan_Siar = Sum(Na_h_Eileanan_Siar)
    /All_North_Ayrshire = Sum(North_Ayrshire)
    /All_North_Lanarkshire = Sum(North_Lanarkshire)
    /All_Orkney_Islands = Sum(Orkney_Islands)
    /All_Perth_and_Kinross = Sum(Perth_and_Kinross)
    /All_Renfrewshire = Sum(Renfrewshire) 
    /All_Scottish_Borders = Sum(Scottish_Borders)
    /All_Shetland_Islands = Sum(Shetland_Islands)
    /All_South_Ayrshire = Sum(South_Ayrshire)
    /All_South_Lanarkshire = Sum(South_Lanarkshire)
    /All_Stirling = Sum(Stirling)
    /All_West_Dunbartonshire = Sum(West_Dunbartonshire) 
    /All_West_Lothian = Sum(West_Lothian). 

Dataset activate SLFnew.
Varstocases
    /Make New_Value from n_CHIs to All_West_Lothian
    /Index Measure (New_Value).
Sort cases by Measure.


**************************************************************************************************************************

**************************************************************************************************************************.
get file = '/conf/hscdiip/01-Source-linkage-files/source-episode-file-20' + !FY + '.zsav'
    /Keep recid Anon_CHI record_keydate1 record_keydate2 gender dob age
             SMRType hl1_sending_lca.
select if recid = 'HL1'.

* Flag to count CHIs.
Recode Anon_CHI ("" = 0) (Else = 1) Into Has_CHI.

* Flags to count M/Fs.
Do if gender = 1.
    Compute Male = 1.
Else if gender = 2.
    Compute Female = 1.
End if.


*Flags to count SMRtype.
If SMRType = 'HL1-Main' HL1_Main = 1.
If SMRType = 'HL1-Other' HL1_Other = 1. 

* Flags to count missing values.
If sysmis(dob) No_DoB = 1.

*Flag to count hl1_sending_lca. 
If hl1_sending_lca = 'S12000033' Aberdeen_City = 1.
If hl1_sending_lca = 'S12000034' Aberdeenshire = 1.
If hl1_sending_lca = 'S12000041' Angus = 1.
If hl1_sending_lca = 'S12000035' Argyll_and_Bute = 1.
If hl1_sending_lca = 'S12000036' City_of_Edinburgh = 1.
If hl1_sending_lca = 'S12000005' Clackmannanshire = 1.
If hl1_sending_lca = 'S12000006' Dumfries_and_Galloway = 1.
If hl1_sending_lca = 'S12000042' Dundee_City = 1. 
If hl1_sending_lca = 'S12000008' East_Ayrshire = 1.
If hl1_sending_lca = 'S12000045' East_Dunbartonshire = 1.
If hl1_sending_lca = 'S12000010' East_Lothian = 1.
If hl1_sending_lca = 'S12000011' East_Renfrewshire = 1.
If hl1_sending_lca = 'S12000014' Falkirk = 1.
If hl1_sending_lca = 'S12000015' Fife = 1. 
If hl1_sending_lca = 'S12000046' Glasgow_City = 1. 
If hl1_sending_lca = 'S12000017' Highland = 1.
If hl1_sending_lca = 'S12000018' Inverclyde = 1.
If hl1_sending_lca = 'S12000019' Midlothian = 1.
If hl1_sending_lca = 'S12000020' Moray = 1. 
If hl1_sending_lca = 'S12000013' Na_h_Eileanan_Siar = 1.
If hl1_sending_lca = 'S12000021' North_Ayrshire = 1.
If hl1_sending_lca = 'S12000044' North_Lanarkshire = 1.
If hl1_sending_lca = 'S12000023' Orkney_Islands = 1.
If hl1_sending_lca = 'S12000024' Perth_and_Kinross = 1.
If hl1_sending_lca = 'S12000038' Renfrewshire = 1. 
If hl1_sending_lca = 'S12000026' Scottish_Borders = 1.
If hl1_sending_lca = 'S12000027' Shetland_Islands = 1.
If hl1_sending_lca = 'S12000028' South_Ayrshire = 1. 
If hl1_sending_lca = 'S12000029' South_Lanarkshire = 1.
If hl1_sending_lca = 'S12000030' Stirling = 1.
If hl1_sending_lca = 'S12000039' West_Dunbartonshire = 1.
If hl1_sending_lca = 'S12000040' West_Lothian = 1.

*Change missing hl1_sending_lca values to 0. 
If sysmis(Aberdeen_City) Aberdeen_City = 0. 
If sysmis(Aberdeenshire) Aberdeenshire = 0. 
If sysmis(Angus) Angus = 0. 
If sysmis(Argyll_and_Bute) Argyll_and_Bute = 0. 
If sysmis(City_of_Edinburgh) City_of_Edinburgh = 0.
If sysmis(Clackmannanshire) Clackmannanshire = 0.
If sysmis(Dumfries_and_Galloway) Dumfries_and_Galloway = 0. 
If sysmis(Dundee_City)  Dundee_City = 0.
If sysmis(East_Ayrshire) East_Ayrshire = 0.
If sysmis(East_Dunbartonshire) East_Dunbartonshire = 0. 
If sysmis(East_Lothian) East_Lothian = 0.
If sysmis(East_Renfrewshire) East_Renfrewshire = 0.
If sysmis(Falkirk) Falkirk = 0.
If sysmis(Fife) Fife = 0. 
If sysmis(Glasgow_City) Glasgow_City = 0.
If sysmis(Highland) Highland = 0.
If sysmis(Inverclyde)  Inverclyde = 0.
If sysmis(Midlothian) Midlothian = 0. 
If sysmis(Moray) Moray = 0.
If sysmis(Na_h_Eileanan_Siar) Na_h_Eileanan_Siar = 0.
If sysmis(North_Ayrshire) North_Ayrshire = 0.
If sysmis(North_Lanarkshire) North_Lanarkshire = 0.
If sysmis(Orkney_Islands) Orkney_Islands = 0. 
If sysmis(Perth_and_Kinross) Perth_and_Kinross = 0.
If sysmis(Renfrewshire) Renfrewshire = 0. 
If sysmis(Scottish_Borders) Scottish_Borders = 0. 
If sysmis(Shetland_Islands) Shetland_Islands = 0. 
If sysmis(South_Ayrshire) South_Ayrshire = 0. 
If sysmis(South_Lanarkshire) South_Lanarkshire = 0. 
If sysmis(Stirling) Stirling = 0. 
If sysmis(West_Dunbartonshire) West_Dunbartonshire = 0. 
If sysmis(West_Lothian) West_Lothian = 0. 


* Flags to count missing values.
If sysmis(dob) No_DoB = 1.

* Get values for whole file.
Dataset Declare SLFexisting.
aggregate outfile = SLFexisting
    /break
    /n_CHIs = sum(Has_CHI)
    /n_Males n_Females = Sum(Male Female)
    /n_episodes = n
    /Earliest_start Earliest_end = Min(record_keydate1 record_keydate2)
    /Latest_start Latest_end  = Max(record_keydate1 record_keydate2)
    /n_HL1_Main = Sum(HL1_Main) 
    /n_HL1_Other = Sum(HL1_Other)
    /All_Aberdeen_City = Sum(Aberdeen_City)
    /All_Aberdeenshire = Sum(Aberdeenshire)
    /All_Angus = Sum(Angus)
    /All_Argyll_and_Bute = Sum(Argyll_and_Bute)
    /All_City_of_Edinburgh = Sum(City_of_Edinburgh)
    /All_Clackmannanshire = Sum(Clackmannanshire)
    /All_Dumfries_and_Galloway = Sum(Dumfries_and_Galloway)
    /All_Dundee_City = Sum(Dundee_City)
    /All_East_Ayrshire = Sum(East_Ayrshire) 
    /All_East_Dunbartonshire =Sum(East_Dunbartonshire)
    /All_East_Lothian = Sum(East_Lothian) 
    /All_East_Renfrewshire = Sum(East_Renfrewshire)
    /All_Falkirk = Sum(Falkirk)
    /All_Fife = Sum(Fife)
    /All_Glasgow_City = Sum(Glasgow_City)
    /All_Highland = Sum(Highland) 
    /All_Inverclyde = Sum(Inverclyde)
    /All_Midlothian = Sum(Midlothian)
    /All_Moray = Sum(Moray)
    /All_Na_h_Eileanan_Siar = Sum(Na_h_Eileanan_Siar)
    /All_North_Ayrshire = Sum(North_Ayrshire)
    /All_North_Lanarkshire = Sum(North_Lanarkshire)
    /All_Orkney_Islands = Sum(Orkney_Islands)
    /All_Perth_and_Kinross = Sum(Perth_and_Kinross)
    /All_Renfrewshire = Sum(Renfrewshire) 
    /All_Scottish_Borders = Sum(Scottish_Borders)
    /All_Shetland_Islands = Sum(Shetland_Islands)
    /All_South_Ayrshire = Sum(South_Ayrshire)
    /All_South_Lanarkshire = Sum(South_Lanarkshire)
    /All_Stirling = Sum(Stirling)
    /All_West_Dunbartonshire = Sum(West_Dunbartonshire) 
    /All_West_Lothian = Sum(West_Lothian). 


Dataset activate SLFexisting.
Varstocases
    /Make Existing_Value from n_CHIs to All_West_Lothian
    /Index Measure (Existing_Value).
Sort cases by Measure.


**************************************************************************************************************************

**************************************************************************************************************************.
* Match together.
match files
    /file = SLFexisting
    /file = SLFnew
    /By Measure.
Dataset Name HL1Comparison.

* Close both datasets.
Dataset close SLFnew.
Dataset close SLFexisting.

* Produce comparisons.
Compute Difference = New_Value - Existing_Value.
Compute PctChange = Difference / Existing_Value * 100.
Compute Issue = (abs(PctChange) > 5).
Alter Type Issue (F1.0) PctChange (PCT4.2).

* Highlight issues.
Crosstabs Measure by Issue.

Save Outfile = !file + 'Homelessness_tests_20' + !FY + '.zsav'
   /zcompressed .



﻿* Encoding: UTF-8.
Insert file ="/conf/irf/11-Development team/Dev00-PLICS-files/2017-18/A01 Set up Macros (1718).sps".

get file = "/conf/hscdiip/Social Care Extracts/SPSS extracts/2017Q4_HC_extracts_ELoth_NLan_SLan.zsav".

Rename Variables
    hc_service_start_date = record_keydate1
    hc_service_end_date = record_keydate2
    chi_gender_code = gender
    chi_postcode = postcode
    chi_date_of_birth = dob
    seeded_chi_number = chi
    reablement = hc_reablement.

Alter type gender (F1.0) postcode (A8) hc_reablement (F1.0) hc_service_provider (F1.0).

 * If the chi seeded postcode is blank use the submitted one.
If postcode = "" postcode = submitted_postcode.

String Year (A4).
Compute Year = !FY.

string recid (a3).
Compute recid eq 'HC'.

 * Use hc_service to create the SMRType.
string SMRType (a10).
Do if hc_service = "1".
    compute SMRType = 'HC-Non-Per'.
Else if hc_service = "2".
    compute SMRType = "HC-Per".
Else.
    compute SMRType = "HC-Unknown".
End if.

Numeric age (F3.0).

Compute age = datediff(!midFY, dob, "years").

String sc_send_lca (A2).
Recode sending_location
    ("100" = "01")
    ("110" = "02")
    ("120" = "03")
    ("130" = "04")
    ("150" = "06")
    ("170" = "08")
    ("180" = "09")
    ("190" = "10")
    ("200" = "11")
    ("210" = "12")
    ("220" = "13")
    ("230" = "14")
    ("235" = "32")
    ("240" = "15")
    ("250" = "16")
    ("260" = "17")
    ("270" = "18")
    ("280" = "19")
    ("290" = "20")
    ("300" = "21")
    ("310" = "22")
    ("320" = "23")
    ("330" = "24")
    ("340" = "25")
    ("350" = "26")
    ("355" = "05")
    ("360" = "27")
    ("370" = "28")
    ("380" = "29")
    ("390" = "30")
    ("395" = "07")
    ("400" = "31")
    into sc_send_lca.

!AddLCADictionaryInfo LCA = sc_send_lca.

Value Labels hc_service_provider
    1 'Local Authority / Health & Social Care Partnership / NHS Board'
    2 'Private'
    3 'Other Local Authority'
    4 'Third Sector'
    5 'Other'.

Value Labels hc_reablement
    0 'No'
    1 'Yes'
    9 'Not Known'.

 * Remove end dates which should be blank.
If end_date_missing record_keydate2 = $sysmis.

* In case keydate is needed as F8.0...
alter type record_keydate1 record_keydate2 (SDATE10).
alter type record_keydate1 record_keydate2 (A10).

Compute record_keydate1 = Concat(char.Substr(record_keydate1, 1, 4), char.Substr(record_keydate1, 6, 2), char.Substr(record_keydate1, 9, 2)).
alter type record_keydate1 (F8.0).

Compute record_keydate2 = Concat(char.Substr(record_keydate2, 1, 4), char.Substr(record_keydate2, 6, 2), char.Substr(record_keydate2, 9, 2)).
alter type record_keydate2 (F8.0).

sort cases by chi record_keydate1 record_keydate2.

save outfile = !File + "Home_Care_for_source-20" + !FY + ".zsav"
    /Keep Year
    recid
    SMRType
    chi
    dob
    age
    gender
    postcode
    sc_send_lca
    record_keydate1
    record_keydate2
    hc_hours
    hc_service_provider
    hc_reablement
    /zcompressed.
get file = !File + "Home_Care_for_source-20" + !FY + ".zsav".

* Encoding: UTF-8.
get file = "/conf/hscdiip/Social Care Extracts/SPSS extracts/2017Q4_SDS_extracts_ELoth_NLan_SLan.zsav"
    /Drop sds_option_1_net_value sds_option_2_net_value sds_option_3_net_value sds_option_1_gross_value sds_option_2_gross_value sds_option_3_gross_value sds_total_net_value sds_total_gross_value.

Alter type social_care_id (A10) financial_year (A4).

sort cases by social_care_id sending_location.
match files file = *
    /table = "/conf/hscdiip/Social Care Extracts/SPSS extracts/2017Q4_Client_for_source.zsav"
    /By social_care_id sending_location.

Rename Variables
    sds_start_date = record_keydate1
    sds_end_date = record_keydate2
    chi_gender_code = gender
    chi_postcode = postcode
    chi_date_of_birth = dob
    seeded_chi_number = chi.

Alter type gender (F1.0) postcode (A8) sds_option_1 sds_option_2 sds_option_3 (F1.0).

* If the chi seeded postcode is blank use the submitted one.
If postcode = "" postcode = submitted_postcode.

* Restructure to create one line per SDS option.
varstocases
    /make recieved from sds_option_1 sds_option_2 sds_option_3
    /Index sds_option.

* Drop the lines that don't have any useful data.
Select if Recieved = 1.

String Year (A4).
Compute Year = !FY.

string recid (a3).
Compute recid eq 'SDS'.

* Use service_type to create the SMRType.
string SMRType (a10).
Do if sds_option = 1.
    Compute SMRType = "SDS-1".
Else if sds_option = 2.
    Compute SMRType = "SDS-2".
Else if sds_option = 3.
    Compute SMRType = "SDS-3".
End if.

Numeric age (F3.0).

Compute age = datediff(!midFY, dob, "years").

 * Uses sending_location and recodes into sc_sending_location using actual codes.
!Create_sc_sending_location.

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

save outfile = !File + "SDS-for-source-20" + !FY + ".zsav"
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
    living_alone
    support_from_unpaid_carer
    social_worker
    housing_support
    type_of_housing
    meals
    day_care
    /zcompressed.
get file = !File + "SDS-for-source-20" + !FY + ".zsav".
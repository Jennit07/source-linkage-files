﻿* Encoding: UTF-8.
* Create maternity costed extract in suitable format for PLICS.

* Read in the maternity extract.  Rename/reformat/recode columns as appropriate. 

* Program by Denise Hastie, July 2016.
* Updated by Denise Hastie, August 2016.  Added in a section that was in the master PLICS file creation program
* with regards to calculating the length of stay for maternity.  

********************************************************************************************************.
 * Run 01-Set up Macros first!.
********************************************************************************************************.

* Read in CSV output file.
GET DATA  /TYPE=TXT
    /FILE = !Extracts + 'Maternity-episode-level-extract-20' + !FY + '.csv'
    /ENCODING='UTF8'
    /DELIMITERS=","
    /QUALIFIER='"'
    /ARRANGEMENT=DELIMITED
    /FIRSTCASE=2
    /VARIABLES=
    CostsFinancialYear A4
    DateofAdmissionFullDate A10
    DateofDischargeFullDate A10
    PatUPIC A10
    PatDateOfBirthC A10
    PracticeLocationCode A5
    PracticeNHSBoardCode A9
    GeoPostcodeC A7
    NHSBoardofResidenceCode A9
    HSCP2016 A9
    GeoCouncilAreaCode A2
    TreatmentLocationCode A7
    TreatmentNHSBoardCode A9
    OccupiedBedDays F4.2
    SpecialtyClassification1497Code A3
    SignificantFacilityCode A2
    ConsultantHCPCode A8
    ManagementofPatientCode A1
    AdmissionReasonCode A2
    AdmittedTransferfromCodenew A2
    AdmittedtransferfromLocationCode A5
    DischargeTypeCode A2
    DischargeTransfertoCodenew A2
    DischargedtoLocationCode A5
    ConditionOnDischargeCode F1.0
    ContinuousInpatientJourneyMarker A5
    CIJPlannedAdmissionCode F1.0
    CIJInpatientDayCaseIdentifierCode A2
    CIJTypeofAdmissionCode A2
    CIJAdmissionSpecialtyCode A3
    CIJDischargeSpecialtyCode A3
    TotalNetCosts F8.2
    Diagnosis1DischargeCode A6
    Diagnosis2DischargeCode A6
    Diagnosis3DischargeCode A6
    Diagnosis4DischargeCode A6
    Diagnosis5DischargeCode A6
    Diagnosis6DischargeCode A6
    Operation1ACode A4
    Operation2ACode A4
    Operation3ACode A4
    Operation4ACode A4
    DateofMainOperationFullDate A10
    AgeatMidpointofFinancialYear F3.0
    NHSHospitalFlag A1
    CommunityHospitalFlag A1
    AlcoholRelatedAdmission A1
    SubstanceMisuseRelatedAdmission A1
    FallsRelatedAdmission A1
    SelfHarmRelatedAdmission A1.
CACHE.

rename variables
    PatUPIC = chi
    PracticeLocationCode = gpprac
    PracticeNHSBoardCode = hbpraccode
    GeoPostcodeC = postcode
    NHSBoardofResidenceCode = hbrescode
    GeoCouncilAreaCode = lca
    TreatmentLocationCode = location
    TreatmentNHSBoardCode = hbtreatcode
    OccupiedBedDays = yearstay
    SpecialtyClassification1497Code = spec
    SignificantFacilityCode = sigfac
    ConsultantHCPCode = conc
    ManagementofPatientCode = mpat
    AdmittedTransferFromCodenew = adtf
    AdmittedTransferFromLocationCode = admloc
    DischargeTypeCode = disch
    DischargeTransferToCodenew = dischto
    DischargedtoLocationCode = dischloc
    ContinuousInpatientJourneyMarker = cis_marker
    CIJTypeofAdmissionCode = newcis_admtype
    CIJAdmissionSpecialtyCode = CIJadm_spec
    CIJDischargeSpecialtyCode = CIJdis_spec
    AlcoholRelatedAdmission = alcohol_adm
    SubstanceMisuseRelatedAdmission = submis_adm
    FallsRelatedAdmission = falls_adm
    SelfHarmRelatedAdmission = selfharm_adm
    TotalNetCosts = cost_total_net
    NHSHospitalFlag = nhshosp
    CommunityHospitalFlag = commhosp
    AgeatMidpointofFinancialYear = age
    CostsFinancialYear = costsfy
    CIJPlannedAdmissionCode = newpattype_ciscode
    Diagnosis1DischargeCode = diag1
    Diagnosis2DischargeCode = diag2
    Diagnosis3DischargeCode = diag3
    Diagnosis4DischargeCode = diag4
    Diagnosis5DischargeCode = diag5
    Diagnosis6DischargeCode = diag6
    Operation1ACode = op1a
    Operation2ACode = op2a
    Operation3ACode = op3a
    Operation4ACode = op4a
    ConditionOnDischargeCode = discondition.

* Create a variable for gender.
numeric gender (F1.0).
compute gender = 2.

string year (a4) recid (a3) ipdc (a1) newcis_ipdc (a1) newpattype_cis (a13).
compute year = !FY.
compute recid = '02B'.

 * Recode GP Practice into a 5 digit number.
 * We assume that if it starts with a letter it's an English practice and so recode to 99995.
Do if Range(char.Substr(gpprac, 1, 1), "A", "Z").
   Compute gpprac = "99995".
End if. 
Alter Type GPprac (F5.0).

Do if (CIJInpatientDayCaseIdentifierCode eq 'IP').
   Compute newcis_ipdc = 'I'.
Else if (CIJInpatientDayCaseIdentifierCode eq 'DC').
   Compute newcis_ipdc = 'D'.
End if.

Do if ((newpattype_ciscode eq 2) and recid eq '02B').
   Compute newpattype_cis = 'Maternity'.
Else if (newpattype_ciscode eq 0).
   Compute newpattype_cis = 'Non-elective'.
Else if (newpattype_ciscode eq 1).
   Compute newpattype_cis = 'Elective'.
End if.

Rename Variables
    DateofAdmissionFullDate = record_keydate1
    DateofDischargeFullDate = record_keydate2
    PatDateOfBirthC = dob
    DateofMainOperationFullDate = dateop1.

alter type record_keydate1 record_keydate2 dob dateop1 (SDate10).
alter type record_keydate1 record_keydate2 dob dateop1 (Date12).


Numeric stay (F7.0).
Compute stay = Datediff(record_keydate2, record_keydate1, "days").

Frequencies stay yearstay.

save outfile = !file + 'maternity_temp.zsav'
   /zcompressed.

get file = !file + 'maternity_temp.zsav'.

 * Put record_keydate back into numeric.
Compute record_keydate1 = xdate.mday(record_keydate1) + 100 * xdate.month(record_keydate1) + 10000 * xdate.year(record_keydate1).
Compute record_keydate2 = xdate.mday(record_keydate2) + 100 * xdate.month(record_keydate2) + 10000 * xdate.year(record_keydate2).

alter type record_keydate1 record_keydate2 (F8.0).

sort cases by chi record_keydate1.

save outfile = !file + 'maternity_for_source-20' + !FY + '.zsav'
   /keep year recid record_keydate1 record_keydate2 chi gender dob gpprac hbpraccode postcode hbrescode lca location hbtreatcode
      stay yearstay spec sigfac conc mpat adtf admloc disch dischto dischloc diag1 diag2 diag3 diag4 diag5 diag6
      op1a dateop1 op2a op3a op4a age discondition cis_marker newcis_admtype newcis_ipdc
      newpattype_ciscode newpattype_cis CIJadm_spec CIJdis_spec alcohol_adm submis_adm falls_adm selfharm_adm commhosp nhshosp
      cost_total_net
   /zcompressed.

get file = !file + 'maternity_for_source-20' + !FY + '.zsav'.

* Housekeeping. 
erase file = !file + 'maternity_temp.zsav'.

 * zip up the raw data.
Host Command = ["gzip -m '" + !Extracts + "Maternity-episode-level-extract-20" + !FY + ".csv'"].







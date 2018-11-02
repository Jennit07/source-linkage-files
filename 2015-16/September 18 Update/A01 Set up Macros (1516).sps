﻿* Encoding: UTF-8.
************************************************************************************************************
                                                   NSS (ISD)
************************************************************************************************************
** AUTHOR:	James McMahon (j.mcmahon1@nhs.net)
** Date:    	01/08/2018
************************************************************************************************************
** Amended by:         
** Date:
** Changes:               
************************************************************************************************************.
 * Set the Financial Year.
Define !FY()
   "1516"
!EndDefine.

 * Set the next FY, needed for SPARRA (and HHG).
Define !NextFY ()
    "1617"
!EndDefine.

Define !File()
   !Quote(!Concat("/conf/sourcedev/Source Linkage File Updates/", !Unquote(!Eval(!FY)), "/"))
!EndDefine.

* Extract files - "home".
Define !Extracts()
   !Quote(!Concat(!Unquote(!Eval(!File)), "Extracts/"))
!EndDefine.

 * Secondary extracts storage in case the above is full, or other reasons.
Define !Extracts_Alt()
   "/conf/hscdiip/DH-Extract/"
!EndDefine.

 * Replace the number with the CSD ref.
Define !CSDRef()
    "SCTASK0065265"
!EndDefine.

Define !CSDExtractLoc()
    !Quote(!Concat(!Unquote(!Eval(!Extracts_Alt)), !Unquote(!Eval(!CSDRef))))
!EndDefine.

 * Location of source lookups.
Define !Lookup()
   "/conf/irf/05-lookups/04-geography/"
!EndDefine.

************************************************************************************************************.
 * This will automatically set from the FY macro above for example for !FY = "1718" it will produce "2017".
Define !altFY()
   !Quote(!Concat('20', !SubStr(!Unquote(!Eval(!FY)), 1, 2)))
!EndDefine.

 * This will also automatically set from the macro above, for example for !FY = "1718" it will produce Date.DMY(30, 9, 2017).
Define !midFY()
   Date.DMY(30, 9, !Unquote(!Eval(!altFY)))
!EndDefine.


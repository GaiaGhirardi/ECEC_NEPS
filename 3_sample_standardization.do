/*------------------------------------------------------------------------------
  ------------------------------------------------------------------------------
				Gaia Ghirardi - ECEC paper - October 2020
				 Standardization & Analytical Sample
 ------------------------------------------------------------------------------
------------------------------------------------------------------------------*/

clear all
set more off, perm
set cformat %3.2f

u "$working_dataset_path/xDataset_weight.dta", clear

* ---------------------------------------------------------------------------- *
* Sample
* ---------------------------------------------------------------------------- *

* Analytical sample
mark sampleF if !missing(att3, can4_wle, math5_wle, SDQ_ppb6, voc6_sum, 	 ///
	single_parent1, sensori1_wle, n_siblings1, n_sib_d, c_gend, 		 	 ///
	place, c_migr_n1, c_weight1, ses_incomeX, c_healthDD2, p_goals, benefit_ecec)

keep if sampleF == 1

* ---------------------------------------------------------------------------- *
* Standardization of competencies and SES
* ---------------------------------------------------------------------------- *

* Mathematics
	egen math5_sd = std(math5_wle) 
	lab var math5_sd "Mathematical: WLE Standardized (w5) - Objective cognitive skills"

* Categorization 
	egen cat4_sd = std(can4_wle) 
	lab var cat4_sd "Categorization: WLE Standardized (w4) - Objective cognitive skills"
	
* Vocabulary 
	egen voc6_sd = std(voc6_sum) 
	lab var voc6_sd "Vocabulary: WLE Standardized (w6) - Objective cognitive skills"	
	
* SDQ 
	egen SDQ_ppb6_sd = std(SDQ_ppb6)
	lab var SDQ_ppb6_sd "Peer problems: Standardized (w6) - Subjective non-cognitive skills"
	
* SDQ 
	egen SDQ_h6_sd = std(SDQ_h6)
	lab var SDQ_h6 "Hyperactivity: Standardized (w6) - Subjective non-cognitive skills"

* SDQ 	
	egen SDQ_bp6_sd = std(SDQ_bp6)
	lab var SDQ_bp6_sd "Behavioral problems: Standardized (w6) - Subjective non-cognitive skills"
	
* SDQ 
	egen SDQ_pb6_sd = std(SDQ_pb6)
	lab var SDQ_pb6_sd "Prosocial behavior: Standardized (w6) - Subjective non-cognitive skills"
	
* SDQ 
	egen SDQ_pb4_sd = std(SDQ_pb4)
	lab var SDQ_pb4_sd "Problems Behaviour: Standardized (w4) - Subjective non-cognitive skills"

* SDQ 
	egen SDQ_ppb4_sd = std(SDQ_ppb4)
	lab var SDQ_ppb4_sd "Peer problems: Standardized (w4) - Subjective non-cognitive skills"	
	
* Cognitive-sensorimotor development 
	egen sensori1_sd = std(sensori1_wle) 	
	lab var sensori1_sd "Cognitive-sensorimotor development: WLE Standardized (w4) - Objective cognitive skills"
	
* SES 
	egen Zses = std(ses_incomeX)	
		
* Save
order _all, alphabetic	
save "$working_dataset_path/xDataset_models.dta", replace

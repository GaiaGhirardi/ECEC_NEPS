/*------------------------------------------------------------------------------
  ------------------------------------------------------------------------------
					Gaia Ghirardi - ECEC paper - December 2020
						Weights useful for the analyses
 ------------------------------------------------------------------------------
------------------------------------------------------------------------------*/

clear all
set more off, perm
set cformat %3.2f

u "$working_dataset_path/xDataset.dta", clear

*------------------------------------------------------------------------------*	
* A. Weight to take into account selection in the SAMPLE
*------------------------------------------------------------------------------*	

* Sample variable

mark sample if !missing(att3, can4_wle, math5_wle, SDQ_ppb6, voc6_sum,		 ///
	ses_incomeX, single_parent1, n_siblings1, n_sib_d,c_gend, place, 	     ///
	c_migr_n1, c_weight1, sensori1_wle, c_healthDD2, p_goals, benefit_ecec)

logit sample att3 single_parent1 c_gend place c_migr_n1 sensori1_wle 		 ///
	i.n_siblings1 n_sib_d c_weight1 ses_incomeX c_healthDD2 p_goals benefit_ecec 
	
predict pr, pr 

bysort ID_t: gen ipw_weight=1/pr	

********************************************************************************
* Normalize the weight
********************************************************************************

sum ipw_weight
scalar ipw_weight=r(mean)
scalar n_sample=r(N)
gen ipw_weight_normalized=n_sample/(n_sample*ipw_weight) 
rename ipw_weight_normalized ipw_sample

*------------------------------------------------------------------------------*
* B. Weight to take into account selection in the TREATMENT
*------------------------------------------------------------------------------*

********************************************************************************
* Ipw
********************************************************************************

logit att3 single_parent1 c_gend place c_migr_n1 sensori1_wle i.n_siblings1  ///
	 n_sib_d i.c_weight1 ses_incomeX c_healthDD2 p_goals benefit_ecec  
	
predict pr1, pr 

bysort ID_t: gen ipw_weight1=1/pr1

********************************************************************************
* Normalize the ipw weight
********************************************************************************

sum ipw_weight1
scalar ipw_weight1=r(mean)
scalar n_sample=r(N)
gen ipw_weight1_norm=n_sample/(n_sample*ipw_weight1) 
rename ipw_weight1_norm ipw_att

*------------------------------------------------------------------------------*
* C. Weight to consider selective panel attrition - W3
*------------------------------------------------------------------------------*

bysort ID_t: gen inw3=.
	replace inw3 = 0 if att3==.
	replace inw3 = 1 if att3!=.
	
logit inw3 single_parent1 c_gend place c_migr_n1 sensori1_wle i.n_siblings1  ///
	n_sib_d i.c_weight1 ses_incomeX c_healthDD2 p_goals benefit_ecec
	
predict pr3, pr 

bysort ID_t: gen ipw_weight_w3=1/pr3

********************************************************************************
* Normalize weight
********************************************************************************

sum ipw_weight_w3
scalar ipw_weight_w3=r(mean)
scalar n_sample=r(N)
gen ipw_weight_w3_norm=n_sample/(n_sample*ipw_weight_w3) 
rename ipw_weight_w3_norm ipw_w3

*------------------------------------------------------------------------------*
* C. Weight to consider selective panel attrition - W4 & W5
*------------------------------------------------------------------------------*

mark sample_w3 if !missing(att3, single_parent1, sensori1_wle, n_siblings1,  ///
	 n_sib_d, c_gend, place, c_migr_n1, c_weight1, ses_incomeX, c_healthDD2, ///
	 p_goals, benefit_ecec)

bysort ID_t: gen inw4=.
	replace inw4 = 0 if math5_wle==.
	replace inw4 = 1 if math5_wle!=.
	
logit inw4 att3 single_parent1 c_gend place c_migr_n1 			 			 ///
		sensori1_wle i.n_siblings1 n_sib_d 		 							 ///
		i.c_weight1 ses_incomeX c_healthDD2 p_goals benefit_ecec if sample_w3==1

predict pr4, pr 

bysort ID_t: gen ipw_weight_w4=1/pr4	

********************************************************************************
* Normalize weight
********************************************************************************

sum ipw_weight_w4
scalar ipw_weight_w4=r(mean)
scalar n_sample=r(N)
gen ipw_weight_w4_norm=n_sample/(n_sample*ipw_weight_w4) 
rename ipw_weight_w4_norm ipw_w4

*------------------------------------------------------------------------------*
* C. Weight to consider selective panel attrition - W6
*------------------------------------------------------------------------------*

mark sample_w5 if !missing(att3, single_parent1, sensori1_wle, n_siblings1,  ///
	n_sib_d, c_gend, place, c_migr_n1, c_weight1, ses_incomeX, can4_wle, 	 ///
	math5_wle, c_healthDD2, p_goals, benefit_ecec)
	 
bysort ID_t: gen inw6=.
	replace inw6 = 0 if SDQ_ppb6==.
	replace inw6 = 1 if SDQ_ppb6!=.
	
logit inw6 att3 single_parent1 c_gend place c_migr_n1 			 			 ///
	sensori1_wle i.n_siblings1 n_sib_d i.c_weight1 ses_incomeX c_healthDD2	 ///
	p_goals benefit_ecec if sample_w5==1
	
predict pr6, pr 

bysort ID_t: gen ipw_weight_w6=1/pr6	

********************************************************************************
* Normalize weight
********************************************************************************

sum ipw_weight_w6
scalar ipw_weight_w6=r(mean)
scalar n_sample=r(N)
gen ipw_weight_w6_norm=n_sample/(n_sample*ipw_weight_w6) 
rename ipw_weight_w6_norm ipw_w6

*------------------------------------------------------------------------------*
* D. Moltiplication weights
*------------------------------------------------------------------------------*

* IPW and attrition
gen weight_ipw_at = ipw_att*ipw_w3*ipw_w4*ipw_w6 

* IPW and selection in the sample
gen weight_ipw_simple = ipw_att*ipw_sample 

* IPW, sample and attrition (use it in H1)
gen weight_ipw_atW3 = ipw_att*ipw_w3*ipw_sample 

* IPW, sample and attrition (use it in H2 & H3 - for categorization & mathematics)
gen weight_ipw_atW45 = ipw_att*ipw_w3*ipw_w4*ipw_sample 

* IPW, sample and attrition (use it in H2 & H3 - for peer problem behaviour & vocabulary)
gen weight_ipw_atW6 = ipw_att*ipw_w3*ipw_w4*ipw_w6*ipw_sample 

*------------------------------------------------------------------------------*
* E. Dropping not useful variables
*------------------------------------------------------------------------------*

drop pr1 pr3 pr4 pr6 pr inw3 inw4 inw6 ipw_weight_w6 ipw_weight_w4 ipw_weight_w3 sample
drop ipw_att ipw_w3 ipw_w4 ipw_w6 ipw_sample sample_w5 sample_w3 ipw_weight1 ipw_weight

save "$working_dataset_path/xDataset_weight.dta", replace


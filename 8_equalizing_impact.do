/* -----------------------------------------------------------------------------
  ------------------------------------------------------------------------------
					Gaia Ghirardi - ECEC paper - December 2020
							What if analysis 
 ------------------------------------------------------------------------------
----------------------------------------------------------------------------- */

use "$working_dataset_path/xDataset_models.dta", clear

* Mathematics	
reg math5_sd i.att3##c.Zses [pw=weight_ipw_atW45]
est store math1
	
margins, dydx(Zses) post // observed 
est store ape_math1

est restore math1
margins, dydx(Zses) at(att3=0) post // scenario 1
est store ape0_math1

est restore math1
margins, dydx(Zses) at(att3=1) post // scenario 2
est store ape1_math1

coefplot (ape_math1, pstyle(p8)) 											 ///
	(ape0_math1, pstyle(p9)) 												 ///
	(ape1_math1, pstyle(p10)), vertical scale(1.2) 							 ///
	xlab(none) yline(0)  ytitle ("Standard Deviation", size(small)) 		 ///
	title ("Mathematics (4 y)", span size(medium)) 							 ///
	ciopts(recast(rcap)) 													 ///
	legend(lab(2 "Observed") 												 ///
	lab(4 "Scenario 1: No ECEC") 											 ///
	lab(6 "Scenario 2: Everyone in ECEC") col(3) color(black) size(medium))  ///
       name(math, replace)

* Categorization
reg cat4_sd i.att3##c.Zses [pw=weight_ipw_atW45] 	
est store cat1
	
margins, dydx(Zses) post // observed 
est store ape_cat1

est restore cat1
margins, dydx(Zses) at(att3=0) post // scenario 1
est store ape0_cat1

est restore cat1
margins, dydx(Zses) at(att3=1) post // scenario 2
est store ape1_cat1	

coefplot (ape_cat1, pstyle(p8)) 											 ///
	(ape0_cat1, pstyle(p9)) 												 ///
	(ape1_cat1, pstyle(p10)), vertical scale(1.2) 							 ///
	xlab(none) yline(0)  ytitle ("Standard Deviation", size(small)) 		 ///
	title ("Categorization (3 y)", span size(medium)) 						 ///
	ciopts(recast(rcap)) 													 ///
	legend(lab(2 "Observed") 												 ///
		   lab(4 "Scenario 1: No ECEC") 									 ///
		   lab(6 "Scenario 2: Everyone in ECEC") col(3) size(medium))  		 ///
       name(cat, replace)
	
* Vocabulary
reg voc6_sd i.att3##c.Zses [pw=weight_ipw_atW6]	
est store voc6_sd	
	
margins, dydx(Zses) post // observed 
est store ape_voc6_sd

est restore voc6_sd
margins, dydx(Zses) at(att3=0) post // scenario 1
est store ape0_voc6_sd

est restore voc6_sd
margins, dydx(Zses) at(att3=1) post // scenario 2
est store ape1_voc6_sd

coefplot (ape_voc6_sd, pstyle(p8)) 											 ///
	(ape0_voc6_sd, pstyle(p9)) 												 ///
	(ape1_voc6_sd, pstyle(p10)), vertical scale(1.2) 						 ///
	xlab(none) yline(0)   ytitle ("Standard Deviation", size(small)) 		 ///
	title ("Vocabulary (5 y)", span size(medium))							 ///
	ciopts(recast(rcap)) 													 ///
	legend(lab(2 "Observed")											 	 ///
		   lab(4 "Scenario 1: No ECEC") 									 ///
		   lab(6 "Scenario 2: Everyone in ECEC") col(3) size(medium)) 		 ///
       name(voc, replace)

* Peers problems behaviour
reg SDQ_ppb6_sd i.att3##c.Zses [pw=weight_ipw_atW6] 
est store m4_ppb1 
	
margins, dydx(Zses) post // observed 
est store ape_m4_ppb1

est restore m4_ppb1 
margins, dydx(Zses) at(att3=0) post // scenario 1
est store ape0_m4_ppb1

est restore m4_ppb1 
margins, dydx(Zses) at(att3=1) post // scenario 2
est store ape1_m4_ppb1	

coefplot (ape_m4_ppb1, pstyle(p8)) 											 ///
	(ape0_m4_ppb1, pstyle(p9)) 												 ///
	(ape1_m4_ppb1, pstyle(p10)), vertical scale(1.2) 						 ///
	xlab(none) yline(0)  ytitle ("Standard Deviation", size(small)) 		 ///
	title ("Peers problems (5 y)", span size(medium)) 						 ///
	ciopts(recast(rcap)) 													 ///
	legend(lab(2 "Observed") 												 ///
		   lab(4 "Scenario 1: No ECEC") 									 ///
		   lab(6 "Scenario 2: Everyone in ECEC") col(3) size(medium)) 		 ///
       name(ppb, replace) 

*summary table
est table ape_math1 ape0_math1 ape1_math1 									 ///
	ape_cat1 ape0_cat1 ape1_cat1 											 ///
	ape_voc6_sd ape0_voc6_sd ape1_voc6_sd 									 ///
	ape_m4_ppb1 ape0_m4_ppb1 ape1_m4_ppb1 									 ///
	, b(%9.3f) star

*graph
grc1leg cat math voc ppb,  ycom col(4)    									 ///
	saving($output/H3_equalizing, replace) 
	
graph export "$output/H3_equalizing.pdf",  replace		

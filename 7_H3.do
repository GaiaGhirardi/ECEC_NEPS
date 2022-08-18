/*------------------------------------------------------------------------------
------------------------------------------------------------------------------
				Gaia Ghirardi - ECEC paper - December 2020
	H3: The startified effect of ECEC attendance on children's competencies 
--------------------------------------------------------------------------------
------------------------------------------------------------------------------*/

clear all
set more off, perm
set cformat %3.2f
u "$working_dataset_path/xDataset_models.dta", clear

svyset psu , strata(stratum)

* Mathematics
reg math5_sd i.att3##c.Zses [pw=weight_ipw_atW45]

margins, dydx(att3) at(Zses=(-2.6636(.5)1.435615)) post
	est store math_t

marginsplot, yline(0) xlab(-2.6636 "Lowest SES"  -2 "-2" 					 ///
	-1 "-1"  0 "0"  1 "1" 1.435615 "Top SES") ciopts(recast(rarea) 	 		 ///
	color(cranberry%15)) plotopts(mcolor("cranberry") lcolor("cranberry") 	 ///
	mfc(white))  xtitle("SES", size(medium)) ytitle("z-score", size(medium)) ///
	title ("Mathematics (4 years old)", size(large)) name(math, replace) 
	
* Categorization
reg cat4_sd i.att3##c.Zses [pw=weight_ipw_atW45]

margins, dydx(att3) at(Zses=(-2.6636(.5)1.435615)) post
	est store cat_t
	
marginsplot, yline(0) xlab(-2.6636 "Lowest SES"  -2 "-2" 					 ///
	-1 "-1"  0 "0"  1 "1" 1.435615 "Top SES")  ciopts(recast(rarea)  	 	 ///
	color(forest_green%15)) plotopts(mcolor("dkgreen") lcolor("dkgreen")  	 ///
	mfc(white)) xtitle("SES", size(medium)) ytitle("z-score", size(medium))  ///
	title ("Categorization (3 years old)", size(large)) name(cat, replace)

* Vocabulary
reg voc6_sd i.att3##c.Zses [pw=weight_ipw_atW6]

margins, dydx(att3) at(Zses=(-2.6636(.5)1.435615)) post
	est store voc6
	
marginsplot, yline(0) xlab(-2.6636 "Lowest SES"  -2 "-2" 	 				 ///
	-1 "-1"  0 "0"  1 "1" 1.435615 "Top SES")  ciopts(recast(rarea) 	 	 ///
	color(navy%15)) plotopts(mcolor("dknavy") lcolor("dknavy") mfc(white))	 ///
	xtitle("SES", size(medium)) ytitle("z-score", size(medium))				 ///
	title ("Vocabulary (5 years old)", size(large)) name(voc6_sd, replace)	

* Peers problems behaviour
reg SDQ_ppb6_sd i.att3##c.Zses [pw=weight_ipw_atW6]

margins, dydx(att3) at(Zses=(-2.6636(.5)1.435615)) post
	est store sdq_t

marginsplot, yline(0) xlab(-2.6636 "Lowest SES"  -2 "-2" 					 ///
	-1 "-1"  0 "0"  1 "1" 1.435615 "Top SES") ciopts(recast(rarea) 	 		 /// 
	color(navy%15)) plotopts(mcolor("emerald") lcolor("emerald") mfc(white)) ///
	xtitle("SES", size(medium))  ytitle("z-score", size(medium)) 			 ///
	title ("Peer problems (5 years old)", size(large)) name(sdq, replace)

graph combine cat math voc6_sd sdq, col(2) ycom saving($output/H3, replace) 
	
graph export "$output/H3.pdf",  replace		

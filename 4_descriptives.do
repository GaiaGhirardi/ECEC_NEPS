/*------------------------------------------------------------------------------
  ------------------------------------------------------------------------------
					Gaia Ghirardi - ECEC paper - July 2020
					Some descriptive statistics in APPENDIX	
 ------------------------------------------------------------------------------
------------------------------------------------------------------------------*/
		
clear all
set more off, perm

u "$working_dataset_path/xDataset_models.dta", clear
cd $output

********************************************************************************
* The relationship between SES and competencies 
********************************************************************************

tw qfitci math5_sd Zses [pw=weight_ipw_atW6], yline(0) ytitle(z-score) 		 ///
	xtitle("") acolor(dkgreen%40) lcolor(dkgreen) lw(medthick)  			 ///
	clp(dash) alw(thin) xlab(-2.663658 "Lowest SES" -2.027677 "-2" 			 ///
	-1.527677 "-1.5"  -1.027677 "-1" -0.527677 "-0.5" -0.027677 "0" 0.472323 ///
	"0.5" 0.972323 	 "1" 1.572811 "Top SES")	 							 ///					
	 legend(off) title(Mathematics (4 years old)) name(math, replace)

tw qfitci cat4_sd Zses [pw=weight_ipw_atW6], yline(0) ytitle(z-score) 		 ///
	xtitle("") acolor(dkgreen%40) lcolor(dkgreen) lw(medthick)  			 ///
	clp(dash) alw(thin) xlab(-2.663658 "Lowest SES" -2.027677 "-2" 			 ///
	-1.527677 "-1.5"  -1.027677 "-1" -0.527677 "-0.5" -0.027677 "0" 0.472323 ///
	"0.5" 0.972323 	 "1" 1.572811 "Top SES") legend(off)  					 ///
	title(Categorization (3 years old)) name(cat, replace) 

tw qfitci voc6_sd Zses [pw=weight_ipw_atW6], yline(0) ytitle(z-score) 		 ///
	xtitle("") acolor(dkgreen%40) lcolor(dkgreen) lw(medthick)  			 ///
	clp(dash) alw(thin) xlab(-2.663658 "Lowest SES" -2.027677 "-2" 			 ///
	-1.527677 "-1.5"  -1.027677 "-1" -0.527677 "-0.5" -0.027677 "0" 0.472323 ///
	"0.5" 0.972323 	 "1" 1.572811 "Top SES")	 							 ///
	legend(off) title(Vocabulary (5 years old)) name(voc6_sd, replace)

tw qfitci SDQ_ppb6_sd Zses [pw=weight_ipw_atW6], yline(0) ytitle(z-score) 	 ///
	xtitle("") acolor(dkgreen%40) lcolor(dkgreen) lw(medthick)  			 ///
	clp(dash) alw(thin) xlab(-2.663658 "Lowest SES" -2.027677 "-2" 			 ///
	-1.527677 "-1.5"  -1.027677 "-1" -0.527677 "-0.5" -0.027677 "0" 0.472323 ///
	"0.5" 0.972323 	 "1" 1.572811 "Top SES")	 							 ///
	legend(off) title(Peer problems behaviour (5 years old))   ///
	name(sdq, replace)
	
graph combine cat math voc6_sd sdq, col(2) ycom saving($output/descriptive_ses_competencies, replace) 
	 	
cd $dofile		
	
********************************************************************************
* Competencies distribution
********************************************************************************

kdens sensori1_sd, norm color(dkgreen%30) recast(area) xtitle("")			 ///
	title("Cognitive sensorimotor (7 months)", size(medsmall)) 				 ///
	name(sens, replace)
	
kdens sensori1_sd, norm color(dkgreen%30) recast(area) xtitle("")			 ///
	title("Mathematics (4 years old)", size(medsmall)) name(math, replace)
	
kdens cat4_sd, norm color(dkgreen%30) recast(area) xtitle("") 				 ///
	title("Categorization (3 years old)", size(medsmall)) name(cat, replace)
	
kdens SDQ_ppb6_sd, norm color(dkgreen%30) recast(area) xtitle("") 			 ///
	title("Peers problems behaviour (5 years old)", size(medsmall)) 		 ///
	name(sdq6, replace)
	
kdens voc6_sd, norm color(dkgreen%30) recast(area) xtitle("") 				 ///
	title("Vocabulary (5 years old)", size(medsmall)) name(voc6, replace)

grc1leg sens cat math sdq6 voc6, col(3) ycom ring(0) pos(5)		
saving($output/ditribution_competencies, replace) 
	
graph export "$output/ditribution_competencies.jpg", quality(100) replace	

********************************************************************************
* The relationship between Sensorimotor and competencies 
********************************************************************************

u "$working_dataset_path/xDataset.dta", clear
cd $output

* SES 
	egen Zses = std(ses_incomeX)	

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
	
* Cognitive-sensorimotor development
	egen sensori1_sd = std(sensori1_wle) 	
	lab var sensori1_sd "Cognitive-sensorimotor development: WLE Standardized (w4) - Objective cognitive skills"
		
*rename variables 
rename single_parent1 cohabitation
rename c_gend gender
rename place place_residence
rename c_migr_n1 migr_background
rename c_weight1 low_weight
rename c_healthDD2 child_health
rename n_sib_d change_n_siblings
rename Zses SES
rename att3 ECEC

* controls
global Zs "cohabitation gender place_residence migr_background n_siblings1 change_n_siblings low_weight child_health benefit_ecec p_goals"

* Mathematics
reg math5_sd sensori1_sd $Zs
margins, at(sensori1_sd=(-2.942863(.5)2.451685))	
marginsplot, yline(0) xlab(-2.942863 "Low " 2.451685 "High") ciopts(recast(rarea) 	 		 ///
	color(dkgreen%10)) plotopts(mcolor("dkgreen") lcolor("dkgreen") 	 ///
	mfc(white))  xtitle("Sensorimotor Development", size(medium)) ytitle("z-score", size(medium)) ///
	title ("Mathematics (4 years old)", size(large)) name(math, replace) 

* Categorization 
reg cat4_sd sensori1_sd $Zs
margins, at(sensori1_sd=(-2.942863(.5)2.451685))
marginsplot, yline(0) xlab(-2.942863 "Low " 2.451685 "High") ciopts(recast(rarea) 	 		 ///
	color(dkgreen%10)) plotopts(mcolor("dkgreen") lcolor("dkgreen") 	 ///
	mfc(white))  xtitle("Sensorimotor Development", size(medium)) ytitle("z-score", size(medium)) ///
	title ("Categorization (3 years old)", size(large)) name(cat, replace) 

* Vocabulary 
reg voc6_sd sensori1_sd $Zs
margins, at(sensori1_sd=(-2.942863(.5)2.451685))	
marginsplot, yline(0) xlab(-2.942863 "Low " 2.451685 "High") ciopts(recast(rarea) 	 		 ///
	color(dkgreen%10)) plotopts(mcolor("dkgreen") lcolor("dkgreen") 	 ///
	mfc(white))  xtitle("Sensorimotor Development", size(medium)) ytitle("z-score", size(medium)) ///
	title ("Vocabulary (5 years old)", size(large)) name(voc, replace) 

* SDQ 
reg SDQ_ppb6_sd sensori1_sd $Zs
margins, at(sensori1_sd=(-2.942863(.5)2.451685))
marginsplot, yline(0) xlab(-2.942863 "Low " 2.451685 "High") ciopts(recast(rarea) 	 		 ///
	color(dkgreen%10)) plotopts(mcolor("dkgreen") lcolor("dkgreen") 	 ///
	mfc(white))  xtitle("Sensorimotor Development", size(medium)) ytitle("z-score", size(medium)) ///
	title ("Peer problems (5 years old)", size(large)) name(sdq, replace) 

* combine
graph combine cat math voc sdq, col(2) ycom 		
	
graph export "$output/descriptive_ses_competencies.jpg", quality(100) replace		 
	
cd $dofile	  
  
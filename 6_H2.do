/*------------------------------------------------------------------------------
  ------------------------------------------------------------------------------
				Gaia Ghirardi - ECEC paper - December 2020
		 H2: The MAIN effect of ECEC attendance on children's competencies 
									IPW
 ------------------------------------------------------------------------------
------------------------------------------------------------------------------*/

clear all
set more off, perm
set cformat %3.2f
u "$working_dataset_path/xDataset_models.dta", clear

* Mathematics	
reg math5_sd att3 [pw=weight_ipw_atW45]
	est store m4_math1

* Categorization
reg cat4_sd att3 [pw=weight_ipw_atW45]	
	est store m4_cat1
	
* Vocabulary
reg voc6_sd att3	[pw=weight_ipw_atW6]	
	est store voc6_sd		

* Peers problems behaviour
reg SDQ_ppb6_sd att3 [pw=weight_ipw_atW6]	
	est store m4_ppb1 

coefplot (m4_cat1, label(Categorization (3 years old))  pstyle(p7))			 ///
	(m4_math1, label(Mathematics (4 years old))  pstyle(p4)) 				 /// 
	(voc6_sd, label(Vocabulary (5 years old))  pstyle(p5))  				 ///
	(m4_ppb1, label(Peers problems behaviour (5 years old))  pstyle(p6))  	 ///
     , keep(att3) $yzeror xlab("") vertical								 	 ///
	 ytitle("z-score", size(small))											 ///
	ciopts(recast(rcap)) legend(col(2) size(vsmall))						 ///
	name(coefplot_ols4_math5, replace) saving($output/H2_att, replace)
	
graph export "$output/H2_att.pdf",  replace





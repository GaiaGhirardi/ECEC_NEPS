/*------------------------------------------------------------------------------
  ------------------------------------------------------------------------------
				Gaia Ghirardi - ECEC paper - October 2020
				H1: Social Inequalities in the use of ECEC 
 ------------------------------------------------------------------------------
------------------------------------------------------------------------------*/

clear all
set more off, perm

u "$working_dataset_path/xDataset_models.dta", clear
cd $output

logit att3 c.Zses [pw=weight_ipw_atW3], or
predict prob1, pr
predictnl phat = predict(), ci(upci lowci)

preserve 
collapse prob1 upci lowci, by(Zses)

gen probability = prob1*100
gen upper = upci*100
gen lower = lowci*100

tw rarea upper lower Zses, color(maroon%20) || line probability Zses, 		 ///
	name(predicted, replace) lc(maroon)  									 /// 
	ytitle("Predicted probabilities") 										 ///
	xlab(-2.6636 "Lowest SES"  -2 "-2" 										 ///
	-1 "-1"  0 "0"  0.8 "1" 1.435615 "Top SES") xtitle("SES")				 ///
	ylab(0 20 40 60 80, labsize(medium)) legend(off) 						 ///
	text(79 -2.2 "OR: 1.28 [CI: 1.21; 1.47]", size(small))					 ///
	text(73 -2.2 "AME: 0.06 [CI: 0.02; 0.08]", size(small))					 ///
	saving($output/H1_att3, replace) 

graph export "$output/H1_att3.pdf" , replace	
	
restore

clear all
u "$working_dataset_path/xDataset_models.dta", clear
cd $dofile

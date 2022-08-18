/*------------------------------------------------------------------------------
  ------------------------------------------------------------------------------
					Gaia Ghirardi - ECEC paper - October 2020
							Data preparation
 ------------------------------------------------------------------------------
------------------------------------------------------------------------------*/

* -----------------------------------------------------------------------------*
* Children's demographic & socio-economic background information 
* -----------------------------------------------------------------------------*

use "$original_dataset_path/SC1_pParent_D_${version}.dta", clear
	label language en
	isid ID_t wave
	xtset ID_t wave
	sort ID_t wave 
	
keep ID_t wave p751001_g1 p700010 p529000_D pb10000 p731802_g2 p731852_g2 	 ///
		  p731802_g1 p731852_g1 p731802_g3 p731852_g3 p731111 p400500_g1v1	 ///
		  p731904_g14 p731954_g14 p510005 p741001 p742001 p521000
	
isid ID_t wave
xtset ID_t wave
sort ID_t wave

nepsmiss _all, 

	rename p751001_g1 place_residence       // Place of Residence (RS West/East)
	rename p700010 c_gender                 // Gender 
	rename p529000_D c_weight               // Birth weight
	rename pb10000 n_siblings        		// Number of siblings
	rename p731802_g2 p1_casmin				// Mother's education (CASMIN)
	rename p731852_g2 p2_casmin 			// Father's education (CASMIN)
	rename p731802_g1 p1_isced 				// Mother's education (ISCED)
	rename p731852_g1 p2_isced 				// Father's education (ISCED)
	rename p731802_g3 p1_edu_years 			// Mother's education (years)
	rename p731852_g3 p2_edu_years 			// Father's education (years)
	rename p731111 single_parent 			// Family composition
	rename p400500_g1v1 c_migr 				// Migration background 
	rename p731904_g14 p1_isei1 			// Mothers Occupation
	rename p731954_g14 p2_isei1 			// Fathers Occupation
	rename p510005 income1 					// Household income
	rename p741001 n_people_household 		// n. people in the house
	rename p742001 n_under14 				// n. people under 14
	rename p521000 c_health					// Child's health
	
* Child health
	fre c_health
	recode c_health (1 2 = 0) (3 4 5 =1), gen(c_healthD)
	lab def c_healthD 0 "Good" 1 "Not good"
	lab value c_healthD c_healthD

	recode c_health (1 = 0) (2 3 4 5 =1), gen(c_healthDD)
	lab def c_healthDD 0 "Very good" 1 "Not very good"
	lab value c_healthDD c_healthDD
	
* Equalized family income 
	fre income1 if wave==1 // n:2926
	bys ID_t (wave): gen ID_pynr = _n
	mipolate income1 ID_pynr, gen(income2) nearest ties (a) by(ID_t)
	drop ID_pynr
	gen n_adult= n_people_household - n_under14
	gen eqs =.
	replace eqs = 1+(n_adult - 1)*0.5 + n_under14 * 0.3 if n_adult>=1
	gen income = income2*eqs 
	fre income if wave==1 // n:3321

* Mothers' education (CASMIN)		
	fre p1_casmin if wave==1 // n: 3472 
	bysort ID_t: egen p1_edu=max(p1_casmin) 
	bysort ID_t: replace p1_casmin=p1_edu if p1_casmin==.l
	bysort ID_t: replace p1_casmin=p1_edu if p1_casmin==.
	fre p1_casmin if wave==1 // n: 3479 
	recode p1_casmin 0/3=1 4/6=2 7/8=3
	lab def p1_casmin 1 "Low" 2 "Medium" 3 "High"
	lab value p1_casmin p1_casmin
	drop p1_edu

* Fathers' education (CASMIN)	
	fre p2_casmin if wave==1 // n: 3224 
	bysort ID_t: egen p2_edu=max(p2_casmin) 
	bysort ID_t: replace p2_casmin=p2_edu if p2_casmin==.l
	bysort ID_t: replace p2_casmin=p2_edu if p2_casmin==.
	fre p2_casmin if wave==1 // n: 3300 
	recode p2_casmin 0/3=1 4/6=2 7/8=3
	lab def p2_casmin 1 "Low" 2 "Medium" 3 "High"
	lab value p2_casmin p2_casmin
	drop p2_edu

* Place of Residence (RS West/East)	
	recode place_residence 2=1 1=0
	lab def place_residence 0 "Western Germany" 1 "Eastern Germany incl. Berlin", replace
	lab val place_residence place_residence
	lab var place_residence "Place of residence"
	
* Child's gender
	recode c_gender 2=0 0=1
	lab def c_gender 0 "Female" 1 "Male", replace
	lab val c_gender c_gender
	lab var c_gender "Gender (child)"	
	
* Partnership status
	recode single_parent 2=0 1=1
	lab def single_parent 1 "Yes" 0 "No"
	lab value single_parent single_parent
	lab var single_parent "Cohabitation family (! attention not single)" 
	preserve
	drop if wave>=4
	xtset
	xttrans single_parent
	restore
	
* N. of siblings 
	recode n_siblings 0=0 1=1 2/12=2
	lab def n_siblings 0 "0 siblings" 1 "1 sibling" 2 "2 or more siblings", replace
	lab val n_siblings n_siblings

* Migration background 
	gen c_migr_n = c_migr
	recode c_migr_n 0=0 7/9=0 2/6=1
	recode c_migr 0=0 2/9=1
	lab def c_migr 0 "No" 1 "Yes", replace
	lab def c_migr_n 0 "No" 1 "Yes", replace
	lab val c_migr c_migr	
	lab val c_migr_n c_migr_n	
	lab var c_migr "Migration background"
	lab var c_migr_n "Migration background"
	
* Birth weight 
	recode c_weight 1/2=1 3/7=0
	lab def c_weight 1 "under 2500g" 0 "more than 2500g", replace 
	lab val c_weight c_weight	

keep ID_t  wave c_gender place_residence n_siblings c_weight single_parent	 ///
	income p1_casmin p2_casmin c_migr_n c_healthDD 
	 
reshape8 wide c_gender place_residence n_siblings c_weight single_parent	 ///
	income p1_casmin p2_casmin c_migr_n c_healthDD, i(ID_t) j(wave)
	
keep ID_t c_gender1 place_residence1 n_siblings1 c_weight1 single_parent1	 ///
	single_parent2 single_parent3 income1 p1_casmin1 p2_casmin1 			 ///
	c_migr_n1 c_healthDD2 n_siblings3
	
** Data management of more type-varying variable: change in number of siblings
	gen n_sib_delta= n_siblings3 - n_siblings1
	recode n_sib_delta (-4/0=0 "No more siblings born") (1/4=1 "One or more siblings born"), gen (n_sib_d)
	lab var n_sib_d "Change in number of siblings"
	drop  n_sib_delta	

** Income: from quantitative variable -> categorical variable
	egen incomeX = xtile (income1), n(5)	
	
** To create SES variables: edu mother, edu father and income  
	polychoricpca p1_casmin1 p2_casmin1 incomeX, score(ses_incomeX) nscore(1)
	drop incomeX 
			
* save
order _all, alphabetic
save "$working_dataset_path/xDemo.dta", replace
	
* ---------------------------------------------------------------------------- *
*  Children's competencies 
* ---------------------------------------------------------------------------- *

* 1. Cognitive measures 

u "$original_dataset_path/SC1_xTargetCompetencies_D_$version", clear 
	label language en
keep ID_t man5_sc1 wave_w* can4_sc1 von6_sc3
nepsmiss _all

	rename man5_sc1 math5_wle 				// Mathematics
	rename can4_sc1 can4_wle 				// Categorization: SON-R Subtest 
	rename von6_sc3 voc6_sum 				// Vocabulary: useful for MICE

* save 
keep ID_t can4_wle math5_wle voc6_sum
order _all, alphabetic 
save "$working_dataset_path/xCognitive_after.dta", replace

* 2. Socio-emotional measures

use "$original_dataset_path/SC1_pParent_D_${version}.dta", clear
	lab lang en
	isid ID_t wave
	xtset ID_t wave	
keep ID_t wave p67801c_g1 p67801a_g1 p67801k_g1 p67801l_g1
nepsmiss _all

	rename p67801c_g1 SDQ_ppb 					// Peer problems behaviour
	rename p67801a_g1 SDQ_pb 					// Pro-social behaviour
	rename p67801k_g1 SDQ_h 					// Hyperactivity
	rename p67801l_g1 SDQ_bp 					// Behavioural problems	

reshape8 wide SDQ_ppb SDQ_pb SDQ_h SDQ_bp, i(ID_t) j(wave)
keep ID_t  SDQ_ppb4 SDQ_pb4 SDQ_bp6 SDQ_ppb6 SDQ_pb6 SDQ_h6

* save 
order _all, alphabetic
save "$working_dataset_path/xNoncognitive_after.dta", replace

* 3. Children's competencies before the treatment

use "$original_dataset_path/SC1_xDirectMeasures_D_${version}.dta", clear
	lab lang en
keep if wave_w1==1 
keep ID_t cdn1_sc1
nepsmiss _all

	rename cdn1_sc1 sensori1_wle // Sensorimotor development

* Save
keep ID_t sensori1_wle
order _all, alphabetic
save "$working_dataset_path/xCompetencies_before.dta", replace

* -----------------------------------------------------------------------------*
* Childcare
* -----------------------------------------------------------------------------*

u "$original_dataset_path/SC1_pParent_D_$version.dta", clear
	label language en	
	sort ID_t wave
	keep ID_t wave pa0100a pa0100b pa0100c pa0100d pa0100e pa0100f 	

nepsmiss _all

* I change title and lables of the variables 	
	recode pa0100a (0=0 "No") (1=1 "Yes"), gen (ecec_cb_attendance)	
	recode pa0100b (0=0 "No") (1=1 "Yes"), gen (ecec_fdc_attendance)	
	recode pa0100c (0=0 "No") (1=1 "Yes"), gen (nanny_attendance)	
	recode pa0100d (0=0 "No") (1=1 "Yes"), gen (aupair_attendance)	
	recode pa0100e (0=0 "No") (1=1 "Yes"), gen (grandparents_attendance)	
	recode pa0100f (0=0 "No") (1=1 "Yes"), gen (relatives_attendance)	
	
	drop pa0100*

* Parental care only
	gen pa =.
	replace pa = 1 if ecec_cb_attendance==.y 
	replace pa = 0 if ecec_cb_attendance==1 | ecec_fdc_attendance==1 |		 ///
	nanny_attendance==1 | aupair_attendance==1 | grandparents_attendance==1 | ///
	relatives_attendance==1
	lab define pa 1 "Only" 0 "Not Only"
	lab value pa pa
	lab var pa "Parental care only"	
	
* ECEC attendance
	replace ecec_cb_attendance = 0 if ecec_cb_attendance ==.y 
	
* ECEC + FDC attendance
	gen ecec_cd_fdc = ecec_cb_attendance
	replace ecec_cd_fdc = 1 if ecec_fdc_attendance == 1
	lab define ecec_cd_fdc 1 "Yes" 0 "No"
	lab value ecec_cd_fdc ecec_cd_fdc
	lab var ecec_cd_fdc "ECEC CB + FDC"
	
keep ID_t wave ecec_cb_attendance ecec_fdc_attendance nanny_attendance 		 ///
	aupair_attendance grandparents_attendance relatives_attendance pa ecec_cd_fdc
	
reshape8 wide ecec_cb_attendance ecec_fdc_attendance nanny_attendance 	   	 ///
	aupair_attendance grandparents_attendance relatives_attendance pa 		 ///
	ecec_cd_fdc, i(ID_t) j(wave)

keep ID_t ecec_cb_attendance3  ecec_fdc_attendance3 nanny_attendance3 	   	 ///
	aupair_attendance3 grandparents_attendance3 relatives_attendance3 pa3    ///
	ecec_cb_attendance2 ecec_cb_attendance1 ecec_cd_fdc3 ecec_cd_fdc2
	
* save
order _all, alphabetic
save "$working_dataset_path/xChildCare_attendance", replace	

* Family day care only
	gen fdc_only=.
	replace fdc_only=0 if ecec_fdc_attendance==0 & nanny_attendance==1 		 ///
	| aupair_attendance==1 | grandparents_attendance==1  				  	 ///
	| relatives_attendance==1 | ecec_cb_attendance3==1 | pa3==1	
	replace fdc_only=1 if ecec_fdc_attendance==1 & nanny_attendance==0 		 ///
	& aupair_attendance==0 & grandparents_attendance==0  					 ///
	& relatives_attendance==0 & ecec_cb_attendance3==0 & pa3==0	
	lab define fdc_only 1 "Only FDC" 0 "Not Only"
	lab value fdc_only fdc_only
	lab var fdc_only "FDC only"

* ECEC 
	* ECEC only 
	gen ecec_cb_only=.
	
	// children who attend ONLY ECEC (x=1)
	replace ecec_cb_only=1 if ecec_cb_attendance3==1 & nanny_attendance==0	 ///
	& aupair_attendance==0 & grandparents_attendance==0 					 ///
	& relatives_attendance==0  & ecec_fdc_attendance==0 & pa3==0	
	
	// reference category children who attended ECEC and other forms of care (x=0)
	replace ecec_cb_only=0 if ecec_cb_attendance3==1 & nanny_attendance==1   ///
	| aupair_attendance==1 | grandparents_attendance==1  					 ///
	| relatives_attendance==1 | ecec_fdc_attendance==1 
	
	// reference category children who did not attend ECEC but other forms of care (x=0)
	replace ecec_cb_only=0 if ecec_cb_attendance3==0 & nanny_attendance==1   ///
	| aupair_attendance==1 | grandparents_attendance==1  					 ///
	| relatives_attendance==1 | ecec_fdc_attendance==1 | pa3==1	
	
	lab define ecec_cb_only 1 "Only ECEC" 0 "Not Only or No ECEC"
	lab value ecec_cb_only ecec_cb_only
	lab var ecec_cb_only "ECEC only"

	* ECEC only 
	clonevar att3 = ecec_cb_only
	replace att3 = . if ecec_cb_attendance3==1 & ecec_cb_only==0 
	lab define att3 1 "Only ECEC" 0 "Not ECEC"
	lab value att3 att3
	lab var att3 "ECEC only vs no ecec attendance"
	
drop ecec_cd_fdc2 ecec_cd_fdc3 ecec_cb_only fdc_only ecec_cb_attendance3	 ///
	ecec_cb_attendance2 ecec_cb_attendance1 ecec_fdc_attendance3			 ///
	aupair_attendance3 nanny_attendance3 grandparents_attendance3 relatives_attendance3
	
* save
order _all, alphabetic
save "$working_dataset_path/xChildCare_attendance", replace	

* -----------------------------------------------------------------------------*
* Potential controls for unobserved heterogeneity 
* -----------------------------------------------------------------------------*

u "$original_dataset_path/SC1_pParent_D_${version}.dta", clear
	label language en
	isid ID_t wave
	xtset ID_t wave
	sort ID_t wave 
	
keep ID_t wave p30211a p30211b p66804b p66804c p66804e p66804f p66804h 		 ///
	p66804k p66804m  p66804n p66804o p66804h p66804m 
	
keep if wave==1	

nepsmiss _all, 
 
* 1. Maternal rational choice perceptions
	fre p30211b // Benefits: with regard to child development 

* reshape 
keep ID_t wave p30211b 
reshape8 wide p30211b, i(ID_t) j(wave)		
keep ID_t p30211b1 	

* Benefit ECEC 
	recode p30211b1 1/3=0  4/5=1, gen (benefit_ecec)
	lab var benefit_ecec "Benefit expectation Daycare: enrichment"
	lab define benefit_ecec 0 "Bad and not (very) good" 1 "Good or very good"
	lab value benefit_ecec benefit_ecec

* save
order _all, alphabetic
save "$working_dataset_path/xAdditionalControls", replace		

* 2. Educational goals 

use "$original_dataset_path/SC1_pParent_D_${version}.dta", clear
	label language en
	isid ID_t wave
	xtset ID_t wave
	sort ID_t wave 
	
keep ID_t wave p67800a p67800b p67800c p67800d p67800e p67800f p67800g

nepsmiss _all, 

keep if wave==2

	corr p67800a p67800b p67800c p67800d p67800e p67800f p67800g
	factor p67800a p67800b p67800c p67800d p67800e p67800f p67800g, 		 ///
	pcf blanks(0.4)
	rotate, blanks (.4)
	
	gen fact2=(p67800a + p67800b + p67800c + p67800f + p67800g)/5 if e(sample)	
	sum fact2	
	alpha p67800a p67800b p67800c p67800f p67800g, item //  0.7158
	
	egen p_goals = std(fact2)	

* reshape 
keep ID_t wave p_goals
reshape8 wide p_goals, i(ID_t) j(wave)
keep ID_t p_goals2

rename p_goals2 p_goals
	
* save
order _all, alphabetic
save "$working_dataset_path/xAdditionalControls2", replace	

* -----------------------------------------------------------------------------*
* Weights 
* -----------------------------------------------------------------------------*

u "$original_dataset_path/SC1_Weights_D_$version.dta", clear
	label language en	

keep ID_t stratum psu

* save
order _all, alphabetic
save "$working_dataset_path/xWeights_attrition", replace	

* -----------------------------------------------------------------------------*
* Merge
* -----------------------------------------------------------------------------*

u "$working_dataset_path/xDemo.dta", clear
merge 1:1 ID_t using "$working_dataset_path/xCognitive_after.dta", 			 ///
	keep(master match) nogen assert(master match)
merge 1:1 ID_t using "$working_dataset_path/xNoncognitive_after.dta",		 ///
	keep(master match) nogen assert(master match)
merge 1:1 ID_t using "$working_dataset_path/xCompetencies_before.dta",		 ///
	keep(master match) nogen assert(master match)
merge 1:1 ID_t using "$working_dataset_path/xChildCare_attendance.dta",		 ///
	keep(master match) nogen assert(master match)
merge 1:1 ID_t using "$working_dataset_path/xWeights_attrition.dta",		 ///
	keep(master match) nogen assert(master match)	
merge 1:1 ID_t using "$working_dataset_path/xAdditionalControls.dta",		 ///
	keep(master match) nogen assert(master match)
merge 1:1 ID_t using "$working_dataset_path/xAdditionalControls2.dta",		 ///
	keep(master match) nogen assert(master match)
save "$working_dataset_path/xDataset.dta", replace

* last cleaning 
drop __ttp1_casmin1 __ttp2_casmin1 __ttincomeX p30211b1 income1
save "$working_dataset_path/xDataset.dta", replace

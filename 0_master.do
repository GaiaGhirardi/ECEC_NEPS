/*------------------------------------------------------------------------------
  ------------------------------------------------------------------------------
					Gaia Ghirardi - ECEC paper - December 2020
							Master Dofile
 ------------------------------------------------------------------------------
------------------------------------------------------------------------------*/

/*
* To install if not available: 
ssc install fre, replace all
ssc install coefplot, replace all
ssc install blindschemes, replace all
ssc install grstyle, replace all
ssc install palettes, replace all
ssc install estout, replace all
net install nepstools, from(http://nocrypt.neps-data.de/stata)
ssc install reshape8, replace all 
ssc install mdesc, replace all
ssc install ebalance, replace all
ssc install egenmore, replace all
ssc install mipolate, replace all
ssc install palettes, replace
ssc install colrspace, replace
ssc install polychoricpca // otherwise findit 
ssc install grc1leg // otherwise findit 
ssc install sensemakr, replace all
*/

* Directories
	global original_dataset_path "/Users/gaia/Dropbox/ECEC_ESR/Dataset/Original Data"
	global working_dataset_path "/Users/gaia/Dropbox/ECEC_ESR/Dataset/Working Data"
	global dofile "/Users/gaia/Dropbox/ECEC_ESR/Dofile"
	global version 7-0-0
	global output  "/Users/gaia/Dropbox/ECEC_ESR/Output"
	global out_latex "/Users/gaia/Dropbox/ECEC_ESR/Output/LaTeX"

* Graphs
	set scheme plotplain
	grstyle init
	grstyle set plain, horizontal grid noextend
	grstyle set legend 6, nobox      
	grstyle set color white, : plotregion
	grstyle set color none, : plotregion_line
	grstyle set color maroon, plots(1) : p#
	grstyle set color dknavy, plots(2) : p#
	grstyle set color dkgreen, plots(3) : p# 
	grstyle set color cranberry, plots(4) : p# 
	grstyle set color dknavy, plots(5) : p# 	
	grstyle set color emerald, plots(6) : p# 	
	grstyle set color dkgreen, plots(7) : p# 
	grstyle set color gold, plots(8) : p# 
	grstyle set color dkorange, plots(9) : p# 
	grstyle set color red, plots(10) : p# 
	grstyle set symbol S, plots(1) : p#
	grstyle set symbol D, plots(2) : p#
	grstyle set symbol O, plots(3) : p#
	grstyle set symbol T, plots(4) : p#
	grstyle set symbol T, plots(9) : p#
	grstyle set symbol S, plots(5) : p#
	grstyle set symbol S, plots(10) : p#
	grstyle set symbol S, plots(6) : p#
	grstyle set symbol S, plots(11) : p#
	grstyle set symbol plus, plots(5) : p#
	grstyle set lp solid, plots(1) : p#
	grstyle set lp solid , plots(2) : p#
	grstyle set lp solid  , plots(3) : p#
	grstyle set lp solid, plots(4) : p#
	grstyle set lp solid, plots(5) : p#
	grstyle set color white, plots(1 2 3 4 5 6 7 8 9 10): p#markfill 
	global yzerob yline(0, lc(black) lw(.05) lp(dash))
	global xzerob xline(0, lc(black) lw(.05) lp(dash))
	global yzerorfine yline(0, lc(black) lw(.05) lp(dash))
	global xzeror xline(0, lc(red) lp(dash))
	global cilook ciopts(recast(rcap))
	global yzeror yline(0, lc(gray) lw(.2)lp(dash))

* Replication analysis
	cd $dofile
	
	set more off, perm
	
		* main analysis 
		do 1_preparation
		do 2_weights 
		do 3_sample_standardization 
		do 4_descriptives
		do 5_H1
		do 6_H2
		do 7_H3
		do 8_equalizing_impact
	
	
	
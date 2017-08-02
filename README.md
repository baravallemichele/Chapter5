# Chapter7
Calibration of simplified safety formats for structural timber design


The scripts with names beginning with “MAIN” are the main scripts where all the inputs are defined and the calculations are performed. All the other scripts are called from the main scripts.
•	MAIN_Calibrate_SFI_and_SFII.m – Calibrates the reliability elements in the simplified safety formats proposed. 
•	MAIN_Make_plots_of_proposed_method.m – Makes the boxplots for comparing the reliability level of the Eurocode and the proposed formats for given reliability elements. All inputs are defined in this script. The script makes use of functions downloadable at http://alex.bikfalvi.com/download/aboxplot.zip .

The scripts make use of functions in the following packages:
•	FERUMcore and FERUMsystems_MSR packages available at http://projects.ce.berkeley.edu/ferum/. 
•	Matlab Statistics and Machine Learning Toolbox (see https://se.mathworks.com/products/statistics.html )

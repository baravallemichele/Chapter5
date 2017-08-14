## Chapter7

This folder contains the scripts behind the calcualtions presented in the article:
# Calibration of simplified safety formats for structural timber design
Michele Baravalle, Michael Mikoschek, François Colling, Jochen Köhler
In Construction and Building Materials Volume 152, 15 October 2017, Pages 1051-1058
https://doi.org/10.1016/j.conbuildmat.2017.06.155


The scripts with names beginning with “MAIN” are the main scripts where all the inputs are defined and the calculations are performed. All the other scripts are called from the main scripts.
•	MAIN_Calibrate_SFI_and_SFII.m – Calibrates the reliability elements in the simplified safety formats proposed. 
•	MAIN_Make_plots_of_proposed_method.m – Makes the boxplots for comparing the reliability level of the Eurocode and the proposed formats for given reliability elements. All inputs are defined in this script. The script makes use of functions downloadable at http://alex.bikfalvi.com/download/aboxplot.zip .

The scripts make use of functions in the following packages:
•	FERUMcore and FERUMsystems_MSR packages available at http://projects.ce.berkeley.edu/ferum/. 
•	Matlab Statistics and Machine Learning Toolbox (see https://se.mathworks.com/products/statistics.html )

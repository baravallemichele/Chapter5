%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2017 Michele Baravalle, NTNU
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or (at
% your option) any later version.

% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
% General Public License for more details.

% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Clear all variables
clear probdata femodel analysisopt gfundata randomfield systems results output_filename dum output
clc;
clear all;
clf;
close all
%% INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Optimized gammaF and kmod'
        %Dom G  Dom Q
gF_opt=[2.14    1.46; %Case 1 
        2.17    1.48; %Case 2
        2.35    1.56; %Case 3 
        2.38    1.58];%Case 4
kmod_opt=[0.63  0.89; %Case 1
          0.62  0.84; %Case 2
          0.63  0.92; %Case 3 
          0.62  0.8]; %Case 4    
subplot_num=1;
H=1;
% Define global variables
global probdata gfundata input output output_overview
%Define random varaibles input
%                   distr    mean     COV      char_fractile  psf0     psi0      kmod       np       nr
input.ResModelUnc =[  2       1       .07       1000                                                      %XR1 Res. model unc. for solid timber
                      2       1       .07       1000                                                      %XR2 Res. model unc. for solid timber
                      2       1       .07       1000                                                      %XR3 Res. model unc. for solid timber
                      2       1       .07       1000                                                      %XR4 Res. model unc. for glulam
                      2       1       .07       1000                                                      %XR5 Res. model unc. for glulam
                      2       1       .07       1000];                                                    %XR6 Res. model unc. for glulam
input.Resistance=[    2       1       .25       0.05          1.30                                        %R1 Bending strength - Solid timber (fmST)
                      2       1       1.2*.25   0.05          1.30                                        %R2 Tension parallel to grain - Solid timber (ft0ST)
                      2       1       .8*.25    0.05          1.30                                        %R3 Compression parallel to grain - Solid timber (fc0ST)
                      2       1       .15       0.05          1.25                                        %R4 Bending strength - Glulam (fmGL)
                      2       1       1.2*.15   0.05          1.25                                        %R5 Tension parallel to grain - Glulam (ft0GL)
                      2       1       .8*.15    0.05          1.25 ];                                     %R6 Compression parallel to grain - Slulam (fc0GL)
input.Permanent=[     1       1       .1        0.5           1.35      1        0.6];                    %G (permanent)
input.VarModelUnc=[   2       1       .27       1143                                                      %XQ1 (Wind time invariant part, mod. unc)
                      2       1       .20       1000];                                                    %XQ2 (Snow time invariant part, mod. unc)
input.Variable =[     15      1       .25       0.98          1.50     0.6       1.0        365      365  %Q1 wind (short term)
                      15      1       .35       0.98          1.50     0.5       0.9        100      11]; %Q2 snow (medium term)
%Notes:
%         distr = Distribution type (1 = Normal;2 = Lognormal;3 = Gamma;4 = Shifted Exponential marginal distribution;  5 = Shifted Rayleigh marginal distribution; 6 = Uniform distribution; 7 = Beta; 8 = Chi-square; 11 = Type I Largest Value marginal distribution;12 = Type I Smallest Value marginal distribution  %13 = Type II Largest Value marginal distribution;14 = Type III Smallest Value marginal distribution ;15 = Gumbel (same as type I largest value) ;16 = Weibull marginal distribution (same as Type III Smallest Value marginal distribution with epsilon = 0 ) %
%         mean = Mean values
%         COV = coefficient of variation
%         char_fractile = fractile corresponding to the characteristic
%         value (if the value is >= 1000 then the characteristic values is taken as value/1000)
%         psf0 = partial safety factor of the existing code (OBS: psf for Q2 is taken equal input.Variable(1,5))
%         psi0 = load combination factor of the existing code
%         kmod = modification factor in the existing code
%         np = number of days the load is present in a year
%         nr = number of new realizations whitin np  
%Select if giving values of alphaG and alphaQ OR values of chiG and chiQ in the limit state function
input.load_domain='Char'  ;                 %'Mean' for working with alphaG and alphaQ; 'Char' for working with chiG and chiQ
input.step=0.05;                            %step between aQ (or XiQ) and aG (or XiG) values
input.num_varloads=1;                       %do not change it!!!
%weights for materials (sum must be 1)
         % fmST     ft0ST   fc0ST   fmGL    ft0GL   fc0GL
input.wR=[.7*.6;    .7*.1;  .7*.3;  .3*.6;  .3*.1;  .3*.3];

%legend, styles etc.
marker=['o';'*';'s';'+';'x'];
C=['k';'r';'b';'g';'c'];
legendstring=['fm - Solid Timber ';
              'ft0 - Solid Timber';
              'fc0 - Solid Timber';
              'fm - Glulam       ';
              'ft0 - Glulam      ';
              'fc0 - Glulam      '] ;
probdata.name = {'XR '; 'R  '; 'G  ';'XQ1';'XQ2';'Q1 ';'Q2 ';' Q1L';'Q2A';'Q1A';'Q2L'}; %random variables names
input.betat=4.2; %initialize target relaibility index 
%% SCRIPT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%number of material properties considered
input.num_mat=size(input.Resistance,1);
for i_SF=1:2
    for i_case=1:4 
            switch i_case
                case 1 %Germany
            input.Variable =[     15      1       .25     0.98          1.50     0.6       1.0        365      365  %Q1 wind (short inst)    
                                  15      1       .35     0.98          1.50     0.5       0.9        100      11]; %Q2 snow (short)
                case 2 %Austria
            input.Variable =[     15      1       .25     0.98          1.50     0.6       1.0        365      365  %Q1 wind (short inst)    
                                  15      1       .35     0.98          1.50     0.7       0.8        150      11]; %Q2 snow (medium)     
                case 3 %denmark
            input.Variable =[     15      1       .25     0.98          1.50     0.6       1.1        365      365  %Q1 wind (inst)    
                                  15      1       .35     0.98          1.50     0.5       0.9        100      11]; %Q2 snow (short)        
                case 4
            input.Variable =[     15      1       .25     0.98          1.50     0.6       1.1        365      365  %Q1 wind (inst)    
                                  15      1       .35     0.98          1.50     0.7       0.8        150      11]; %Q2 snow (medium)        
            end %End switch

            %% Ferry Borges Castanheta load combination
            %Create maxima of Q1 and Q2 for shorter ref. periods to be used in Ferry
            %Borges Castanheta combination rule.
            %LC1 - Q1 yearly maxima only
            %LC2 - Q2 yearly maxima only
            %LC3 - Q1 (max over npQ2/365 years) + Q2 (max over 1/nrQ2 years)
            mQ1L=input.Variable(1,2)+sqrt(6)/pi*log(input.Variable(2,8)/365);                                       %mean of Q1 leading
            COVQ1L=input.Variable(1,2)*input.Variable(1,3)/mQ1L;                                                    %cov of Q1 leading
            mQ2A=input.Variable(2,2)+sqrt(6)/pi*log(1/input.Variable(2,9));                                         %mean of Q2 accompanying
            COVQ2A=input.Variable(2,2)*input.Variable(2,3)/mQ2A;                                                    %cov of Q1 accompanying
            %LC4 - Q2 (max over 1 year) + Q1 (max over npQ2/(365*nrQ2) years)
            mQ1A=input.Variable(1,2)+sqrt(6)/pi*log(input.Variable(2,8)/365/input.Variable(2,9));                   %mean of Q1 accompanying
            COVQ1A=input.Variable(1,2)*input.Variable(1,3)/mQ1A;                                                    %cov of Q1 accompanying
            mQ2L=input.Variable(2,2);                                                                               %mean of Q2 leading
            COVQ2L=input.Variable(2,2)*input.Variable(2,3)/mQ2L;                                                    %cov of Q1 leading
            input.VariableFBC = [ 15     mQ1L     COVQ1L     0                                                      %Q1 Leading
                                  15     mQ2A     COVQ2A     0                                                      %Q2 Accompanying
                                  15     mQ1A     COVQ1A     0                                                      %Q1 Accompanying
                                  15     mQ2L     COVQ2L     0];                                                    %Q2 Leading
            %% LIMIT STATE FUNCTIONS AND PARTIAL DERIVATIVES
            %Random varaibles numbering
            % |              1    2    3    4     5     6    7    8     9     10    11|
            % | rand vars x=[XR   R    G    XQ1   XQ2   Q1   Q2   Q1L   Q2A   Q1A   Q2L]|
            %Parameters in the limit state functions (the 2nd and 3rd can be alphas or chis) 
            % | parameters gfundata(1).thetag=[z aG aQ kmod]|
            Limit_state_functions
            %%
            subplot(2,4,subplot_num)
            switch i_SF
                case 1 %Structures dominated by permanent loads
                %          R1-Solid wood       R2-Glulam       
                input.aG=[ .6 1; .6 1; .6 1;  .6 1;.6 1;.6 1];           %max and min values of aG or XiG -> aG is then min:input.step:max
                input.aQ=[ 0  1; 0  1; 0  1;   0 1; 0 1; 0 1];           %max and min values of aQ or XiQ -> aQ is then min:input.step:max 
                case 2 %Structures dominated by short-medium term and instantaneous loads
                 %          R1-Solid wood       R2-Glulam       
                 input.aG=[ .00  .6; .00 .6; .00 .6;  .00  .6;.00  .6;.00  .6];        %max and min values of aG or XiG -> aG is then min:input.step:max
                 input.aQ=[ 0 1; 0 1; 0 1;   0 1; 0 1; 0 1];        %max and min values of aQ or XiQ -> aQ is then min:input.step:max
            end
            %% SAFETY LEVEL OF CURRENT EUROCODE
            %Eurocode Format
            input.des_eq='EC0-6.10';
            %Partial safety factors
            psf=[input.Resistance(:,5);input.Permanent(:,5);input.Variable(1,5)]; %[R1 R2 R3 R4 R5 R6 G Q] 
            penalty_func_EC(i_case,i_SF)=form_0(psf);
            penalty_func=penalty_func_EC(i_case,i_SF);
            make_output_overview
            mean_beta_existing=output_overview.mean_beta;
            input.minbeta=output_overview.min_beta;
            input.betat=output_overview.mean_beta;
            clear allbeta allbeta_column allz allz_column  allweights  allweights_column
            allbeta=[output(1).beta1 output(2).beta1 output(3).beta1 output(4).beta1 output(5).beta1 output(6).beta1];
            allz=[output(1).z output(2).z output(3).z output(4).z output(5).z output(6).z];
            allweights=[output(1).weights output(2).weights output(3).weights output(4).weights output(5).weights output(6).weights];
            num_el=size(allbeta,1)*size(allbeta,2);
            allbeta_column(:,1)=reshape(allbeta,[num_el,1]);
            allz_column(:,1)=reshape(allz,[num_el,1]);
            allweights_column(:,1)=reshape(allweights,[num_el,1]);
                
            %% OPTIMIZE 'SFI' FORMAT
            input.des_eq='SFI'; 
            %Partial safety factors
            psf=[input.Resistance(:,5);input.Permanent(:,5);input.Variable(1,5);gF_opt(i_case,i_SF)];
            penalty_func_SFI(i_case,i_SF)=form_0(psf);
            penalty_func=penalty_func_SFI(i_case,i_SF);
            make_output_overview
            mean_beta_existing=output_overview.mean_beta;
            input.minbeta=output_overview.min_beta;
            input.betat=output_overview.mean_beta;
            allbeta=[output(1).beta1 output(2).beta1 output(3).beta1 output(4).beta1 output(5).beta1 output(6).beta1];
            allz=[output(1).z output(2).z output(3).z output(4).z output(5).z output(6).z];
            allweights=[output(1).weights output(2).weights output(3).weights output(4).weights output(5).weights output(6).weights];
            num_el=size(allbeta,1)*size(allbeta,2);
            allbeta_column(:,2)=reshape(allbeta,[num_el,1]);
            allz_column(:,2)=reshape(allz,[num_el,1]);
            allweights_column(:,2)=reshape(allweights,[num_el,1]);
            %% OPTIMIZE THE kmod' FACTOR IN THE 'SFII' FORMAT
            input.des_eq='SFII';
            psf=[input.Resistance(:,5);input.Permanent(:,5);input.Variable(1,5);kmod_opt(i_case,i_SF)];
            penalty_func_SFIII(i_case,i_SF)=form_0(psf);
            penalty_func=penalty_func_SFIII(i_case,i_SF);
            make_output_overview
            mean_beta_existing=output_overview.mean_beta;
            input.minbeta=output_overview.min_beta;
            input.betat=output_overview.mean_beta;
            allbeta=[output(1).beta1 output(2).beta1 output(3).beta1 output(4).beta1 output(5).beta1 output(6).beta1];
            allz=[output(1).z output(2).z output(3).z output(4).z output(5).z output(6).z];
            allweights=[output(1).weights output(2).weights output(3).weights output(4).weights output(5).weights output(6).weights];
            num_el=size(allbeta,1)*size(allbeta,2);
            allbeta_column(:,3)=reshape(allbeta,[num_el,1]);
            allz_column(:,3)=reshape(allz,[num_el,1]);
            allweights_column(:,3)=reshape(allweights,[num_el,1]);

            %Summary    
            allz_column(:,2)=allz_column(:,2)./allz_column(:,1); %Design divided by Eucorode design
            allz_column(:,3)=allz_column(:,3)./allz_column(:,1);
                
            SFI_average_overdesign(i_case,i_SF)=sum(allweights_column(:,2).*allz_column(:,2));
            SFI_min_overdesign(i_case,i_SF)=min(allz_column(:,2));
            SFI_max_overdesign(i_case,i_SF)=max(allz_column(:,2));
            SFIII_average_overdesign(i_case,i_SF)=sum(allweights_column(:,3).*allz_column(:,3));
            SFIII_min_overdesign(i_case,i_SF)=min(allz_column(:,3));
            SFIII_max_overdesign(i_case,i_SF)=max(allz_column(:,3));
                
            SFI_allfailurecosts(i_case,i_SF)=sum(H.*normcdf(-allbeta_column(:,2)).*allweights_column(:,2))/sum(H.*normcdf(-allbeta_column(:,1)).*allweights_column(:,1));
            SFI_min_failurecosts(i_case,i_SF)=min(H.*normcdf(-allbeta_column(:,2)).*allweights_column(:,2))/sum(H.*normcdf(-allbeta_column(:,1)).*allweights_column(:,1));
            SFI_max_failurecosts(i_case,i_SF)=max(H.*normcdf(-allbeta_column(:,2)).*allweights_column(:,2))/sum(H.*normcdf(-allbeta_column(:,1)).*allweights_column(:,1));
            SFIII_allfailurecosts(i_case,i_SF)=sum(H.*normcdf(-allbeta_column(:,3)).*allweights_column(:,3))/sum(H.*normcdf(-allbeta_column(:,1)).*allweights_column(:,1));
            SFIII_min_failurecosts(i_case,i_SF)=min(H.*normcdf(-allbeta_column(:,3)).*allweights_column(:,3))/sum(H.*normcdf(-allbeta_column(:,1)).*allweights_column(:,1));
            SFIII_max_failurecosts(i_case,i_SF)=max(H.*normcdf(-allbeta_column(:,3)).*allweights_column(:,3))/sum(H.*normcdf(-allbeta_column(:,1)).*allweights_column(:,1));
                
            aboxplot(allbeta_column,'colorgrad','green_up','Labels',{'EC0/EC5',strcat('SFI - \gamma_F = ',num2str(round(100*gF_opt(i_case,i_SF))/100)),strcat('SFII - k_{mod} = ',num2str(round(100*kmod_opt(i_case,i_SF))/100))})
            set(gca,'XTickLabelRotation',30)
                if i_SF==1
                    title(strcat('Case ',num2str(i_case),' - Permanent dominant'))
                else
                    title(strcat('Case ',num2str(i_case),' - Variable dominant'))
                end
            axis([.5 3.5 3 8])    
            subplot_num=subplot_num+1;
    end
end
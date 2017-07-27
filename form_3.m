function [ output_args ] = form_3( kmod_fixed )
%execute form given the global safety factor included in the simplified load combinations, output=sum of weighted penalty function
%   used for:
%       performing FORM with fixed gM,gG,gQ
%       and calibrating gF and the fixed k_mod to be used in simplified des. equations
%   inputs: 
%       global psf used in the simplified design equations gF
%   outputs:
%       weighted penalty function        

    % Initialize output
    output_args=0; 
    dum1=0; dum2=0; %dummy varaibles
    % Global variables
    global probdata gfundata input output
    
    %Input
    gF=1.40; %global safety factor

    %Cycles over materials and variable loads
    for imat=1:input.num_mat
        
        %FIXED Partial safety factors
        gM=[input.Resistance(imat,5)];
        gG=input.Permanent(1,5);
        gQ=input.Variable(1,5);
        
        %define Ferum input
        probdata.marg = [input.ResModelUnc(imat,1), input.ResModelUnc(imat,2), input.ResModelUnc(imat,2)*input.ResModelUnc(imat,3),input.ResModelUnc(imat,2)-input.ResModelUnc(imat,2)*input.ResModelUnc(imat,3), nan, nan, nan, nan, 0;...     %1
                         input.Resistance(imat,1), input.Resistance(imat,2), input.Resistance(imat,2)*input.Resistance(imat,3),input.Resistance(imat,2)-input.Resistance(imat,2)*input.Resistance(imat,3), nan, nan, nan, nan, 0;...            %2
                         input.Permanent(1), input.Permanent(2), input.Permanent(2)*input.Permanent(3),input.Permanent(2), nan, nan, nan, nan, 0;...                                                                                            %3
                         input.VarModelUnc(1,1), input.VarModelUnc(1,2), input.VarModelUnc(1,2)*input.VarModelUnc(1,3),input.VarModelUnc(1,2)+input.VarModelUnc(1,2)*input.VarModelUnc(1,3), nan, nan, nan, nan, 0;...                          %4
                         input.VarModelUnc(2,1), input.VarModelUnc(2,2), input.VarModelUnc(2,2)*input.VarModelUnc(2,3),input.VarModelUnc(2,2)+input.VarModelUnc(2,2)*input.VarModelUnc(2,3), nan, nan, nan, nan, 0;...                          %5
                         input.Variable(1,1), input.Variable(1,2), input.Variable(1,2)*input.Variable(1,3),input.Variable(1,2)+input.Variable(1,2)*input.Variable(1,3), nan, nan, nan, nan, 0;...                                               %6
                         input.Variable(2,1), input.Variable(2,2), input.Variable(2,2)*input.Variable(2,3),input.Variable(2,2)+input.Variable(2,2)*input.Variable(2,3), nan, nan, nan, nan, 0;...                                               %7
                         input.VariableFBC(1,1), input.VariableFBC(1,2), input.VariableFBC(1,2)*input.VariableFBC(1,3),input.VariableFBC(1,2)+3*input.VariableFBC(1,2)*input.VariableFBC(1,3), nan, nan, nan, nan, 0;...                          %8
                         input.VariableFBC(2,1), input.VariableFBC(2,2), input.VariableFBC(2,2)*input.VariableFBC(2,3),input.VariableFBC(2,2)+3*input.VariableFBC(2,2)*input.VariableFBC(2,3), nan, nan, nan, nan, 0;...                          %9
                         input.VariableFBC(3,1), input.VariableFBC(3,2), input.VariableFBC(3,2)*input.VariableFBC(3,3),input.VariableFBC(3,2)+3*input.VariableFBC(3,2)*input.VariableFBC(3,3), nan, nan, nan, nan, 0;...                          %10
                         input.VariableFBC(4,1), input.VariableFBC(4,2), input.VariableFBC(4,2)*input.VariableFBC(4,3),input.VariableFBC(4,2)+3*input.VariableFBC(4,2)*input.VariableFBC(4,3), nan, nan, nan, nan, 0];                            %11
        % Correlation matrix (square matrix with dimension equal to number of r.v.'s)
        probdata.correlation = eye(size(probdata.marg,1)); 
        
        % Calculate the characteristic values
        f=[input.ResModelUnc(imat,4) input.Resistance(imat,4) input.Permanent(4) input.VarModelUnc(1,4) input.VarModelUnc(2,4) input.Variable(1,4) input.Variable(2,4) input.VariableFBC(1,4) input.VariableFBC(2,4) input.VariableFBC(3,4) input.VariableFBC(4,4)]; %Characteristic fractiles.
        xk = characteristic_value(probdata.marg, f ); %calculate characteristic values given the probdata.marg and characteristic fractiles
        
        % Determine the parameters,the mean and standard deviation associated with the distribution of each random variable
        probdata.parameter = distribution_parameter(probdata.marg);
        
        %Load reduction factors
        psi0Q1=input.Variable(1,6);
        psi0Q2=input.Variable(2,6);
        
            %form for different values of aQ and aG
            iaQ=1;
            for aQ=input.aQ(imat,1):input.step:input.aQ(imat,2)
                iaG=1;dum=aQ;
                for aG=input.aG(imat,1):input.step:input.aG(imat,2)
                    aQ=dum;
                    %Calculate aQ and aG giving the exact values of XiG and XiQ
                    if input.load_domain=='Char'
                       aQ=-(aQ*xk(7))/(aQ*xk(6)-aQ*xk(7)-xk(6));
                       aG=(aG*(aQ*xk(6)-aQ*xk(7)+xk(7)))/(aG*aQ*xk(6)-aG*aQ*xk(7)-aG*xk(3)+aG*xk(7)+xk(3));
                    end
                    
                    %Ratios between different loads
                    output(imat).XiG(iaQ,iaG)=(aG*xk(3))/sum([aG*xk(3) (1-aG)*aQ*xk(6) (1-aG)*(1-aQ)*xk(7)]); %ratio between characteristic value of g and sum of characteristic values of all loads
                    output(imat).XiQ(iaQ,iaG)=(aQ*xk(6))/sum([aQ*xk(6) (1-aQ)*xk(7)]); %ratio between characteristic value of q1 and sum of characterictic values of variable loads
        
                    % Just safe design  
                    switch input.des_eq
                        case 'EC0-6.10'
                            kmod=[input.Variable(1,7) %kmod of the load with shortest duration 
                                  input.Variable(2,7)
                                  max(input.Variable(1,7),input.Variable(2,7))
                                  max(input.Variable(1,7),input.Variable(2,7))
                                  input.Permanent(1,7)];
                            z=[ (aG*xk(3)*gG+(1-aG)*aQ*xk(6)*gQ)*gM/xk(2)/kmod(1)
                                (aG*xk(3)*gG+(1-aG)*(1-aQ)*xk(7)*gQ)*gM/xk(2)/kmod(2)
                                ( aG*xk(3)*gG+(1-aG)*( aQ*xk(6)*gQ+(1-aQ)*xk(7)*gQ*psi0Q2  )  )*gM/xk(2)/kmod(3)
                                ( aG*xk(3)*gG+(1-aG)*( aQ*xk(6)*gQ*psi0Q1+(1-aQ)*xk(7)*gQ  )  )*gM/xk(2)/kmod(4)
                                (aG*gG*xk(3))*gM/xk(2)/kmod(5)];
                            output(imat).decisive_design_eq(iaQ,iaG)=mean(find(z==max(z))); %save the design equation giving largest z (decisive design equation)
                         case 'SFII'
                            kmod=[kmod_fixed %kmod of the load with shortest duration 
                                  kmod_fixed
                                  kmod_fixed
                                  kmod_fixed
                                  kmod_fixed];
                            z=[ (aG*xk(3)*gG+(1-aG)*aQ*xk(6)*gQ)*gM/xk(2)/kmod(1)
                                (aG*xk(3)*gG+(1-aG)*(1-aQ)*xk(7)*gQ)*gM/xk(2)/kmod(2)
                                ( aG*xk(3)*gG+(1-aG)*( aQ*xk(6)*gQ+(1-aQ)*xk(7)*gQ*psi0Q2  )  )*gM/xk(2)/kmod(3)
                                ( aG*xk(3)*gG+(1-aG)*( aQ*xk(6)*gQ*psi0Q1+(1-aQ)*xk(7)*gQ  )  )*gM/xk(2)/kmod(4)
                                (aG*gG*xk(3))*gM/xk(2)/kmod(5)];
                            output(imat).decisive_design_eq(iaQ,iaG)=mean(find(z==max(z))); %save the design equation giving largest z (decisive design equation)
                        case 'SFI'
                            kmod=[input.Variable(1,7) %kmod of the load with shortest duration 
                                  input.Variable(2,7)
                                  max(input.Variable(1,7),input.Variable(2,7))];
                            z=[ (aG*xk(3)*gG+(1-aG)*aQ*xk(6)*gQ)*gM/xk(2)/kmod(1)
                                (aG*xk(3)*gG+(1-aG)*(1-aQ)*xk(7)*gQ)*gM/xk(2)/kmod(2)
                                ( aG*xk(3)*gF+(1-aG)*( aQ*xk(6)*gF+(1-aQ)*xk(7)*gF  )  )*gM/xk(2)/kmod(3)];
                            output(imat).decisive_design_eq(iaQ,iaG)=mean(find(z==max(z))); %save the design equation giving largest z (decisive design equation)
                        otherwise
                            disp('Error: chose a design format!')
                    end
                    
                    % define the parameter values
                    dummy_beta=100; %dummy variable for beta
                    
                    %Real kmod
                    kmod_real=[input.Variable(1,7) %kmod of the load with shortest duration to be used in limit states for calcualting Pf
                          input.Variable(2,7)
                          max(input.Variable(1,7),input.Variable(2,7))
                          max(input.Variable(1,7),input.Variable(2,7))
                          input.Permanent(1,7)];
                    
                    %Cycle over the 5 limit state functions
                    for iLC=1:5
                            gfundata(iLC).thetag = [max(z) aG aQ kmod_real(iLC)];
                        % FORM
                            LoadFerumOptions;
                            [formresults] = form(iLC,probdata,analysisopt,gfundata,femodel,randomfield);
                            if formresults.beta1<dummy_beta
                            dummy_beta=formresults.beta1;
                            results.form = formresults;
                        % output structure
                            output(imat).aG(iaQ,iaG)=aG;
                            output(imat).aQ(iaQ,iaG)=aQ;
                            output(imat).z(iaQ,iaG)=max(z);
                            output(imat).beta1(iaQ,iaG)=results.form.beta1;
                            output(imat).alphaXR(iaQ,iaG)=results.form.alpha(1);
                            output(imat).alphaR(iaQ,iaG)=results.form.alpha(2);
                            output(imat).alphaG(iaQ,iaG)=results.form.alpha(3);
                            output(imat).weights(iaQ,iaG)=input.wR(imat)*1/(length(input.aQ(imat,1):input.step:input.aQ(imat,2))*length(input.aG(imat,1):input.step:input.aG(imat,2)));
                            else
                                %nothing
                            end
                    end
                    iaG=iaG+1;
                end %end cycle for aG
                iaQ=iaQ+1;
            end %end cycle for aQ
            
            % Evalaute penalty function
            if kmod_fixed<0
                output_args=1e+99; %for avoiding psfs <1
            else
                    d=0.23;
                    output_args=output_args+sum(sum(output(imat).weights.*( (output(imat).beta1-input.betat)./d -1 +exp(-(output(imat).beta1-input.betat)./d) ))); 
            end
            output(imat).characteristic_values=xk;
            output(imat).meanbeta1=mean2(output(imat).beta1);
            output(imat).standarddev_beta1=std2(output(imat).beta1);
            output(imat).minbeta1=min(min(output(imat).beta1));
            output(imat).maxbeta1=max(max(output(imat).beta1));
    end %end cycle for material
        min_beta=1e99;
        mean_beta=0;
        for imat=1:input.num_mat
                    min_beta=min(min_beta,min(min(output(imat).beta1)));
                    mean_beta=mean_beta+sum(sum(output(imat).beta1.*output(imat).weights));
        end
  
end %end function


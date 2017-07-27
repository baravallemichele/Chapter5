%the script calculates the weighted mean and stddev of beta in output
global output input output_overview
    
mean_beta=0;
tot_weight=0;
min_beta=1e99;
max_beta=0;
for imat=1:input.num_mat
            mean_beta=mean_beta+sum(sum(output(imat).beta1.*output(imat).weights));
            tot_weight=tot_weight+sum(sum(output(imat).weights));
            min_beta=min(min_beta,min(min(output(imat).beta1)));
            max_beta=max(max_beta,max(max(output(imat).beta1)));
end

stddev_beta=0;
for imat=1:input.num_mat
            stddev_beta=stddev_beta+sum(sum(  output(imat).weights.* (mean_beta-output(imat).beta1).^2));
end

output_overview.des_eq=input.des_eq;
output_overview.mean_beta=mean_beta;
output_overview.stddev_beta=sqrt(stddev_beta);
output_overview.min_beta=min_beta;
output_overview.max_beta=max_beta;
output_overview.tot_weight=tot_weight;
output_overview.psf=psf;
output_overview.penalty_func=penalty_func;
output_overview.betat=input.betat;
output_overview.Pf_predictive=integral(@(b) normpdf(b,mean_beta,stddev_beta).*normcdf(-b),mean_beta-2*stddev_beta,mean_beta+2*stddev_beta);

output_overview

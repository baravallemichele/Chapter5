%% MAKE PLOTS FOR DIFFERENT VALUES OF aG AND aQ
symbol=['o';'*';'^';'+';'p'];

if input.load_domain=='Mean' 
    figure
    for imat=1:input.num_mat
        subplot(2,3,imat)
        C=output(imat).beta1;
        surf(output(imat).aG,output(imat).aQ,output(imat).beta1,'facecolor','k','FaceAlpha',0.3)%,'edgeColor',color,'faceColor',color,'LineStyle','-','FaceAlpha',0.3)
        hold on
        mesh(output(imat).aG,output(imat).aQ,output(imat).beta1./output(imat).beta1.*input.betat,'edgeColor','r','facecolor','r','LineStyle','-','FaceAlpha',0.5)
        legend(input.des_eq,'\beta_t')
        legend('Location','southoutside')
        xlabel('a_G'); ylabel('a_Q'); zlabel('\beta');
        xlim([0 1]); ylim([0 1]); zlim([3 6]);%zlim([ floor(10*min_beta)/10 ceil(10*max_beta)/10]);
        grid on; hold on; box on;
        title(strcat(legendstring(imat,:)));
    end
end
%% MAKE PLOTS FOR DIFFERENT VALUES OF XiG AND XiQ
if input.load_domain=='Char' 
  figure  
    for imat=1:input.num_mat
        subplot(2,3,imat)
        C=output(imat).beta1;
        surf(output(imat).XiG,output(imat).XiQ,output(imat).beta1,'facecolor','k','FaceAlpha',0.3)%,'edgeColor',color,'faceColor',color,'LineStyle','-','FaceAlpha',0.3)
        hold on
        mesh(output(imat).XiG,output(imat).XiQ,output(imat).beta1./output(imat).beta1.*input.betat,'edgeColor','r','facecolor','r','LineStyle','-','FaceAlpha',0.5)
        legend(input.des_eq,'\beta_t')
        legend('Location','southoutside')
        xlabel('\chi_G'); ylabel('\chi_Q'); zlabel('\beta');
        xlim([0 1]); ylim([0 1]); zlim([3 6]);%zlim([ floor(10*min_beta)/10 ceil(10*max_beta)/10]);
        grid on; hold on; box on;
        title(strcat(legendstring(imat,:)));
    end
end
%%
%Load the desired dataset
%Format --> bernoulliGittens_AA_BB_C.mat
%AA: Number of arms considered
%BB: Number of trials run
%C: Arm selection method: 0 - Varaiya, 1 - Baseline(random),
%2 - Semi-intelligent

%Determines whether or not the figures generated will be saved to the
%working directory
saveFlag = 1;

textS = 14; %Define plot text font size
N=10; %Number of agents
iter = [50 100 150 200]; %Number of iterations ("t")
v = [0 1 2]; %Solution version: 0 - Varaiya, 1 - Baseline(random),
      %2 - Semi-intelligent

for iter_i = iter
    for ii = v
        
         eval(['load bernoulliGittins_' num2str(N) '_' num2str(iter_i) '_' num2str(ii) '.mat;']); 
%         %Redundant plots
%         stemFig = figure;
%         stem(aId);
%         xlabel('Iteration No.','FontSize',textS,'FontWeight','bold')
%         ylabel('Arm Id','FontSize',textS,'FontWeight','bold')
%         if(saveFlag == 1)
%             eval(['print(stemFig,''stemFig_' num2str(N) '_' num2str(iter_i) '_' num2str(ii) ''',''-dpng'');']);
%         end
% 
%         histFig = figure;
%         hist(aId)
%         xlabel('Arm Id','FontSize',textS,'FontWeight','bold')
%         ylabel('Arm Frequency','FontSize',textS,'FontWeight','bold')
%         if(saveFlag == 1)
%             eval(['print(histFig,''histFig_' num2str(N) '_' num2str(iter_i) '_' num2str(ii) ''',''-dpng'');']);
%         end

        %Plot resulting best arm selection on C(r), used primarily for
        %SMC2016 draft
        linew = 2;
        matchFig = figure;
        plot(gRef(1,:),gRef(2,:),'b','linewidth',linew);hold on;
        plot(gRef(1,:),gRef(3,:),'r--','linewidth',linew)
        mkRef = linspace(0,1);
        maxArm = mode(aId);
        distPt = pdist([locsA(maxArm,:);aB]);
        mkRefVal = distPt*ones(1,length(mkRef));hold on;
        plot(mkRefVal,mkRef,'k:','linewidth',linew);
        %Identify the location of the best arm on C(r)
        intersectPt = interp1(gRef(1,:),gRef(2,:),distPt,'linear');
        h = plot(distPt,intersectPt,'*');
        set(h, 'MarkerSize', 15, 'MarkerEdgeColor','k', 'LineWidth',3);
%         ptRef = [(distPt+5),(intersectPt+0.05)]
%         if (intersectPt < gRef(3,1))
%             annotation('textarrow',[ptRef(1) distPt+2]/max(gRef(1,:)),[ptRef(2) ptRef(2)],'String','Below')
%         else
%             annotation('textarrow',[ptRef(1) distPt+2]/max(gRef(1,:)),[ptRef(2) ptRef(2)],'String','Above')
%         end
        xlabel('Separation, r[nmi]','FontSize',textS,'FontWeight','bold');
        ylabel('Success of Communication, C(r)','FontSize',textS,'FontWeight','bold');
        FE = legend('C(r)','\gamma','r_{Best Arm}');
        LEG = findobj(FE,'type','text');
        set(LEG,'FontSize',14,'FontWeight','bold');

        if(saveFlag == 1)
            eval(['print(matchFig,''matchFig_' num2str(N) '_' num2str(iter_i) '_' num2str(ii) ''',''-dpng'');']);
        end
    end
end

%% Print script for comparing methods (primarily used for data for SMC2016)
close all;clc;
N = 10; iter_i = 200;
ii=0;
eval(['load bernoulliGittins_' num2str(N) '_' num2str(iter_i) '_' num2str(ii) '.mat;']);
v0Dist = distMax

ii=1;
eval(['load bernoulliGittins_' num2str(N) '_' num2str(iter_i) '_' num2str(ii) '.mat;']);
v1Dist = distMax

ii=2;
eval(['load bernoulliGittins_' num2str(N) '_' num2str(iter_i) '_' num2str(ii) '.mat;']);
v2Dist = distMax

methName = {'Gittens Index','Uniformed Random','Educated Guess'};
methCmp = figure;
ax = gca;
bar([0 1 2],[v0Dist v1Dist v2Dist]);
%ax.XTickLabel = {methName};
set(ax,'XTickLabel',methName);

eval(['print(methCmp,''methCmpFig_' num2str(N) '_' num2str(iter) ''',''-dpng'');']);
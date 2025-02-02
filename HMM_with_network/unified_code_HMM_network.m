function [World,HMM] = unified_code_HMM_network()
addpath(genpath(pwd))
close all
clc

dbstop if error
%     %% Define and chaeck constants as global var: Consts
%     global Consts
%     SetConsts();
%     %% Creation of the world: World
%     World = CreateWorld('World_small.bmp');
%     %% Initialization of the Hiden Markov Model: HMM
%     HMM = InitHMM(World);
%     %% Initialization of the Simulation: Sim
%     Sim = InitSim();
%     %% Sampling from the HMM
%     for t = 1:Consts.BaseRate:Consts.SimTime
%         %% HMM STEP
%         if mod(t,Consts.MarkovRate) == 0
%             Sim = HMM_Step(HMM,Sim);
%         end
%         %% Observation STEP
%         if mod(t,Consts.ObsRate) == 0
%
%         end
%         %% Network STEP
%         if mod(t,Consts.NetRate) == 0
%
%         end
%         %% Processing
%
%     end
%     %% Animation
%     AnimateSim(World,Sim);
% end




%% Initilization
[Network,Global] = SetupAndInitialize();
PorbLinkFailure = 0;
rng(1)
%% Simulations
Network_GMD = Network;
Network_NGMD = Network;

Network_FDN = Network;
Network_OPT = Network;
Network_GCF = Network;
Network_CEN = Network;
Network_IND = Network;
for k=1:Global.T
    if k~=1
        for i = 1:Network.NumNodes
            Network_NGMD.Node(i).Prior(:,k) = Network_NGMD.Node(i).Post(:,k-1);
            Network_GMD.Node(i).Prior(:,k) = Network_GMD.Node(i).Post(:,k-1);
            Network_FDN.Node(i).Prior(:,k) = Network_FDN.Node(i).Post(:,k-1);
            Network_OPT.Node(i).Prior(:,k) = Network_OPT.Node(i).Post(:,k-1);
            Network_GCF.Node(i).Prior(:,k) = Network_GCF.Node(i).Post(:,k-1);
            Network_CEN.Node(i).Prior(:,k) = Network_CEN.Node(i).Post(:,k-1);
            Network_IND.Node(i).Prior(:,k) = Network_IND.Node(i).Post(:,k-1);
        end
    end
    %     if ~Network.ProbOfLinkFail(k)
    %         Graph = generate_graph([1 1 ;1 1 ]);
    %     else
    %         Graph = generate_graph([1 0 ;0 1 ]);
    %     end
    PorbLinkFailure = Network.ProbOfLinkFail(k)
    [Graph,X_GT] = simstep(Network,Global,PorbLinkFailure);
    Network_NGMD.Graph = Graph; % make sure to put the new graph in the Network structure as well this will be use later in my codes
    Network_GMD.Graph = Graph; % make sure to put the new graph in the Network structure as well this will be use later in my codes
    Network_NGCF.Graph = Graph; % make sure to put the new graph in the Network structure as well this will be use later in my codes
    
    
    Network_GMD = GMD(Global,Network_GMD,k);
    Network_NGMD = NGMD(Global,Network_NGMD,k);
    
    
    Network_FDN = FDN(Global,Network_FDN,k);
    Network_OPT = OPT(Global,Network_OPT,k);
    
    Network_GCF = GCF(Global,Network_GCF,k);
    Network_NGCF = GCF(Global,Network_NGCF,k);
    
    
    Network_CEN = CEN(Global,Network_CEN,k);
    Network_IND = IND(Global,Network_IND,k);
end
PM_GMD_GT = PerfMeas_GT(Global,Network_GMD);
PM_NGMD_GT = PerfMeas_GT(Global,Network_NGMD);
PM_NGCF_GT = PerfMeas_GT(Global,Network_NGCF);


PM_FDN_GT = PerfMeas_GT(Global,Network_FDN);
PM_OPT_GT = PerfMeas_GT(Global,Network_OPT);
PM_GCF_GT = PerfMeas_GT(Global,Network_GCF);
PM_CEN_GT = PerfMeas_GT(Global,Network_CEN);
PM_IND_GT = PerfMeas_GT(Global,Network_IND);

PM_GMD_CEN = PerfMeas_CEN(Global,Network_GMD,Network_CEN);
PM_NGMD_CEN = PerfMeas_CEN(Global,Network_NGMD,Network_CEN);

PM_GCF_CEN = PerfMeas_CEN(Global,Network_GCF,Network_CEN);
PM_NGCF_CEN = PerfMeas_CEN(Global,Network_NGCF,Network_CEN);


PM_GMD_CEN.BCS
PM_GMD_CEN.HEL
PM_GMD_CEN.meanBCS
PM_GMD_CEN.meanHEL
%% Analysis
%Mutual Information(MI) between FDN and GMD
P_FDN_N1 = Network_FDN.Node(1).Post;
P_FDN_N2 = Network_FDN.Node(2).Post;
P_GMD_N1 = Network_GMD.Node(1).Post;
P_GMD_N2 = Network_GMD.Node(2).Post;
P_NGMD_N1 = Network_NGMD.Node(1).Post;
P_NGMD_N2 = Network_NGMD.Node(2).Post;


plot(P_FDN_N1(1,:)-P_GMD_N1(1,:));hold;plot(P_FDN_N2(1,:)-P_GMD_N2(1,:));
%% PLOT
% figure;
% subplot(311);
% hold on;
% plot(PM_GMD_GT.Node(1).Post_Entropy(1:end-1))
% plot(PM_GMD_GT.Node(1).Prior_Entropy(2:end))
% legend('Post','Prior')
%
% subplot(312);
% hold on;
% plot(PM_GMD_GT.Node(2).Post_Entropy(1:end-1))
% plot(PM_GMD_GT.Node(2).Prior_Entropy(2:end))
% legend('Post','Prior')
%
% subplot(313);
% hold on;
% plot(PM_GMD_GT.Node(1).Post_Entropy(1:end-1)+PM_GMD_GT.Node(2).Post_Entropy(1:end-1))
% plot(PM_GMD_GT.Node(1).Prior_Entropy(2:end)+PM_GMD_GT.Node(2).Prior_Entropy(2:end))
% legend('Post','Prior')




figure
subplot(321)
plot(PM_GMD_CEN.BCS(1,:)); hold on ; plot(PM_GCF_CEN.BCS(1,:)); hold on ; plot(PM_NGMD_CEN.BCS(1,:));
xlabel('step')
ylabel('BC distance')
legend('N1_{GMD}','N1_{GCF}','N1_{NGMD}')


subplot(323)
plot(PM_GMD_CEN.BCS(2,:)); hold on ; plot(PM_GCF_CEN.BCS(2,:)); hold on ; plot(PM_NGMD_CEN.BCS(2,:));
xlabel('step')
ylabel('BC distance')
legend('N2_{GMD}','N2_{GCF}','N2_{NGMD}')


subplot(325)
plot(PM_GMD_CEN.meanBCS); hold on ; plot(PM_GCF_CEN.meanBCS); plot(PM_NGMD_CEN.meanBCS);
xlabel('step')
ylabel('BC distance')
legend('Mean BC GMD','Mean BC GCF','Mean BC NGMD')



subplot(322)
plot(PM_GMD_CEN.HEL(1,:)); hold on ; plot(PM_GCF_CEN.HEL(1,:)); hold on
xlabel('step')
ylabel('HEL distance')
legend('N1_{GMD}','N1_{GCF}')


subplot(324)
plot(PM_GMD_CEN.HEL(2,:)); hold on ; plot(PM_GCF_CEN.HEL(2,:)); hold on
xlabel('step')
ylabel('HEL distance')
legend('N2_{GMD}','N2_{GCF}')


subplot(326)
plot(PM_GMD_CEN.meanHEL); hold on ; plot(PM_GCF_CEN.meanHEL);
xlabel('step')
ylabel('HEL distance')
legend('Mean BC GMD','Mean BC GCF')



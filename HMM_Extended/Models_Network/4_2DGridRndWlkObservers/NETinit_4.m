function [Network] = NETinit_4(Sim,HMM)
    [Network] = NETinit(Sim,HMM);    
    for i = 1:Network.NumNodes
        Network.Node(i).Config = Sim.NodeConfig(i);
        Network.Node(i).z(1,1) = Sim.InitState;
    end
    %% Nodes observation models (constant over time)    
    for i = 1:Network.NumNodes
        Network.Node(i).ObsMdl = zeros(HMM.NumStates,HMM.NumStates+1);
        Network.Node(i).ObsMdlHist = zeros(HMM.NumStates,HMM.NumStates+1,Sim.EndTime);
    end
    %% Manually set network connectivity over time
    Network.ConHist(:,:,1) = eye(Network.NumNodes);    
    Network.Connectivity = Sim.NetConnectivity;
end
function SetConfig(World)
    global Config
    %% Set Config   
    Config.BaseRate = 1;
    Config.MarkovRate = 360;
    Config.NetRate = 1;
    Config.SimTime = 500*Config.MarkovRate;
    Config.PixelLen = 1;
    Config.GT_InitState = 10;
    
    Config.Network.NumOfNodes = 6;
    Config.Network.Node(1).MotionMdlType = 1;
    Config.Network.Node(2).MotionMdlType = 1;
    Config.Network.Node(3).MotionMdlType = 1;
    Config.Network.Node(4).MotionMdlType = 1;    
    Config.Network.Node(5).MotionMdlType = 1;
    Config.Network.Node(6).MotionMdlType = 1;     
    
    Config.Network.Node(1).MoveDir = [0 1];
    Config.Network.Node(2).MoveDir = [0 -1];
    Config.Network.Node(3).MoveDir = [-1 0];
    Config.Network.Node(4).MoveDir = [1 0];    
    Config.Network.Node(5).MoveDir = [0 -1];
    Config.Network.Node(6).MoveDir = [-1 0];      
    
    Config.Network.Node(1).ObsDir = [1 0];
    Config.Network.Node(2).ObsDir = [-1 0];
    Config.Network.Node(3).ObsDir = [0 1];
    Config.Network.Node(4).ObsDir = [0 -1];
    Config.Network.Node(5).ObsDir = [-1 0];
    Config.Network.Node(6).ObsDir = [0 -1];    
    
    Config.Network.Node(1).Pos(1,:) = [1 1];
    Config.Network.Node(2).Pos(1,:) = [World.n_r World.n_c];
    Config.Network.Node(3).Pos(1,:) = [World.n_r 1];
    Config.Network.Node(4).Pos(1,:) = [1 World.n_c];
    Config.Network.Node(5).Pos(1,:) = [17 1];
    Config.Network.Node(6).Pos(1,:) = [1 19];
    
    Config.Network.Node(1).ID = 1;
    Config.Network.Node(2).ID = 2;
    Config.Network.Node(3).ID = 3;
    Config.Network.Node(4).ID = 4;
    Config.Network.Node(5).ID = 5;
    Config.Network.Node(6).ID = 6;    
    
    Config.Network.Node(1).ObsMdlType = 1;
    Config.Network.Node(2).ObsMdlType = 1;
    Config.Network.Node(3).ObsMdlType = 1;
    Config.Network.Node(4).ObsMdlType = 1;
    Config.Network.Node(5).ObsMdlType = 1;   
    Config.Network.Node(6).ObsMdlType = 1;     
    %% Check Config
    % Check Rates
    if mod(Config.MarkovRate,Config.BaseRate) ~=0
        error('Internal Error: MarkovRate should be an integer multiplier of the BaseRate!');
    end
    if mod(Config.NetRate,Config.BaseRate) ~=0
        error('Internal Error: NetRate should be an integer multiplier of the BaseRate!');
    end
end
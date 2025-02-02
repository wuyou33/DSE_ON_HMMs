function Ent = EntropyCostFuncGCF(omega,Network,k)
    Post = ones(size(Network.Node(1).Post(:,k)));
    for i = 1:Network.NumNodes
        Post = Post.*Network.Node(i).Post(:,k).^omega(i);
    end
    Post = Post/sum(Post);
    Ent = Entropy(Post);
end
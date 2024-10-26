function result = runCustomCompoundNetworkSim(K, p1, p2, p3, N)
    % p1: probability of failure for direct link
    % p2: probability of failure for first series link
    % p3: probability of failure for second series link
    
    simResults = ones(1,N); % Store results for each simulation
    
    for i = 1:N
        txAttemptCount = 0;    % Total transmission count
        pktSuccessCount = 0;   % Successfully transmitted packets
        
        % Continue until K packets have made it through
        while pktSuccessCount < K
            txAttemptCount = txAttemptCount + 1;  % Count transmission attempt
            
            % Try both paths simultaneously:
            % Path 1: Direct link (p1)
            % Path 2: Two series links (p2, p3)
            
            % Try direct path
            r1 = rand;  % Direct link
            
            % Try series path
            r2 = rand;  % First link of series path
            r3 = rand;  % Second link of series path
            
            % Packet succeeds if either:
            % 1. Direct path succeeds (r1 > p1) OR
            % 2. Both links in series path succeed (r2 > p2 AND r3 > p3)
            if (r1 > p1) || (r2 > p2 && r3 > p3)
                pktSuccessCount = pktSuccessCount + 1;
            end
        end
        
        simResults(i) = txAttemptCount;
    end
    
    result = mean(simResults);
end
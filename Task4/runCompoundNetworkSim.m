function result = runCompoundNetworkSim(K, p, N)
    simResults = ones(1,N); % Store results for each simulation
    
    for i = 1:N
        txAttemptCount = 0;    % Total transmission count
        pktSuccessCount = 0;   % Successfully transmitted packets
        
        % Continue until K packets have made it through
        while pktSuccessCount < K
            txAttemptCount = txAttemptCount + 1;  % Count transmission attempt
            
            % Try both paths simultaneously:
            % Path 1: Direct link (p)
            % Path 2: Two series links (p each)
            
            % Try direct path
            r1 = rand;  % Direct link
            
            % Try series path
            r2 = rand;  % First link of series path
            r3 = rand;  % Second link of series path
            
            % Packet succeeds if either:
            % 1. Direct path succeeds (r1 > p) OR
            % 2. Both links in series path succeed (r2 > p AND r3 > p)
            if (r1 > p) || (r2 > p && r3 > p)
                pktSuccessCount = pktSuccessCount + 1;
            end
        end
        
        simResults(i) = txAttemptCount;
    end
    
    result = mean(simResults);
end
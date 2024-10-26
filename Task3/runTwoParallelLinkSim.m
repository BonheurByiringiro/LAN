function result = runTwoParallelLinkSim(K, p, N)
    simResults = ones(1,N); % Store results for each simulation
    
    for i = 1:N
        txAttemptCount = 0;    % Total transmission count
        pktSuccessCount = 0;   % Successfully transmitted packets
        
        % Continue until K packets have made it through
        while pktSuccessCount < K
            txAttemptCount = txAttemptCount + 1;  % Count transmission attempt
            
            % Try both links simultaneously (one transmission)
            r1 = rand;  % First link
            r2 = rand;  % Second link
            
            % Packet succeeds if either link succeeds
            if (r1 > p) || (r2 > p)
                pktSuccessCount = pktSuccessCount + 1;
            end
        end
        
        simResults(i) = txAttemptCount;
    end
    
    result = mean(simResults);
end
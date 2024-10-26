function result = runTwoSeriesLinkSim(K, p, N)
    simResults = ones(1,N); % Store results for each simulation
    
    for i = 1:N
        txAttemptCount = 0;    % Total transmission count
        pktSuccessCount = 0;   % Successfully transmitted packets
        
        % Continue until K packets have made it through both links
        while pktSuccessCount < K
            linkSuccess = false;
            
            while ~linkSuccess
                txAttemptCount = txAttemptCount + 1;  % Count transmission attempt
                
                % Try first link
                r1 = rand;
                if r1 > p  % First link successful
                    % Try second link
                    r2 = rand;
                    if r2 > p  % Second link successful
                        linkSuccess = true;
                        pktSuccessCount = pktSuccessCount + 1;
                    end
                end
            end
        end
        
        simResults(i) = txAttemptCount;
    end
    
    result = mean(simResults);
end
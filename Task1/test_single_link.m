% Define parameters
K = 1;      % number of packets
p = 0.5;    % probability of failure (50%)
N = 1000;   % number of simulations

% Run the simulation
result = runSingleLinkSim(K, p, N);

% Display the result
fprintf('Average number of transmissions: %.2f\n', result);
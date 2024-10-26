% task5_main.m
% Program to simulate and plot custom compound network results
clear;
clc;
close all;

% Define parameters
K_values = [1, 5, 10];        % Different packet sizes for task 5
N = 1000;                     % Number of iterations per simulation
p_values = 0.01:0.01:0.99;    % Range for varying probability

% Define the six test cases
test_cases = {
    % p1    p2    p3(varying)   filename
    {0.10,  0.60,  p_values,    'case1'},  % Case 1
    {0.60,  0.10,  p_values,    'case2'},  % Case 2
    {0.10,  p_values,  0.60,    'case3'},  % Case 3
    {0.60,  p_values,  0.10,    'case4'},  % Case 4
    {p_values,  0.10,  0.60,    'case5'},  % Case 5
    {p_values,  0.60,  0.10,    'case6'}   % Case 6
};

% Colors for different K values
colors = {'b', 'r', 'g'};  % Blue, Red, Green for K=1,5,10

% Process each test case
for case_idx = 1:length(test_cases)
    % Extract test case parameters
    case_params = test_cases{case_idx};
    p1 = case_params{1};
    p2 = case_params{2};
    p3 = case_params{3};
    case_name = case_params{4};
    
    % Create figure for this case
    fig = figure('Name', sprintf('Case %d', case_idx), ...
        'Position', [100, 100, 800, 600]);
    ax = gca;
    set(ax, 'YScale', 'log');
    grid(ax, 'on');
    ax.GridLineStyle = '-';
    ax.GridAlpha = 0.15;
    hold(ax, 'on');
    box(ax, 'on');
    
    % Process each K value
    for k_idx = 1:length(K_values)
        K = K_values(k_idx);
        simulated_results = zeros(size(p_values));
        
        % Calculate results for each varying probability value
        for p_idx = 1:length(p_values)
            % Select proper probabilities based on which one is varying
            if isa(p1, 'double') && length(p1) > 1
                sim_p1 = p1(p_idx);
                sim_p2 = p2;
                sim_p3 = p3;
            elseif isa(p2, 'double') && length(p2) > 1
                sim_p1 = p1;
                sim_p2 = p2(p_idx);
                sim_p3 = p3;
            else
                sim_p1 = p1;
                sim_p2 = p2;
                sim_p3 = p3(p_idx);
            end
            
            % Run simulation
            simulated_results(p_idx) = runCustomCompoundNetworkSim(K, sim_p1, sim_p2, sim_p3, N);
        end
        
        % Plot results
        semilogy(ax, p_values, simulated_results, [colors{k_idx} 'o'], ...
            'MarkerFaceColor', 'none', 'MarkerSize', 6);
    end
    
    % Format plot
    ylim(ax, [10^0 10^4]);
    yticks(ax, 10.^(0:4));
    xlim(ax, [0 1]);
    
    % Labels and title
    xlabel(ax, 'Varying Probability of Failure', 'FontSize', 12);
    ylabel(ax, 'Average Number of Transmissions', 'FontSize', 12);
    if isa(p1, 'double') && length(p1) > 1
        varying = 'p1';
        fixed = sprintf('p2=%.2f, p3=%.2f', p2, p3);
    elseif isa(p2, 'double') && length(p2) > 1
        varying = 'p2';
        fixed = sprintf('p1=%.2f, p3=%.2f', p1, p3);
    else
        varying = 'p3';
        fixed = sprintf('p1=%.2f, p2=%.2f', p1, p2);
    end
    title(ax, sprintf('Compound Network Results - Varying %s (%s)', varying, fixed), ...
        'FontSize', 14);
    
    % Create legend
    legend_entries = {};
    for k = K_values
        legend_entries = [legend_entries, {sprintf('K=%d Simulated', k)}];
    end
    legend(ax, legend_entries, 'Location', 'northwest', 'FontSize', 10);
    
    % Save figure
    figuresDir = 'figures';
    if ~exist(figuresDir, 'dir')
        mkdir(figuresDir);
    end
    
    filename = fullfile(figuresDir, sprintf('compound_custom_%s', case_name));
    try
        saveas(fig, [filename '.png']);
        saveas(fig, [filename '.fig']);
    catch ME
        fprintf('Warning: Could not save figure %s\n', filename);
        fprintf('Error message: %s\n', ME.message);
    end
end

fprintf('All figures have been saved in the "figures" folder.\n');
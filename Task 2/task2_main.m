% task2_main.m
% Program to simulate and plot two series link network results

% Clear workspace and figures
clear;
clc;
close all;

% Define parameters
K_values = [1, 5, 15, 50, 100];    % Different packet sizes
p_values = 0:0.01:0.99;            % Range of failure probabilities
N = 1000;                          % Number of iterations per simulation

% Colors for different K values
colors = {'b', 'r', 'g', 'm', 'k'};  % Blue, Red, Green, Magenta, Black

% Create combined results figure
fig_combined = figure('Name', 'Combined Results', ...
    'Position', [100, 100, 800, 600]);
ax_combined = gca;
set(ax_combined, 'YScale', 'log');
grid(ax_combined, 'on');
ax_combined.GridLineStyle = '-';
ax_combined.GridAlpha = 0.15;
hold(ax_combined, 'on');
box(ax_combined, 'on');

% Initialize arrays for results
all_calculated = zeros(length(K_values), length(p_values));
all_simulated = zeros(length(K_values), length(p_values));

% Process each K value
for k_idx = 1:length(K_values)
    K = K_values(k_idx);
    simulated_results = zeros(size(p_values));
    calculated_results = zeros(size(p_values));
    
    % Calculate results for each p value
    for p_idx = 1:length(p_values)
        p = p_values(p_idx);
        % Run simulation
        simulated_results(p_idx) = runTwoSeriesLinkSim(K, p, N);
        % Calculate theoretical result
        if p == 1
            calculated_results(p_idx) = Inf;
        else
            % For series network, expected transmissions multiply
            calculated_results(p_idx) = K * (1/(1-p))^2;
        end
    end
    
    % Store results
    all_calculated(k_idx, :) = calculated_results;
    all_simulated(k_idx, :) = simulated_results;
    
    % Create individual figure for this K value
    fig_individual = figure('Name', sprintf('K = %d', K), ...
        'Position', [100, 100, 800, 600]);
    ax_individual = gca;
    
    % Plot individual results
    semilogy(ax_individual, p_values, calculated_results, colors{k_idx}, ...
        'LineWidth', 2);
    hold(ax_individual, 'on');
    semilogy(ax_individual, p_values, simulated_results, [colors{k_idx} 'o'], ...
        'MarkerFaceColor', 'none', 'MarkerSize', 6);
    
    % Format individual plot
    grid(ax_individual, 'on');
    ax_individual.GridLineStyle = '-';
    ax_individual.GridAlpha = 0.15;
    box(ax_individual, 'on');
    
    % Set axis properties for individual plot
    ylim(ax_individual, [10^0 10^4]);
    yticks(ax_individual, 10.^(0:4));
    xlim(ax_individual, [0 1]);
    
    % Labels and title for individual plot
    xlabel(ax_individual, 'Probability of Failure (p)', 'FontSize', 12);
    ylabel(ax_individual, 'Average Number of Transmissions', 'FontSize', 12);
    title(ax_individual, sprintf('Two Series Link Network Results (K = %d)', K), ...
        'FontSize', 14);
    legend(ax_individual, {'Calculated', 'Simulated'}, ...
        'Location', 'northwest', 'FontSize', 10);
    
    % Add to combined plot
    figure(fig_combined);
    semilogy(ax_combined, p_values, calculated_results, colors{k_idx}, ...
        'LineWidth', 2);
    semilogy(ax_combined, p_values, simulated_results, [colors{k_idx} 'o'], ...
        'MarkerFaceColor', 'none', 'MarkerSize', 6);
end

% Finalize combined plot
figure(fig_combined);
xlabel(ax_combined, 'Probability of Failure (p)', 'FontSize', 12);
ylabel(ax_combined, 'Average Number of Transmissions', 'FontSize', 12);
title(ax_combined, 'Two Series Link Network Results - All K Values', ...
    'FontSize', 14);

% Create legend entries for combined plot
legend_entries = {};
for k = K_values
    legend_entries = [legend_entries, ...
        {sprintf('K=%d Calculated', k), sprintf('K=%d Simulated', k)}];
end
legend(ax_combined, legend_entries, 'Location', 'northwest', 'FontSize', 10);

% Set final axis properties for combined plot
ylim(ax_combined, [10^0 10^4]);
yticks(ax_combined, 10.^(0:4));
xlim(ax_combined, [0 1]);

% Create figures directory if it doesn't exist
if ~exist('figures', 'dir')
    mkdir('figures');
end

% Save all figures
figures = findall(0, 'Type', 'figure');
for i = 1:length(figures)
    fig = figures(i);
    figure(fig.Number);
    
    % Get the name of the figure and create filename
    if strcmp(fig.Name, 'Combined Results')
        filename = 'two_series_combined_results';
    else
        k_str = extractBetween(fig.Name, 'K = ', '');
        filename = sprintf('two_series_link_K%s', k_str{1});
    end
    
    % Save in multiple formats
    saveas(fig, fullfile('figures', [filename '.png']));
    saveas(fig, fullfile('figures', [filename '.fig']));
end

fprintf('All figures have been saved in the "figures" folder.\n');
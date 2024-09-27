close all;
clear all;

%% Define ranges for Icut and binSize
Icut_values = [0.1,0.5];
binSize_values = [1,2];

%% Load time-series data
load("file.mat");

%% Set up the parallel pool
pool = gcp(); % Get the current parallel pool, or create one if it doesn't exist
numWorkers = pool.NumWorkers;

%% Parallel processing over Icut values
parfor Icut_idx = 1:length(Icut_values)
    Icut = Icut_values(Icut_idx);

    % Create a main folder for each Icut value
    mainFolder = strcat('expAvalanches/Icut_', num2str(Icut));
    if ~exist(mainFolder, 'dir')
        mkdir(mainFolder);
    end

    for binSize_idx = 1:length(binSize_values)
        binSize = -binSize_values(binSize_idx);

        % Create a subfolder for each binSize within the Icut folder
        subFolder = strcat(mainFolder, '/bs', num2str(binSize));
        if ~exist(subFolder, 'dir')
            mkdir(subFolder);
        end

        %% Pre-process data for analysis
        G = netC([1]);
        voltage = 1; %12V
        dt = 0.01; %0.1

        % get time-vectors, and cut when current is too low
        times = cell(size(G)); % time-vectors
        V = voltage * ones(numel(G)); % specify voltage for each

        for i = 1:numel(G)
            times{i} = dt * [1:numel(G{i})];
            I = G{i} * V(i);
            G{i}(I < Icut) = Icut * V(i);
        end

        %% Process avalanches from data
        Gt = Icut; %12V_uddipan_5e-4%*Icut; % threshold on delta G to be an event
        r = 0.03; % threshold on deltaG/G to be an event

        fitML = false; % fit using maximum likelihood method

        % Threshold Peak event detection method
        eventDetect = struct('method', 'thresholdPeak', 'thresh', Gt, 'relThresh', r); 

        % Conditions allow us to cut from first to last event
        conditions = struct('type', 'eventInterval', 'thresh', Gt, 'ratio', r); 
        disp('running')
        combinedCritAnalysis(G, V, times, subFolder, eventDetect, fitML, binSize, conditions);

        %% Import files of processed avalanches
        Exp = load(strcat(subFolder, '/critResults.mat'));
        Exp = Exp.results;

        %% Plot Figure 4
        nb = 20; % number of bins
        figure('visible', 'off');
        subplot(2, 3, 4);
        sizeAv = Exp.avalanche.sizeAv;
        xmin = Exp.avalanche.sizeFit.lc;
        xmax = Exp.avalanche.sizeFit.uc;
        tau = Exp.avalanche.sizeFit.tau;
        dtau = Exp.avalanche.sizeFit.dTau;
        [bins, N, edges] = LogBin(sizeAv, nb);

        x = xmin:0.01:xmax;
        A = N(find(edges <= xmin, 1));
        y = A * (x / xmin).^(-tau);
        loglog(bins, N, 'r.');
        hold on;
        loglog(x, y, 'k-');
        xlabel('S');
        ylabel('P(S)');
        text(100, 1e-1, strcat('S^{-', num2str(tau, 2), '}'), 'Color', 'k');
        title('Experiment');
        xlim([1, 1000]);
        xticks([1, 10, 100, 1000]);
        ylim([1e-4, 1]);
        xrange = xlim;
        yrange = ylim;
        shift = -0.17;
        text(10^((1-shift)*log10(xrange(1)) + shift*log10(xrange(2))), ...
             10^(shift*log10(yrange(1)) + (1-shift)*log10(yrange(2))), 'd', ...
             'fontweight', 'bold', 'fontsize', 12);

        subplot(2, 3, 5);
        lifeAv = Exp.avalanche.lifeAv;
        xmin = Exp.avalanche.timeFit.lc;
        xmax = Exp.avalanche.timeFit.uc;
        alpha = Exp.avalanche.timeFit.alpha;
        [bins, N, edges] = LogBin(lifeAv, nb);

        x = xmin:0.01:xmax;
        A = N(find(edges <= xmin, 1)) / 2;
        y = A * (x / xmin).^(-alpha);
        loglog(bins, N, 'r.');
        hold on;
        loglog(x, y, 'k-');
        xlabel('T');
        ylabel('P(T)');
        text(20, 1e-1, strcat('T^{-', num2str(alpha, 2), '}'), 'Color', 'k');
        xlim([1, 100]);
        xticks([1, 10, 100]);
        ylim([1e-4, 1]);
        xrange = xlim;
        yrange = ylim;
        shift = -0.17;
        text(10^((1-shift)*log10(xrange(1)) + shift*log10(xrange(2))), ...
             10^(shift*log10(yrange(1)) + (1-shift)*log10(yrange(2))), 'e', ...
             'fontweight', 'bold', 'fontsize', 12);

        subplot(2, 3, 6);
        [mSize, mLife] = avalancheAvSize(sizeAv, lifeAv);
        gamma_m_1 = Exp.avalanche.gamma.x2;
        loglog(mLife, mSize, 'r.');
        A = mSize(find(mLife > xmin, 1));
        y = A * (x / xmin).^(gamma_m_1);
        hold on;
        loglog(x, y, 'k-');
        xlabel('T');
        ylabel('\langle S \rangle (T)');
        text(2, 100, strcat('T^{', num2str(gamma_m_1, 2), '}'), 'Color', 'k');
        xlim([1, 100]);
        xticks([1, 10, 100]);
        ylim([1, 1000]);
        yticks([1, 10, 100, 1000]);
        xrange = xlim;
        yrange = ylim;
        shift = -0.17;
        text(10^((1-shift)*log10(xrange(1)) + shift*log10(xrange(2))), ...
             10^(shift*log10(yrange(1)) + (1-shift)*log10(yrange(2))), 'f', ...
             'fontweight', 'bold', 'fontsize', 12);

        % Save figures with Icut and binSize in filename
        saveas(gcf, strcat(subFolder, '/Figure_4_Icut_', num2str(Icut), '_binSize_', num2str(binSize), '.png'));
        disp(strcat2({'\tau = ', num2str(Exp.avalanche.sizeFit.tau), '+/-', num2str(Exp.avalanche.sizeFit.dTau)}));
        disp(strcat2({'\alpha = ', num2str(Exp.avalanche.timeFit.alpha), '+/-', num2str(Exp.avalanche.timeFit.dAlpha)}));
        dx1 = ((Exp.avalanche.timeFit.dAlpha / (Exp.avalanche.timeFit.alpha - 1)) + ...
               (Exp.avalanche.sizeFit.dTau / (Exp.avalanche.sizeFit.tau - 1))) * Exp.avalanche.gamma.x1;
        disp(strcat2({'S,T: 1/\sigma \nu z = ', num2str(Exp.avalanche.gamma.x1), '+/-', num2str(dx1)}));
        disp(strcat2({'<S>(T): 1/\sigma \nu z = ', num2str(Exp.avalanche.gamma.x2), '+/-', num2str(Exp.avalanche.gamma.dx2)}));
        disp(strcat2({'Suc = ', num2str(Exp.avalanche.sizeFit.uc), ', Tuc = ', num2str(Exp.avalanche.timeFit.uc)}));
        disp(strcat2({'Icut=',num2str(Icut),'binSize= ',num2str(binSize)}));
        close all;
    end
end

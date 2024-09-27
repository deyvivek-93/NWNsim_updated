% Define the full file path to the Excel file
folder = 'E:\VIVEK\OneDrive - Indian Institute of Science\OneDrive_2024-03-28\Collaboration Data\valid_data\output_final_binned\thresh_0.03\bin_500'; % Modify this to match your actual folder path
file = 'merged_data_out.xlsx';
fullFilePath = fullfile(folder, file);

% Define the sheet name and column name
%sheet = 'Avl_S';
sheet = 'T_duration';

column = 'A:A'; % Replace with the actual column name

% Read the 'size' column from the Excel sheet
data = xlsread(fullFilePath, sheet, column);

positiveData = data(data > 0);

fitTrun = true; % Set to false for a simple power-law fit

% Call the mlFit function with the filtered data and fitting option
result = mlFit(positiveData, fitTrun);

% Extract the filename without extension
[~, baseFileName, ~] = fileparts(file);

% Define the full file path to the Excel file for saving results
resultsFile = [baseFileName, '_PTresults.xlsx']; % Append "_results.xlsx" to the base filename
resultsFilePath = fullfile(folder, resultsFile);

% Create tables to store the results
plResults = table(...
    {'Tau'; 'Xmin'; 'Xmax'; 'llike'; 'aic'; 'bic'; 'SigmaTau'; 'P'; 'PCrit'; 'KS'}, ...
    {result.PL.tau; result.PL.xmin; result.PL.xmax; result.PL.llike; result.PL.aic; ...
    result.PL.bic; result.PL.dtau; result.PL.p; result.PL.pcrit; result.PL.ks});

expResults = table(...
    {'Lambda'; 'Lambda Confidence Interval'; 'Log-Likelihood'; 'AIC'; 'BIC'}, ...
    {result.E.lambda; result.E.dlambda; result.E.llike; result.E.aic; result.E.bic});

lnResults = table(...
    {'Mu'; 'sigma'; 'dsigma'; 'dmu'; 'Log-Likelihood'; 'AIC'; 'BIC'}, ...
    {result.LN.mu; result.LN.sigma; result.LN.dsigma; result.LN.dmu; ...
    result.LN.llike; result.LN.aic; result.LN.bic});

wbResults = table(...
    {'nu'; 'dnu'; 'gamma'; 'dgamma'; 'Log-Likelihood'; 'AIC'; 'BIC'}, ...
    {result.WB.nu; result.WB.dnu; result.WB.gamma; result.WB.dgamma; ...
    result.WB.llike; result.WB.aic; result.WB.bic});

% Define the sheet names for each table
sheetNames = {'PL_Results', 'Exp_Results', 'LN_Results', 'WB_Results'};

% Write the tables to an Excel file with different sheet names
writetable(plResults, resultsFilePath, 'Sheet', 'PL_Results', 'WriteVariableNames', false);
writetable(expResults, resultsFilePath, 'Sheet', 'Exp_Results', 'WriteVariableNames', false);
writetable(lnResults, resultsFilePath, 'Sheet', 'LN_Results', 'WriteVariableNames', false);
writetable(wbResults, resultsFilePath, 'Sheet', 'WB_Results', 'WriteVariableNames', false);

disp(['Results saved in ' resultsFilePath]);


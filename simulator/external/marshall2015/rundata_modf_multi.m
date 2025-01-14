% Define the folder containing Excel files
folder = 'E:\VIVEK\OneDrive - Indian Institute of Science\OneDrive_2024-03-28\Collaboration Data\valid_data\output_final_binned\thresh_0.03\bin_1000'; % Modify to your folder path
output_folder= fullfile(folder,'PSPT_output');
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end
% Get a list of all Excel files in the folder
fileList = dir(fullfile(folder, '*.xlsx'));
%{
% Loop through each Excel file
for i = 1:length(fileList)
    % Get the current Excel file's name
    currentFile = fileList(i).name;

    try
        % Define the full file path to the current Excel file
        fullFilePath = fullfile(folder, currentFile);

        % Define the sheet name and column name
        sheet = 'iei_rise'; % Modify sheet name as needed
        %sheet = 'Avl_S';
        column = 'A:A'; % Replace with the actual column name

        % Read the 'size' column from the Excel sheet
        data = xlsread(fullFilePath, sheet, column);

        positiveData = data(data > 0);

        fitTrun = true; % Set to false for a simple power-law fit

        % Call the mlFit function with the filtered data and fitting option
        result = mlFit(positiveData, fitTrun);

        % Extract the filename without extension
        [~, baseFileName, ~] = fileparts(currentFile);

        % Define the full file path to save the results
        resultsFile = [baseFileName, '_ieiriseresults.xlsx']; % Append "_results.xlsx" to the base filename
        %resultsFile = [baseFileName, '_PSresults.xlsx'];
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
        
        sheetNames = {'PL_Results', 'Exp_Results', 'LN_Results', 'WB_Results'};

        % Write the tables to an Excel file with different sheet names
        writetable(plResults, resultsFilePath, 'Sheet', 'PL_Results', 'WriteVariableNames', false);
        writetable(expResults, resultsFilePath, 'Sheet', 'Exp_Results', 'WriteVariableNames', false);
        writetable(lnResults, resultsFilePath, 'Sheet', 'LN_Results', 'WriteVariableNames', false);
        writetable(wbResults, resultsFilePath, 'Sheet', 'WB_Results', 'WriteVariableNames', false);

        disp(['Results saved in ' resultsFilePath]);
    catch err
        % Handle the error (you can add your own error handling code here)
        disp(['Error processing file ' currentFile]);
        disp(err.message);
    end
end


% Loop through each Excel file
for i = 1:length(fileList)
    % Get the current Excel file's name
    currentFile = fileList(i).name;

    try
        % Define the full file path to the current Excel file
        fullFilePath = fullfile(folder, currentFile);

        % Define the sheet name and column name
        sheet = 'iei_fall';
        %sheet = 'T_duration'; % Modify sheet name as needed
        column = 'A:A'; % Replace with the actual column name

        % Read the 'size' column from the Excel sheet
        data = xlsread(fullFilePath, sheet, column);

        positiveData = data(data > 0);

        fitTrun = true; % Set to false for a simple power-law fit

        % Call the mlFit function with the filtered data and fitting option
        result = mlFit(positiveData, fitTrun);

        % Extract the filename without extension
        [~, baseFileName, ~] = fileparts(currentFile);

        % Define the full file path to save the results
        resultsFile = [baseFileName, '_ieifallresults.xlsx']; % Append "_results.xlsx" to the base filename
        %resultsFile = [baseFileName, '_PSresults.xlsx'];
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
        
        sheetNames = {'PL_Results', 'Exp_Results', 'LN_Results', 'WB_Results'};

        % Create tables to store the results (same code as before)

        % Write the tables to an Excel file with different sheet names
        writetable(plResults, resultsFilePath, 'Sheet', 'PL_Results', 'WriteVariableNames', false);
        writetable(expResults, resultsFilePath, 'Sheet', 'Exp_Results', 'WriteVariableNames', false);
        writetable(lnResults, resultsFilePath, 'Sheet', 'LN_Results', 'WriteVariableNames', false);
        writetable(wbResults, resultsFilePath, 'Sheet', 'WB_Results', 'WriteVariableNames', false);

        disp(['Results saved in ' resultsFilePath]);
    catch err
        % Handle the error (you can add your own error handling code here)
        disp(['Error processing file ' currentFile]);
        disp(err.message);
    end
end
%}
for i = 1:length(fileList)
    % Get the current Excel file's name
    currentFile = fileList(i).name;

    try
        % Define the full file path to the current Excel file
        fullFilePath = fullfile(folder, currentFile);

        % Define the sheet name and column name
        %sheet = 'iei_rise'; % Modify sheet name as needed
        sheet = 'Avl_S';
        column = 'A:A'; % Replace with the actual column name

        % Read the 'size' column from the Excel sheet
        data = xlsread(fullFilePath, sheet, column);

        positiveData = data(data > 0);

        fitTrun = true; % Set to false for a simple power-law fit

        % Call the mlFit function with the filtered data and fitting option
        result = mlFit(positiveData, fitTrun);

        % Extract the filename without extension
        [~, baseFileName, ~] = fileparts(currentFile);

        % Define the full file path to save the results
        %resultsFile = [baseFileName, '_ieiriseresults.xlsx']; % Append "_results.xlsx" to the base filename
        resultsFile = [baseFileName, '_PSresults.xlsx'];
        resultsFilePath = fullfile(output_folder, resultsFile);
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
        
        sheetNames = {'PL_Results', 'Exp_Results', 'LN_Results', 'WB_Results'};

        % Write the tables to an Excel file with different sheet names
        writetable(plResults, resultsFilePath, 'Sheet', 'PL_Results', 'WriteVariableNames', false);
        writetable(expResults, resultsFilePath, 'Sheet', 'Exp_Results', 'WriteVariableNames', false);
        writetable(lnResults, resultsFilePath, 'Sheet', 'LN_Results', 'WriteVariableNames', false);
        writetable(wbResults, resultsFilePath, 'Sheet', 'WB_Results', 'WriteVariableNames', false);

        disp(['Results saved in ' resultsFilePath]);
    catch err
        % Handle the error (you can add your own error handling code here)
        disp(['Error processing file ' currentFile]);
        disp(err.message);
    end
end


for i = 1:length(fileList)
    % Get the current Excel file's name
    currentFile = fileList(i).name;

    try
        % Define the full file path to the current Excel file
        fullFilePath = fullfile(folder, currentFile);

        % Define the sheet name and column name
        %sheet = 'iei_rise'; % Modify sheet name as needed
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
        [~, baseFileName, ~] = fileparts(currentFile);

        % Define the full file path to save the results
        %resultsFile = [baseFileName, '_ieiriseresults.xlsx']; % Append "_results.xlsx" to the base filename
        resultsFile = [baseFileName, '_PTresults.xlsx'];
        resultsFilePath = fullfile(output_folder, resultsFile);
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
        
        sheetNames = {'PL_Results', 'Exp_Results', 'LN_Results', 'WB_Results'};

        % Write the tables to an Excel file with different sheet names
        writetable(plResults, resultsFilePath, 'Sheet', 'PL_Results', 'WriteVariableNames', false);
        writetable(expResults, resultsFilePath, 'Sheet', 'Exp_Results', 'WriteVariableNames', false);
        writetable(lnResults, resultsFilePath, 'Sheet', 'LN_Results', 'WriteVariableNames', false);
        writetable(wbResults, resultsFilePath, 'Sheet', 'WB_Results', 'WriteVariableNames', false);

        disp(['Results saved in ' resultsFilePath]);
    catch err
        % Handle the error (you can add your own error handling code here)
        disp(['Error processing file ' currentFile]);
        disp(err.message);
    end
end
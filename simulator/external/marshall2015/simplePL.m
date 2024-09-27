% Define the full file path to the Excel file
folder = 'E:\VIVEK\Vivek Dey\csv_YSZ\merge\output_final\edge\with mean IEI_rise_rtn_modf\mean_0.8'; % Modify this to match your actual folder path
file = 'merged_data_out.xlsx';
fullFilePath = fullfile(folder, file);

% Define the sheet name
sheet = 'Event_T_S';

% Define column names
columnA = 'A:A'; % Replace with the actual column name for x
columnB = 'B:B'; % Replace with the actual column name for y

% Read data from columns A and B
dataA = xlsread(fullFilePath, sheet, columnA);
dataB = xlsread(fullFilePath, sheet, columnB);

% Call your function using dataA as x and dataB as y
% Replace 'YourFunctionName' with the actual name of your function
%result = fitPowerLawLinearLogLog(dataA, dataB);

% Modify the result as needed
% For example, you can save it to a file or perform additional computations
[beta, dbeta] = fitPowerLawLinearLogLog(dataA, dataB);

% Display the values of beta and dbeta
fprintf('beta: %f\n', beta);
fprintf('dbeta: %f\n', dbeta);
% Display the result
disp('Result:');
disp(result);

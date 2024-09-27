% Define the full file path to the Excel file
folder = 'E:\VIVEK\Vivek Dey\csv_YSZ\merge\output_final\edge\with mean IEI_rise_rtn_modf\mean_0.8'; % Modify this to match your actual folder path
file = 'merged_data_out.xlsx';
fullFilePath = fullfile(folder, file);

% Define the sheet name and column name
sheet = 'iei_rise';
column = 'A:A'; % Replace with the actual column name

% Read the 'size' column from the Excel sheet
data = xlsread(fullFilePath, sheet, column);

positiveData = data(data > 0);

fitTrun = true; % Set to false for a simple power-law fit

% Call the mlFit function with the filtered data and fitting option
result = mlFit(positiveData, fitTrun);

powerLawResults = result.PL;





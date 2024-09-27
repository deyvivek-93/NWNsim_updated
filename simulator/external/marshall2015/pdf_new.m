% Define the full file path to the Excel file
folder = 'E:\VIVEK\Vivek Dey\csv_YSZ\merge\merge_multi_analysis\output_final\mean\thresh_0.1'; % Modify this to match your actual folder path
file = 'merged_data_out.xlsx';
fullFilePath = fullfile(folder, file);

% Define the sheet name and column name
sheet = 'Avl_S';

column = 'A:A'; % Replace with the actual column name

% Read the 'size' column from the Excel sheet
data = xlsread(fullFilePath, sheet, column);

% Calculate the probability distribution function (PDF)
[counts, edges] = histcounts(data, 'Normalization', 'probability');

% Plot the PDF in log-log scale
plot(edges(1:end-1), counts, 'o-');
xlabel('Value');
ylabel('Probability');
title('Probability Distribution Function (PDF) in Log-Log Scale');

% Optionally, you can add grid lines for better visualization
grid on;

% Optionally, you can adjust plot settings, such as line styles and colors
% For example:
% loglog(edges(1:end-1), counts, 'bo-', 'LineWidth', 2, 'MarkerSize', 8);

% Optionally, you can save the plot to an image file (e.g., PDF or PNG)
% saveas(gcf, 'pdf_plot.png');

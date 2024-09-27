% Specify the folder where your images are located
folderPath = 'E:\VIVEK\Vivek Dey\Codes\1. Icut\2D\Updated_codes_21-7-23\z_v\Z_data_diff_RF';

% Get a list of image files in the folder
imageFiles = dir(fullfile(folderPath, '*.png')); % Modify the extension as needed

% Extract RF values from the filenames
RF_values = cellfun(@(x) str2double(regexp(x, 'RF_(\d+)_', 'tokens', 'once')), {imageFiles.name});

% Create a VideoWriter object
outputVideo = VideoWriter('output_video.mp4', 'MPEG-4'); % Output video format and filename
outputVideo.FrameRate = 10; % Set the frame rate (adjust as needed, lower value for slower video)

% Open the video writer for writing
open(outputVideo);

% Loop through the image files and write each as a frame in the video
for i = 1:numel(imageFiles)
    img = imread(fullfile(folderPath, imageFiles(i).name)); % Read the image
    
    % Display the RF value on top of the image
    RF_value = RF_values(i);
    imgWithRF = img;
    textPosition = [10, 10]; % Adjust the position of the text
    imgWithRF = insertText(imgWithRF, textPosition, sprintf('RF: %.2f', RF_value), 'FontSize', 12, 'TextColor', 'white', 'BoxColor', 'black', 'BoxOpacity', 0.7, 'AnchorPoint', 'LeftTop', 'Font', 'Times New Roman');
    
    % Write the image with the RF value as a frame to the video
    writeVideo(outputVideo, imgWithRF);
end

% Close the video writer
close(outputVideo);

% Move the video to a desired location (one level up from the image folder)
movefile('output_video.mp4', 'E:\VIVEK\Vivek Dey\Codes\1. Icut\2D\Updated_codes_21-7-23\z_v\Z_data_diff_RF'); % Modify the destination path as needed

function calculateACF(results)
%{
    Calculate the autocorrelation function (ACF) of IEI data.
    Also computes the integrated value of the ACF from 0 to 1000 seconds,
    the slope of the ACF, and the 95% confidence bounds.
    
    Inputs:
        results: A structure containing IEI data in results.iei.ieidata
%}

    ieiDat = results;  % Extract IEI data
    
    % Number of observations
    N = length(ieiDat);
    
    % Calculate the ACF
    dt = 1;  % Assuming unit time step; adjust if necessary
    [acf, lags] = xcorr(ieiDat, 'coeff');  % Compute the autocorrelation
    lags = lags * dt;  % Convert lags to time units (seconds)
    
    % Compute 95% confidence bounds
    confInterval = 1.96 / sqrt(N);
    upperBound = confInterval * ones(size(acf));
    lowerBound = -confInterval * ones(size(acf));
    
    % Plot the ACF with confidence bounds
    figure;
    plot(lags, acf, 'b-', 'DisplayName', 'ACF');
    hold on;
    plot(lags, upperBound, 'r--', 'DisplayName', '95% Confidence Upper Bound');
    plot(lags, lowerBound, 'r--', 'DisplayName', '95% Confidence Lower Bound');
    xlabel('Lag (s)');
    ylabel('ACF');
    title('Autocorrelation Function of IEI with 95% Confidence Bounds');
    legend('show');
    grid on;
    
    % Compute the integrated value of the ACF from 0 to 1000 s
    ACF_integral = trapz(lags(lags >= 0 & lags <= 1000), acf(lags >= 0 & lags <= 1000));
    fprintf('Integrated ACF value from 0 to 1000 seconds: %.4f\n', ACF_integral);
    
    % Compute the slope of the ACF
    % Fit a linear model to the ACF
    validLags = lags(lags >= 0);  % Only positive lags
    validACF = acf(lags >= 0);
    
    % Use a linear fit to estimate the slope
    p = polyfit(validLags, validACF, 1);
    slope = p(1);
    fprintf('Slope of the ACF: %.4f\n', slope);
    
    % Optionally, you can plot the fitted line
    figure;
    plot(validLags, validACF, 'b-', 'DisplayName', 'ACF');
    hold on;
    fittedLine = polyval(p, validLags);
    plot(validLags, fittedLine, 'r--', 'DisplayName', 'Fitted Line');
    xlabel('Lag (s)');
    ylabel('ACF');
    title('ACF and Fitted Line');
    legend('show');
    grid on;
    
    % Save the ACF, lags, and confidence bounds to a structure
    data.acf = acf;
    data.lags = lags;
    data.upperBound = upperBound;
    data.lowerBound = lowerBound;
    
    % Optionally, save the structure to a .mat file
    save('acf_data.mat', 'data');
end

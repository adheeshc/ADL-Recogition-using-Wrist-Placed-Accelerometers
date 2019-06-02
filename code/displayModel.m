function displayModel(folder)
% function displayModel(folder)
%
% displayModel plots the acceleration recorded in the modelling trials
% stored in the given folder. Acceleration data are decoded and filtered
% with median filtering.
%
% Input:
%   folder --> name of the folder containing the dataset to be displayed
%
% Output:
%   ---
%
% Example:
   folder = 'C:\Users\Adheesh\Desktop\UMD\Sensor Systems\Project\698-activity-data\Climb_stairs\';
   displayModel(folder);

% READ THE ACCELEROMETER DATA FILES
files = dir([folder,'*.txt']);
numFiles = length(files);
dataFiles = zeros(1,numFiles);
noisy_x = [];
noisy_y = [];
noisy_z = [];
for i=1:1:numFiles
    dataFiles(i) = fopen([folder files(i).name],'r');
    data = fscanf(dataFiles(i),'%d\t%d\t%d\n',[3,inf]);

    % Fix the array sizes for data vectors of differing lengths
    noisy_x = padarray(noisy_x, [0,max(size(data,2)-size(noisy_x,2),0)],0,'post');
    noisy_y = padarray(noisy_y, [0,max(size(data,2)-size(noisy_y,2),0)],0,'post');
    noisy_z = padarray(noisy_z, [0,max(size(data,2)-size(noisy_z,2),0)],0,'post');

    % CONVERT THE ACCELEROMETER DATA INTO REAL ACCELERATION VALUES
    % mapping from [0..63] to [-14.709..+14.709]
    noisy_x(i,1:size(data,2)) = -14.709 + (data(1,:)/63)*(2*14.709);
    noisy_y(i,1:size(data,2)) = -14.709 + (data(2,:)/63)*(2*14.709);
    noisy_z(i,1:size(data,2)) = -14.709 + (data(3,:)/63)*(2*14.709);
end
noisy_x = transpose(noisy_x);
noisy_y = transpose(noisy_y);
noisy_z = transpose(noisy_z);

% REDUCE THE NOISE ON THE SIGNALS BY MEDIAN FILTERING
n = 3;      % order of the median filter
x_set = medfilt1(noisy_x,n);
y_set = medfilt1(noisy_y,n);
z_set = medfilt1(noisy_z,n);
numSamples = length(x_set(:,1));

% DISPLAY THE RESULTS
time = 1:1:numSamples;
% noisy signal
figure,
    subplot(3,1,1);
    plot(time,noisy_x,'-');
    axis([0 numSamples -14.709 +14.709]);
    title('Noisy accelerations along the x axis');
    subplot(3,1,2);
    plot(time,noisy_y,'-');
    axis([0 numSamples -14.709 +14.709]);
    ylabel('acceleration [m/s^2]');
    title('Noisy accelerations along the y axis');
    subplot(3,1,3);
    plot(time,noisy_z,'-');
    axis([0 numSamples -14.709 +14.709]);
    xlabel('time [samples]');
    title('Noisy accelerations along the z axis');
% clean signal
figure,
    subplot(3,1,1);
    plot(time,x_set,'-');
    axis([0 numSamples -14.709 +14.709]);
    title('Filtered accelerations along the x axis');
    subplot(3,1,2);
    plot(time,y_set,'-');
    axis([0 numSamples -14.709 +14.709]);
    ylabel('acceleration [m/s^2]');
    title('Filtered accelerations along the y axis');
    subplot(3,1,3);
    plot(time,z_set,'-');
    axis([0 numSamples -14.709 +14.709]);
    xlabel('time [samples]');
    title('Filtered accelerations along the z axis');
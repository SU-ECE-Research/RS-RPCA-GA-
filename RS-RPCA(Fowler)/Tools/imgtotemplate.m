function imgtotemplate(path, filename, start_frame, end_frame)

S = imgtomat(path, filename, start_frame, end_frame);
%[X, num_rows, num_cols] mattotemplate(path, filename, S, num_rows, num_cols)
% imgtomat('D:\RPCA\Data\ATO04_P016\7-06-12\', 'IMG_%04d.PNG', 0031, 0063)

pathAndFileName = strcat(path, filename);
pathAndFileName = strrep(pathAndFileName,'\','\\');
%pathAndFileName = strrep(pathAndFileName,'JPG','PNG');

num_frames = size(S, 2);

% Motion threhsolding
% Thresholds motion images (sparse matrix S from RPCA)
C = 2;


% Initialize field for speed
T = zeros(num_rows*num_cols,num_frames);

% Define function for calculating standard deviation of sparse matrix
sparse_sigma = @(x) std(single(S(:,x)));
sparse_mean = @(x) mean(single(S(:,x)));

for k = 1:num_frames
    % Template is sparse matrix with any values outside template
    T(:,k) = ((single(S(:,k)) > (sparse_mean(k) + C*sparse_sigma(k))) | (single(S(:,k)) < (sparse_mean(k) - C*sparse_sigma(k))))*255;
end
% Turn it binary for space
T = logical(T);

ThresholdpathAndFileName = strrep(pathAndFileName,'IMG_','IMG_Th_');
for frame = 1:num_frames

    current_filename = sprintf(ThresholdpathAndFileName, frame);
    image = reshape(T(:, frame), [num_rows num_cols]);
    imwrite(image, current_filename);
end

% Structuring element for binary morphology to create template.
% Future work: scale strel_size based on number of foreground pixels and

% size of blobs
    strelShape = 'disk';
    strelSize = 100;

% Define structural element for morphological operation
se = strel(strelShape,strelSize);
% Initialize morphed field for speed
M = zeros(num_rows*num_cols,num_frames);

for imN = 1:num_frames
    % Get thresholded image in matrix form
    template = reshape(T(:, imN), [num_rows num_cols]);
    % Perform each morphological operation
    m1 = bwmorph(template,'majority',1);
    m2 = imclose(m1, se);
    % Assign morphed image onto new field
    M(:,imN) = m2(:);
end
M = logical(M);

TemplatepathAndFileName = strrep(pathAndFileName,'IMG_','IMG_T_');
for frame = 1:num_frames
  current_filename = sprintf(TemplatepathAndFileName, frame);
  image = reshape(M(:, frame), [num_rows num_cols]);
  imwrite(image, current_filename);
end


function mattotemplate(path, filename, start_frame, S, num_rows, num_cols, LC, UC, strelSize, bwmorphIteration)

pathAndFileName = strcat(path, filename);
pathAndFileName = strrep(pathAndFileName,'\','\\');
pathAndFileName = strrep(pathAndFileName,'JPG','PNG');

num_frames = size(S, 2);

% Motion threhsolding
% Thresholds motion images (sparse matrix S from RPCA)
%LC = 2;
%UC = 2;

% Initialize field for speed
T = zeros(num_rows*num_cols,num_frames);

% Define function for calculating standard deviation of sparse matrix
sparse_sigma = @(x) std(single(S(:,x)));
sparse_mean = @(x) mean(single(S(:,x)));

for k = 1:num_frames
    % Template is sparse matrix with any values outside template
    T(:,k) = ((single(S(:,k)) > (sparse_mean(k) + UC*sparse_sigma(k))) | (single(S(:,k)) < (sparse_mean(k) - LC*sparse_sigma(k))))*255;
end
% Turn it binary for space
T = logical(T);

%for frame = 1:num_frames
  %current_filename = sprintf('G:\\RPCA(GA)\\Data\\RS-RPCA_Th_IMG_%04d.PNG', frame);
  %image = reshape(T(:, frame), [num_rows num_cols]);
  %imwrite(image, current_filename);
%end

% Structuring element for binary morphology to create template.
% Future work: scale strel_size based on number of foreground pixels and

% size of blobs
    strelShape = 'disk';
    %strelSize = 100;

% Define structural element for morphological operation
se = strel(strelShape,strelSize);
% Initialize morphed field for speed
M = zeros(num_rows*num_cols,num_frames);

for imN = 1:num_frames
    % Get thresholded image in matrix form
    template = reshape(T(:, imN), [num_rows num_cols]);
    % Perform each morphological operation
    m1 = bwmorph(template,'majority',bwmorphIteration);
    m2 = imclose(m1, se);
    % Assign morphed image onto new field
    M(:,imN) = m2(:);
end
M = logical(M);


for frame = 1:num_frames
  current_filename = sprintf(pathAndFileName, frame -1 + start_frame);
  image = reshape(M(:, frame), [num_rows num_cols]);
  imwrite(image, current_filename);
end


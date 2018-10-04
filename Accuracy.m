function a = Accuracy(path, filename, start_frame, end_frame)



imageCount = 1;
for frame = start_frame:end_frame
    template_filename = strcat(path, 'RS-RPCA_T_' , sprintf(filename, frame));
    groundTruth_filename = strcat(path, '\\GroundTruth\\' , strrep(sprintf(filename, frame), '.PNG', '_BW.png'));
    
    BW_groundTruth = imread(groundTruth_filename);
    BW = imread(template_filename);

    X = BW_groundTruth;
    Y = BW;
    NX = not(X);
    NY = not(Y);

    Alpha = 1;
    Beta = 1;

    Tversky = sum(X.*Y) / ( sum(X.*Y) + Alpha*sum(X.*NY) +  Beta*sum(NX.*Y) );
    a(imageCount) = Tversky;
    imageCount = imageCount + 1 ;

end


%MSE = immse(int8(BW), int8(BW_groundTruth)); fprintf('\n The mean-squared error is %0.4f\n', MSE);
%similarity = dice(BW,BW_groundTruth); fprintf('\n The DICE similarity is %0.4f\n', similarity);

%fprintf('\n The Tversky index is %0.4f\n', Tversky);


%imwrite(imfuse(BW, BW_groundTruth), 'G:\\RPCA(GA)\\Data\\ATO12\\CAM41985\\6-14-12\\Accuracy\\Accuracy_F0000015_BW.png');


%imshowpair(BW, BW_groundTruth)
%title(['Dice Index = ' num2str(similarity)])

end
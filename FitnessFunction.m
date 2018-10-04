function y = FitnessFunction(x)

%FITNESSFUNCTION Summary of this function goes here
%   Detailed explanation goes here

tic

Row_SubRate = x(1);
LSigma = x(2);
USigma = x(3);
StRelSize = round(x(4));
bwMorph = int8(x(5));


run_tests('G:\RPCA(GA)\Data\ATO04_P016\7-06-12\', 'IMG_%04d.JPG', 0031, 0048, Row_SubRate, LSigma, USigma, StRelSize, bwMorph)
run_tests('G:\RPCA(GA)\Data\ATO06_P038\8-18-12\', 'IMG_%04d.JPG', 0664, 0670, Row_SubRate, LSigma, USigma, StRelSize, bwMorph)

Accuracy1 = Accuracy('G:\RPCA(GA)\Data\ATO04_P016\7-06-12\', 'IMG_%04d.PNG', 0031, 0048); 
Accuracy2 = Accuracy('G:\RPCA(GA)\Data\ATO06_P038\8-18-12\', 'IMG_%04d.PNG', 0664, 0670);
AccuracyBoth = [Accuracy1, Accuracy2];

%set score penalty function
n = numel(AccuracyBoth);
g = sum(AccuracyBoth>0.8816);

k = (n - g) /n;

BIPScore = 2*(g)-k*log2(n);

GAaccuracy = 1000 - BIPScore;

Run_Time = toc;


%log both Accuracy and time data for run

AccuracyLog.parameters = x;
AccuracyLog.Time = Run_Time;
AccuracyLog.set1 = 'G:\RPCA(GA)\Data\ATO04_P016\7-06-12\ IMG_%04d.JPG 0031 0048';
AccuracyLog.set2 = 'G:\RPCA(GA)\Data\ATO06_P038\8-18-12\ IMG_%04d.JPG 0664 0670';
AccuracyLog.GAaccuracy = GAaccuracy;
AccuracyLog.Accuracy1 = Accuracy1;
AccuracyLog.Accuracy2 = Accuracy2;
AccuracyLog.AccuracyBoth = AccuracyBoth;
AccuracyLog.BIPScore = BIPScore;


dt = datestr(now,'mmmm-dd-yyyy_HH_MM_SS_FFF');
name = strcat('/Log/AccuracyDetails/',dt,'_AccuracyDetails');
Filename = sprintf('%s',[pwd name]);
save(Filename,'AccuracyLog');




y(1) = Run_Time;
y(2) = GAaccuracy;
end


clc;
predictions=TrainedModel.predictFcn(diabetestraining);
ytrain=diabetestraining.label;
txt=sprintf('The train accuracy is %f',sum(ytrain==predictions)/length(ytrain));
disp(txt);
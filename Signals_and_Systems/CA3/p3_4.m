clc;
predictions=TrainedModel.predictFcn(diabetesvalidation);
ytest=diabetesvalidation.label;
txt=sprintf('The test accuracy is %f',sum(ytest==predictions)/length(ytest));
disp(txt);
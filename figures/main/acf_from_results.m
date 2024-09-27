%clear all; close all;

result=results.IEI.ieiDat;
data=result(:,2);
data=data';
calculateACF(data);
clc;
clear;
close all;
current_file = mfilename('fullpath'); 
[current_path, ~, ~] = fileparts(current_file);
run('./MRI_pADMM.m'); 
clear; 


mat_file1 = 'pADMM_MRI_MCP.mat';
mat_file2 = 'pADMM_MRI_SCAD.mat';

X1 = load(mat_file1);
X2 = load(mat_file2);


figure(1);
semilogy(X1.e,'-d','LineWidth',1.7,'Color', "r",'MarkerIndices',1:5:length(X1.e));
set(gca, 'FontSize', 14);
xlabel('Iteration','FontSize',19);
ylabel('L_1','FontSize', 19);
grid on;
hold on;
semilogy(X2.e2,':*','LineWidth',1.7,'Color', "r",'MarkerIndices',1:5:length(X2.e2));
% grid on;
hold on;
legend('ADMM-MCP','ADMM-SCAD','pADMM-MCP','pADMM-SCAD');

figure(2);
semilogy(X1.L2,'-d','LineWidth',1.7,'Color', "r",'MarkerIndices',1:5:length(X1.L2));
set(gca, 'FontSize', 14);
xlabel('Iteration','FontSize',19);
ylabel('L_2','FontSize', 19);
grid on;
hold on;
semilogy(X2.L22,':*','LineWidth',1.7,'Color', "r",'MarkerIndices',1:5:length(X2.L22));
% grid on;
hold on;
legend('ADMM-MCP','ADMM-SCAD','pADMM-MCP','pADMM-SCAD');

figure(3);
t = linspace(0,X1.tEnd,length(X1.L2));
semilogy(t,X1.L2,'-d','LineWidth',1.7,'Color', "r",'MarkerIndices',1:5:length(X1.L2));
set(gca, 'FontSize', 14);
xlabel('Time(s)','FontSize',19);
ylabel('L_2','FontSize', 19);
grid on;
hold on;

t = linspace(0,X2.tEnd2,length(X2.L22));
semilogy(t,X2.L22,':*','LineWidth',1.7,'Color', "r",'MarkerIndices',1:5:length(X2.L22));
% grid on;
hold on;
legend('pADMM-MCP','pADMM-SCAD','ADMM-MCP','ADMM-SCAD');

figure(4);
t = linspace(0,X1.tEnd,length(X1.e));
semilogy(t,X1.e,'-d','LineWidth',1.7,'Color', "r",'MarkerIndices',1:5:length(X1.e));
set(gca, 'FontSize', 14);
xlabel('Time(s)','FontSize',19);
ylabel('L_1','FontSize', 19);
grid on;
hold on;
t = linspace(0,X2.tEnd2,length(X2.e2));
semilogy(t,X2.e2,':*','LineWidth',1.7,'Color', "r",'MarkerIndices',1:5:length(X2.e2));
% grid on;
hold on;
legend('pADMM-MCP','pADMM-SCAD','ADMM-MCP','ADMM-SCAD');


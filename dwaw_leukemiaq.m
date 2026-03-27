clc;
clear;
close all;
current_file = mfilename('fullpath'); 
[current_path, ~, ~] = fileparts(current_file);
% run('current_path/test2.m'); 
% clear; 
% run('current_path/TB_ADMM1.m'); 
% clear; 
mat_file1 = 'ADMM_MCP.mat';
mat_file2 = 'ADMM_SCAD.mat';
mat_file3 = 'pADMM_MCP.mat';
mat_file4 = 'pADMM_SCAD.mat';
mat_file5 = 'pADMM_MCPq5.mat';
mat_file6 = 'pADMM_SCADq5.mat';
mat_file7 = 'pADMM_MCPq10.mat';
mat_file8 = 'pADMM_SCADq10.mat';
mat_file9 = 'pADMM_MCPq20.mat';
mat_file10 = 'pADMM_SCADq20.mat';
mat_file11 = 'pADMM_MCPq50.mat';
mat_file12 = 'pADMM_SCADq50.mat';
% fpath = dir(fullfile(current_path,'*.mat'));
X1 = load(mat_file1);
X2 = load(mat_file2);
Y1 = load(mat_file3);
Y2 = load(mat_file4);
Y3 = load(mat_file5);
Y4 = load(mat_file6);
Y5 = load(mat_file7);
Y6 = load(mat_file8);
Y7 = load(mat_file9);
Y8 = load(mat_file10);
Y9 = load(mat_file11);
Y10 = load(mat_file12);

% fpath = dir(fullfile(current_path,'*.mat'));
% X1 = load(fpath(1).name);
% X2 = load(fpath(2).name);
% Y1 = load(fpath(3).name);
% Y2 = load(fpath(4).name);
% figure(1);
% semilogy(X1.e,'LineWidth',1.7,'Color', "b", Marker="d");
% xlabel('iteration','FontSize',16);
% ylabel('primal residual','FontSize', 16)
% grid on;
% hold on;
% semilogy(X2.e2,'LineWidth',1.7,'Color', "b", Marker="*");
% % grid on;
% hold on;
% semilogy(Y1.e,'LineWidth',1.7,'Color', 'r', Marker="d");
% hold on;
% semilogy(Y2.e2,'LineWidth',1.7,'Color', 'r',Marker="*");
% legend('ADMM-MCP','ADMM-SCAD','pADMM-MCP','pADMM-SCAD');



% figure(1);
% semilogy(X1.e,'-d','LineWidth',1.7,'Color', "b",'MarkerIndices',1:2:length(X1.e));
% set(gca, 'FontSize', 14);
% xlabel('Iteration','FontSize',19);
% ylabel('L_1','FontSize', 19)
% grid on;
% hold on;
% semilogy(X2.e2,':*','LineWidth',1.7,'Color', "b",'MarkerIndices',1:2:length(X2.e2));
% % grid on;
% hold on;
% semilogy(Y1.e,'-d','LineWidth',1.7,'Color', 'r', 'MarkerIndices',1:2:length(Y1.e));
% hold on;
% semilogy(Y2.e2,':*','LineWidth',1.7,'Color', 'r','MarkerIndices',1:2:length(Y2.e2));
% legend('ADMM-MCP','ADMM-SCAD','pADMM-MCP','pADMM-SCAD');
% 
% figure(2);
% semilogy(X1.L2,'-d','LineWidth',1.7,'Color', "b",'MarkerIndices',1:2:length(X1.L2));
% set(gca, 'FontSize', 14);
% xlabel('Iteration','FontSize',19);
% ylabel('L_2','FontSize', 19);
% grid on;
% hold on;
% semilogy(X2.L22,':*','LineWidth',1.7,'Color', "b",'MarkerIndices',1:2:length(X2.L22));
% % grid on;
% hold on;
% semilogy(Y1.L2,'-d','LineWidth',1.7,'Color', 'r', 'MarkerIndices',1:2:length(Y1.L2));
% hold on;
% semilogy(Y2.L22,':*','LineWidth',1.7,'Color', 'r','MarkerIndices',1:2:length(Y2.L22));
% legend('ADMM-MCP','ADMM-SCAD','pADMM-MCP','pADMM-SCAD');
% 
% figure(3);
% t = linspace(0,X1.tEnd,length(X1.L2));
% semilogy(t,X1.L2,'-d','LineWidth',1.7,'Color', "b",'MarkerIndices',1:2:length(X1.L2));
% set(gca, 'FontSize', 14);
% xlabel('Time(s)','FontSize',19);
% ylabel('L_2','FontSize', 19)
% grid on;
% hold on;
% 
% t = linspace(0,X2.tEnd2,length(X2.L22));
% semilogy(t,X2.L22,':*','LineWidth',1.7,'Color', "b",'MarkerIndices',1:3:length(X2.L22));
% % grid on;
% hold on;
% t = linspace(0,Y1.tEnd,length(Y1.L2));
% semilogy(t,Y1.L2,'-d','LineWidth',1.7,'Color', 'r', 'MarkerIndices',1:2:length(Y1.L2));
% hold on;
% t = linspace(0,Y2.tEnd2,length(Y2.L22));
% semilogy(t,Y2.L22,':*','LineWidth',1.7,'Color', 'r','MarkerIndices',1:3:length(Y2.L22));
% legend('ADMM-MCP','ADMM-SCAD','pADMM-MCP','pADMM-SCAD');
% 
% figure(4);
% t = linspace(0,X1.tEnd,length(X1.e));
% semilogy(t,X1.e,'-d','LineWidth',1.7,'Color', "b",'MarkerIndices',1:2:length(X1.e));
% set(gca, 'FontSize', 14);
% xlabel('Time(s)','FontSize',19);
% ylabel('L_1','FontSize', 19)
% grid on;
% hold on;
% 
% t = linspace(0,X2.tEnd2,length(X2.e2));
% semilogy(t,X2.e2,':*','LineWidth',1.7,'Color', "b",'MarkerIndices',1:3:length(X2.e2));
% % grid on;
% hold on;
% t = linspace(0,Y1.tEnd,length(Y1.e));
% semilogy(t,Y1.e,'-d','LineWidth',1.7,'Color', 'r', 'MarkerIndices',1:2:length(Y1.e));
% hold on;
% t = linspace(0,Y2.tEnd2,length(Y2.e2));
% semilogy(t,Y2.e2,':*','LineWidth',1.7,'Color', 'r','MarkerIndices',1:3:length(Y2.e2));
% legend('ADMM-MCP','ADMM-SCAD','pADMM-MCP','pADMM-SCAD');

figure(5);
t = linspace(0,X1.tEnd,length(X1.e));
semilogy(t,X1.e,'-d','LineWidth',1.7,'Color', "b",'MarkerIndices',1:2:length(X1.e));
set(gca, 'FontSize', 14);
xlabel('Time(s)','FontSize',19);
ylabel('L_1','FontSize', 19)
grid on;
hold on;

% t = linspace(0,Y1.tEnd2,length(Y1.e2));
% semilogy(t,Y1.e2,':*','LineWidth',1.7,'Color', "b",'MarkerIndices',1:3:length(X2.e2));
% grid on;
% hold on;
t = linspace(0,Y1.tEnd,length(Y1.e));
semilogy(t,Y1.e,':*','LineWidth',1.7,'Color', 'r', 'MarkerIndices',1:2:length(Y1.e));
hold on;
% t = linspace(0,Y2.tEnd2,length(Y2.e2));
% semilogy(t,Y2.e2,':*','LineWidth',1.7,'Color', 'r','MarkerIndices',1:3:length(Y2.e2));
% legend('ADMM-MCP','ADMM-SCAD','pADMM-MCP','pADMM-SCAD');
t = linspace(0,Y3.tEnd,length(Y3.e));
semilogy(t,Y3.e,':*','LineWidth',1.7,'Color', [255 174 0]/255, 'MarkerIndices',1:2:length(Y3.e));
hold on;
t = linspace(0,Y5.tEnd,length(Y5.e));
semilogy(t,Y5.e,':*','LineWidth',1.7,'Color', 'm', 'MarkerIndices',1:2:length(Y5.e));
hold on;
% t = linspace(0,Y7.tEnd,length(Y7.e));
% semilogy(t,Y7.e,':*','LineWidth',1.7,'Color', [4 157 107]/255, 'MarkerIndices',1:2:length(Y7.e));
% hold on;
t = linspace(0,Y9.tEnd,length(Y9.e));
semilogy(t,Y9.e,':*','LineWidth',1.7,'Color', [4 157 107]/255, 'MarkerIndices',1:2:length(Y9.e));
% title('Nonconvex function');
legend('ADMM-$$\hat{q}$$=0','pADMM-$$\hat{q}$$=1','pADMM-$$\hat{q}$$=5','pADMM-$$\hat{q}$$=10','pADMM-$$\hat{q}$$=50','Interpreter','latex');


figure(6);
t = linspace(0,X1.tEnd,length(X1.L2));
semilogy(t,X1.L2,'-d','LineWidth',1.7,'Color', "b",'MarkerIndices',1:2:length(X1.L2));
set(gca, 'FontSize', 14);
xlabel('Time(s)','FontSize',19);
ylabel('L_2','FontSize', 19)
grid on;
hold on;

% t = linspace(0,Y1.tEnd2,length(Y1.e2));
% semilogy(t,Y1.e2,':*','LineWidth',1.7,'Color', "b",'MarkerIndices',1:3:length(X2.e2));
% grid on;
% hold on;
t = linspace(0,Y1.tEnd,length(Y1.L2));
semilogy(t,Y1.L2,':*','LineWidth',1.7,'Color', 'r', 'MarkerIndices',1:2:length(Y1.L2));
hold on;
% t = linspace(0,Y2.tEnd2,length(Y2.e2));
% semilogy(t,Y2.e2,':*','LineWidth',1.7,'Color', 'r','MarkerIndices',1:3:length(Y2.e2));
% legend('ADMM-MCP','ADMM-SCAD','pADMM-MCP','pADMM-SCAD');
t = linspace(0,Y3.tEnd,length(Y3.L2));
semilogy(t,Y3.L2,':*','LineWidth',1.7,'Color', [255 174 0]/255, 'MarkerIndices',1:2:length(Y3.L2));
hold on;
t = linspace(0,Y5.tEnd,length(Y5.L2));
semilogy(t,Y5.L2,':*','LineWidth',1.7,'Color', 'm', 'MarkerIndices',1:2:length(Y5.L2));
hold on;
% t = linspace(0,Y7.tEnd,length(Y7.e));
% semilogy(t,Y7.e,':*','LineWidth',1.7,'Color', [4 157 107]/255, 'MarkerIndices',1:2:length(Y7.e));
% hold on;
t = linspace(0,Y9.tEnd,length(Y9.L2));
semilogy(t,Y9.L2,':*','LineWidth',1.7,'Color', [4 157 107]/255, 'MarkerIndices',1:2:length(Y9.L2));
%title('Nonconvex function');
legend('ADMM-$$\hat{q}$$=0','pADMM-$$\hat{q}$$=1','pADMM-$$\hat{q}$$=5','pADMM-$$\hat{q}$$=10','pADMM-$$\hat{q}$$=50','Interpreter','latex');



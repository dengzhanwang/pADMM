clear;
clc;
format long;

folder1 = '.\data\archive\Alzheimer_s Dataset\train\MildDemented';
folder2 = '.\data\archive\Alzheimer_s Dataset\train\ModerateDemented';
folder3 = '.\data\archive\Alzheimer_s Dataset\train\NonDemented';
folder4 = '.\data\archive\Alzheimer_s Dataset\train\VeryMildDemented';
folder = {folder1,folder2,folder3,folder4}; 
target_size = [70, 70];  
matrix = [];

for i = 1:4
    files = dir(fullfile(folder{i}, '*.jpg'));
    for j = 1:50
    img = imread(fullfile(folder{i}, files(j).name));
    compressed = imresize(img, target_size);
    matrix = [matrix; compressed(:)'];
    end
end

A = double(matrix);

n = 50*4; %train Number of samples
p = 70*70;   %Number of sample features

b_train = zeros(n,1);
b_train(51:100,:) = 1;
b_train(101:150,:) = 2;
b_train(151:end,:) = 3;


max_iter = 200;
H = diag(ones(1,p)); 
% H= rand(p,p);
alpha1 = 0.3;
alpha2 = 0.2;
gamma = 0.1;
lambda = 0.2;
mu = 1;

beta1 = 1;
beta2 = 1;
Lambda1 = ones(p,1);
Lambda2 = ones(p,1);
X = ones(p,1); 
V = ones(p,1); 
U = ones(p,1);


tStart = tic;
stop = 0; iter = 0; error = 1;
while (error>1e-7 && iter<max_iter)
     
    fns = Euclidean();
    fns = subprolemX(A, b_train,beta1,beta2,Lambda1,Lambda2,U,V,X,H ,fns);
    x0.main = X+rand(size(X));
    % x0.main = rand(size(X));

    params.x0 = x0;
    params.verbose = 1;
    params.Max_Iteration = 200;
    params.OutputGap = 1;
    params.Tolerance = 1e-8;
    params.m = 10;
    params.SafeGuardTypeInBB = 1;
    params.max_innit = 10;

    [xopt, info] = RSD(fns, params);
    Xnew = xopt.main;
    % ee = norm(x)
    Vnew = (beta2.*H*Xnew-Lambda2+V)./(alpha1*(1-alpha2)+beta2+1);
    Y = (beta1.*H*Xnew-Lambda1+U)./(beta1+1);

    for k = 1:size(Y,1)
        if abs(Y(k))>gamma*lambda
            Unew(k) = Y(k);
        elseif abs(Y(k)) <= alpha1*alpha2*lambda/(beta1+1)
            Unew(k) = 0;
        else
            % U(k) = (Y(k)-lambda*alpha1*alpha2*gamma*sign(Y(k))./(gamma*beta1+1))./(1-alpha1*alpha2/(beta1*lambda+1));
            Unew(k) = (gamma*(beta1+1)*Y(k)-lambda*alpha1*alpha2*gamma*sign(Y(k))/(beta1*gamma+gamma-alpha1*alpha2));

        end
    end

     L2(iter+1) = norm(Unew'-U,'fro')+norm(Xnew-X,'fro')+norm(Vnew-V,'fro');

    X = Xnew;
    U = Unew';
    V = Vnew;
    Lambda1 = Lambda1 + mu*beta1 .*(U-H*X);
    Lambda2 = Lambda2 + mu*beta2 .*(V-H*X);
    beta1 = 1.06*beta1;
    beta2 = 1.06*beta2;
    error = norm(U-H*X,'fro') + norm(V-H*X,'fro');
        
    iter = iter+1;
    e(iter) = error;
    t = A*X-b_train;
    if iter>1 && abs(e(iter)-e(iter-1))<1e-7
        break;
    end
end
tEnd = toc(tStart) ;
figure(1);
semilogy(e,'LineWidth',1.7,'Color', "b", Marker="d");
xlabel('Iteration','FontSize',16);
ylabel('L1','FontSize', 16)
hold on;

figure(3);
semilogy(L2,'LineWidth',1.7,'Color', "b",Marker="d");
xlabel('Iteration','FontSize',16);
ylabel('L2','FontSize', 16)
hold on;

%---------------------------------------------------
%SCAD
alpha1 = 0.3;
alpha2 = 0.2;
gamma = 5;
lambda = 0.2;
mu = 1;

beta1 = 1;
beta2 = 1;
Lambda1 = ones(p,1);
Lambda2 = ones(p,1);
X = ones(p,1); 
V = ones(p,1); 
U = ones(p,1);

tStart2 = tic;
stop = 0; iter = 0; error = 1;
while (error>1e-7 && iter<max_iter)
    fns = Euclidean();
    fns = subprolemX(A, b_train,beta1,beta2,Lambda1,Lambda2,U,V,X,H ,fns);
    x0.main = X+rand(size(X));
    % x0.main = rand(size(X));

    params.x0 = x0;
    params.verbose = 1;
    params.Max_Iteration = 200;
    params.OutputGap = 1;
    params.Tolerance = 1e-8;
    params.m = 10;
    params.SafeGuardTypeInBB = 1;
    params.max_innit = 10;

    [xopt, info] = RSD(fns, params);
    Xnew = xopt.main;
    Vnew = (beta2.*H*Xnew-Lambda2+V)./(alpha1*(1-alpha2)+beta2+1);
    
    Y = (beta1.*H*Xnew-Lambda1+U)./(beta1+1);
    
    for k = 1:size(Y,1)
        if abs(Y(k))>gamma*lambda
            Unew(k) = Y(k);
        elseif abs(Y(k)) <= alpha1*alpha2*lambda/(beta1+1)
            Unew(k) = 0;
        elseif abs(Y(k)) >= alpha1*alpha2*lambda/(beta1+1) && abs(Y(k)) <= alpha1*alpha2*lambda*gamma/((beta1+1)+(gamma-1))
            % U(k) = (Y(k)-lambda*alpha1*alpha2*gamma*sign(Y(k))./(gamma*beta1+1))./(1-alpha1*alpha2/(beta1*lambda+1));
            Unew(k) = Y(k) - sign(Y(k))*alpha1*alpha2*lambda/(beta1+1);
        else 
            Unew(k) = ((gamma-1)*(beta1+1)*Y(k)-sign(Y(k))*alpha1*alpha2*lambda*gamma)./((beta1+1)*(gamma-1)-alpha1*alpha2);
        end
    end
    L22(iter+1) = norm((Unew'-U),'fro')+norm(Xnew-X,'fro')+norm(Vnew-V,'fro');

    X = Xnew;
    U = Unew';
    V = Vnew;
         
    Lambda1 = Lambda1 + mu*beta1 .*(U-H*X);
    Lambda2 = Lambda2 + mu*beta2 .*(V-H*X);
    beta1 = 1.06*beta1;
    beta2 = 1.06*beta2;

    error = norm(U-H*X,'fro') + norm(V-H*X,'fro');

    iter = iter+1;
    e2(iter) = error;
    
    if iter>1 && abs(e2(iter)-e2(iter-1))<1e-7
        break;
    end
end
tEnd2 = toc(tStart2) ;

save('pADMM_MRI_MCP.mat', 'e', 'L2','tEnd');
save('pADMM_MRI_SCAD.mat', 'e2', 'L22','tEnd2');
figure(1);
semilogy(e2,'LineWidth',1.7,'Color', "b",Marker="*");
xlabel('Iteration','FontSize',16);
ylabel('L_1','FontSize', 16);

legend('pADMM-MCP','pADMM-SCAD');
figure(2);
plot(f2, 'LineWidth',1.7,'Color', "b",Marker="*");
xlabel('Iteration','FontSize',16);
ylabel('Function value','FontSize', 16)

legend('pADMM-MCP','pADMM-SCAD');
figure(3);
semilogy(L22,'LineWidth',1.7,'Color', "b",Marker="*");
xlabel('Iteration','FontSize',16);
ylabel('L2','FontSize', 16)

 legend('pADMM-MCP','pADMM-SCAD');

% -------------------------------------------

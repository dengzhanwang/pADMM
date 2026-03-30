clc; clear; close all;

%% ------------------- Data Preparation -------------------
folder1 = '.\\data\\archive\\Alzheimer_s Dataset\\train\\MildDemented';
folder2 = '.\\data\\archive\\Alzheimer_s Dataset\\train\\ModerateDemented';
folder3 = '.\\data\\archive\\Alzheimer_s Dataset\\train\\NonDemented';
folder4 = '.\\data\\archive\\Alzheimer_s Dataset\\train\\VeryMildDemented';
folder = {folder1, folder2, folder3, folder4};
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

n = 50 * 4;
p = 70 * 70;
b_train = zeros(n, 1);
b_train(51:100, :) = 1;
b_train(101:150, :) = 2;
b_train(151:end, :) = 3;

H = eye(p);

%% ------------------- Parameters -------------------
alpha1 = 0.3; alpha2 = 0.2; gamma = 0.1; lambda = 0.2; mu = 1;
beta1 = 1; beta2 = 1;
lin_step_scale = 1.2;
lin_tol = 1e-5;
lin_max_iter = 60;

Lambda1 = ones(p, 1); Lambda2 = ones(p, 1);
X = ones(p, 1); V = ones(p, 1); U = ones(p, 1);

%% ------------------- Linearized ADMM -------------------
tStart = tic;
error = 1; iter = 0;

while error > lin_tol && iter < lin_max_iter
    gradX = beta1 * H' * (H * X - U) + beta2 * H' * (H * X - V);
    t_lin = lin_step_scale / (beta1 + beta2 + eps);
    Xnew = X - t_lin * gradX;

    Vnew = (beta2 .* H * Xnew - Lambda2 + V) ./ (alpha1 * (1 - alpha2) + beta2 + 1);

    Y = (beta1 .* H * Xnew - Lambda1 + U) ./ (beta1 + 1);
    Unew = zeros(size(Y));
    for k = 1:length(Y)
        if abs(Y(k)) > gamma * lambda
            Unew(k) = Y(k);
        elseif abs(Y(k)) <= alpha1 * alpha2 * lambda / (beta1 + 1)
            Unew(k) = 0;
        else
            Unew(k) = gamma * (beta1 + 1) * Y(k) - lambda * alpha1 * alpha2 * gamma * sign(Y(k)) / (beta1 * gamma + gamma - alpha1 * alpha2);
        end
    end

    Lambda1 = Lambda1 + mu * beta1 .* (Unew - H * Xnew);
    Lambda2 = Lambda2 + mu * beta2 .* (Vnew - H * Xnew);

    error = norm(Unew - H * Xnew, 'fro') + norm(Vnew - H * Xnew, 'fro');
    iter = iter + 1;

    X = Xnew; U = Unew; V = Vnew;
    e(iter) = error;
end

tEnd = toc(tStart);
disp(['Linearized ADMM Time: ', num2str(tEnd)]);

figure(1);
semilogy(e, 'LineWidth', 1.7, 'Color', 'b', 'Marker', 'd');
xlabel('Iteration', 'FontSize', 16);
ylabel('Residual', 'FontSize', 16);
legend('Linearized ADMM');
title('Linearized ADMM Residual Convergence');

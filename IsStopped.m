function stop = IsStopped(iter, Xs, fvs, ngfs, ngf0, times, fns, params)
% Check stopping criterion
%
% INPUT:
% iter : the current iteration
% Xs   : previous iterates
% fvs  : previous function values, the last one is the value at the current iterate
% ngfs : previous norms of gradients, the last one is the norm at the current iterate
% times : computational times until every iteration
% fns : a struct that contains required function handles
% params: : a struct that contains parameters that are used
%     params.Tolerance          : tolerance of stopping criterion.
%     params.Max_Iteration      : the maximum number of iterations.
%
% OUTPUT:
% stop : stop the algorithm or not
%     0 : not stop
%     1 : stop
% 
% By Wen Huang

    params = SetDefaultParams(params, 'Tolerance', 1e-6, 'float', eps, inf);
    params = SetDefaultParams(params, 'Max_Iteration', 500, 'float', 0, inf);

%     stop = (ngfs(end) / ngf0 < params.Tolerance || iter >= params.Max_Iteration);
    stop = (ngfs(end) < params.Tolerance || iter >= params.Max_Iteration);
end

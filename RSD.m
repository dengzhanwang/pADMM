function [xopt, info] = RSD(fns, params)
% Solver of the steepest descent method
%
% INPUT:
% fns : a struct that contains required function handles
%     fns.f(x) : return objective function value at x.
%     fns.Grad(x) : return the gradient of objection function at x.
%     fns.Metric(x, v1, v2) : return the inner product g_x(v1, v2) of two tangent vectors v1 and v2 on T_x M.
%     fns.ScalarTimesVector(a, v) : return a tangent vector which is a times v.
%
% params : a struct that contains parameters that are used in the solver.
%     params.x0 : initial approximation of minimizer.
%     params.verbose [1]         : '0' means silence, '1' means initial and final outputs. '2' means a lot of outputs, '3' means more than need to know.
%     params.KeepNum [2]         : The number of iterates, function values, gradients, and search directions is "KeepNum"
%     params.OutputGap [1]       : output information every "OutputGap" iterations
%     params.initstepsize        : Function handle, the default method is [(3.60), NW2006]
%     params.linesearch          : Function handle, the default method is the backtracking 
%     params.IsStopped           : Function handle, the default one is |grad f(x_k)| / |grad f(x_0)| < 1e-6 
%
% OUTPUT:
% xopt : the last iterate
% info : informtion generated during the algorithms
%      
%
% By Wen Huang

    fprintf('RSD\n');
    % set default parameters and check the legal range of parameters
    params = SetDefaultParams(params, 'verbose', 1, 'int', 0, 3);
    params = SetDefaultParams(params, 'KeepNum', 2, 'int', 1, inf);
    params = SetDefaultParams(params, 'OutputGap', 1, 'int', 1, inf);
    params = SetDefaultParams(params, 'Accuracy', 0, 'float', 0, 1);
    params = SetDefaultParams(params, 'initstepsize', @InitStepSizeBB, 'handle', [], []);
    params = SetDefaultParams(params, 'linesearch', @LinesearchBacktracking, 'handle', [], []);
    params = SetDefaultParams(params, 'IsStopped', @IsStopped, 'handle', [], []);

    tic;
    x1 = params.x0;% initial iterate
    [f1, x1] = fns.f(x1); % function value
    [gradf1, x1] = fns.Grad(x1); % Riemannian gradient
    ngf1 = sqrt(fns.Metric(x1, gradf1, gradf1)); % initial norm of grad
    ngf0 = ngf1;
    iter = 0;
    if(params.verbose >= 1)
        fprintf('iter:%d,f:%.3e,|gf|:%.3e\n', iter, f1, ngf1);
    end
    % Get search direction
    eta1 = fns.ScalarTimesVector(x1, -1, fns.PreCon(x1, gradf1)); % search direction
    fvs = f1; ngfs = ngf1; times = toc; Xs{1} = x1; GFs{1} = gradf1; Etas{1} = eta1; stepsizes = []; lf = 1; lgf = 1; lhf = 0; lR = 0; lvt = 0;
    stop = 0;
    status = 0;
    while(~stop && (status == 0 || status == 1))
        
        % Find appropriate initial step size
        initslope = fns.Metric(x1, eta1, gradf1);
        [initstepsize, InitInfo] = params.initstepsize(iter, initslope, fvs, Xs, GFs, Etas, stepsizes, fns, params);
        
        % Line search algorithm
        [stepsizeeta, stepsize, x2, f2, gradf2, slopex2, LSinfo, status] = params.linesearch(eta1, x1, fvs, ngfs, gradf1, initslope, initstepsize, iter, fns, params);

        
        ngf2 = sqrt(fns.Metric(x2, gradf2, gradf2)); % norm of grad
        % finish line search
        
        if(length(Xs) >= params.KeepNum)
            Xs(1) = []; GFs(1) = []; Etas(1) = [];
        end
        eta1 = fns.ScalarTimesVector(x2, -1, fns.PreCon(x2, gradf2));
        
        stepsizes(end + 1) = stepsize;
        fvs(end + 1) = f2;
        ngfs(end + 1) = ngf2;
        times(end + 1) = toc;
        Xs{end + 1} = x2;
        GFs{end + 1} = gradf2;
        Etas{end + 1} = eta1;
        iter = iter + 1;
        stop = params.IsStopped(iter, Xs, fvs, ngfs, ngf0, times, fns, params);
        lf(end + 1) = InitInfo.lf + LSinfo.lf; lgf(end + 1) = InitInfo.lgf + LSinfo.lgf; lhf(end + 1) = InitInfo.lhf; lR(end + 1) = InitInfo.lR + LSinfo.lR; lvt(end + 1) = InitInfo.lvt + LSinfo.lvt;
        % Get ready for the next iteration
        x1 = x2; f1 = f2; gradf1 = gradf2; ngf1 = ngf2;
        if(params.verbose >= 2 && mod(iter, params.OutputGap) == 0)
            fprintf('iter:%d,f:%.16e,|gf|:%.3e,s0:%.1e,snew:%.1e,t0:%.1e,tnew:%.1e,status:%d,lf:%d,lgf:%d,lR:%d,lvt:%d\n', iter, f1, ngf1, initslope, slopex2, initstepsize, stepsize, status, sum(lf), sum(lgf), sum(lR), sum(lvt));
        end
    end
    if(params.verbose >= 1)
        fprintf('iter:%d,f:%.16e,|gf|:%.3e,|gf|/|gf0|:%.3e,ComTime:%.2e,status:%d,lf:%d,lgf:%d,lR:%d,lvt:%d\n', iter, f1, ngf1, ngf1 / ngf0, toc, status, sum(lf), sum(lgf), sum(lR), sum(lvt));
    end
    xopt = x1;
    info.ComTime = toc;
    info.iter = iter;
    info.ngfs = ngfs;
    info.times = times;
    info.fvs = fvs;
    info.xs = Xs;
    info.gfs = GFs;
    info.etas = Etas;
    info.lf = lf;
    info.lgf = lgf;
    info.lhf = lhf;
    info.lR = lR;
    info.lvt = lvt;
end

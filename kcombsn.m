function C = kcombsn(N,k,p)
% C = KCOMBSN(N,k,p) returns the k-by-p matrix C consisting of k random 
% combinations of p unique integers between 1 and N. 
% 
% Note that:
% 1.    N, k and p should be positive integers, with p < N.
% 2.    There are at most nchoosek(N,p) combinations of unique integers
%       between 1 and N, therefor k <= nchoosek(N,p).
%
% Example: The following code:
%
%   N = 9;
%   k = 3;
%   p = 4;
%   C = kcombsn(N,k,p);
%
% could return the following matrix C:
%
%   5   3   9   6
%   1   6   5   2
%   5   6   4   2
%
% NB: This code is to prevent taking a subset of all possible combinations,
% as constructing all possible combination, e.g. using nchoosek(1:N,p),
% easily runs into memory issues. 
% 

    % The above mentioned input checks:
    for x = [N,k,p]
        if ~isscalar(x) || rem(x,1) ~= 0 || x < 1
            error('N, k and p should be positive integers')
        end
    end
    
    if p >= N
        error('p should be smaller than N')
    end
    
    msgID = 'MATLAB:nchoosek:LargeCoefficient';
    warning('off',msgID)
    if k > nchoosek(N,p)
            error(['There are only %d combinations of unique integers ' ...
                'between 1 and %d, not %d'],nchoosek(N,p),N,k);
    end
    warning('on',msgID)
    
    % Initiate C, and its sorted copy.    
    C       = randperm(N,p);
    Csort   = sort(C,2);

    while size(C,1) < k
        % Generate a new combination of unique integers between 1 and N
        Row      = randperm(N,p);
        RowSort = sort(Row);

        % If it isn't already present, add it to C.
        if isempty(intersect(RowSort,Csort,'rows'))
            C     = [C; Row];
            Csort = [Csort; RowSort];
        end
    end

end
    

    

    
    
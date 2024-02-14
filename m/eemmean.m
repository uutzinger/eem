function [eem_mean,eem_std]=eemmean(eem1,varargin);
% [eem_mean,eem_std] = eemmean(eem1,eem2,..);
% calucaltes mean and std of all matrices passed as argument 
% UU UT
% Added cell support
% UU, UofA 2003

if ~iscell(eem1)
    qq=length(varargin);
    if qq<1; error('Needs at least 2 eems'); end

    [n,m]=size(eem1);

    em=eem1(2:n,1);
    ex=eem1(1,2:m);

    meem=[];
    seem=[];

    tmp = [eem1(1,1)];
    for k=1:qq,
        tmp2=varargin{k};
        tmp=[tmp;tmp2(1,1)];
    end
    r=mean(tmp);

    for i=2:m, % scan over exciation wavlength
        %put all emission wavelengths together
        tmp = [eem1(2:n,i)];
        for k=1:qq,
            tmp2=varargin{k};
            tmp=[tmp,tmp2(2:n,i)];
        end
        % calcualte mean and std on transposed matrix for all emission wavelengths
        meem=[meem,mean(tmp')'];
        seem=[seem, std(tmp')'];
    end

    eem_mean=[[r,ex];em,meem];
    eem_std =[[r,ex];em,seem];

else
    
    [n,qq]=size(eem1);

    [n,m]=size(eem1{1,1});

    % Calculate mean of (1,1) element
    tmp = [eem1{1,1}(1,1)];
    for k=1:qq,
        tmp=[tmp;eem1{1,k}(1,1)];
    end
    r=mean(tmp);

    meem=[];
    seem=[];
    for i=2:m, % scan over exciation wavlength
        %put all emission wavelengths together
        tmp = [];
        for k=1:qq,
            tmp=[tmp,eem1{1,k}(2:n,i)];
        end
        % calcualte mean and std on transposed matrix for all emission wavelengths
        meem=[meem,mean(tmp')'];
        seem=[seem, std(tmp')'];
    end

    em=eem1{1,1}(2:n,1);
    ex=eem1{1,1}(1,2:m);
    
    eem_mean=[[r,ex];em,meem];
    eem_std =[[r,ex];em,seem];
    
end    

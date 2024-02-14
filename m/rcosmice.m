function x=rcosmice(x)
% function reem=r_cosmice(eem)
% remove cosmic rays from EEM
% uses local linear interpolation to set new values
% edit file to change critical values

% critical values 
c1 = 500; % maximum abs slope to accept
p  = 20; % data window length for mean
q  = 3; % factor times standard deviation to search for
c2 = 5; % distance between slopes
%
[m,n]=size(x);
for ii=2:n
  dx = diff(x(2:m,ii));
  sdx= std(dx);
  i=1;
  index=[]; dindex=[];
  while i<=length(dx)
   ei = i+p;
   if ei > length(dx) ei=length(dx); end
   mdx=mean(dx(i:ei));
   fdx=find(dx(i:ei) > (mdx+q.*sdx) | dx(i:ei) < (mdx-q.*sdx));
   fdx=fdx+i-1;
   dindex=[dindex;fdx];
   index=[index;fdx+2];
   i=ei+1;
  end
%  clf
%  plot(x(2:m,ii),'y')
%  hold on
%  plot(dx,'c')
%  plot(dindex,dx(dindex),'co')
%  plot(index-1,x(index,ii),'yx')

  % index
  % find in a row
  %lindex=zeros(length(index),2);k=1;
  %lindex(1,1)=1;lindex(1,2)=index(1);
  %for i=2:length(index)
  %  if index(i) == index(i-1)+1 % is a candidate
  %   lindex(k,1)=lindex(k,1)+1;
  %  else % was a single number
  %   k=k+1;
  %   lindex(k,1)=1;
  %   lindex(k,2)=index(i);
  %  end  % if
  %end % for
  
  if length(index) > 0 
   lindex=zeros(length(index),2);k=1;i=1;
   while i<length(dindex)-1,
     found=0;
     for j=i+1:length(dindex),
      if dindex(j)-dindex(i)>c2  break; end 
      rmi=min(dx(dindex(j)),dx(dindex(i)));
      rma=max(dx(dindex(j)),dx(dindex(i)));
      if (rmi<0 & rma>0) r=abs(rma/rmi); else r=0; end
%      [r, i, dx(dindex(i)), j, dx(dindex(j))]
      if (r < 2 & r > 0.5)
          lindex(k,[1,2])= [index(i), index(j-1)]; % oposite slope found
          found = 1;
      end
     end
     if found 
       k=k+1; i=j+1; 
     else
       i=i+1;
     end
   end
   lindex=lindex(1:k-1,[1,2]);
  end

  if length(lindex) > 0
   t=size(lindex,1); lt=length(x(:,ii));
   for i=1:t
    if lindex(i,1)-2 > 1 x1=x(lindex(i,1)-2,ii); else x1= x(2,ii); end
    if lindex(i,1)-1 > 1 x2=x(lindex(i,1)-1,ii); else x2= x(2,ii); end
    if lindex(i,1)+1 < lt x3=x(lindex(i,2)+1,ii); else x3= x(lt,ii); end
    if lindex(i,1)+2 < lt x4=x(lindex(i,2)+2,ii); else x4= x(lt,ii); end
    % Method of least squares for linear interpolation 
    % A'Ax=A'y
    k  = [x1;x2;x3;x4];
    A  = [[1;1;1;1], [lindex(i,1)-2;lindex(i,1)-1;lindex(i,2)+1;lindex(i,2)+2]];
    ll = inv(A'*A) * A'*k;
    if abs(ll(2)) < c1
     for k=lindex(i,1):lindex(i,2)
      x(k,ii)=ll(1)+k*ll(2);
%      plot(k-1,x(k,ii),'ro')
     end
    end
   end
   rx=x(2:m,ii);
%   plot(rx,'g');
%   pause;
  end
end


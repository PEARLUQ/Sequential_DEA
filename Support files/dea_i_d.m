function [effk]=dea_i_d(xk,yk,X,Y,rts)

% =======
% dea_i_d
% =======
%
% Computation of effiency for an observation (xk,yk)
% in a DEA dual model for input orientation 
% 
%         Usage
%         [effk]=dea_i_d(xk,yk,X,Y,rts)
%         IN   :
%         ------
%            xk  : Vector of input for observation (xk,yk) (px1)
%            yk  : Vector of input for observation (xk,yk) (qx1)
%            X   : Matrix of input(s)  (n x p)
%            Y   : Matrix of output(s) (n x k)
%            rts : Assumption on returns to scale (text)
%                     'NIRS' = Non increasing rts
%                     'NDRS' = Non decreasing rts
%                     'CRS'  = Constant rts
%                     'VRS'  = Variable rts
%         OUT  :
%         ------
%	effk    : Efficiency scores of observation (xk,yk)
% 
% Use : LP
% Called by : dea
% Proposed by L. Simar
% Adapted by P. Vanden Eeckaut (June 1998), D. Mitrut (October 2001)
% up-dated and checked by L. Simar (december 2002)
%
% INSTITUT DE STATISTIQUE - UNIVERSITE CATHOLIQUE DE LOUVAIN
%
% Input inefficiency measures of a new DMU xk (px1) and yk(qx1)
% with respect to a fixed reference set
% determined by a given X (nxp) and Y (nxq)
% Need to input f,A,b
% for solving in x minf'x s.t. Ax<=b
% ==> call x = LP(f,A,b)
%    -if constraints on x: xLB<= x <= xUB
% ==> call x=LP(f,A,b,xLB,xUB)
%    -if the first N constraints defined by A and b 
%     are equality constraints, must be writen in first N rows
% ==> call x=LP(f,A,b,xLB,xUB,[],N)

% -------------------
% Identify dimensions
% -------------------

[n,p]=size(X);
[n,q]=size(Y);

% -----------------------------
% compute efficiency of new DMU
% -----------------------------

f=[1.00;zeros(n,1)]; % Objective function

if strcmp('NIRS',rts) % NIRS model
   A=[0,ones(1,n);-xk,X';zeros(q,1),-Y'];
   b=[1;zeros(p,1);-yk];
   lbx=zeros(p+q+1,1);
   ubx=ones(p+q+1,1)*inf;
   xeff=lp(b,-A',f,lbx,ubx);
   effk=-b'*xeff;
   return
end

if strcmp('NDRS',rts) % NDRS model
   A=[0,-ones(1,n);-xk,X';zeros(q,1),-Y'];
   b=[-1;zeros(p,1);-yk];
   lbx=zeros(p+q+1,1);
   ubx=ones(p+q+1,1)*inf;
   xeff=lp(b,-A',f,lbx,ubx);
   effk=-b'*xeff;
   return
end

if strcmp('CRS',rts) % CRS model
   A=[-xk,X';zeros(q,1),-Y'];
   b=[zeros(p,1);-yk];
   lbx=zeros(p+q,1);
   ubx=ones(p+q,1)*inf;
   xeff=lp(b,-A',f,lbx,ubx);
   effk=-b'*xeff;
   return
end

if strcmp('VRS',rts) % VRS model
   A=[0,-ones(1,n);-xk,X';zeros(q,1),-Y'];
   b=[-1;zeros(p,1);-yk];
   lbx=[-inf;zeros(p+q,1)];
   ubx=ones(p+q+1,1)*inf;
   xeff=lp(b,-A',f,lbx,ubx);
   %xeff=lp(b,[-A';b'],[f;0],lbx,ubx); % to impose effk>=0
   effk=-b'*xeff;
   return  
end

disp('Incorrect assumption on RTS')
return



%% Best Observer for X,theta2 as output
%% Parameters already given

m1=100;
m2=100;
m=1000;
l1=20;
l2=10;
g=9.8;
%% State Matrices
%%
A=[0 1 0 0 0 0; 
    0 0 -(m1*g)/m 0 -(m2*g)/m 0; 
    0 0 0 1 0 0;
    0 0 (-(m1*g)/(m*l1) -(g/l1)) 0 -(m2*g)/(m*l1) 0;
    0 0 0 0 0 1; 
    0 0 -(m1*g)/(m*l2) 0 (-(m2*g)/(m*l2) -(g/l2)) 0 ];
B=[0; 1/m; 0; 1/(m*l1); 0; 1/(m*l2)];
C=[1 0 0 0 0 0; 0 0 0 0 1 0];
D=0;
states = {'x' 'x_dot' 'p1' 'p1_dot' 'p2' 'p2_dot'}; %states
inputs = {'F'};                                    % intput
outputs = {'x' ;'p2'};                           % output
%% Finding the gain matrix from LQR
%%
Q = [1000 0 0 0 0 0; 
    0 0 0 0 0 0;
    0 0 1000000 0 0 0; 
    0 0 0 0 0 0;
    0 0 0 0 1000000 0; 
    0 0 0 0 0 0]                       %LQR parameters
R = 0.1 ;                              %LQR Input
K = lqr(A,B,Q,R)                       %Gain Calculation from LQR
Ac = [(A-(B*K))];
Bc = [B];
Cc = [C];
Dc = [D];
l=eig(Ac)                                       %eigenvalues of closed loop
states = {'x' 'x_dot' 'p1' 'p1_dot' 'p2' 'p2_dot'};    %states
inputs = {'f'};                                        % intput for lqr
outputs = {'x' ;'p2'};                                 % output after lqr
sys_cl = ss(Ac,Bc,Cc,Dc,'statename',states,'inputname',inputs,'outputname',outputs); %creates statesspace model
t = 0:0.1:200;
f = 50*ones(size(t));
[y,t,x]=lsim(sys_cl,f,t);   %simulates  response 
[AX,H1,H2] = plotyy(t,y(:,1),[t,t],[y(:,2)],'plot');
%% Finding 'best' observer matrix
%%
P = 10*[l.']
L = place(A',C',P)' 
Al = [(A-(L*C))];
Bl = [B];
Cl = [C];
Dl = [D];
states = {'x' 'x_dot' 'p1' 'p1_dot' 'p2' 'p2_dot'};   %states
inputs = {'f'};                                    % intput for observer
outputs = {'x' ;'p2'};                             % output after obserever
sys_c2 = ss(Al,Bl,Cl,Dl,'statename',states,'inputname',inputs,'outputname',outputs); %creates statesspace model
t = 0:0.1:200;
f = 50*ones(size(t));
[y,t,x]=lsim(sys_c2,f,t); %simulates response 
[AX,H1,H2] = plotyy(t,y(:,1),[t,t],[y(:,2)],'plot');%plotting the response
title('Best Observer');
qb = [1 -2 3 -4 5 pi/2]'*-0.1;
escala = 10;
d_1 = 0.1625*escala;
d_4 = 0.1333*escala;
d_5 = 0.0997*escala;
d_6 = 0.0996*escala;

a_2 = -0.425*escala;
a_3 = -0.3922*escala;

k = [0 -pi/2 0 pi/2 -pi/2 0]';
q = qb + k;

% T00 = mi_HT(0,0,0,0);
% T01 = T00*mi_HT(q(1),d_1,0,pi/2);
% T02 = T01*mi_HT(q(2)-pi/2,0,a_2,0);
% T03 = T02*mi_HT(q(3),0,a_3,0);
% T04 = T03*mi_HT(q(4)+pi/2,d_4,0,pi/2);
% T05 = T04*mi_HT(q(5)-pi/2,d_5,0,-pi/2);
% T06 = T05*mi_HT(q(6),d_6,0,0)
% %
T00 = mi_HT(0,0,0,0);
T01 = T00*mi_HT(q(1),d_1,0,pi/2);
T02 = T01*mi_HT(q(2),0,a_2,0);
T03 = T02*mi_HT(q(3),0,a_3,0);
T04 = T03*mi_HT(q(4),d_4,0,pi/2);
T05 = T04*mi_HT(q(5),d_5,0,-pi/2);
T06 = T05*mi_HT(q(6),d_6,0,0)

MarcoRef(T00,0)
MarcoRef(T01,1)
MarcoRef(T02,2)
MarcoRef(T03,3)
MarcoRef(T04,4)
MarcoRef(T05,5)
MarcoRef(T06,6)

hold off

%%
q = InverseKinematicUR5eITESMTampico(T06,q+0.1);
if isempty(q)
    q=zeros(6,1);
end
qb = q - k


function output = mi_HT(theta,d,a,alpha)
    output = [mi_Rotz(theta),[0 0 0]';[0 0 0],1]*...
        [eye(3),[a 0 d]';[0 0 0],1]*...
        [mi_Rotx(alpha),[0 0 0]';[0 0 0],1];
end

function output = mi_Rotz(theta)
%Ingreso un ángulo en RADIANES y devuelve la respectiva matriz de rotación en z.
    output = [cos(theta) -sin(theta) 0;
              sin(theta) cos(theta) 0;
              0 0 1];
end

function output = mi_Rotx(theta)
%Ingreso un ángulo en RADIANES y devuelve la respectiva matriz de rotación en x.
    output = [1 0 0;
              0 cos(theta) -sin(theta);
              0 sin(theta) cos(theta)];
end

function MarcoRef(T,num)
    R = T(1:3,1:3);
    p = T(1:3,4);
    x0 = [1 0 0]';
    y0 = [0 1 0]';
    z0 = [0 0 1]';
    
    x1 = R*x0;
    y1 = R*y0;
    z1 = R*z0;
    hold all
    quiver3(p(1),p(2),p(3),x1(1),x1(2),x1(3),'r','LineWidth',1)
    quiver3(p(1),p(2),p(3),y1(1),y1(2),y1(3),'g','LineWidth',1)
    quiver3(p(1),p(2),p(3),z1(1),z1(2),z1(3),'b','LineWidth',1)
    text(p(1)+x1(1),p(2)+x1(2),p(3)+x1(3),strcat('$X_',num2str(num),'$'),'Color','k',Interpreter='latex')
    text(p(1)+y1(1),p(2)+y1(2),p(3)+y1(3),strcat('$Y_',num2str(num),'$'),'Color','k',Interpreter='latex')
    text(p(1)+z1(1),p(2)+z1(2),p(3)+z1(3),strcat('$Z_',num2str(num),'$'),'Color','k',Interpreter='latex')
    grid on
    hold off
end
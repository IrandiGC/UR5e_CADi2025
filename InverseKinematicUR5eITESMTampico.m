function output = InverseKinematicUR5eITESMTampico(H_Actual,q_Anterior)
    %Unidades en cm    
    escala = 10;
    d_1 = 0.1625*escala;
    d_4 = 0.1333*escala;
    d_5 = 0.0997*escala;
    d_6 = 0.0996*escala;

    a_2 = -0.425*escala;
    a_3 = -0.3922*escala;

    numSol = 16;
    theta = zeros(6,numSol);
    p05x= H_Actual(1,4)-d_6*H_Actual(1,3);
    p05y= H_Actual(2,4)-d_6*H_Actual(2,3);
    theta(1,1:numSol/2)= atan2(p05y,p05x)+acos(d_4/(sqrt(p05x^2+p05y^2)))+pi/2;
    theta(1,numSol/2+1:end)= atan2(p05y,p05x)-acos(d_4/(sqrt(p05x^2+p05y^2)))+pi/2;

    for i = 1:16
        try
            if mod(i,8)==1
                p16z= H_Actual(1,4)*sin(theta(1,i))-H_Actual(2,4)*cos(theta(1,i));
                theta(5,i:i+3) = acos((p16z-d_4)/d_6);
                theta(5,i+4:i+7) = -theta(5,i);
            end
            if mod(i,4)==1
                T01 = mi_HT(theta(1,i),d_1,0,pi/2);
                T45 = mi_HT(theta(5,i),d_5,0,-pi/2);
                zy=H_Actual(1,2)*sin(theta(1,i))-H_Actual(2,2)*cos(theta(1,i));
                zx=H_Actual(1,1)*sin(theta(1,i))-H_Actual(2,1)*cos(theta(1,i));
                theta(6,i:i+3)= atan2(-zy/sin(theta(5,i)),zx/sin(theta(5,i)));
                T56 = mi_HT(theta(6,i),d_6,0,0);
                T14 = (T01\H_Actual)/(T45*T56);
                p13 =T14*[0; -d_4; 0; 1] - [0; 0; 0; 1];
                p13m=norm(p13);
                theta(3,[i i+1])=-acos((p13m^2-a_2^2-a_3^2)/(2*a_2*a_3));
                theta(3,[i+2 i+3])=acos((p13m^2-a_2^2-a_3^2)/(2*a_2*a_3));
            end
            if mod(i,2)==1
                T23 = mi_HT(theta(3,i),0,a_3,0);
                theta(2,i) = -atan2(p13(2),-p13(1))+asin(a_3*sin(theta(3,i))/p13m);
                theta(2,i+1) = -atan2(p13(2),-p13(1))-asin(a_3*sin(theta(3,i))/p13m);
            end
            T12 = mi_HT(theta(2,i),0,a_2,0);
            T34=(T12*T23)\T14;
            theta(4,i) = atan2(T34(2,1),T34(1,1));
        catch
            theta(:,i)=NaN;
        end
    end
    temp0 = sum((theta-q_Anterior).^2,1);
    output = theta(:,temp0 == min(temp0));
% T01 = mi_HT(q(1),d_1,0,pi/2);
% T12 = mi_HT(q(2)-pi/2,0,a_2,0);
% T23 = mi_HT(q(3),0,a_3,0);
% T34 = mi_HT(q(4)+pi/2,d_4,0,pi/2);
% T45 = mi_HT(q(5)-pi/2,d_5,0,-pi/2);
% T56 = mi_HT(q(6),d_6,0,0);

end

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
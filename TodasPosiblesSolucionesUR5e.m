function Salida = TodasPosiblesSolucionesUR5e(H_Actual)

    % H_Actual              --->    Es la transformación homogenea requerida,
    % q                     --->    Es el vector de coordenadas articulares anterior.
    % Configuracion_Entrada --->    Es el booleano que define mano hacia
    %                               adentro o hacia afuera.
    % R_int                 --->    Define el círculo interior de histéresis.
    % R_ext                 --->    Define el círculo exterior de histéresis.


    % Este código se probo dentro de un espacio de trabajo definido por un
    % cilindro de
    % radio en intervalo [0.25,0.91] m
    % angulo en intervalo [-pi,pi] rad
    % altura en intervalo [0,0.4] m 


    %Unidades en m    
    
    d_1 = 0.1625;
    d_4 = 0.1333;
    d_5 = 0.0997;
    d_6 = 0.0996 + 0.1628;

    a_2 = -0.425;
    a_3 = -0.3922;

    %Se prepara una matriz para almacenar las posibles 16 soluciones.
    numSol = 16;
    theta = zeros(6,numSol);
    P = zeros(3,numSol);
    altura_codo = zeros(numSol,1);
    punto_muneca = zeros(3,numSol);

    %Aquí se coloca el algoritmo para generar las 16 soluciones, revisar
    %artículo Analytic Inverse Kinematics for the Universal Robots UR-5/UR-10 Arms Kelsey P. Hawkins

    p05x= H_Actual(1,4)-d_6*H_Actual(1,3);
    p05y= H_Actual(2,4)-d_6*H_Actual(2,3);

    temp = atan2(p05y,p05x)+acos(d_4/(sqrt(p05x^2+p05y^2)))+pi/2;
    theta(1,1:numSol/2)= mod(temp + pi, 2*pi) - pi; %Valores de theta_1 entre (-pi,pi]

    temp = atan2(p05y,p05x)-acos(d_4/(sqrt(p05x^2+p05y^2)))+pi/2;

    theta(1,numSol/2+1:end)= mod(temp + pi, 2*pi) - pi; %Valores de theta_1 entre (-pi,pi]

    for i = 1:16
        %Si alguna solución númerica no se puede calcular, se descarta y se coloca NAN 
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
                
                temp = -atan2(p13(2),-p13(1))+asin(a_3*sin(theta(3,i))/p13m);                
                theta(2,i) = mod(temp + pi, 2*pi) - pi;
                
                temp = -atan2(p13(2),-p13(1))-asin(a_3*sin(theta(3,i))/p13m);
                theta(2,i+1) = mod(temp + pi, 2*pi) - pi;
            end
            T12 = mi_HT(theta(2,i),0,a_2,0);
            T34=(T12*T23)\T14;
            theta(4,i) = atan2(T34(2,1),T34(1,1));
        catch
            theta(:,i)=NaN;
        end
    end
    %De todas soluciones, se determina su ubicación final.
    % display(theta)
    for i=1:numSol
        temp = mi_HT(theta(1,i),d_1,0,pi/2)*mi_HT(theta(2,i),0,a_2,0);
        altura_codo(i) = temp(3,4);
        temp = temp*mi_HT(theta(3,i),0,a_3,0)*mi_HT(theta(4,i),d_4,0,pi/2);
        punto_muneca(:,i) = temp(1:3,4);
        temp = temp*mi_HT(theta(5,i),d_5,0,-pi/2)*mi_HT(theta(6,i),d_6,0,0);

        P(:,i) = temp(1:3,4);
    end

    %Se descartan todas las "soluciones" que no son soluciones.
    condicion = sum((P-H_Actual(1:3,4)).^2,1)< 0.001;
    Salida.Angulos = theta(:,condicion);
    Salida.Codo = altura_codo(condicion);
    Salida.Muneca = punto_muneca(:,condicion);
end

% Funciones usadas en este algoritmo.
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
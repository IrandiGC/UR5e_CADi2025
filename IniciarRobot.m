function [jointSub,trajGoal,trajAct,gripGoal,gripAct,rgbImgSub,rgbDptSub] = IniciarRobot(rosIP)
%%%Inicia la configuración de todo
    % Apaga cualquier otra conexion con ROS
    rosshutdown; 
    % Inicia ROS asignando la dirección IP
    rosinit(rosIP,11311);
    %Muestra la lista de las cosas que hay
    rostopic list;

    %Declaracion del griper para la red ROS
    [gripAct,gripGoal] = rosactionclient('/gripper_controller/follow_joint_trajectory','control_msgs/FollowJointTrajectory','DataFormat','struct');
    gripAct.FeedbackFcn = [];
    gripAct.ResultFcn = [];

    %Declaración de las articulaciones para la red ROS
    [trajAct,trajGoal] = rosactionclient('/pos_joint_traj_controller/follow_joint_trajectory','control_msgs/FollowJointTrajectory','DataFormat','struct');
    trajAct.FeedbackFcn = []; 
    trajAct.ResultFcn = []; 
    jointSub = rossubscriber("/joint_states",'DataFormat','struct');


    %Declaraciòn de la cámara RGB
    rgbImgSub = rossubscriber("/camera/rgb/image_raw","sensor_msgs/Image","DataFormat","struct");
    pause(1)

    %Declaración de la cámara de profundidad
    rgbDptSub = rossubscriber('/camera/depth/image_raw',"sensor_msgs/Image","DataFormat","struct");
    pause(1)
end

%-----Funcionamiento-----
%Manda a iniciar todo lo necesario para el funcionamiento del cobot, nos devuelve ciertos valores para poder usarlos en los siguientes codigos y funciones
%Dentro de este codigo, debemos de verificar la direccion ip del cobot en linux
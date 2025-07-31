function MoverRobot(q,trajAct,trajGoal,jointSub)

    %Acomodamos la información como es requerida por el paquete
    UR5eConfig = [q(3) q(2) q(1) q(4) q(5) q(6)];
    trajGoal = packTrajGoal(UR5eConfig,trajGoal);
    %Enviamos paquete
    sendGoal(trajAct,trajGoal);
    
    %% Esta parte del código espera hasta que la norma del error articular sea 0.1
    desviacionArticular = zeros(6,1);
    
    while true
        ValoresArticulares = LeerValoresArticulares(jointSub);
        desviacionArticular(1) = mod(q(1) - ValoresArticulares.q1-pi,2*pi)-pi;
        desviacionArticular(2) = mod(q(2) - ValoresArticulares.q2-pi,2*pi)-pi;
        desviacionArticular(3) = mod(q(3) - ValoresArticulares.q3-pi,2*pi)-pi;
        desviacionArticular(4) = mod(q(4) - ValoresArticulares.q4-pi,2*pi)-pi;
        desviacionArticular(5) = mod(q(5) - ValoresArticulares.q5-pi,2*pi)-pi;
        desviacionArticular(6) = mod(q(6) - ValoresArticulares.q6-pi,2*pi)-pi;
        if norm(desviacionArticular) < 0.001
            break
        end
    end

end

function trajGoal = packTrajGoal(config,trajGoal)
    jointWaypointTimes = 3;
    jointWaypoints = config';
    numJoints = size(jointWaypoints,1);
    
    trajGoal.Trajectory.JointNames = {'elbow_joint','shoulder_lift_joint','shoulder_pan_joint','wrist_1_joint','wrist_2_joint','wrist_3_joint'};
    
    for idx = 1:numJoints
    
        trajGoal.GoalTolerance(idx) = rosmessage('control_msgs/JointTolerance','DataFormat','struct');
        trajGoal.GoalTolerance(idx).Name = trajGoal.Trajectory.JointNames{idx};
        trajGoal.GoalTolerance(idx).Position = 0;
        trajGoal.GoalTolerance(idx).Velocity = 0;
        trajGoal.GoalTolerance(idx).Acceleration = 0;
    
    end
    
    trajPts = rosmessage('trajectory_msgs/JointTrajectoryPoint','DataFormat','struct');
    trajPts.TimeFromStart = rosduration(jointWaypointTimes,'DataFormat','struct');
    trajPts.Positions = jointWaypoints;
    trajPts.Velocities = zeros(size(jointWaypoints));
    trajPts.Accelerations = zeros(size(jointWaypoints));
    trajPts.Effort = zeros(size(jointWaypoints));
    
    trajGoal.Trajectory.Points = trajPts;
end
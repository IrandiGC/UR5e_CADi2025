function MoverRobot(q,trajAct,trajGoal,jointSub)

    %Acomodamos la información como es requerida por el paquete
    UR5eConfig = [q(3) q(2) q(1) q(4) q(5) q(6)];
    trajGoal = packTrajGoal(UR5eConfig,trajGoal);
    %Enviamos paquete
    sendGoal(trajAct,trajGoal);
    
    %% Esta parte del código espera hasta que la norma del error articular sea 0.1
    desviacionArticular = zeros(6,1);
    while true
        jointStateMsg = receive(jointSub,3);
        desviacionArticular(1) = q(1) - jointStateMsg.Position(4);
        desviacionArticular(2) = q(2) - jointStateMsg.Position(3);
        desviacionArticular(3) = q(3) - jointStateMsg.Position(1);
        desviacionArticular(4) = q(4) - jointStateMsg.Position(5);
        desviacionArticular(5) = q(5) - jointStateMsg.Position(6);
        desviacionArticular(6) = q(6) - jointStateMsg.Position(7);
        if norm(desviacionArticular) < 0.01
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
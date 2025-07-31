function ActivacionGripper(ValorGripper,gripAct,gripGoal,jointSub)
    ValorGripper = min(max(ValorGripper,0),0.8);
    gripGoal=packGripGoal(ValorGripper,gripGoal);
    sendGoal(gripAct,gripGoal);    
    
    %% Esta parte del código espera hasta que el gripper cubra el 99% de su recorrido.
    while true
        ValoresArticulares = LeerValoresArticulares(jointSub);
        if abs(ValoresArticulares.Gripper - ValorGripper) < 0.008
            break
        end
    end

end

function gripGoal=packGripGoal(position,gripGoal)
    jointWaypointTimes = 3;
    gripGoal.Trajectory.JointNames = {'robotiq_85_left_knuckle_joint'};
    gripGoal.GoalTolerance = rosmessage('control_msgs/JointTolerance','DataFormat','struct');
    gripGoal.GoalTolerance.Name = gripGoal.Trajectory.JointNames{1};
    gripGoal.GoalTolerance.Position = 0;
    gripGoal.GoalTolerance.Velocity = 0.1;
    gripGoal.GoalTolerance.Acceleration = 0.1;
    
    trajPts = rosmessage('trajectory_msgs/JointTrajectoryPoint','DataFormat','struct');
    trajPts.TimeFromStart = rosduration(jointWaypointTimes,'DataFormat','struct');
    trajPts.Positions = position;
    trajPts.Velocities = 0;
    trajPts.Accelerations = 0;
    trajPts.Effort = 0.1;
    
    gripGoal.Trajectory.Points = trajPts;
end
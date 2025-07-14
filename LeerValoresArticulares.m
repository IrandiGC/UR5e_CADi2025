function ValoresArticulares = LeerValoresArticulares(jointSub)
    jointStateMsg = receive(jointSub,3);
    ValoresArticulares.q1 = jointStateMsg.Position(4); % update configuration in initial guess
    ValoresArticulares.q2 = jointStateMsg.Position(3);
    ValoresArticulares.q3 = jointStateMsg.Position(1);
    ValoresArticulares.q4 = jointStateMsg.Position(5);
    ValoresArticulares.q5 = jointStateMsg.Position(6);
    ValoresArticulares.q6 = jointStateMsg.Position(7);
    ValoresArticulares.Gripper = jointStateMsg.Position(2);
end
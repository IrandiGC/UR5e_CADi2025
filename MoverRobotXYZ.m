function q = MoverRobotXYZ(gripperX,gripperY,gripperZ,gripperTheta,q,trajAct,trajGoal,jointSub)
    gripperTranslation = [gripperX;gripperY;gripperZ];

    gripperRotation = [cos(gripperTheta),sin(gripperTheta),0;
                       sin(gripperTheta),-cos(gripperTheta),0;
                       0,0,-1];

    tform = [gripperRotation,gripperTranslation;
            0,0,0,1];

    q = UnaSolucionesUR5e(tform,q);

    MoverRobot(q+ [pi pi/2 0 0 pi/2 0]',trajAct,trajGoal,jointSub);
end
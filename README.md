# UR5e

En el archivo **InverseKinemticUR5eITESMTampico.m** se encuentra el archivo que resuelve la cinemática inversa basada en la tabla de DH del fabricante, debe observar que los valores de los ángulos no corresponden con la implementación que se tiene en la competencia **Robocup Arm Challenge** siendo necesario un cambio de coordenadas:

$$ \begin{bmatrix} \bar{q}_1 \\\ \bar{q}_2 \\\ \bar{q}_3 \\\ \bar{q}_4 \\\ \bar{q}_5 \\\ \bar{q}_6 \end{bmatrix}  = \begin{bmatrix} q_1 \\\ q_2 \\\ q_3 \\\ q_4 \\\ q_5 \\\ q_6 \end{bmatrix} + \begin{bmatrix} 0 \\\ \frac{-\pi}{2} \\\ 0 \\\ \frac{\pi}{2} \\\ \frac{-\pi}{2} \\\ 0 \end{bmatrix} $$

Revise el archivo **Prueba_Algortimo.m** para ver un ejemplo de la implementación de este cambio de coordenadas.

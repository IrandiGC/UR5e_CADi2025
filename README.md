# UR5e

## Archivo InverseKinematicUR5eITESMTampico.m
En el archivo  **InverseKinemticUR5eITESMTampico.m** se encuentra el archivo que resuelve la cinemática inversa basada en la tabla de DH del fabricante, debe observar que los valores de los ángulos no corresponden con la implementación que se tiene en la competencia **Robocup Arm Challenge** siendo necesario un cambio de coordenadas:

$$ \begin{bmatrix} \bar{q}_1 \\\ \bar{q}_2 \\\ \bar{q}_3 \\\ \bar{q}_4 \\\ \bar{q}_5 \\\ \bar{q}_6 \end{bmatrix}  = \begin{bmatrix} q_1 \\\ q_2 \\\ q_3 \\\ q_4 \\\ q_5 \\\ q_6 \end{bmatrix} + \begin{bmatrix} 0 \\\ \frac{-\pi}{2} \\\ 0 \\\ 0 \\\ \frac{-\pi}{2} \\\ 0 \end{bmatrix} $$
![image](https://github.com/user-attachments/assets/5e4b4e82-6d76-443c-9103-d8a0a6516569)

## Archivo Prueba_Algoritmo.m
Revise el archivo **Prueba_Algortimo.m** para ver un ejemplo de la implementación de este cambio de coordenadas.

## Archivo UR_template_cartesian_modificado.mlx
La simulación de una trayectoria se encuentra en el archivo **R_template_cartesian_modificado.mlx**, revisarlo e intentar programar diferentes trayectorias. !Reportar detalles en las trayectorias para su discusión!

## Revisión de detalles de convocatoria
Revise https://drive.google.com/file/d/1w9tBy3DKmZBKEfOqOFUXcT8hcQig6sNS/view 
![image](https://github.com/IrandiGC/UR5e/assets/149118292/1dc46e4f-faaf-4a7c-88ed-36a9610a8f1d)

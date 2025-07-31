function Salida = UnaSolucionesUR5e(H_Actual,PosicionArticularAnterior)
    CinematicaInversa = TodasPosiblesSolucionesUR5e(H_Actual);

    %Condición de muñeca apuntando hacia adelante
    condicion = min(sum(CinematicaInversa.Muneca.^2,1)) - sum(CinematicaInversa.Muneca.^2,1) >= -0.0001;
    CinematicaInversa.Angulos = CinematicaInversa.Angulos(:,condicion);
    CinematicaInversa.Codo = CinematicaInversa.Codo(condicion);

    %Condición de codo hacia arriba
    condicion = max(CinematicaInversa.Codo) - CinematicaInversa.Codo <= 0.0001;
    CinematicaInversa.Angulos = CinematicaInversa.Angulos(:,condicion);

    %Condición de proximidad
    w =[1 1 1 1 1 1];
    [~,condicion] = min((w*(CinematicaInversa.Angulos-PosicionArticularAnterior).^2));
    CinematicaInversa.Angulos = CinematicaInversa.Angulos(:,condicion);
    
    %Salida
    Salida = CinematicaInversa.Angulos;
end
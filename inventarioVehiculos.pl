vehiculo(toyota, corolla, sedan, 25000, 2023).
vehiculo(nissan, versa, sedan, 18000, 2024).
vehiculo(toyota, rav4, suv, 28000, 2024).
vehiculo(bmw, x5, suv, 60000, 2024).
vehiculo(honda, crv, suv, 30000, 2023).
vehiculo(honda, pilot, suv, 45000, 2023).
vehiculo(ford, f150, pickup, 45000, 2022).
vehiculo(ford, ranger, pickup, 35000, 2022).
vehiculo(bmw, m4, sport, 75000, 2024).
vehiculo(nissan, z, sport, 40000, 2023).

presupuesto_vehiculo(Referencia, PresupuestoMaximo) :-
        vehiculo(_, Referencia, _, Precio, _),
        Precio =< PresupuestoMaximo.

referencias_por_marca(Marca, ListaReferencias) :-
        findall(Referencia, vehiculo(Marca, Referencia, _, _, _),ListaReferencias).

calcular_valor([], 0).
calcular_valor([vehiculo(_, _, _, Precio, _) | Resto], Valor) :-
    calcular_valor(Resto, ValorResto),
    Valor is Precio + ValorResto.

manejo_presupuesto(ListaInicial, Presupuesto, ListaInicial, ValorTotal) :-
        calcular_valor(ListaInicial, ValorTotal),
        ValorTotal =< Presupuesto.

manejo_presupuesto(ListaInicial, Presupuesto, ListaAjustada, ValorTotal) :-
        calcular_valor(ListaInicial, ValorInicial),
        ValorInicial > Presupuesto,
        ordenar_y_ajustar(ListaInicial, Presupuesto, ListaAjustada),
        calcular_valor(ListaAjustada, ValorTotal).

por_precio(Relacion, vehiculo(_,_,_,Precio1,_), vehiculo(_,_,_,Precio2,_)) :-
    (Precio1 < Precio2 -> Relacion = < ; Relacion = >).

ajustar_presupuesto([], _, _, ListaFinal, ListaFinal).
ajustar_presupuesto([Vehiculo | Resto], Limite, ValorActual, ListaActual, SeleccionFinal) :-
    Vehiculo = vehiculo(_, _, _, Precio, _),
    NuevoValor is ValorActual + Precio,
    (   NuevoValor =< Limite
    ->  ajustar_presupuesto(Resto, Limite, NuevoValor, [Vehiculo | ListaActual], SeleccionFinal)
    ;   SeleccionFinal = ListaActual).

ordenar_y_ajustar(Seleccion, Limite, SeleccionFinal) :-
    predsort(por_precio, Seleccion, SeleccionOrdenada),
    ajustar_presupuesto(SeleccionOrdenada, Limite, 0, [], SeleccionFinal).

calcular_valor_sedanes(ValorTotal, ListaFinal) :-
    findall(vehiculo(Marca, Ref, sedan, Precio, Anio),
            vehiculo(Marca, Ref, sedan, Precio, Anio),
            ListaSedanes),
    manejo_presupuesto(ListaSedanes, 500000, ListaFinal, ValorTotal).    

generar_reporte(Marca, Tipo, Presupuesto, [ListaFinal, ValorTotal]) :-
    filtrar_vehiculos_por_criterio(Marca, Tipo, ListaFiltrada),
    manejo_presupuesto(ListaFiltrada, Presupuesto, ListaFinal, ValorTotal).

filtrar_vehiculos_por_criterio(Marca, Tipo, ListaVehiculos) :-
    findall(vehiculo(Marca, Ref, Tipo, Precio, Anio),
            vehiculo(Marca, Ref, Tipo, Precio, Anio),
            ListaVehiculos).
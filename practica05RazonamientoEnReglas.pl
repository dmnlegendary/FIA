% Practica 5.- Fundamentos de Inteligencia Artificial
% @Author: Chen Yangfeng & Diaz Jimenez Jorge Arif
% @Version: 5.34
% Grupo: 4BM1
% Oct 2023
% Prof. Hernadez Cruz Macario

:- dynamic conocido/1.

main :-
    bienvenida,
    nl, write('Menu'), nl,
    nl, write('1 Diagnosticar falla de computadora'),
    nl, write('2 Salir'),
    nl, nl, write('Indica tu opcion:'),
    read(Opcion),
    nl,
    Opcion = 1, diagnosticar_falla,
    nl, writeln('Gracias por utilizar este programa\n').

bienvenida :-
    writeln('\nBienvenido al diagnostico de fallas en computadoras'),
    writeln('=============================================================='),
    writeln('\nPuedo ayudarte a identificar problemas en tu computadora.'),
    writeln('Por favor, responde a mis preguntas con "si" o "no".').

diagnosticar_falla :-
    limpia_memoria_de_trabajo,
    writeln("\nVoy a hacerte algunas preguntas para diagnosticar la falla de tu computadora.\n"),
    haz_diagnostico(Falla),
    escribe_diagnostico(Falla),
    ofrece_explicacion_diagnostico(Falla).

diagnosticar_falla :-
    write('No se pudo determinar la falla con la informacion proporcionada.').

haz_diagnostico(Falla) :-
    obten_hipotesis_y_sintomas(Falla, ListaDeSintomas),
    prueba_presencia_de(Falla, ListaDeSintomas).

obten_hipotesis_y_sintomas(Falla, ListaDeSintomas) :-
    rules(falla_computadora(Falla), sintomas(ListaDeSintomas)).

prueba_presencia_de(_, []).
prueba_presencia_de(Falla, [Sintoma | RestoSintomas]) :-
    prueba_verdad_de(Falla, Sintoma),
    prueba_presencia_de(Falla, RestoSintomas).

prueba_verdad_de(_, Sintoma) :-
    conocido(Sintoma).

prueba_verdad_de(Falla, Sintoma) :-
    not(conocido(is_false(Sintoma))),
    pregunta_sobre(Falla, Sintoma, Respuesta),
    Respuesta = si.

pregunta_sobre(Falla, Sintoma, Respuesta) :-
    write('¿Tu computadora '), write(Sintoma), write('? '),
    read(Respuesta),
    process(Falla, Sintoma, Respuesta, Respuesta).

process(_, Sintoma, si, si) :-
    asserta(conocido(Sintoma)).
process(_, Sintoma, no, no) :-
    asserta(conocido(is_false(Sintoma))).
process(Falla, Sintoma, porque, Respuesta) :-
    nl,
    write('Estoy investigando la falla siguiente: '),
    write(Falla), write('.'), nl, write('Para esto necesito saber si '),
    write(Sintoma), write('.'), nl, pregunta_sobre(Falla, Sintoma, Respuesta).
process(Falla, Sintoma, Respuesta, Respuesta) :-
    Respuesta \== no,
    Respuesta \== si,
    Respuesta \== porque,
    nl,
    write('Debes contestar "si", "no" o "porque".'), nl,
    pregunta_sobre(Falla, Sintoma, Respuesta).

escribe_diagnostico(Falla) :-
    write('\nEl diagnostico es: '),
    write(Falla), write('.'), nl.

ofrece_explicacion_diagnostico(Falla) :-
    pregunta_si_necesita_explicacion(Respuesta),
    actua_consecuentemente(Falla, Respuesta).

pregunta_si_necesita_explicacion(Respuesta) :-
    write('\n¿Quieres que justifique este diagnostico? '),
    read(RespuestaUsuario),
    asegura_respuesta_si_o_no(RespuestaUsuario, Respuesta).

asegura_respuesta_si_o_no(si, si).
asegura_respuesta_si_o_no(no, no).
asegura_respuesta_si_o_no(_, Respuesta) :-
    write('Debes contestar "si" o "no".'),
    pregunta_si_necesita_explicacion(Respuesta).

actua_consecuentemente(_, no).
actua_consecuentemente(Falla, si) :-
    rules(falla_computadora(Falla), sintomas(ListaDeSintomas)),
    write('\nEste diagnostico se basa en la presencia de los siguientes sintomas:\n '), nl,
    escribe_lista_de_sintomas(ListaDeSintomas).

escribe_lista_de_sintomas([]).
escribe_lista_de_sintomas([Sintoma | RestoSintomas]) :-
    write(Sintoma), nl,
    escribe_lista_de_sintomas(RestoSintomas).

limpia_memoria_de_trabajo :-
    retractall(conocido(_)).

rules(falla_computadora('Pantalla negra'),
    sintomas(['la pantalla esta completamente en negro',
            'la computadora no muestra ninguna imagen',
            'no se escucha ningun sonido de arranque'])).

rules(falla_computadora('Computadora no enciende'),
    sintomas(['la computadora no responde al presionar el boton de encendido',
            'no hay luces ni sonidos de arranque',
            'no se enciende ninguna luz LED'])).

rules(falla_computadora('Perdida de datos'),
    sintomas(['se han perdido archivos o datos importantes',
            'experimentaste errores al acceder a tus archivos',
            'algunos archivos o carpetas han desaparecido'])).

rules(falla_computadora('Sobrecalentamiento'),
    sintomas(['la computadora se calienta en exceso',
            'se apaga de forma repentina debido al calor',
            'escuchas el ventilador funcionando constantemente'])).

rules(falla_computadora('Problemas de conexion a Internet'),
    sintomas(['experimentas desconexiones frecuentes a la red',
            'la velocidad de internet es lenta o intermitente',
            'otros dispositivos en la red funcionan correctamente'])).

rules(falla_computadora('Problemas de sonido'),
    sintomas(['no hay audio o sonido en la computadora',
            'escuchas ruidos extraños o distorsiones en el sonido',
            'los altavoces no funcionan correctamente'])).

rules(falla_computadora('Problemas de software'),
    sintomas(['experimentas bloqueos o congelamientos de aplicaciones',
            'los programas no se inician o se cierran inesperadamente',
            'observas mensajes de error frecuentes'])).

rules(falla_computadora('Problemas de hardware'),
    sintomas(['la computadora emite pitidos o codigos de error al arrancar',
            'hay problemas con el teclado, el mouse o los dispositivos externos',
            'la pantalla muestra pixeles muertos o problemas visuales'])).

rules(falla_computadora('Problemas de arranque lento'),
    sintomas(['la computadora tarda mucho tiempo en arrancar',
            'el proceso de inicio es lento y tedioso',
            'experimentas retrasos significativos al encender la computadora'])).

rules(falla_computadora('Problemas de impresion'),
    sintomas(['las impresiones salen con errores o de mala calidad',
            'la impresora no responde a las solicitudes de impresion',
            'experimentas problemas al instalar o configurar una impresora'])).

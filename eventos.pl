:- discontiguous executar_opcao/1.
:- discontiguous exec_op_4/1.
:- discontiguous exec_op_4/1.


%conexao com banco
abrir_conexao :-
    odbc_connect('bdprolog',_,
                             [user(root),
                              password(''),
                              alias(teste1),
                              open(once)
                             ]).
fechar_conexao :-
    odbc_disconnect('teste1').

%cria evento
cria_evento(Nome, Data, Local):-
    odbc_prepare('teste1',
                 'insert into eventos(NOME_EVENT, DATA_EVENT, LOCAL_EVENT)
                 VALUES (?, ?, ?)',[varchar, varchar, varchar], Statement),
    odbc_execute(Statement,[Nome, Data, Local]),
    writeln('evento cadastrado').

%cria palestrante
cria_palestra(Titulo, Palestrante, Horario, Idevento):-
    odbc_prepare('teste1',
                 'insert into palestras(titulo_pale, palestrante_pale, horario_pale, evento_id)
                 VALUES (?, ?, ?, ?)',[varchar, varchar, varchar, integer], Statement),
    odbc_execute(Statement,[Titulo, Palestrante, Horario, Idevento]),
    writeln('palestrante cadastrado').

%cria participante
cria_participante(Nome, Email, Empresa):-
    odbc_prepare('teste1',
                 'insert into participantes(nome_part, email_part, empresa_part)
                 VALUES (?, ?, ?)',[varchar, varchar, varchar], Statement),
    odbc_execute(Statement,[Nome, Email, Empresa]),
    writeln('participante cadastrado').

%cria sala
cria_sala(Nome,Capacidade):-
    odbc_prepare('teste1',
                 'insert into salas(nome_sala, capacidade_sala)
                 VALUES (?, ?)',[varchar, integer], Statement),
    odbc_execute(Statement,[Nome, Capacidade]),
    writeln('sala cadastrada').

%mostar eventos
apres_evento:-
    odbc_query('teste1',
               'select id, NOME_EVENT from eventos',row(ID,NOME)),
    writeln(ID - NOME),
    fail.
apres_evento.

%mostar participante
apres_part:-
    odbc_query('teste1',
               'select id, nome_part from participantes',row(ID,NOME)),
    writeln(ID - NOME),
    fail.
apres_part.

%mostar palestra
apres_pale:-
    odbc_query('teste1',
               'select id, titulo_pale from palestras',row(ID,NOME)),
    writeln(ID - NOME),
    fail.
apres_pale.

%mostar palestrante
apres_palestrante:-
    odbc_query('teste1',
               'select id, palestrante_pale from palestras',row(ID,NOME)),
    writeln(ID - NOME),
    fail.
apres_palestrante.

%participante no evento
part_event(Idevent,Idpart):-
    odbc_prepare('teste1',
                 'insert into event_part(ID_EVENT, ID_PART)
                 VALUES (?, ?)',[integer, integer], Statement),
    odbc_execute(Statement,[Idevent, Idpart]),
    writeln('participante atribuido ao evento').

%hora na sala
hora_sala(Idsala,Idhora):-
    odbc_prepare('teste1',
                 'insert into sala_hora(id_sala, hora)
                 VALUES (?, ?)',[integer, integer], Statement),
    odbc_execute(Statement,[Idsala, Idhora]),
    writeln('hora atribuida a sala').
hora_sala.

%mostar hora
apres_hora:-
    odbc_query('teste1',
               'select id, horario_pale from palestras',row(ID,NOME)),
    writeln(ID - NOME),
    fail.
apres_hora.

%mostar sala
apres_sala:-
    odbc_query('teste1',
               'select id, nome_sala from salas',row(ID,NOME)),
    writeln(ID - NOME),
    fail.
apres_sala.

%palestra e evento
event_pale(Idevent,Idpale):-
    odbc_prepare('teste1',
                 'insert into event_pale(id_event, id_pale)
                 VALUES (?, ?)',[integer, integer], Statement),
    odbc_execute(Statement,[Idevent, Idpale]),
    writeln('palestra atribuido ao evento').
event_pale.

%busca participantes
busca_pale(Idevento):-
    odbc_prepare('teste1',
                 'select palestras.titulo_pale
                 from palestras
                 inner join event_pale on event_pale.id_pale = palestras.id
                 inner join eventos on eventos.id = event_pale.id_event
                 WHERE event_pale.id_event = ? ',[integer], Statement, [ fetch(fetch)]),
    odbc_execute(Statement,[Idevento]),
    fetch(Statement).

%busca palestras de um palestrante
busca_pp(Nome):-
    odbc_prepare('teste1',
                 'select titulo_pale
                 from palestras
                 WHERE palestrante_pale = ? ',[varchar], Statement, [ fetch(fetch)]),
    odbc_execute(Statement,[Nome]),
    fetch(Statement).

%busca sala
busca_sala(Horario):-
    odbc_prepare('teste1',
                 'select salas.nome_sala
                 from salas
                 inner join sala_hora on sala_hora.id_sala = salas.id
                 inner join palestras on palestras.id = sala_hora.hora
                 WHERE palestras.horario_pale != ? ',[varchar], Statement, [ fetch(fetch)]),
    odbc_execute(Statement,[Horario]),
    fetch(Statement).


%busca participantes
busca_part(Idevento):-
    odbc_prepare('teste1',
                 'select participantes.nome_part
                 from participantes
                 inner join event_part on event_part.ID_PART = participantes.id
                 inner join eventos on eventos.id = event_part.ID_EVENT
                 WHERE event_part.ID_EVENT = ? ',[integer], Statement, [ fetch(fetch)]),
    odbc_execute(Statement,[Idevento]),
    fetch(Statement).

fetch(Statement) :-
        odbc_fetch(Statement, Row, []),
    (   Row == end_of_file
    ->  true
    ;   Row =..[_|Args],
        writeln_list(Args),
        fetch(Statement)
    ).
writeln_list([]).
writeln_list([H|T]):-
                    writeln(H),
                    writeln_list(T).

start:-
    repeat,
    write('Menu de opções disponíveis'), nl,
    write('1. Criar Evento'), nl,
    write('2. Criar Palestra'), nl,
    write('3. Criar Participante'), nl,
    write('4. Criar Sala'), nl,
    write('5. Apresenta Eventos'),nl,
    write('6. Apresenta Palestras'),nl,
    write('7. Apresenta Palestrantes'),nl,
    write('8. Apresenta Salas'),nl,
    write('9. Apresenta todos os Participantes.'),nl,
    write('10. Apresenta Horarios Cadastrados.'),nl,
    write('11. Associar participante ao evento.'),nl,
    write('12. Associar sala e hora.'),nl,
    write('13. Associar evento e palestra.'),nl,
    write('14. participantes associados a um evento.'),nl,
    write('15. Recuperar todas as palestras de um evento específico.'),nl,
    write('16. Recuperar todas as salas disponíveis para um horário específico.'),nl,
    write('17. Recuperar todas as palestras de um palestrante específico.'),nl,
    read(OPCAO),
    executar_opcao(OPCAO),
    OPCAO = 0,
    !.

executar_opcao(1):-
    write('Titulo do evento:'),nl,
    read(Nome),
    write('Data do evento:'),nl,
    read(Data),
    write('Local do evento:'),nl,
    read(Local),
    cria_evento(Nome, Data, Local).

 executar_opcao(2):-
    write('Titulo da palestra:'),nl,
    read(Titulo),
    write('Nome do palestrante:'),nl,
    read(Palestrante),
    write('Horario da palestra:'),nl,
    read(Horario),
    write('evento pertecente:'),nl,
    read(Idevento),
    cria_palestra(Titulo, Palestrante, Horario, Idevento).

executar_opcao(3):-
    write('Nome do participante:'),nl,
    read(Nome),
    write('Email do participante:'),nl,
    read(Email),
    write('Empresa do participante:'),nl,
    read(Empresa),
    cria_participante(Nome, Email, Empresa).

executar_opcao(4):-
    write('Nome da sala:'),nl,
    read(Nome),
    write('Capacidade da sala:'),nl,
    read(Capacidade),
    cria_sala(Nome,Capacidade).

executar_opcao(5) :-
    write('Eventos organizados pela empresa:'), nl,
    apres_evento.

executar_opcao(6) :-
    write('Palestras cadastradas:'), nl,
    apres_pale.

executar_opcao(7) :-
    write('Palestarntes cadastrados:'), nl,
    apres_palestrante.

executar_opcao(8) :-
    write('salas cadastradas:'), nl,
    apres_sala.

executar_opcao(9) :-
    write('participantes cadastrados:'), nl,
    apres_part.

executar_opcao(10) :-
    write('horarios cadastrados:'), nl,
    apres_hora.

executar_opcao(11):-
    write('numero do evento'),nl,
    read(Idevent),
    write('numero do aparticipante'),nl,
    read(Idpart),
    part_event(Idevent,Idpart).

executar_opcao(12):-
    write('numero da sala'),nl,
    read(Idsala),
    write('id da hora disponivel'),nl,
    read(Idhora),
    hora_sala(Idsala,Idhora).

executar_opcao(13):-
    write('numero do evento'),nl,
    read(Idevent),
    write('numero da palestra'),nl,
    read(Idpale),
    event_pale(Idevent,Idpale).

executar_opcao(14):-
    write('id do evento'),nl,
    read(Idevento),
    busca_part(Idevento).

executar_opcao(15):-
    write('id do evento'),nl,
    read(Idevento),
    busca_pale(Idevento).

executar_opcao(16):-
    write('horario desejado'),nl,
    read(Horario),
    busca_sala(Horario).

executar_opcao(17):-
    write('Palestarnte desejado'),nl,
    read(Nome),
    busca_pp(Nome).

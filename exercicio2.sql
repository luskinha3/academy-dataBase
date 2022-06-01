create database academy;

create schema faculdade;

create table if not exists faculdade.mentores(
	mentor_id serial primary key,
	nome varchar(128) not null,
	sala_de_aula varchar (255) not null
);

create table if not exists faculdade.posts(
	post_id serial primary key,
	mentor_id integer references faculdade.mentores(mentor_id),
	descricao varchar(255) not null
);

create table  if not exists faculdade.curtidas(
	mentor_id integer not null references faculdade.mentores(mentor_id),
	post_id integer not null references faculdade.posts(post_id),
	primary key(mentor_id, post_id)
);

insert into faculdade.mentores(nome,sala_de_aula) values ('Warren Buffet', 'Sala de Aula Torvalds');
insert into faculdade.mentores(nome,sala_de_aula) values ('Steven Spielberg', 'Sala de Aula Gates');
insert into faculdade.mentores(nome,sala_de_aula) values ('Socrates', 'Sala de Aula Jobs');

insert into faculdade.posts(mentor_id,descricao) values (1,'post 01');
insert into faculdade.posts(mentor_id,descricao) values (1,'post 02');
insert into faculdade.posts(mentor_id,descricao) values (3,'post 03');

insert into faculdade.curtidas(mentor_id,post_id) values (1,1);
insert into faculdade.curtidas(mentor_id,post_id) values (3,2);
insert into faculdade.curtidas(mentor_id,post_id) values (3,3);

-- parte 01
select nome, "Total de curtidas" from faculdade.mentores 
inner join  (select mentor_id, count(mentor_id) as "Total de curtidas" from faculdade.curtidas group by mentor_id) 
as curtidas_por_mentor  
on mentores.mentor_id = curtidas_por_mentor.mentor_id;

-- parte 02
select mentores.sala_de_aula, curtidas.post_id from faculdade.mentores 
inner join faculdade.curtidas on mentores.mentor_id = curtidas.mentor_id

-- parte 03

select sala_de_aula, avg(post_id) as media from (select mentores.sala_de_aula, curtidas.post_id from faculdade.mentores 
inner join faculdade.curtidas on mentores.mentor_id = curtidas.mentor_id) as curtidas_por_sala group by sala_de_aula;



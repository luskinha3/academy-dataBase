-- metodo 01

create database academy;

create schema biblioteca;

create table biblioteca.livro (
	livro_id serial primary key,
	nome varchar (128) not null,
	ano integer not null,
	maximo_tempo_reserva integer not null,
	prateleira integer not null 
);

insert into biblioteca.livro (nome, ano, maximo_tempo_reserva, prateleira) values ('senhor dos aneis', 1954, 12, 23);
insert into biblioteca.livro (nome, ano, maximo_tempo_reserva, prateleira) values ('Harry Potter e a Pedra Filosofal', 1997, 9, 23);
insert into biblioteca.livro (nome, ano, maximo_tempo_reserva, prateleira) values ('O Hobbit', 1937, 18, 26);
insert into biblioteca.livro (nome, ano, maximo_tempo_reserva, prateleira) values ('Duna', 1984, 5, 26);

select livro_id,nome, maximo_tempo_reserva from biblioteca.livro 
inner join (select prateleira as prateleira_id, avg(maximo_tempo_reserva) as tempo_medio from biblioteca.livro 
group by prateleira) as prateleira 
on livro.prateleira = prateleira.prateleira_id where maximo_tempo_reserva > tempo_medio ;

-- metodo 02

create schema biblioteca;

create table biblioteca.prateleira(
	id integer primary key,
	tempo_medio_espera integer default 0
);

create table biblioteca.livro (
	livro_id serial primary key,
	nome varchar (128) not null,
	ano integer not null,
	maximo_tempo_reserva integer not null,
	id_prateleira integer references biblioteca.prateleira(id) 
);

create or replace function cadastra_livro(nome varchar, ano integer, maximo_tempo_reserva integer, id_prateleira integer) returns void as $$
	declare			
		media_prateleira integer default 0;
	begin
		perform id from biblioteca.prateleira where id = id_prateleira;
	
		if not found then
			insert into biblioteca.prateleira (id) values (id_prateleira);
		end if;
		
		insert into biblioteca.livro(nome,ano,maximo_tempo_reserva,id_prateleira) values (nome, ano, maximo_tempo_reserva, id_prateleira);
		select avg(livro.maximo_tempo_reserva) from biblioteca.livro group by livro.id_prateleira into media_prateleira;
		update  biblioteca.prateleira set tempo_medio_espera = media_prateleira where id_prateleira = id;
	end
	
$$ language plpgsql;

select cadastra_livro ('Senhor dos Anéis', 1954, 12, 23);
select cadastra_livro ('Harry Potter e a Pedra Filosofal', 1997, 9, 23);
select cadastra_livro ('O Hobbit', 1937, 18, 26);
select cadastra_livro ('Duna', 1984, 5, 26);

select livro_id,nome,maximo_tempo_reserva from biblioteca.livro 
inner join biblioteca.prateleira on livro.id_prateleira = prateleira.id
where maximo_tempo_reserva > tempo_medio_espera;

select * from biblioteca.livro;












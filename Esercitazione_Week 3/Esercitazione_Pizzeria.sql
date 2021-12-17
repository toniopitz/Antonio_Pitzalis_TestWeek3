Create database Es_Pizzeria;

--Crezione Struttura
create table Pizza
(
id int primary key identity(1,1),
nome varchar(30),
prezzo decimal(3,2)
);
create table Ingrediente
(
id int primary key identity(1,1),
nome varchar(30),
costo decimal(3,2),
scorte int
);
create table Composizione
(
idPizza int foreign key references Pizza(id),
idIngrediente int foreign key references Ingrediente(id),
primary key (idPizza,idIngrediente)
);
--Fine creazione struttura
go
--Procedure di inserimento
go
--1 Inserimento di una nuova pizza 
create procedure InserisciPizza
@nome varchar(30),
@prezzo decimal(3,2)
as
begin
	begin try
		if(@prezzo > 0)
			insert into Pizza values(@nome,@prezzo);
	end try
	begin catch
		select ERROR_MESSAGE() as MessaggioErrore;
	end catch
end
go 
create procedure InserisciIngrediente
@nome varchar(30),
@costo decimal(3,2),
@scorte int
as
begin
	begin try
		if(@costo > 0 and @scorte >= 0)
			insert into Ingrediente values(@nome,@costo,@scorte);
	end try
	begin catch
		select ERROR_MESSAGE() as MessaggioErrore;
	end catch
end
go 
--2 Inserimento/Assegnazione di un ingrediente
create procedure InserisciComposizione
@nomePizza varchar(30),
@nomeIngrediente varchar(30)
as
begin
	begin try
		insert into Composizione values( (select id from Pizza where @nomePizza = Pizza.nome),
										(select id from Ingrediente where @nomeIngrediente = Ingrediente.nome));
	end try
	begin catch
		select ERROR_MESSAGE() as MessaggioErrore;
	end catch
end
go
--Fine procedure Inserimento
go
--Inserimento dati
execute InserisciPizza 'Margherita',5;
execute InserisciPizza 'Bufala',7;
execute InserisciPizza 'Diavola',6;
execute InserisciPizza 'Quattro Stagioni',6.5;
execute InserisciPizza 'Porcini',7;
execute InserisciPizza 'Dioniso',8;
execute InserisciPizza 'Ortolana',8;
execute InserisciPizza 'Patate e Salsiccia',6;

execute InserisciIngrediente 'Pomodoro',0.5,250;
execute InserisciIngrediente 'Mozzarella',0.7,200;
execute InserisciIngrediente 'Mozzarella di Bufala',1,150;
execute InserisciIngrediente 'Spianata Piccante',0.8,100;
execute InserisciIngrediente 'Funghi',0.9,120;
execute InserisciIngrediente 'Carciofi',0.6,80;
execute InserisciIngrediente 'Prosciutto Cotto',0.7,200;
execute InserisciIngrediente 'Olive',0.4,300;
execute InserisciIngrediente 'Funghi Porcini',2,50;
execute InserisciIngrediente 'Stracchino',1,100;
execute InserisciIngrediente 'Speck',1,80;
execute InserisciIngrediente 'Rucola',0.3,130;
execute InserisciIngrediente 'Grana',1.2,110;
execute InserisciIngrediente 'Verdure di stagione',0.9,70;
execute InserisciIngrediente 'Patate',0.6,150;
execute InserisciIngrediente 'Salsiccia',1,78;

execute InserisciComposizione 'Margherita','Pomodoro';
execute InserisciComposizione 'Margherita','Mozzarella';
execute InserisciComposizione 'Bufala','Pomodoro';
execute InserisciComposizione 'Bufala','Mozzarella di Bufala';
execute InserisciComposizione 'Diavola','Pomodoro';
execute InserisciComposizione 'Diavola','Mozzarella';
execute InserisciComposizione 'Diavola','Spianata Piccante';
execute InserisciComposizione 'Quattro Stagioni','Pomodoro';
execute InserisciComposizione 'Quattro Stagioni','Mozzarella';
execute InserisciComposizione 'Quattro Stagioni','Funghi';
execute InserisciComposizione 'Quattro Stagioni','Carciofi';
execute InserisciComposizione 'Quattro Stagioni','Prosciutto Cotto';
execute InserisciComposizione 'Quattro Stagioni','Olive';
execute InserisciComposizione 'Porcini','Pomodoro';
execute InserisciComposizione 'Porcini','Mozzarella';
execute InserisciComposizione 'Porcini','Funghi Porcini';
execute InserisciComposizione 'Dioniso','Pomodoro';
execute InserisciComposizione 'Dioniso','Mozzarella';
execute InserisciComposizione 'Dioniso','Stracchino';
execute InserisciComposizione 'Dioniso','Speck';
execute InserisciComposizione 'Dioniso','Rucola';
execute InserisciComposizione 'Dioniso','Grana';
execute InserisciComposizione 'Ortolana','Pomodoro';
execute InserisciComposizione 'Ortolana','Mozzarella';
execute InserisciComposizione 'Ortolana','Verdure di stagione';
execute InserisciComposizione 'Patate e Salsiccia','Mozzarella';
execute InserisciComposizione 'Patate e Salsiccia','Patate';
execute InserisciComposizione 'Patate e Salsiccia','Salsiccia';
go
--Fine inserimento dati
go



--Implementazione QUERY

--1. Estrarre tutte le pizze con prezzo superiore a 6 euro.
select p.nome as 'Pizze che superano i 6 euro di costo'
from Pizza as p
where p.prezzo > 6;

--2. Estrarre la pizza/le pizze più costosa/e
select p.nome as 'Pizza/e più costosa/e'
from Pizza as p
where p.prezzo = (select MAX(p.prezzo) from Pizza as p);

--3. Estrarre le pizze <<bianche>> 
select distinct p.nome as 'Pizze bianche'
from Pizza as p inner join Composizione as c on p.id = c.idPizza
				inner join Ingrediente	as i on i.id = c.idIngrediente
where p.nome in (select p.nome
				from Pizza as p inner join Composizione as c on p.id = c.idPizza
								inner join Ingrediente	as i on i.id = c.idIngrediente
				where i.nome = 'Pomodoro');

--4. Estrarre le pizze che contengo funghi (di qualsiasi tipo).
select p.nome as 'Pizze con i funghi'
from Pizza as p inner join Composizione as c on p.id = c.idPizza
				inner join Ingrediente	as i on i.id = c.idIngrediente
where i.nome like('Funghi%');

go
--Procedure
go
--3 Aggiornamento del prezzo di una pizza
create procedure AggPrezzoPizza
@nomePizza varchar(30),
@nuovoPrezzo decimal(5,2)
as 
begin
	begin try
		if(@nuovoPrezzo > 0)
			update Pizza set prezzo = @nuovoPrezzo where Pizza.nome = @nomePizza;
	end try
	begin catch
		select ERROR_MESSAGE() as MessaggioErrore;
	end catch
end
go
--Prova
execute AggPrezzoPizza 'Margherita',6;
go
--Verifica
select *
from Pizza;
go
create procedure DeleteIngrediente
@nomeIngrediente varchar(30),
@nomePizza varchar(30)
as
begin
	begin try
	delete from Composizione where (idIngrediente = (select id from Ingrediente where Ingrediente.nome = @nomeIngrediente))
								and(idPizza = (select id from Pizza where Pizza.nome = @nomePizza));
	end try
	begin catch
		select ERROR_LINE(), ERROR_MESSAGE() as 'Messaggio d''errore';
	end catch
end
go

--Prova
execute DeleteIngrediente 'Pomodoro','Margherita';
go

--Verifica
select p.nome
from Pizza as p inner join Composizione as c on p.id = c.idPizza
				inner join Ingrediente	as i on i.id = c.idIngrediente
where i.nome = 'Pomodoro';
go

--5. Incremento del 10% del prezzo delle pizze contenenti un ingrediente
create procedure MaggiorazionePrz(@nomeIngrediente varchar(30))
as
begin
	begin try
	update Pizza set prezzo += (prezzo*10)/100 where (Pizza.id = ( select c.idPizza 
							from Ingrediente as i   inner join Composizione as c on i.id = c.idIngrediente
							where i.nome = @nomeIngrediente));
	end try
	begin catch
		select ERROR_MESSAGE() as 'Messaggio d''Errore';
	end catch
end
go
	--Test
	execute MaggiorazionePrz 'Funghi'; 
	select *
from Pizza as p inner join Composizione as c on p.id = c.idPizza
				inner join Ingrediente	as i on i.id = c.idIngrediente
where i.nome = 'Funghi';
--Implementazione delle funzioni
--1. Tabella listino pizze(nome,prezzo)
go
create function ListinoPizze()
returns table
as
return  
select Pizza.nome as 'Nome Pizza', prezzo as 'Prezzo'
from Pizza;
go
	--Test
	select * from dbo.ListinoPizze();
	go
--2. Tabella listino pizze(nome,prezzo) contenenti un ingrediente
go
create function ListinoPizzeIng(@nomeIngrediente varchar(30))
returns table
as
return  
select distinct p.nome as 'Nome Pizza', p.prezzo as 'Prezzo'
from Pizza as p inner join Composizione as c on p.id = c.idPizza
				inner join Ingrediente as i on i.id = c.idIngrediente
where p.id in (	select c.idPizza
				from  Composizione as c	inner join Ingrediente as i on i.id = c.idIngrediente
				where i.nome = @nomeIngrediente);
go
	--Test
	select * from ListinoPizzeIng('Pomodoro');
	go
--3. Tabella listino pizze(nome,prezzo) che non contengono un certo ingrediente
create function ListinoPizzeNonIng(@nomeIngrediente varchar(30))
returns table
as
return  
select distinct p.nome as 'Nome Pizza', p.prezzo as 'Prezzo'
from Pizza as p inner join Composizione as c on p.id = c.idPizza
				inner join Ingrediente as i on i.id = c.idIngrediente
where p.id not in (	select c.idPizza
					from  Composizione as c	inner join Ingrediente as i on i.id = c.idIngrediente
					where i.nome = @nomeIngrediente);
go
	--Test
	select * from ListinoPizzeNonIng('Pomodoro');
	go
--4. Calcolo numero pizze contenenti un ingrediente
create function nPizzePerIng(@nomeIngrediente varchar(30))
returns int
as

begin
declare @numeroPizze int
	select @numeroPizze = COUNT(*)
	from ListinoPizzeIng(@nomeIngrediente);
return @numeroPizze
end
go
	--Test
	select dbo.nPizzePerIng('Pomodoro') as 'Numero Pizze per Ing';
	go

--5. Calcolo numero pizze che non contengono un ingrediente
create function nPizzePerIngNon(@nomeIngrediente varchar(30))
returns int
as

begin
declare @numeroPizze int
	select @numeroPizze = COUNT(*)
	from ListinoPizzeNonIng(@nomeIngrediente);
return @numeroPizze
end
go
	--Test
	select dbo.nPizzePerIngNon('Pomodoro') as 'Numero Pizze che non contengono Ingrediente';
	go

--6 Calcolo numero ingredienti contenuti in una pizza
create function nIngredientiPerPizza(@nomePizza varchar(30))
returns int
as

begin
declare @numeroIngredienti int
	select @numeroIngredienti = COUNT(*)
	from Pizza as p inner join Composizione as c on p.id = c.idPizza
				where c.idIngrediente in (select i.id 
										  from Ingrediente as i  inner join Composizione as c on i.id = c.idIngrediente
																inner join Pizza as p on p.id = c.idPizza
										  where p.nome = @nomePizza)
										and c.idPizza = (select p.id from Pizza as p where p.nome = @nomePizza)
return @numeroIngredienti
end
go
	--Test
	select dbo.nIngredientiPerPizza('Ortolana') as 'Numero Ingredienti per pizza scelta';
	go

/*Realizzare una view che rappresenta il menù con tutte le pizze.
	Opzionale: la vista deve restituire una tabella con prima colonna
	contenente il nome della pizza, seconda colonna il prezzo e terza
	colonna la lista unica di tutti gli ingredienti separati da virgola
	(vedi esempio in tabella)*/


create view Menu as
select p.nome, p.prezzo 
from Pizza as p
group by p.nome, p.prezzo
go
select * from Menu;


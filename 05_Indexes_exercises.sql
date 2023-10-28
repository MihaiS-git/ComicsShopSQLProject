create database IndexExercices;
go

use IndexExercices;

create table Ta(
	coda int primary key identity,
	a2 int unique,
	a3 int,
	a4 int
)

create table Tc(
	codc int primary key identity,
	coda int foreign key references Ta(coda),
	c3 int
)
go
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------


if exists(select * from sys.procedures where name = 'populare')
drop procedure populare
go

create procedure populare as
begin
	declare @i int = 1
	declare @j int = 0
	while @i <= 5000
	begin
		insert into Ta
		values(@i+10000, @i+20000, @i+30000)
		set @i = @i + 1
	end

	while @j < 30000
	begin
		declare @k int = 1
		while @k <= 5000
		begin
			insert into Tc
			values(@k, @j+100000)
			set @k += 1
			set @j += 1
		end
	end
end

exec populare

select count(*) from Ta
select count(*) from Tc
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
/*
a. Verificati indecsii existenti pe tabelul Ta. Scrieti doua interogari SELECT pe tabelul Ta ale caror
planuri de executie sa contina operatorii clustered index seek si nonclustered index seek.
*/
EXEC sp_helpindex 'Ta'
EXEC sp_helpindex 'Tc'


select * from Ta where coda = 3333

create nonclustered index my_index_Ta_a2 on Ta(a2)

drop index my_index_Ta_a2 on Ta

select * from Ta where coda = 3333
select * from Ta where a2 = 13333

/*
b. Scrieti o interogare SELECT pe tabelul Ta cu o clauza de forma WHERE a3 = valoare si
analizati planul de executie. Creati un index nonclustered pe coloana a3 util pentru interogare.
Evidentiati schimbarile din planul de executie: operatori, estimated subtree cost pe SELECT.
*/

select * from Ta where a3 = 23333
--estimated subtree cost = 0.0198931

create nonclustered index my_index_Ta_a3 on Ta(a3)
select * from Ta where a3 = 23333
--estimated subtree cost = 0.0032831

drop index my_index_Ta_a3 on Ta

/*
c. Scrieti o interogare SELECT cu INNER JOIN intre Tc si Ta (cheie externa = cheie primara) si
o filtrare de forma coloana utilizata in JOIN = valoare. Analizati planul de executie. Creati un
index nonclustered pe coloana care este cheie externa in Tc si analizati din nou planul de executie.
*/

select Tc.c3 from Tc
join Ta
on Tc.coda = Ta.coda
where Ta.coda =1333

create nonclustered index my_index_Tc_coda on Tc(coda)

drop index my_index_Tc_coda on Tc

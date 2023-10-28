use [ComicsShop];

select * from comics;
select * from [dbo].[bonus_comics];

-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
/*
1. scrieți câte o procedură stocată pentru operația de INSERT pe două tabele; parametrii unei
astfel de proceduri sunt atributele care descriu entitățile sau relațiile din tabel; fiecare
procedură va utiliza funcții pentru validarea anumitor parametri (de ex. anul nașterii trebuie
sa fie înainte de data curentă); se cere o funcție user-defined pe procedură; opțional se pot
utiliza și funcții sistem;
*/
-----------------------------------------------------------------------------------------------------------------
---------------------------------PRIMUL TABEL - COMICS---------------------------------------------
-----------------------------------------------------------------------------------------------------------------
--Functie care returneaza un tabel cu  randurile din tabela bonus_comics care sunt active (activ=1)

create function SelectActiveBonusComics()
returns table
as 
return
select * from bonus_comics where active = 1
go
-----------------------------------------------------------------------------------------------------------------

create proc InsertAcitveIntoComicsFromBonus as
begin
	if exists (select * from bonus_comics where active = 1)
	begin
		insert into comics(title, description, unit_price, units_stock, active, category_id)
		select title, description, unit_price, units_stock, active, category_id from dbo.SelectActiveBonusComics()
		--delete from bonus_comics where active = 1
	end

end
go
-----------------------------------------------------------------------------------------------------------------
execute InsertAcitveIntoComicsFromBonus
-----------------------------------------------------------------------------------------------------------------
drop procedure InsertAcitveIntoComicsFromBonus
-----------------------------------------------------------------------------------------------------------------
delete from comics where title like 'Bonus%'
select * from comics
select * from bonus_comics
-----------------------------------------------------------------------------------------------------------------
-------------------------------AL DOILEA TABEL-ORDERS--------------------------------------------
-----------------------------------------------------------------------------------------------------------------

select * from orders

--Functie care verifica validitatea datei calendaristice
if exists(select * from sys.objects where name = 'CheckValidDate')
drop function CheckValidDate;
go
create function CheckValidDate(@date date)
returns bit
as
begin
	declare @result bit = 0;
	if datediff(day, @date, getdate())>= 0
	begin
		set @result = 1;
	end
	return @result;
end;
go

--Procedura de inserare pentru un order
if exists(select * from sys.procedures where name = 'InsertOrder')
drop procedure InsertOrder;
go
create procedure InsertOrder(@customer_id bigint, @total_price decimal(11,2), @shipping_status varchar(255), @date_created date, @last_updated date)
as
begin
	declare @IsDateCreatedValid bit = dbo.CheckValidDate(@date_created);
	declare @IsLastUpdatedValid bit = dbo.CheckValidDate(@last_updated);
	if (@IsDateCreatedValid = 1 and @IsLastUpdatedValid = 1 and datediff(day,@date_created,@last_updated )>=0)
	begin
		insert into orders(customer_id, total_price, shipping_status, date_created, last_updated)
		values(@customer_id, @total_price, @shipping_status, @date_created, @last_updated);
		print '==========================Success==============================';
	end;
	else
	begin
		print '========================Invalid Order============================';
	end;
end;
go


--date valide
exec InsertOrder 4, 555, 'pending', '2023-04-15', '2023-04-15'
--date invalide(@date_created > @last_updated)
exec InsertOrder 4, 555, 'pending', '2023-04-20', '2023-04-15'
--data invalide(din viitor)
exec InsertOrder 4, 555, 'pending', '2023-08-15', '2023-08-15'

select * from orders

delete from orders where total_price = 555
go

-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
/*
2. creați un view pe baza de date care să opereze pe cel puțin două tabele; scrieți două
interogări SELECT pe acest view care să producă informații relevante pentru un potențial
utilizator;
*/

--VIEW -- toate comics cu autor din tabelele comics-comics_authors-authors

create view ComicsWithAuthors as
select c.title, c.description, a.author_first_name, a.author_last_name, c.unit_price, c.units_stock
from comics c
join comics_authors ca
on c.comic_id = ca.comic_id
join authors a
on ca.author_id = a.author_id

select * from ComicsWithAuthors

--selectati toate comic-urile cu pretul mai mare de 10 care exista pe stoc, afisati titlul, autorii si pretul
select title, author_first_name, author_last_name, unit_price from ComicsWithAuthors
where unit_price > 10 and units_stock > 0 

--afisati valoarea totala a comic-urilor de pe stoc pentru care 'John Doe' este autor
select sum(unit_price*units_stock) as TotalValue, author_first_name, author_last_name from ComicsWithAuthors
where author_first_name = 'John' and author_last_name = 'Doe'
group by  author_first_name, author_last_name

-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
/*
3. implementați un trigger pentru un tabel T la alegere, pentru operațiile de adăugare,
modificare, ștergere, care să introducă într-un tabel log data și ora la care s-a realizat
operația pe tabelul T, tipul operației (I/U/D), numele tabelului T și numărul de înregistrări
afectate din T; opțional, puteti crea triggere similare și pe alte tabele;
*/
drop trigger  if exists InsertIntoLogTable;
drop table if exists log_table
go

create table log_table (
log_id int primary key identity,
date date,
time time(0),
operation_type varchar(10),
table_name varchar(100),
rows_affected int
)
go

create or alter trigger InsertIntoLogTable
on orders
after insert, update, delete
as
begin
	declare @operation_type varchar(10);
	if exists(select * from inserted)
	begin
		if exists(select * from deleted)		
		begin
			set @operation_type = 'UPDATE';
		end
		else
		begin
			set @operation_type = 'INSERT';
		end
	end
	else
	begin
		set @operation_type = 'DELETE';
	end

	insert into log_table(date, time, operation_type, table_name, rows_affected)
	select convert(date, getdate()), 
				convert(time(0), 
				getdate()), 
				@operation_type,
				'orders', 
				case @operation_type
					when 'INSERT' then count(*)
					when 'DELETE' then count(*)
					when 'UPDATE' then count(*) / 2
				end as rows_affected
				from (select * from inserted
				union all
				select * from deleted
				) as RowsAffected;
end

select * from log_table
truncate table log_table

--date valide
exec InsertOrder 4, 555, 'pending', '2023-04-15', '2023-04-15'
exec InsertOrder 4, 555, 'delivered', '2023-04-15', '2023-04-15'

--date invalide(@date_created > @last_updated)
exec InsertOrder 4, 555, 'pending', '2023-04-20', '2023-04-15'
--data invalide(din viitor)
exec InsertOrder 4, 555, 'pending', '2023-08-15', '2023-08-15'

update orders
set total_price = 600 where total_price = 555

select * from orders

delete from orders where total_price = 555
delete from orders where total_price = 599.52

insert into orders (customer_id, total_price, shipping_status, date_created, last_updated)
values (5, 555, 'pending', '2023-04-15', '2023-04-15'),
			(6, 555, 'pending', '2023-04-15', '2023-04-15'),
			(7, 555, 'pending', '2023-04-15', '2023-04-15')

-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
/*
4. scrieți un cursor în care să executați o procedură stocată pentru fiecare rând din rezultatul
interogării asociate cursorului; observați dacă puteți obține același efect fără să utilizați
cursorul.
*/
if exists(select * from sys.procedures where name = 'AddTVA')
drop procedure AddTVA
go
------
create procedure AddTVA(@order_id bigint) as
begin
	update orders
	set total_price = total_price * 1.19
	where order_id = @order_id
end
------
declare @cursor_order_id bigint;

declare tax_cursor cursor for
select order_id from orders;

open tax_cursor;

fetch next from tax_cursor into @cursor_order_id;

while @@fetch_status = 0
begin
	exec AddTVA @order_id = @cursor_order_id;
	fetch next from tax_cursor into @cursor_order_id;
end

close tax_cursor;
deallocate tax_cursor;
------------
select * from orders
select * from log_table

--alternativa
update orders
set total_price = total_price * 0.84
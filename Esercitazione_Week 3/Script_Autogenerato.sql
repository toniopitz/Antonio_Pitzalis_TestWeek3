USE [master]
GO
/****** Object:  Database [Es_Pizzeria]    Script Date: 12/17/2021 3:27:44 PM ******/
CREATE DATABASE [Es_Pizzeria]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Es_Pizzeria', FILENAME = N'C:\Users\Antonio.pitzalis\Es_Pizzeria.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Es_Pizzeria_log', FILENAME = N'C:\Users\Antonio.pitzalis\Es_Pizzeria_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Es_Pizzeria] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Es_Pizzeria].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Es_Pizzeria] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Es_Pizzeria] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Es_Pizzeria] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Es_Pizzeria] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Es_Pizzeria] SET ARITHABORT OFF 
GO
ALTER DATABASE [Es_Pizzeria] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [Es_Pizzeria] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Es_Pizzeria] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Es_Pizzeria] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Es_Pizzeria] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Es_Pizzeria] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Es_Pizzeria] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Es_Pizzeria] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Es_Pizzeria] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Es_Pizzeria] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Es_Pizzeria] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Es_Pizzeria] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Es_Pizzeria] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Es_Pizzeria] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Es_Pizzeria] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Es_Pizzeria] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Es_Pizzeria] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Es_Pizzeria] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Es_Pizzeria] SET  MULTI_USER 
GO
ALTER DATABASE [Es_Pizzeria] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Es_Pizzeria] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Es_Pizzeria] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Es_Pizzeria] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Es_Pizzeria] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Es_Pizzeria] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [Es_Pizzeria] SET QUERY_STORE = OFF
GO
USE [Es_Pizzeria]
GO
/****** Object:  UserDefinedFunction [dbo].[nIngredientiPerPizza]    Script Date: 12/17/2021 3:27:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[nIngredientiPerPizza](@nomePizza varchar(30))
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
GO
/****** Object:  UserDefinedFunction [dbo].[nPizzePerIng]    Script Date: 12/17/2021 3:27:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[nPizzePerIng](@nomeIngrediente varchar(30))
returns int
as

begin
declare @numeroPizze int
	select @numeroPizze = COUNT(*)
	from ListinoPizzeIng(@nomeIngrediente);
return @numeroPizze
end
GO
/****** Object:  UserDefinedFunction [dbo].[nPizzePerIngNon]    Script Date: 12/17/2021 3:27:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[nPizzePerIngNon](@nomeIngrediente varchar(30))
returns int
as

begin
declare @numeroPizze int
	select @numeroPizze = COUNT(*)
	from ListinoPizzeNonIng(@nomeIngrediente);
return @numeroPizze
end
GO
/****** Object:  Table [dbo].[Pizza]    Script Date: 12/17/2021 3:27:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pizza](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nome] [varchar](30) NULL,
	[prezzo] [decimal](3, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[ListinoPizze]    Script Date: 12/17/2021 3:27:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[ListinoPizze]()
returns table
as
return  
select Pizza.nome as 'Nome Pizza', prezzo as 'Prezzo'
from Pizza;
GO
/****** Object:  Table [dbo].[Ingrediente]    Script Date: 12/17/2021 3:27:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ingrediente](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nome] [varchar](30) NULL,
	[costo] [decimal](3, 2) NULL,
	[scorte] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Composizione]    Script Date: 12/17/2021 3:27:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Composizione](
	[idPizza] [int] NOT NULL,
	[idIngrediente] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[idPizza] ASC,
	[idIngrediente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[ListinoPizzeIng]    Script Date: 12/17/2021 3:27:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[ListinoPizzeIng](@nomeIngrediente varchar(30))
returns table
as
return  
select distinct p.nome as 'Nome Pizza', p.prezzo as 'Prezzo'
from Pizza as p inner join Composizione as c on p.id = c.idPizza
				inner join Ingrediente as i on i.id = c.idIngrediente
where p.id in (	select c.idPizza
				from  Composizione as c	inner join Ingrediente as i on i.id = c.idIngrediente
				where i.nome = @nomeIngrediente);
GO
/****** Object:  UserDefinedFunction [dbo].[ListinoPizzeNonIng]    Script Date: 12/17/2021 3:27:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[ListinoPizzeNonIng](@nomeIngrediente varchar(30))
returns table
as
return  
select distinct p.nome as 'Nome Pizza', p.prezzo as 'Prezzo'
from Pizza as p inner join Composizione as c on p.id = c.idPizza
				inner join Ingrediente as i on i.id = c.idIngrediente
where p.id not in (	select c.idPizza
					from  Composizione as c	inner join Ingrediente as i on i.id = c.idIngrediente
					where i.nome = @nomeIngrediente);
GO
/****** Object:  View [dbo].[Menu]    Script Date: 12/17/2021 3:27:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[Menu] as
select p.nome, p.prezzo 
from Pizza as p
group by p.nome, p.prezzo
GO
ALTER TABLE [dbo].[Composizione]  WITH CHECK ADD FOREIGN KEY([idIngrediente])
REFERENCES [dbo].[Ingrediente] ([id])
GO
ALTER TABLE [dbo].[Composizione]  WITH CHECK ADD FOREIGN KEY([idPizza])
REFERENCES [dbo].[Pizza] ([id])
GO
/****** Object:  StoredProcedure [dbo].[AggPrezzoPizza]    Script Date: 12/17/2021 3:27:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[AggPrezzoPizza]
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
GO
/****** Object:  StoredProcedure [dbo].[DeleteIngrediente]    Script Date: 12/17/2021 3:27:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[DeleteIngrediente]
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
GO
/****** Object:  StoredProcedure [dbo].[InserisciComposizione]    Script Date: 12/17/2021 3:27:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[InserisciComposizione]
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
GO
/****** Object:  StoredProcedure [dbo].[InserisciIngrediente]    Script Date: 12/17/2021 3:27:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[InserisciIngrediente]
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
GO
/****** Object:  StoredProcedure [dbo].[InserisciPizza]    Script Date: 12/17/2021 3:27:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[InserisciPizza]
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
GO
/****** Object:  StoredProcedure [dbo].[MaggiorazionePrz]    Script Date: 12/17/2021 3:27:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[MaggiorazionePrz](@nomeIngrediente varchar(30))
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
GO
USE [master]
GO
ALTER DATABASE [Es_Pizzeria] SET  READ_WRITE 
GO

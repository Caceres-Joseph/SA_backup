USE [master]
GO
/****** Object:  Database [Almacenamiento]    Script Date: 16/10/2019 16:05:23 ******/
CREATE DATABASE [Almacenamiento]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Traduccion', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\Traduccion.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Traduccion_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\Traduccion_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Almacenamiento] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Almacenamiento].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Almacenamiento] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Almacenamiento] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Almacenamiento] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Almacenamiento] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Almacenamiento] SET ARITHABORT OFF 
GO
ALTER DATABASE [Almacenamiento] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Almacenamiento] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Almacenamiento] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Almacenamiento] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Almacenamiento] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Almacenamiento] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Almacenamiento] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Almacenamiento] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Almacenamiento] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Almacenamiento] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Almacenamiento] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Almacenamiento] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Almacenamiento] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Almacenamiento] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Almacenamiento] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Almacenamiento] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Almacenamiento] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Almacenamiento] SET RECOVERY FULL 
GO
ALTER DATABASE [Almacenamiento] SET  MULTI_USER 
GO
ALTER DATABASE [Almacenamiento] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Almacenamiento] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Almacenamiento] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Almacenamiento] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'Almacenamiento', N'ON'
GO
USE [Almacenamiento]
GO
/****** Object:  UserDefinedTableType [dbo].[Hierarchy]    Script Date: 16/10/2019 16:05:23 ******/
CREATE TYPE [dbo].[Hierarchy] AS TABLE(
	[element_id] [int] NOT NULL,
	[sequenceNo] [int] NULL,
	[parent_ID] [int] NULL,
	[Object_ID] [int] NULL,
	[NAME] [nvarchar](2000) NULL,
	[StringValue] [nvarchar](max) NOT NULL,
	[ValueType] [varchar](10) NOT NULL,
	PRIMARY KEY CLUSTERED 
(
	[element_id] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO
/****** Object:  UserDefinedFunction [dbo].[fn_JWT_ReturnSecret]    Script Date: 16/10/2019 16:05:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Estudiantes Laboratorio SA Segundo semestre 2019>
-- Create date: <26/09/2019>
-- Description:	<Funcion para ecriptar password>
-- Version: <1.0.0>
-- =============================================
create FUNCTION [dbo].[fn_JWT_ReturnSecret]
(
	-- Add the parameters for the function here
	@Password as varchar(25),@TipoEncript as varchar(3)
)
RETURNS varchar(25)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Encript as varchar(25)


	set @Encript = case 
					when @TipoEncript = 'MD5'
						then   SUBSTRING(master.dbo.fn_varbintohexstr(HashBytes('MD5', @Password)), 3, 32)
					when @TipoEncript = 'SHA'
						then   SUBSTRING(master.dbo.fn_varbintohexstr(HashBytes('SHA',@Password)), 3, 40)
					when @TipoEncript = 'SH1'
						then SUBSTRING(master.dbo.fn_varbintohexstr(HashBytes('SHA1', @Password)), 3, 40)
				end
		

	-- Return the result of the function
	RETURN @Encript

END

GO
/****** Object:  UserDefinedFunction [dbo].[JSONEscaped]    Script Date: 16/10/2019 16:05:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE FUNCTION [dbo].[JSONEscaped] ( /* this is a simple utility function that takes a SQL String with all its clobber and outputs it as a sting with all the JSON escape sequences in it.*/
 @Unescaped NVARCHAR(MAX) --a string with maybe characters that will break json
 )
RETURNS NVARCHAR(MAX)
AS
BEGIN
  SELECT @Unescaped = REPLACE(@Unescaped, FROMString, TOString)
  FROM (SELECT '' AS FromString, '\' AS ToString 
        UNION ALL SELECT '"', '"' 
        UNION ALL SELECT '/', '/'
        UNION ALL SELECT CHAR(08),'b'
        UNION ALL SELECT CHAR(12),'f'
        UNION ALL SELECT CHAR(10),'n'
        UNION ALL SELECT CHAR(13),'r'
        UNION ALL SELECT CHAR(09),'t'
 ) substitutions
RETURN @Unescaped
END
GO
/****** Object:  UserDefinedFunction [dbo].[parseJSON]    Script Date: 16/10/2019 16:05:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION [dbo].[parseJSON]( @JSON NVARCHAR(MAX))
/**
Summary: >
  The code for the JSON Parser/Shredder will run in SQL Server 2005, 
  and even in SQL Server 2000 (with some modifications required).
 
  First the function replaces all strings with tokens of the form @Stringxx,
  where xx is the foreign key of the table variable where the strings are held.
  This takes them, and their potentially difficult embedded brackets, out of 
  the way. Names are  always strings in JSON as well as  string values.
 
  Then, the routine iteratively finds the next structure that has no structure 
  Contained within it, (and is, by definition the leaf structure), and parses it,
  replacing it with an object token of the form ‘@Objectxxx‘, or ‘@arrayxxx‘, 
  where xxx is the object id assigned to it. The values, or name/value pairs 
  are retrieved from the string table and stored in the hierarchy table. G
  radually, the JSON document is eaten until there is just a single root
  object left.
Author: PhilFactor
Date: 01/07/2010
Version: 
  Number: 4.6.2
  Date: 01/07/2019
  Why: case-insensitive version
Example: >
  Select * from parseJSON('{    "Person": 
      {
       "firstName": "John",
       "lastName": "Smith",
       "age": 25,
       "Address": 
           {
          "streetAddress":"21 2nd Street",
          "city":"New York",
          "state":"NY",
          "postalCode":"10021"
           },
       "PhoneNumbers": 
           {
           "home":"212 555-1234",
          "fax":"646 555-4567"
           }
        }
     }
  ')
Returns: >
  nothing
**/
	RETURNS @hierarchy TABLE
	  (
	   Element_ID INT IDENTITY(1, 1) NOT NULL, /* internal surrogate primary key gives the order of parsing and the list order */
	   SequenceNo [int] NULL, /* the place in the sequence for the element */
	   Parent_ID INT null, /* if the element has a parent then it is in this column. The document is the ultimate parent, so you can get the structure from recursing from the document */
	   Object_ID INT null, /* each list or object has an object id. This ties all elements to a parent. Lists are treated as objects here */
	   Name NVARCHAR(2000) NULL, /* the Name of the object */
	   StringValue NVARCHAR(MAX) NOT NULL,/*the string representation of the value of the element. */
	   ValueType VARCHAR(10) NOT null /* the declared type of the value represented as a string in StringValue*/
	  )
	  /*
 
	   */
	AS
	BEGIN
	  DECLARE
	    @FirstObject INT, --the index of the first open bracket found in the JSON string
	    @OpenDelimiter INT,--the index of the next open bracket found in the JSON string
	    @NextOpenDelimiter INT,--the index of subsequent open bracket found in the JSON string
	    @NextCloseDelimiter INT,--the index of subsequent close bracket found in the JSON string
	    @Type NVARCHAR(10),--whether it denotes an object or an array
	    @NextCloseDelimiterChar CHAR(1),--either a '}' or a ']'
	    @Contents NVARCHAR(MAX), --the unparsed contents of the bracketed expression
	    @Start INT, --index of the start of the token that you are parsing
	    @end INT,--index of the end of the token that you are parsing
	    @param INT,--the parameter at the end of the next Object/Array token
	    @EndOfName INT,--the index of the start of the parameter at end of Object/Array token
	    @token NVARCHAR(200),--either a string or object
	    @value NVARCHAR(MAX), -- the value as a string
	    @SequenceNo int, -- the sequence number within a list
	    @Name NVARCHAR(200), --the Name as a string
	    @Parent_ID INT,--the next parent ID to allocate
	    @lenJSON INT,--the current length of the JSON String
	    @characters NCHAR(36),--used to convert hex to decimal
	    @result BIGINT,--the value of the hex symbol being parsed
	    @index SMALLINT,--used for parsing the hex value
	    @Escape INT --the index of the next escape character
	    
	  DECLARE @Strings TABLE /* in this temporary table we keep all strings, even the Names of the elements, since they are 'escaped' in a different way, and may contain, unescaped, brackets denoting objects or lists. These are replaced in the JSON string by tokens representing the string */
	    (
	     String_ID INT IDENTITY(1, 1),
	     StringValue NVARCHAR(MAX)
	    )
	  SELECT--initialise the characters to convert hex to ascii
	    @characters='0123456789abcdefghijklmnopqrstuvwxyz',
	    @SequenceNo=0, --set the sequence no. to something sensible.
	  /* firstly we process all strings. This is done because [{} and ] aren't escaped in strings, which complicates an iterative parse. */
	    @Parent_ID=0;
	  WHILE 1=1 --forever until there is nothing more to do
	    BEGIN
	      SELECT
	        @start=PATINDEX('%[^a-zA-Z]["]%', @json collate SQL_Latin1_General_CP850_Bin);--next delimited string
	      IF @start=0 BREAK --no more so drop through the WHILE loop
	      IF SUBSTRING(@json, @start+1, 1)='"' 
	        BEGIN --Delimited Name
	          SET @start=@Start+1;
	          SET @end=PATINDEX('%[^\]["]%', RIGHT(@json, LEN(@json+'|')-@start) collate SQL_Latin1_General_CP850_Bin);
	        END
	      IF @end=0 --either the end or no end delimiter to last string
	        BEGIN-- check if ending with a double slash...
             SET @end=PATINDEX('%[\][\]["]%', RIGHT(@json, LEN(@json+'|')-@start) collate SQL_Latin1_General_CP850_Bin);
 		     IF @end=0 --we really have reached the end 
				BEGIN
				BREAK --assume all tokens found
				END
			END 
	      SELECT @token=SUBSTRING(@json, @start+1, @end-1)
	      --now put in the escaped control characters
	      SELECT @token=REPLACE(@token, FromString, ToString)
	      FROM
	        (SELECT           '\b', CHAR(08)
	         UNION ALL SELECT '\f', CHAR(12)
	         UNION ALL SELECT '\n', CHAR(10)
	         UNION ALL SELECT '\r', CHAR(13)
	         UNION ALL SELECT '\t', CHAR(09)
			 UNION ALL SELECT '\"', '"'
	         UNION ALL SELECT '\/', '/'
	        ) substitutions(FromString, ToString)
		SELECT @token=Replace(@token, '\\', '\')
	      SELECT @result=0, @escape=1
	  --Begin to take out any hex escape codes
	      WHILE @escape>0
	        BEGIN
	          SELECT @index=0,
	          --find the next hex escape sequence
	          @escape=PATINDEX('%\x[0-9a-f][0-9a-f][0-9a-f][0-9a-f]%', @token collate SQL_Latin1_General_CP850_Bin)
	          IF @escape>0 --if there is one
	            BEGIN
	              WHILE @index<4 --there are always four digits to a \x sequence   
	                BEGIN
	                  SELECT --determine its value
	                    @result=@result+POWER(16, @index)
	                    *(CHARINDEX(SUBSTRING(@token, @escape+2+3-@index, 1),
	                                @characters)-1), @index=@index+1 ;
	         
	                END
	                -- and replace the hex sequence by its unicode value
	              SELECT @token=STUFF(@token, @escape, 6, NCHAR(@result))
	            END
	        END
	      --now store the string away 
	      INSERT INTO @Strings (StringValue) SELECT @token
	      -- and replace the string with a token
	      SELECT @JSON=STUFF(@json, @start, @end+1,
	                    '@string'+CONVERT(NCHAR(5), @@identity))
	    END
	  -- all strings are now removed. Now we find the first leaf.  
	  WHILE 1=1  --forever until there is nothing more to do
	  BEGIN
	 
	  SELECT @Parent_ID=@Parent_ID+1
	  --find the first object or list by looking for the open bracket
	  SELECT @FirstObject=PATINDEX('%[{[[]%', @json collate SQL_Latin1_General_CP850_Bin)--object or array
	  IF @FirstObject = 0 BREAK
	  IF (SUBSTRING(@json, @FirstObject, 1)='{') 
	    SELECT @NextCloseDelimiterChar='}', @type='object'
	  ELSE 
	    SELECT @NextCloseDelimiterChar=']', @type='array'
	  SELECT @OpenDelimiter=@firstObject
	  WHILE 1=1 --find the innermost object or list...
	    BEGIN
	      SELECT
	        @lenJSON=LEN(@JSON+'|')-1
	  --find the matching close-delimiter proceeding after the open-delimiter
	      SELECT
	        @NextCloseDelimiter=CHARINDEX(@NextCloseDelimiterChar, @json,
	                                      @OpenDelimiter+1)
	  --is there an intervening open-delimiter of either type
	      SELECT @NextOpenDelimiter=PATINDEX('%[{[[]%',
	             RIGHT(@json, @lenJSON-@OpenDelimiter)collate SQL_Latin1_General_CP850_Bin)--object
	      IF @NextOpenDelimiter=0 
	        BREAK
	      SELECT @NextOpenDelimiter=@NextOpenDelimiter+@OpenDelimiter
	      IF @NextCloseDelimiter<@NextOpenDelimiter 
	        BREAK
	      IF SUBSTRING(@json, @NextOpenDelimiter, 1)='{' 
	        SELECT @NextCloseDelimiterChar='}', @type='object'
	      ELSE 
	        SELECT @NextCloseDelimiterChar=']', @type='array'
	      SELECT @OpenDelimiter=@NextOpenDelimiter
	    END
	  ---and parse out the list or Name/value pairs
	  SELECT
	    @contents=SUBSTRING(@json, @OpenDelimiter+1,
	                        @NextCloseDelimiter-@OpenDelimiter-1)
	  SELECT
	    @JSON=STUFF(@json, @OpenDelimiter,
	                @NextCloseDelimiter-@OpenDelimiter+1,
	                '@'+@type+CONVERT(NCHAR(5), @Parent_ID))
	  WHILE (PATINDEX('%[A-Za-z0-9@+.e]%', @contents collate SQL_Latin1_General_CP850_Bin))<>0 
	    BEGIN
	      IF @Type='object' --it will be a 0-n list containing a string followed by a string, number,boolean, or null
	        BEGIN
	          SELECT
	            @SequenceNo=0,@end=CHARINDEX(':', ' '+@contents)--if there is anything, it will be a string-based Name.
	          SELECT  @start=PATINDEX('%[^A-Za-z@][@]%', ' '+@contents collate SQL_Latin1_General_CP850_Bin)--AAAAAAAA
              SELECT @token=RTrim(Substring(' '+@contents, @start+1, @End-@Start-1)),
	            @endofName=PATINDEX('%[0-9]%', @token collate SQL_Latin1_General_CP850_Bin),
	            @param=RIGHT(@token, LEN(@token)-@endofName+1)
	          SELECT
	            @token=LEFT(@token, @endofName-1),
	            @Contents=RIGHT(' '+@contents, LEN(' '+@contents+'|')-@end-1)
	          SELECT  @Name=StringValue FROM @strings
	            WHERE string_id=@param --fetch the Name
	        END
	      ELSE 
	        SELECT @Name=null,@SequenceNo=@SequenceNo+1 
	      SELECT
	        @end=CHARINDEX(',', @contents)-- a string-token, object-token, list-token, number,boolean, or null
                IF @end=0
	        --HR Engineering notation bugfix start
	          IF ISNUMERIC(@contents) = 1
		    SELECT @end = LEN(@contents) + 1
	          Else
	        --HR Engineering notation bugfix end 
		  SELECT  @end=PATINDEX('%[A-Za-z0-9@+.e][^A-Za-z0-9@+.e]%', @contents+' ' collate SQL_Latin1_General_CP850_Bin) + 1
	       SELECT
	        @start=PATINDEX('%[^A-Za-z0-9@+.e][A-Za-z0-9@+.e]%', ' '+@contents collate SQL_Latin1_General_CP850_Bin)
	      --select @start,@end, LEN(@contents+'|'), @contents  
	      SELECT
	        @Value=RTRIM(SUBSTRING(@contents, @start, @End-@Start)),
	        @Contents=RIGHT(@contents+' ', LEN(@contents+'|')-@end)
	      IF SUBSTRING(@value, 1, 7)='@object' 
	        INSERT INTO @hierarchy
	          (Name, SequenceNo, Parent_ID, StringValue, Object_ID, ValueType)
	          SELECT @Name, @SequenceNo, @Parent_ID, SUBSTRING(@value, 8, 5),
	            SUBSTRING(@value, 8, 5), 'object' 
	      ELSE 
	        IF SUBSTRING(@value, 1, 6)='@array' 
	          INSERT INTO @hierarchy
	            (Name, SequenceNo, Parent_ID, StringValue, Object_ID, ValueType)
	            SELECT @Name, @SequenceNo, @Parent_ID, SUBSTRING(@value, 7, 5),
	              SUBSTRING(@value, 7, 5), 'array' 
	        ELSE 
	          IF SUBSTRING(@value, 1, 7)='@string' 
	            INSERT INTO @hierarchy
	              (Name, SequenceNo, Parent_ID, StringValue, ValueType)
	              SELECT @Name, @SequenceNo, @Parent_ID, StringValue, 'string'
	              FROM @strings
	              WHERE string_id=SUBSTRING(@value, 8, 5)
	          ELSE 
	            IF @value IN ('true', 'false') 
	              INSERT INTO @hierarchy
	                (Name, SequenceNo, Parent_ID, StringValue, ValueType)
	                SELECT @Name, @SequenceNo, @Parent_ID, @value, 'boolean'
	            ELSE
	              IF @value='null' 
	                INSERT INTO @hierarchy
	                  (Name, SequenceNo, Parent_ID, StringValue, ValueType)
	                  SELECT @Name, @SequenceNo, @Parent_ID, @value, 'null'
	              ELSE
	                IF PATINDEX('%[^0-9]%', @value collate SQL_Latin1_General_CP850_Bin)>0 
	                  INSERT INTO @hierarchy
	                    (Name, SequenceNo, Parent_ID, StringValue, ValueType)
	                    SELECT @Name, @SequenceNo, @Parent_ID, @value, 'real'
	                ELSE
	                  INSERT INTO @hierarchy
	                    (Name, SequenceNo, Parent_ID, StringValue, ValueType)
	                    SELECT @Name, @SequenceNo, @Parent_ID, @value, 'int'
	      if @Contents=' ' Select @SequenceNo=0
	    END
	  END
	INSERT INTO @hierarchy (Name, SequenceNo, Parent_ID, StringValue, Object_ID, ValueType)
	  SELECT '-',1, NULL, '', @Parent_ID-1, @type
	--
	   RETURN
	END
GO
/****** Object:  UserDefinedFunction [dbo].[ToJSON]    Script Date: 16/10/2019 16:05:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ToJSON]
	(
	      @Hierarchy Hierarchy READONLY
	)
	 
	/*
	the function that takes a Hierarchy table and converts it to a JSON string
	 
	Author: Phil Factor
	Revision: 1.5
	date: 1 May 2014
	why: Added a fix to add a name for a list.
	example:
	 
	Declare @XMLSample XML
	Select @XMLSample='
	  <glossary><title>example glossary</title>
	  <GlossDiv><title>S</title>
	   <GlossList>
	    <GlossEntry id="SGML"" SortAs="SGML">
	     <GlossTerm>Standard Generalized Markup Language</GlossTerm>
	     <Acronym>SGML</Acronym>
	     <Abbrev>ISO 8879:1986</Abbrev>
	     <GlossDef>
	      <para>A meta-markup language, used to create markup languages such as DocBook.</para>
	      <GlossSeeAlso OtherTerm="GML" />
	      <GlossSeeAlso OtherTerm="XML" />
	     </GlossDef>
	     <GlossSee OtherTerm="markup" />
	    </GlossEntry>
	   </GlossList>
	  </GlossDiv>
	 </glossary>'
	 
	DECLARE @MyHierarchy Hierarchy -- to pass the hierarchy table around
	insert into @MyHierarchy select * from dbo.ParseXML(@XMLSample)
	SELECT dbo.ToJSON(@MyHierarchy)
	 
	       */
	RETURNS NVARCHAR(MAX)--JSON documents are always unicode.
	AS
	BEGIN
	  DECLARE
	    @JSON NVARCHAR(MAX),
	    @NewJSON NVARCHAR(MAX),
	    @Where INT,
	    @ANumber INT,
	    @notNumber INT,
	    @indent INT,
	    @ii int,
	    @CrLf CHAR(2)--just a simple utility to save typing!
	      
	  --firstly get the root token into place 
	  SELECT @CrLf=CHAR(13)+CHAR(10),--just CHAR(10) in UNIX
	         @JSON = CASE ValueType WHEN 'array' THEN 
	         +COALESCE('{'+@CrLf+'  "'+NAME+'" : ','')+'[' 
	         ELSE '{' END
	            +@CrLf
	            + case when ValueType='array' and NAME is not null then '  ' else '' end
	            + '@Object'+CONVERT(VARCHAR(5),OBJECT_ID)
	            +@CrLf+CASE ValueType WHEN 'array' THEN
	            case when NAME is null then ']' else '  ]'+@CrLf+'}'+@CrLf end
	                ELSE '}' END
	  FROM @Hierarchy 
	    WHERE parent_id IS NULL AND valueType IN ('object','document','array') --get the root element
	/* now we simply iterat from the root token growing each branch and leaf in each iteration. This won't be enormously quick, but it is simple to do. All values, or name/value pairs withing a structure can be created in one SQL Statement*/
	  Select @ii=1000
	  WHILE @ii>0
	    begin
	    SELECT @where= PATINDEX('%[^[a-zA-Z0-9]@Object%',@json)--find NEXT token
	    if @where=0 BREAK
	    /* this is slightly painful. we get the indent of the object we've found by looking backwards up the string */ 
	    SET @indent=CHARINDEX(char(10)+char(13),Reverse(LEFT(@json,@where))+char(10)+char(13))-1
	    SET @NotNumber= PATINDEX('%[^0-9]%', RIGHT(@json,LEN(@JSON+'|')-@Where-8)+' ')--find NEXT token
	    SET @NewJSON=NULL --this contains the structure in its JSON form
	    SELECT  
	        @NewJSON=COALESCE(@NewJSON+','+@CrLf+SPACE(@indent),'')
	        +case when parent.ValueType='array' then '' else COALESCE('"'+TheRow.NAME+'" : ','') end
	        +CASE TheRow.valuetype
	        WHEN 'array' THEN '  ['+@CrLf+SPACE(@indent+2)
	           +'@Object'+CONVERT(VARCHAR(5),TheRow.[OBJECT_ID])+@CrLf+SPACE(@indent+2)+']' 
	        WHEN 'object' then '  {'+@CrLf+SPACE(@indent+2)
	           +'@Object'+CONVERT(VARCHAR(5),TheRow.[OBJECT_ID])+@CrLf+SPACE(@indent+2)+'}'
	        WHEN 'string' THEN '"'+dbo.JSONEscaped(TheRow.StringValue)+'"'
	        ELSE TheRow.StringValue
	       END 
	     FROM @Hierarchy TheRow 
	     inner join @hierarchy Parent
	     on parent.element_ID=TheRow.parent_ID
	      WHERE TheRow.parent_id= SUBSTRING(@JSON,@where+8, @Notnumber-1)
	     /* basically, we just lookup the structure based on the ID that is appended to the @Object token. Simple eh? */
	    --now we replace the token with the structure, maybe with more tokens in it.
	    Select @JSON=STUFF (@JSON, @where+1, 8+@NotNumber-1, @NewJSON),@ii=@ii-1
	    end
	  return @JSON
	end
GO
/****** Object:  Table [dbo].[almacenamiento.BitacoCambio]    Script Date: 16/10/2019 16:05:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[almacenamiento.BitacoCambio](
	[idBitacoraCambio] [int] IDENTITY(1,1) NOT NULL,
	[idDetalleComplemento] [int] NOT NULL,
	[IdEstado] [int] NOT NULL,
	[FechaCambio] [datetime] NOT NULL,
	[nombreusr] [varchar](100) NULL,
	[correousr] [varchar](150) NULL,
 CONSTRAINT [PK_almacenamiento.BitacoCambio] PRIMARY KEY CLUSTERED 
(
	[idBitacoraCambio] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[almacenamiento.Cadena]    Script Date: 16/10/2019 16:05:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[almacenamiento.Cadena](
	[idDetalleComplemento] [int] IDENTITY(1,1) NOT NULL,
	[idComplemento] [int] NOT NULL,
	[idlocalizacion] [int] NOT NULL,
	[idEstado] [int] NOT NULL,
	[cadena] [varchar](max) NOT NULL,
	[nombreusr] [varchar](100) NULL,
	[correousr] [varchar](150) NULL,
	[idCadenaOriginal] [int] NULL,
 CONSTRAINT [PK_almacenamiento.CrearCadena] PRIMARY KEY CLUSTERED 
(
	[idDetalleComplemento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[almacenamiento.Complemento]    Script Date: 16/10/2019 16:05:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[almacenamiento.Complemento](
	[idComplemento] [int] IDENTITY(1,1) NOT NULL,
	[Complemento] [varchar](60) NOT NULL,
	[nombreusr] [varchar](100) NOT NULL,
	[correousr] [varchar](150) NOT NULL,
	[idEstado] [int] NULL,
 CONSTRAINT [PK_almacenamiento.CrearComplemento] PRIMARY KEY CLUSTERED 
(
	[idComplemento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[almacenamiento.ComplementoLocalizacion]    Script Date: 16/10/2019 16:05:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[almacenamiento.ComplementoLocalizacion](
	[IdComplemento] [int] NOT NULL,
	[idlocalizacion] [int] NOT NULL,
	[idestado] [int] NOT NULL,
 CONSTRAINT [PK_almacenamiento.ComplementoLocalizacion] PRIMARY KEY CLUSTERED 
(
	[IdComplemento] ASC,
	[idlocalizacion] ASC,
	[idestado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[almacenamiento.Estado]    Script Date: 16/10/2019 16:05:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[almacenamiento.Estado](
	[idEstado] [int] IDENTITY(1,1) NOT NULL,
	[Estado] [varchar](15) NOT NULL,
 CONSTRAINT [PK_almacenamiento.Estado] PRIMARY KEY CLUSTERED 
(
	[idEstado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[almacenamiento.Localizacion]    Script Date: 16/10/2019 16:05:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[almacenamiento.Localizacion](
	[idlocalizacion] [int] IDENTITY(1,1) NOT NULL,
	[Localizacion] [nchar](10) NULL,
	[Internacionalizacion] [nchar](10) NULL,
	[idEstado] [int] NOT NULL,
 CONSTRAINT [PK_almacenamiento.Localizacion] PRIMARY KEY CLUSTERED 
(
	[idlocalizacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[almacenamiento.BitacoCambio]  WITH CHECK ADD  CONSTRAINT [FK_almacenamiento.BitacoCambio_almacenamiento.Cadena] FOREIGN KEY([idDetalleComplemento])
REFERENCES [dbo].[almacenamiento.Cadena] ([idDetalleComplemento])
GO
ALTER TABLE [dbo].[almacenamiento.BitacoCambio] CHECK CONSTRAINT [FK_almacenamiento.BitacoCambio_almacenamiento.Cadena]
GO
ALTER TABLE [dbo].[almacenamiento.Cadena]  WITH CHECK ADD  CONSTRAINT [FK_almacenamiento.CrearCadena_almacenamiento.CrearComplemento] FOREIGN KEY([idComplemento])
REFERENCES [dbo].[almacenamiento.Complemento] ([idComplemento])
GO
ALTER TABLE [dbo].[almacenamiento.Cadena] CHECK CONSTRAINT [FK_almacenamiento.CrearCadena_almacenamiento.CrearComplemento]
GO
ALTER TABLE [dbo].[almacenamiento.Cadena]  WITH CHECK ADD  CONSTRAINT [FK_almacenamiento.CrearCadena_almacenamiento.Estado] FOREIGN KEY([idEstado])
REFERENCES [dbo].[almacenamiento.Estado] ([idEstado])
GO
ALTER TABLE [dbo].[almacenamiento.Cadena] CHECK CONSTRAINT [FK_almacenamiento.CrearCadena_almacenamiento.Estado]
GO
ALTER TABLE [dbo].[almacenamiento.Cadena]  WITH CHECK ADD  CONSTRAINT [FK_almacenamiento.CrearCadena_almacenamiento.Localizacion] FOREIGN KEY([idlocalizacion])
REFERENCES [dbo].[almacenamiento.Localizacion] ([idlocalizacion])
GO
ALTER TABLE [dbo].[almacenamiento.Cadena] CHECK CONSTRAINT [FK_almacenamiento.CrearCadena_almacenamiento.Localizacion]
GO
ALTER TABLE [dbo].[almacenamiento.Complemento]  WITH CHECK ADD  CONSTRAINT [FK_almacenamiento.CrearComplemento_almacenamiento.Estado] FOREIGN KEY([idEstado])
REFERENCES [dbo].[almacenamiento.Estado] ([idEstado])
GO
ALTER TABLE [dbo].[almacenamiento.Complemento] CHECK CONSTRAINT [FK_almacenamiento.CrearComplemento_almacenamiento.Estado]
GO
ALTER TABLE [dbo].[almacenamiento.ComplementoLocalizacion]  WITH CHECK ADD  CONSTRAINT [FK_almacenamiento.ComplementoLocalizacion_almacenamiento.Complemento] FOREIGN KEY([IdComplemento])
REFERENCES [dbo].[almacenamiento.Complemento] ([idComplemento])
GO
ALTER TABLE [dbo].[almacenamiento.ComplementoLocalizacion] CHECK CONSTRAINT [FK_almacenamiento.ComplementoLocalizacion_almacenamiento.Complemento]
GO
ALTER TABLE [dbo].[almacenamiento.ComplementoLocalizacion]  WITH CHECK ADD  CONSTRAINT [FK_almacenamiento.ComplementoLocalizacion_almacenamiento.Estado] FOREIGN KEY([idestado])
REFERENCES [dbo].[almacenamiento.Estado] ([idEstado])
GO
ALTER TABLE [dbo].[almacenamiento.ComplementoLocalizacion] CHECK CONSTRAINT [FK_almacenamiento.ComplementoLocalizacion_almacenamiento.Estado]
GO
ALTER TABLE [dbo].[almacenamiento.ComplementoLocalizacion]  WITH CHECK ADD  CONSTRAINT [FK_almacenamiento.ComplementoLocalizacion_almacenamiento.Localizacion] FOREIGN KEY([idlocalizacion])
REFERENCES [dbo].[almacenamiento.Localizacion] ([idlocalizacion])
GO
ALTER TABLE [dbo].[almacenamiento.ComplementoLocalizacion] CHECK CONSTRAINT [FK_almacenamiento.ComplementoLocalizacion_almacenamiento.Localizacion]
GO
/****** Object:  StoredProcedure [dbo].[sp_almacenamientoEliminaComplemento]    Script Date: 16/10/2019 16:05:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Grupo 2
-- Create date: 2019-10-06
-- Description:	Elimina un complemento por identificacion o por nombre
-- =============================================
CREATE PROCEDURE [dbo].[sp_almacenamientoEliminaComplemento] 
	-- Add the parameters for the stored procedure here
	@idComplemento int = NULL,
	@complemento varchar(60) =  NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @eliminado int;
	declare @Resultado varchar(max);
	set @eliminado = 0;


	BEGIN TRY
		IF ((@idComplemento is not null and @idComplemento >0) and @eliminado = 0)
		BEGIN
			if (select count(*) from [dbo].[almacenamiento.Cadena] where idComplemento = @idComplemento) > 0
			BEGIN
				delete [dbo].[almacenamiento.Cadena] where idComplemento = @idComplemento
			END
			delete [dbo].[almacenamiento.Complemento] where idComplemento = @idComplemento
			set @eliminado = 1
		END
		IF (@complemento is not null and @eliminado = 0)
		BEGIN
			IF (select count(*) from [dbo].[almacenamiento.Cadena] where idComplemento = (select top 1 idComplemento from [dbo].[almacenamiento.Complemento] where complemento = @complemento)) > 0
			BEGIN
				delete [dbo].[almacenamiento.Cadena] where idComplemento = (select top 1 idComplemento from [dbo].[almacenamiento.Complemento] where complemento = @complemento)
			END
			delete [dbo].[almacenamiento.Complemento] where Complemento = @complemento
		END
		set @Resultado = '{
							"estado" : "200",
							"mensaje" : "Se ha eliminado el complemento satisfactoriamente"
						  }'
	END TRY		
	BEGIN CATCH
		set @Resultado = ' 
						{
							"estado" : "500",
							"mensaje" : "Ha ocurrido un error al intentar eliminar el complemento"
						}
						'
	END CATCH
    select @Resultado
END
GO
/****** Object:  StoredProcedure [dbo].[sp_almacenamientoEliminarCatalogo]    Script Date: 16/10/2019 16:05:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_almacenamientoEliminarCatalogo]
	@idCatalogo int = null,@localizacion varchar(30) = null,@Internacionalizacion varchar(30) = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @Resultado as varchar(max)
	BEGIN TRY 
		delete [dbo].[almacenamiento.Localizacion]
		where idlocalizacion = @idCatalogo or Localizacion = @localizacion or Internacionalizacion = @Internacionalizacion
		set @Resultado = '{
					 	 "estado": "200",
						 "mensaje":"Se elimino correctamente la Localizacion"
						}
						'

	END TRY
	BEGIN CATCH
		set @Resultado = '{
					 	 "estado": "401",
						 "mensaje":"Error al eliminar el catalogo"
						}
						'
	END CATCH
   
END
GO
/****** Object:  StoredProcedure [dbo].[sp_almacenamientoInsertaCadena]    Script Date: 16/10/2019 16:05:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Grupo 2
-- Create date: 07/10/2019
-- Description:	Inserta una cadena relacionada a un complemento
-- =============================================
CREATE PROCEDURE [dbo].[sp_almacenamientoInsertaCadena]
	-- Recibe el parametro y guarda una cadena de traduccion
	@Complemento varchar(60),@Localizacion varchar(10)= nULL,@internacionalizacion varchar(10)=null,
	@cadena varchar(max),@nombreusr varchar(100),@correousr varchar(150)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @Resultado as varchar(max)
    declare @idComplemento int
	declare @idLocalizacion int
	declare @idEstado int
	

	begin try 
		--Busca el complemento y la localizacion sobre la que se insertara la cadena
		select @idComplemento = idComplemento  from [dbo].[almacenamiento.Complemento] where Complemento = @Complemento
		--La localizacion, puede no existir 
		if (select count(*) from [dbo].[almacenamiento.Localizacion] where (Localizacion = @Localizacion or Internacionalizacion = @internacionalizacion) ) = 0
		begin
			exec [dbo].[sp_almacenamientoInsertaLocalizacion] @Localizacion,@internacionalizacion
		end
		
		select @idLocalizacion = idlocalizacion from [dbo].[almacenamiento.Localizacion] where (Localizacion = @Localizacion or Internacionalizacion = @internacionalizacion) 
		
		--------------------------------------------
		select @idEstado = idEstado from [dbo].[almacenamiento.Estado] where Estado = 'Activo'
		insert into [dbo].[almacenamiento.Cadena] 
		values (@idComplemento,@idLocalizacion,@idEstado,isnull(@cadena,'NA'),@nombreusr,@correousr,Null)

		set @Resultado = '{
					 	 "estado": "200",
						 "mensaje":"Cadena agregada correctamente al complemento "' + @Complemento + 
						'}
						'


	end try
	begin catch
		set @Resultado = '{
					 		 "estado": "401",
							 "mensaje":"Error al Insertar la Cadena"
							}'
	end catch
	select @Resultado
END
GO
/****** Object:  StoredProcedure [dbo].[sp_almacenamientoInsertaComplemento]    Script Date: 16/10/2019 16:05:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_almacenamientoInsertaComplemento]
	-- Add the parameters for the stored procedure here
	@Json varchar(max),@nombreusr varchar(100),@correousr varchar(150),@localizacion as varchar(20) = null,@Estado as varchar(15) =null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		DECLARE @idLocalizacion int
		DECLARE @idEstado int
		DECLARE @resultado varchar(max)
		DECLARE @Complemento varchar(60)
		DECLARE @IdComplemento int
	BEGIN TRY
		
		Select *
		into ##tmpJson
		from parseJSON(@Json)

		select @idEstado = idEstado from [dbo].[almacenamiento.Estado] where Estado = 'Activo'

		select @complemento = StringValue 
		from ##tmpJson
		where Parent_ID = (select Object_ID  from ##tmpJson where Name = 'complementos')
		and Name = 'nombre'

		insert into [dbo].[almacenamiento.Complemento]
		values (@Complemento,@nombreusr,@correousr,@idEstado)

		select @IdComplemento = idComplemento from [dbo].[almacenamiento.Complemento] where Complemento = @complemento

		insert into [dbo].[almacenamiento.ComplementoLocalizacion]
		select @IdComplemento,(select idlocalizacion from [dbo].[almacenamiento.Localizacion] where Localizacion =  StringValue),@idEstado
		from ##tmpJson
		where  Parent_ID = (select Object_ID  from ##tmpJson where Name = 'localizaciones')
		and Name = 'nombre'
					   		 	  
		set @Resultado = ' 
						{
						  "estado": "200",
						  "mensaje": "OK",
						  "data": 
							{
							  "nombre": "Se ha insertado el Complemento Correctamente "							 
							}
						}
					'
	END TRY
	BEGIN CATCH
		set @Resultado = '{
					 	 "estado": "401",
						 "mensaje":"Error al Crear el Complemento"
						}
						'
	end CATCH
    -- Insert statements for procedure here
	SELECT @Resultado
END
GO
/****** Object:  StoredProcedure [dbo].[sp_almacenamientoInsertaEstado]    Script Date: 16/10/2019 16:05:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gupo 1
-- Create date: 06/10/2019
-- Description:	Inserta estado en la tabla de estados, devuelve
-- un string con formato json
-- =============================================
CREATE PROCEDURE [dbo].[sp_almacenamientoInsertaEstado]
	@Estado varchar(25)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @Resultado as varchar(max)
	BEGIN TRY 
		--inserta en la tabla de estados.
		insert into dbo.[almacenamiento.Estado] values(@Estado)
		set @Resultado = ' 
						{
						  "estado": "200",
						  "mensaje": "OK",
						  "data": 
							{
							  "nombre": "' + @Estado +'"							 
							}
						}
					'
	END TRY
	BEGIN CATCH
		set @Resultado = '{
					 	 "estado": "401",
						 "mensaje":"Error al Crear Estado"
						}
						'
	end CATCH
    -- Insert statements for procedure here
	SELECT @Resultado
END
GO
/****** Object:  StoredProcedure [dbo].[sp_almacenamientoInsertaLocalizacion]    Script Date: 16/10/2019 16:05:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Grupo2
-- Create date: 2019-10-06
-- Description:	Se crea el catalogo de localizacion, cuando inserta lo crea como estado activo.
-- =============================================
CREATE PROCEDURE [dbo].[sp_almacenamientoInsertaLocalizacion]
	@localizacion varchar(10) = null, @internacionalizacion varchar(10) = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @IdEstado int
	declare @Resultado as varchar(max)
	BEGIN TRY 
		--Busca el estado activo
		if (select count(*) from [dbo].[almacenamiento.Estado] where Estado = 'Activo') > 0
		begin
			select @IdEstado = idEstado from [dbo].[almacenamiento.Estado] where Estado = 'Activo'
		end
		else
		begin
			exec [dbo].[sp_alamacenamientoInsertaEstado] 'Activo'
		end 

		if (select count(*) from dbo.[almacenamiento.Localizacion] where (Internacionalizacion = @localizacion or Localizacion = @localizacion)) = 0
		--inserta en la tabla de localizcaion.
		begin
			insert into dbo.[almacenamiento.Localizacion] values(@localizacion,@internacionalizacion,@IdEstado)
			set @Resultado = ' 
						{
						  "estado": "200",
						  "mensaje": "OK",
						  "data": 
							{
							  "nombre": "' +isnull( @localizacion,'')+'-' +isnull(@internacionalizacion,'')+'"							 
							}
						}
					'
		 end
		 --else
		 --begin
			-- set @Resultado = ' 
			--			{
			--			  "estado": "200",
			--			  "mensaje": "OK",
			--			  "data": 
			--				{
			--				  "nombre": "Complemento ya existente '+isnull( @localizacion,'')+'-' +isnull(@internacionalizacion,'')+'"
			--				}
			--			}
			--		'
		 --end
	END TRY
	BEGIN CATCH
		set @Resultado = '{
					 	 "estado": "401",
						 "mensaje":"Error al Crear la Localizacion"
						}
						'
	end CATCH
    -- Insert statements for procedure here
	SELECT @Resultado
END
GO
/****** Object:  StoredProcedure [dbo].[sp_almacenamientoInsertaTraduccion]    Script Date: 16/10/2019 16:05:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Grupo 2
-- Create date: 07/10/2019
-- Description:	Inserta una cadena relacionada a un complemento
-- =============================================
CREATE PROCEDURE [dbo].[sp_almacenamientoInsertaTraduccion]
	-- Recibe el parametro y guarda una cadena de traduccion
	@Complemento varchar(60),@Localizacion varchar(10)= nULL,@internacionalizacion varchar(10)=null,
	@cadenaOrginal varchar(max),@cadena varchar(max),@nombreusr varchar(100),@correousr varchar(150)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @Resultado as varchar(max)
    declare @idComplemento int
	declare @idLocalizacion int
	declare @idEstado int
	declare @idlocalizacionorginal int
	declare @idDetalleComplemento int = 0
	

	begin try 
		--Busca el complemento y la localizacion sobre la que se insertara la cadena
		select @idComplemento = idComplemento,@idlocalizacionorginal = idlocalizacion  from [dbo].[almacenamiento.Complemento] where Complemento = @Complemento
		--La localizacion, puede no existir 
		if (select count(*) from [dbo].[almacenamiento.Localizacion] where (Localizacion = @Localizacion or Internacionalizacion = @internacionalizacion) ) = 0
		begin
			exec [dbo].[sp_almacenamientoInsertaLocalizacion] @Localizacion,@internacionalizacion
		end
		
		select @idLocalizacion = idlocalizacion from [dbo].[almacenamiento.Localizacion] where (Localizacion = @Localizacion or Internacionalizacion = @internacionalizacion) 
		-------------------------------------------
		select @idEstado = idEstado from [dbo].[almacenamiento.Estado] where Estado = 'Activo'
		----------------Busca la cadena Original
		select @idDetalleComplemento = idDetalleComplemento from [dbo].[almacenamiento.Cadena] 
		where idcomplemento = @idComplemento 
		and cadena = @cadenaOrginal and idlocalizacion = @idlocalizacionorginal

		--Almacena Cadena Traducida
		if @idDetalleComplemento != 0
		begin
			insert into [dbo].[almacenamiento.Cadena] 
			values (@idComplemento,@idLocalizacion,@idEstado,isnull(@cadena,'NA'),@nombreusr,@correousr,@idDetalleComplemento)

			set @Resultado = '{
					 		 "estado": "200",
							 "mensaje":"Traduccion agregada correctamente al complemento..."' + @Complemento + 
							'}
							'
		end
		else
		begin
			set @Resultado = '{
					 		 "estado": "400",
							 "mensaje":"No existe Cadena Original..."' + @Complemento + 
							'}
							'
		end
	end try
	begin catch
		set @Resultado = '{
					 		 "estado": "401",
							 "mensaje":"Error al Insertar Traduccion..."
							}'
	end catch
	select @Resultado
END
GO
/****** Object:  StoredProcedure [dbo].[sp_almacenamientoObtenerCatalogo]    Script Date: 16/10/2019 16:05:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gupo 1
-- Create date: 06/10/2019
-- Description:	Muestra la tabla de catalogos
-- =============================================
CREATE PROCEDURE [dbo].[sp_almacenamientoObtenerCatalogo]
	@idCatalogo int = null,@localizacion varchar(30) = null,@Internacionalizacion varchar(30) = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @Resultado as varchar(max)
	BEGIN TRY 
		if (@idCatalogo is not null or @localizacion is not null or @Internacionalizacion is not null)
		BEGIN
			SELECT idlocalizacion,Localizacion,Internacionalizacion,Estado 
			FROM [dbo].[almacenamiento.Localizacion] L
			inner join [dbo].[almacenamiento.Estado] E
				on l.idEstado = E.idEstado
			WHERE (L.idlocalizacion = @idCatalogo or Localizacion = @localizacion or Internacionalizacion = @Internacionalizacion)
		END
		ELSE
		BEGIN
			SELECT idlocalizacion,Localizacion,Internacionalizacion,Estado 
			FROM [dbo].[almacenamiento.Localizacion] L
			inner join [dbo].[almacenamiento.Estado] E
				on l.idEstado = E.idEstado
		END
	END TRY
	BEGIN CATCH
		set @Resultado = '{
					 	 "estado": "401",
						 "mensaje":"Error al Desplegar los Catalogos"
						}
						'
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[sp_almacenamientoObtenerComplemento]    Script Date: 16/10/2019 16:05:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Grupo 2
-- Create date: 2019-10-06
-- Description:	Lista de complementos, lo puede hacer por ID o todos
-- =============================================
CREATE PROCEDURE [dbo].[sp_almacenamientoObtenerComplemento]
	-- Add the parameters for the stored procedure here
	@idComplemento int = null,@complemento varchar(60) = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @Resultado as varchar(max)
	BEGIN TRY
		-- Insert statements for procedure here
		IF (@idComplemento is null and @complemento is null)
		BEGIN
			select C.idComplemento,C.Complemento,C.nombreusr,c.correousr,E.Estado,l.Internacionalizacion,
			l.Localizacion
			from [almacenamiento.Complemento] C
			inner join [dbo].[almacenamiento.ComplementoLocalizacion] CL
				on C.idComplemento = CL.idComplemento
			inner join 	[dbo].[almacenamiento.Estado] E
				on e.idEstado = c.idEstado	
			inner join [dbo].[almacenamiento.Localizacion] L
				on l.idlocalizacion = CL.idlocalizacion
		END
		ELSE
		BEGIN
			select C.idComplemento,C.Complemento,C.nombreusr,c.correousr,E.Estado,l.Internacionalizacion,
			l.Localizacion
			from [almacenamiento.Complemento] C
			inner join [dbo].[almacenamiento.ComplementoLocalizacion] CL
				on C.idComplemento = CL.idComplemento
			inner join 	[dbo].[almacenamiento.Estado] E
				on e.idEstado = c.idEstado	
			inner join [dbo].[almacenamiento.Localizacion] L
				on l.idlocalizacion = CL.idlocalizacion
			where C.idComplemento = @idComplemento or C.Complemento = @complemento	
		END
	END TRY
	BEGIN CATCH
			select  '{
					 		 "estado": "401",
							 "mensaje":"Error en la busqueda de complementos"
							}
							'
	END CATCH
	--SELECT @Resultado
END
GO
/****** Object:  StoredProcedure [dbo].[sp_almacenamientoRetornaCadena]    Script Date: 16/10/2019 16:05:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Grupo2
-- Create date: 2019-10-07
-- Description:	Retorna una cadena o todas las cadenas que han cargado al complemento por localizacion
-- =============================================
CREATE PROCEDURE [dbo].[sp_almacenamientoRetornaCadena]
	@Complemento varchar(60),@Cadena varchar(max) = null,@localizacion varchar(20)=NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @Resultado varchar(max)
	declare @idComplemento int
	declare @idLocalizacion int

	select @idComplemento = idComplemento from [dbo].[almacenamiento.Complemento] where Complemento = @Complemento
	if @localizacion is not null
	begin 
		--Envia la localizacion 
		(select top 1 @idLocalizacion = idlocalizacion from [dbo].[almacenamiento.Localizacion] where (Localizacion = @localizacion or Internacionalizacion = @localizacion))
	end
	else
	begin
		--Toma la localizacion original del complemento
		select @idLocalizacion = idlocalizacion from [almacenamiento.Complemento] where Complemento = @Complemento
	end


	BEGIN TRY
	if @Cadena is not null or @Cadena <> ''
		begin 
			select Co.idComplemento,Co.Complemento,Lo.Localizacion,c.cadena
			from [dbo].[almacenamiento.Cadena] C
			inner join [dbo].[almacenamiento.Complemento] Co on C.idComplemento = Co.idComplemento
			inner join [dbo].[almacenamiento.Localizacion] Lo on Lo.idlocalizacion = C.idlocalizacion
			where C.idComplemento = @idComplemento
			and C.idlocalizacion = @idLocalizacion
			and cadena = @Cadena
		end
		else
		begin
			select Co.idComplemento,Co.Complemento,Lo.Localizacion,c.cadena
			from [dbo].[almacenamiento.Cadena] C
			inner join [dbo].[almacenamiento.Complemento] Co on C.idComplemento = Co.idComplemento
			inner join [dbo].[almacenamiento.Localizacion] Lo on Lo.idlocalizacion = C.idlocalizacion
			where C.idComplemento =@idComplemento
			and C.idlocalizacion = @idLocalizacion--(select top 1 idlocalizacion from [dbo].[almacenamiento.Localizacion] where (Localizacion = @localizacion or Internacionalizacion = @localizacion))
		end
	END TRY
	BEGIN CATCH
			set @Resultado = '{
					 		 "estado": "401",
							 "mensaje":"Error al listar complemento"
							}
							'
	END CATCH
	--SELECT @Resultado
END
GO
/****** Object:  StoredProcedure [dbo].[sp_traduccionRevisar]    Script Date: 16/10/2019 16:05:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_traduccionRevisar]
	-- Add the parameters for the stored procedure here
	 @Complemento varchar(60), @LocalizacionTraduccion varchar(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    select C.Complemento,Ca.cadena As CadenaOriginal, C.idlocalizacion IdioOriginal, isnull(ca2.cadena,'No hay traduccion para esta cadena') CadenaTraducida
	,Ca2.nombreusr,ca2.correousr
		from [dbo].[almacenamiento.Complemento] C
		inner join [dbo].[almacenamiento.Cadena] Ca on C.idComplemento = Ca.idComplemento and C.idlocalizacion = Ca.idlocalizacion
		left join [dbo].[almacenamiento.Cadena] Ca2 on C.idComplemento = Ca2.idComplemento 
			and Ca2.idlocalizacion = (select idlocalizacion from [dbo].[almacenamiento.Localizacion] where Localizacion = @LocalizacionTraduccion)
			and Ca2.IdCadenaOriginal = Ca.idDetalleComplemento 
		where Complemento = @Complemento
END
GO
USE [master]
GO
ALTER DATABASE [Almacenamiento] SET  READ_WRITE 
GO

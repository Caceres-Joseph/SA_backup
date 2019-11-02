USE `master`;
 
/****** Object:  Database [Almacenamiento]    Script Date: 16/10/2019 16:05:23 ******/
CREATE DATABASE Almacenamiento
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Traduccion', FILENAME = N'C:Program FilesMicrosoft SQL ServerMSSQL11.MSSQLSERVERMSSQLDATATraduccion.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Traduccion_log', FILENAME = N'C:Program FilesMicrosoft SQL ServerMSSQL11.MSSQLSERVERMSSQLDATATraduccion_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE `Almacenamiento` SET COMPATIBILITY_LEVEL = 110;
 
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
then
CALL `Almacenamiento`.`dbo` v_action; = 'enable'
end if;
 
ALTER DATABASE `Almacenamiento` SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE `Almacenamiento` /* SET ANSI_NULLS OFF */ 
 
ALTER DATABASE `Almacenamiento` /* SET ANSI_PADDING OFF */ 
 
ALTER DATABASE `Almacenamiento` SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE `Almacenamiento` SET ARITHABORT OFF 
GO
ALTER DATABASE `Almacenamiento` SET AUTO_CLOSE OFF 
GO
ALTER DATABASE `Almacenamiento` SET AUTO_SHRINK OFF 
GO
ALTER DATABASE `Almacenamiento` SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE `Almacenamiento` SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE `Almacenamiento` SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE `Almacenamiento` SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE `Almacenamiento` SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE `Almacenamiento` /* SET QUOTED_IDENTIFIER OFF */ 
 
ALTER DATABASE `Almacenamiento` SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE `Almacenamiento` SET  DISABLE_BROKER 
GO
ALTER DATABASE `Almacenamiento` SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE `Almacenamiento` SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE `Almacenamiento` SET TRUSTWORTHY OFF 
GO
ALTER DATABASE `Almacenamiento` SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE `Almacenamiento` SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE `Almacenamiento` SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE `Almacenamiento` SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE `Almacenamiento` SET RECOVERY FULL 
GO
ALTER DATABASE `Almacenamiento` SET  MULTI_USER 
GO
ALTER DATABASE `Almacenamiento` SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE `Almacenamiento` SET DB_CHAINING OFF 
GO
ALTER DATABASE `Almacenamiento` SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE `Almacenamiento` SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
CALL sys.sp_db_vardecimal_storage_format( N'Almacenamiento', N'ON');
 
USE `Almacenamiento`;
 
/****** Object:  UserDefinedTableType [dbo].[Hierarchy]    Script Date: 16/10/2019 16:05:23 ******/
CREATE TYPE [dbo].[Hierarchy] AS TABLE(
	[element_id] [int] NOT NULL,
	`sequenceNo` `int` NULL,
	`parent_ID` `int` NULL,
	`Object_ID` `int` NULL,
	`NAME` [nvarchar](2000) NULL,
	`StringValue` [nvarchar](max) NOT NULL,
	`ValueType` [varchar](10) NOT NULL,
	PRIMARY KEY CLUSTERED 
(
	`element_id` ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO
/****** Object:  UserDefinedFunction [dbo].[fn_JWT_ReturnSecret]    Script Date: 16/10/2019 16:05:23 ******/
/* SET ANSI_NULLS ON */
 
/* SET QUOTED_IDENTIFIER ON */
 

-- =============================================
-- Author:		<Estudiantes Laboratorio SA Segundo semestre 2019>
-- Create date: <26/09/2019>
-- Description:	<Funcion para ecriptar password>
-- Version: <1.0.0>
-- =============================================
delimiter //

create FUNCTION fn_JWT_ReturnSecret
(
	-- Add the parameters for the function here
	p_Password as varchar(25)
//

DELIMITER ;

,@TipoEncript as varchar(3)
)
RETURNS varchar(25)
AS
BEGIN
	-- Declare the return variable here
	DECLARE v_Encript varchar(25)


	set v_Encript = case 
					when @TipoEncript = 'MD5'
						then   SUBSTRING(master.dbo.fn_varbintohexstr(HashBytes('MD5', @Password)), 3, 32)
					when @TipoEncript = 'SHA'
						then   SUBSTRING(master.dbo.fn_varbintohexstr(HashBytes('SHA',@Password)), 3, 40)
					when @TipoEncript = 'SH1'
						then SUBSTRING(master.dbo.fn_varbintohexstr(HashBytes('SHA1', @Password)), 3, 40)
				end
		

	-- Return the result of the function
	RETURN v_Encript

END

GO
/****** Object:  UserDefinedFunction [dbo].[JSONEscaped]    Script Date: 16/10/2019 16:05:23 ******/
/* SET ANSI_NULLS ON */
 
/* SET QUOTED_IDENTIFIER ON */
 
 
DELIMITER //

CREATE FUNCTION JSONEscaped ( /* this is a simple utility function that takes a SQL String with all its clobber and outputs it as a sting with all the JSON escape sequences in it.*/
 p_Unescaped LONGTEXT -- a string with maybe characters that will break json
 )
RETURNS LONGTEXT
BEGIN
  SELECT REPLACE(p_Unescaped, FROMString, TOString) INTO p_Unescaped
  FROM (SELECT '' AS FromString, '' AS ToString 
        UNION ALL SELECT '"', '"' 
        UNION ALL SELECT '/', '/'
        UNION ALL SELECT CHR(08),'b'
        UNION ALL SELECT CHR(12),'f'
        UNION ALL SELECT CHR(10),'n'
        UNION ALL SELECT CHR(13),'r'
        UNION ALL SELECT CHR(09),'t'
 ) substitutions;
RETURN p_Unescaped;
END;
//

DELIMITER ;


 
/****** Object:  UserDefinedFunction [dbo].[parseJSON]    Script Date: 16/10/2019 16:05:23 ******/
/* SET ANSI_NULLS ON */
 
/* SET QUOTED_IDENTIFIER ON */
 
delimiter //

create FUNCTION parseJSON( p_JSON LONGTEXT)
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
	   Element_ID
   	//

DELIMITER ;

 INT IDENTITY(1, 1) NOT NULL, /* internal surrogate primary key gives the order of parsing and the list order */
	   SequenceNo `int` NULL, /* the place in the sequence for the element */
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
	    v_FirstObject INT; -- the index of the first open bracket found in the JSON string
	    DECLARE v_OpenDelimiter INT;-- the index of the next open bracket found in the JSON string
	    DECLARE v_NextOpenDelimiter INT;-- the index of subsequent open bracket found in the JSON string
	    DECLARE v_NextCloseDelimiter INT;-- the index of subsequent close bracket found in the JSON string
	    DECLARE v_Type NVARCHAR(10);-- whether it denotes an object or an array
	    DECLARE v_NextCloseDelimiterChar CHAR(1);-- either a '}' or a ']'
	    DECLARE v_Contents LONGTEXT; -- the unparsed contents of the bracketed expression
	    DECLARE v_Start INT; -- index of the start of the token that you are parsing
	    DECLARE v_end INT;-- index of the end of the token that you are parsing
	    DECLARE v_param INT;-- the parameter at the end of the next Object/Array token
	    DECLARE v_EndOfName INT;-- the index of the start of the parameter at end of Object/Array token
	    DECLARE v_token NVARCHAR(200);-- either a string or object
	    DECLARE v_value LONGTEXT; -- the value as a string
	    DECLARE v_SequenceNo int; -- the sequence number within a list
	    DECLARE v_Name NVARCHAR(200); -- the Name as a string
	    DECLARE v_Parent_ID INT;-- the next parent ID to allocate
	    DECLARE v_lenJSON INT;-- the current length of the JSON String
	    DECLARE v_characters NCHAR(36);-- used to convert hex to decimal
	    DECLARE v_result BIGINT;-- the value of the hex symbol being parsed
	    DECLARE v_index SMALLINT;-- used for parsing the hex value
	    DECLARE v_Escape INT -- the index of the next escape character
	    
	  DROP TEMPORARY TABLE IF EXISTS @Strings;
  	CREATE TEMPORARY TABLE @Strings /* in this temporary table we keep all strings, even the Names of the elements, since they are 'escaped' in a different way, and may contain, unescaped, brackets denoting objects or lists. These are replaced in the JSON string by tokens representing the string */
	    (
	     String_ID INT AUTO_INCREMENT,
	     StringValue LONGTEXT
	    )
	  SET-- initialise the characters to convert hex to ascii
	    v_characters='0123456789abcdefghijklmnopqrstuvwxyz',
	    v_SequenceNo=0, -- set the sequence no. to something sensible.
	  /* firstly we process all strings. This is done because [{} and ] aren't escaped in strings, which complicates an iterative parse. */
	    v_Parent_ID=0;
	  WHILE 1=1 -- forever until there is nothing more to do
	    DO
	      SET
	        v_Start=PATINDEX('%[^a-zA-Z]["]%', @json collate SQL_Latin1_General_CP850_Bin);-- next delimited string
	      IF v_Start=0 THEN BREAK
      	END IF; -- no more so drop through the WHILE loop
	      IF SUBSTRING(@json, v_Start+1, 1)='"' 
	        THEN -- Delimited Name
	          SET v_Start=v_Start+1;
	          SET v_end=PATINDEX('%[^]["]%', RIGHT(@json, CHAR_LENGTH(RTRIM(Concat(@json,'|')))-v_Start); collate SQL_Latin1_General_CP850_Bin);
	        END IF;
	      IF v_end=0 -- either the end or no end delimiter to last string
	        THEN-- check if ending with a double slash...
             SET v_end=PATINDEX('%[][]["]%', RIGHT(@json, CHAR_LENGTH(RTRIM(Concat(@json,'|')))-v_Start); collate SQL_Latin1_General_CP850_Bin);
 		     IF v_end=0 -- we really have reached the end 
				THEN
				BREAK -- assume all tokens found
				END IF;
			END IF; 
	      SET v_token=SUBSTRING(@json, v_Start+1, v_end-1)
	      -- now put in the escaped control characters
	      SELECT REPLACE(v_token, FromString, ToString) INTO v_token
	      FROM
	        (SELECT           'b', CHR(08)
	         UNION ALL SELECT 'f', CHR(12)
	         UNION ALL SELECT 'n', CHR(10)
	         UNION ALL SELECT 'r', CHR(13)
	         UNION ALL SELECT 't', CHR(09)
			 UNION ALL SELECT '"', '"'
	         UNION ALL SELECT '/', '/'
	        ) substitutions(FromString, ToString)
		SET v_token=Replace(v_token, '\', '')
	      SET v_result=0, v_Escape=1
	  -- Begin to take out any hex escape codes
	      WHILE v_Escape>0
	        BEGIN
	          SET v_index=0,
	          -- find the next hex escape sequence
	          v_Escape=PATINDEX('%x[0-9a-f][0-9a-f][0-9a-f][0-9a-f]%', v_token collate SQL_Latin1_General_CP850_Bin)
	          IF v_Escape>0 -- if there is one
	            THEN
	              WHILE v_index<4 -- there are always four digits to a x sequence   
	                DO
	                  SET -- determine its value
	                    v_result=v_result+POWER(16, v_index)
	                    *(CHARINDEX(SUBSTRING(v_token, v_Escape+2+3-v_index, 1),
	                                v_characters)-1), v_index=v_index+1 ;
	         
	                END WHILE;
	                -- and replace the hex sequence by its unicode value
	              SET v_token=INSERT(v_token, v_Escape, 6, NCHAR(v_result));
	            END IF;
	        END;
	      -- now store the string away 
	      INSERT INTO @Strings (StringValue) SELECT v_token
	      -- and replace the string with a token
	      SET @JSON=INSERT(@json, v_Start, v_end+1,
	                    Concat('@string',CONVERT(NCHAR)(5), @@identity))
	    END
	  -- all strings are now removed. Now we find the first leaf.  
	  WHILE 1=1  -- forever until there is nothing more to do
	  BEGIN
	 
	  SET v_Parent_ID=v_Parent_ID+1
	  -- find the first object or list by looking for the open bracket
	  SET v_FirstObject=PATINDEX('%[{[[]%', @json collate SQL_Latin1_General_CP850_Bin)-- object or array
	  IF v_FirstObject = 0 THEN BREAK
  	END IF;
	  IF (SUBSTRING(@json, v_FirstObject, 1)='{') THEN 
	    SET v_NextCloseDelimiterChar='}', v_Type='object';
	  ELSE 
	    SET v_NextCloseDelimiterChar=']', v_Type='array';
  	END IF;
	  SET v_OpenDelimiter=v_FirstObject
	  WHILE 1=1 -- find the innermost object or list...
	    BEGIN
	      SET
	        v_lenJSON=CHAR_LENGTH(RTRIM(CONCAT(@JSON,'|')))-1
	  -- find the matching close-delimiter proceeding after the open-delimiter
	      SET
	        v_NextCloseDelimiter=CHARINDEX(v_NextCloseDelimiterChar, @json,
	                                      v_OpenDelimiter+1)
	  -- is there an intervening open-delimiter of either type
	      SET v_NextOpenDelimiter=PATINDEX('%[{[[]%',
	             RIGHT(@json, v_lenJSON-v_OpenDelimiter)collate SQL_Latin1_General_CP850_Bin)-- object
	      IF v_NextOpenDelimiter=0 THEN 
	        BREAK
      	END IF;
	      SET v_NextOpenDelimiter=v_NextOpenDelimiter+v_OpenDelimiter
	      IF v_NextCloseDelimiter<v_NextOpenDelimiter THEN 
	        BREAK
      	END IF;
	      IF SUBSTRING(@json, v_NextOpenDelimiter, 1)='{' THEN 
	        SET v_NextCloseDelimiterChar='}', v_Type='object';
	      ELSE 
	        SET v_NextCloseDelimiterChar=']', v_Type='array';
      	END IF;
	      SET v_OpenDelimiter=v_NextOpenDelimiter
	    END
	  -- -and parse out the list or Name/value pairs
	  SET
	    v_Contents=SUBSTRING(@json, v_OpenDelimiter+1,
	                        v_NextCloseDelimiter-v_OpenDelimiter-1)
	  SET
	    @JSON=INSERT(@json, v_OpenDelimiter,
	                v_NextCloseDelimiter-v_OpenDelimiter+1,
	                Concat('@',v_Type+CONVERT(NCHAR)(5), v_Parent_ID))
	  WHILE (PATINDEX('%[A-Za-z0-9@+.e]%', v_Contents collate SQL_Latin1_General_CP850_Bin))<>0 
	    BEGIN
	      IF v_Type='object' -- it will be a 0-n list containing a string followed by a string, number,boolean, or null
	        THEN
	          SET
	            v_SequenceNo=0,v_end=CHARINDEX(':', Concat(' ',v_Contents));-- if there is anything, it will be a string-based Name.
	          SET  v_Start=PATINDEX('%[^A-Za-z@][@]%', Concat(' ',v_Contents) collate; SQL_Latin1_General_CP850_Bin)-- AAAAAAAA
              SET v_token=RTrim(Substring(Concat(' ',v_Contents), v_Start+1, v_end-v_Start-1)),
	            v_EndOfName=PATINDEX('%[0-9]%', v_token collate; SQL_Latin1_General_CP850_Bin),
	            v_param=RIGHT(v_token, CHAR_LENGTH(RTRIM(v_token))-v_EndOfName+1)
	          SET
	            v_token=LEFT(v_token, v_EndOfName-1),
	            v_Contents=RIGHT(Concat(' ',v_Contents), CHAR_LENGTH(RTRIM(Concat(' ',v_Contents,'|')))-v_end-1);
	          SELECT  StringValue INTO v_Name FROM @strings
	            WHERE string_id=v_param; -- fetch the Name
	      ELSE 
	        SET v_Name=null,v_SequenceNo=v_SequenceNo+1;
      	END IF; 
	      SET
	        v_end=CHARINDEX(',', v_Contents)-- a string-token, object-token, list-token, number,boolean, or null
                IF v_end=0 THEN
	        -- HR Engineering notation bugfix start
	          IF ISNUMERIC(v_Contents) = 1 THEN
		    SET v_end = CHAR_LENGTH(RTRIM(v_Contents)) + 1;
	          Else
	        -- HR Engineering notation bugfix end 
		  SET  v_end=PATINDEX('%[A-Za-z0-9@+.e][^A-Za-z0-9@+.e]%', Concat(v_Contents,' ') collate;
          	END IF;
                END IF; SQL_Latin1_General_CP850_Bin) + 1
	       SET
	        v_Start=PATINDEX('%[^A-Za-z0-9@+.e][A-Za-z0-9@+.e]%', Concat(' ',v_Contents) collate SQL_Latin1_General_CP850_Bin)
	      -- select @start,@end, LEN(@contents+'|'), @contents  
	      SET
	        v_value=RTRIM(SUBSTRING(v_Contents, v_Start, v_end-v_Start)),
	        v_Contents=RIGHT(Concat(v_Contents,' '), CHAR_LENGTH(RTRIM(Concat(v_Contents,'|')))-v_end)
	      IF SUBSTRING(v_value, 1, 7)='@object' THEN 
	        INSERT INTO @hierarchy
	          (Name, SequenceNo, Parent_ID, StringValue, Object_ID, ValueType)
	          SELECT v_Name, v_SequenceNo, v_Parent_ID, SUBSTRING(v_value, 8, 5),
	            SUBSTRING(v_value, 8, 5), 'object'; 
	      ELSEIF 
	        SUBSTRING(v_value, 1, 6)='@array' THEN 
	          INSERT INTO @hierarchy
	            (Name, SequenceNo, Parent_ID, StringValue, Object_ID, ValueType)
	            SELECT v_Name, v_SequenceNo, v_Parent_ID, SUBSTRING(v_value, 7, 5),
	              SUBSTRING(v_value, 7, 5), 'array'; 
	        ELSEIF 
	          SUBSTRING(v_value, 1, 7)='@string' THEN 
	            INSERT INTO @hierarchy
	              (Name, SequenceNo, Parent_ID, StringValue, ValueType)
	              SELECT v_Name, v_SequenceNo, v_Parent_ID, StringValue, 'string'
	              FROM @strings
	              WHERE string_id=SUBSTRING(v_value, 8, 5);
	          ELSEIF 
	            v_value IN ('true', 'false') THEN 
	              INSERT INTO @hierarchy
	                (Name, SequenceNo, Parent_ID, StringValue, ValueType)
	                SELECT v_Name, v_SequenceNo, v_Parent_ID, v_value, 'boolean';
	            ELSEIF
	              v_value='null' THEN 
	                INSERT INTO @hierarchy
	                  (Name, SequenceNo, Parent_ID, StringValue, ValueType)
	                  SELECT v_Name, v_SequenceNo, v_Parent_ID, v_value, 'null';
	              ELSEIF
	                PATINDEX('%[^0-9]%', v_value THEN collate
      	END IF; SQL_Latin1_General_CP850_Bin)>0 
	                  INSERT INTO @hierarchy
	                    (Name, SequenceNo, Parent_ID, StringValue, ValueType)
	                    SELECT v_Name, v_SequenceNo, v_Parent_ID, v_value, 'real'
	                ELSE
	                  INSERT INTO @hierarchy
	                    (Name, SequenceNo, Parent_ID, StringValue, ValueType)
	                    SELECT v_Name, v_SequenceNo, v_Parent_ID, v_value, 'int'
	      if v_Contents=' ' then Set v_SequenceNo=0;
      	end if;
	    END;
	  END WHILE
	INSERT INTO @hierarchy (Name, SequenceNo, Parent_ID, StringValue, Object_ID, ValueType)
	  SELECT '-',1, NULL, '', v_Parent_ID-1, v_Type
	-- 
	   RETURN
	END
GO
/****** Object:  UserDefinedFunction [dbo].[ToJSON]    Script Date: 16/10/2019 16:05:23 ******/
/* SET ANSI_NULLS ON */
 
/* SET QUOTED_IDENTIFIER ON */
 
DELIMITER //

CREATE FUNCTION ToJSON
	(
	      p_Hierarchy Hierarchy READONLY
	)
	//

DELIMITER ;


	 
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
	RETURNS NVARCHAR(MAX)-- JSON documents are always unicode.
	AS
	BEGIN
	  DECLARE
	    v_JSON LONGTEXT;
	    DECLARE v_NewJSON LONGTEXT;
	    DECLARE v_Where INT;
	    DECLARE v_ANumber INT;
	    DECLARE v_notNumber INT;
	    DECLARE v_indent INT;
	    DECLARE v_ii int;
	    DECLARE v_CrLf CHAR(2)-- just a simple utility to save typing!
	      
	  -- firstly get the root token into place 
	  SELECT CHR(13)+CHR(10),-- just CHAR(10) in UNIX
	         CASE ValueType WHEN 'array' THEN 
	         CONCAT(+COALESCE(Concat('{',v_CrLf,'  "',NAME,'" : '),''),'[') 
	         ELSE '{' END
	            +v_CrLf
	            + case when ValueType='array' and NAME is not null then '  ' else '' end
	            , '@Object',CONVERT(VARCHAR(5),OBJECT_ID)
	            +v_CrLf+CASE ValueType WHEN 'array' THEN
	            case when NAME is null then ']' else Concat('  ]',v_CrLf,'}',v_CrLf) end
	                ELSE '}' END INTO v_CrLf, v_JSON
	  FROM @Hierarchy 
	    WHERE parent_id IS NULL AND valueType IN ('object','document','array') -- get the root element
	/* now we simply iterat from the root token growing each branch and leaf in each iteration. This won't be enormously quick, but it is simple to do. All values, or name/value pairs withing a structure can be created in one SQL Statement*/
	  Set v_ii=1000
	  WHILE v_ii>0
	    begin
	    SET v_Where= PATINDEX('%[^[a-zA-Z0-9]@Object%',v_JSON)-- find NEXT token
	    if v_Where=0 then BREAK
    	end if;
	    /* this is slightly painful. we get the indent of the object we've found by looking backwards up the string */ 
	    SET v_indent=CHARINDEX(chr(10)+chr(13),Reverse(LEFT(v_JSON,v_Where))+chr(10)+chr(13))-1
	    SET v_notNumber= PATINDEX('%[^0-9]%', CONCAT(RIGHT(v_JSON,CHAR_LENGTH(RTRIM(CONCAT(v_JSON,'|')))-v_Where-8),' '))-- find NEXT token
	    SET v_NewJSON=NULL -- this contains the structure in its JSON form
	    SELECT  
	        COALESCE(CONCAT(v_NewJSON,',',v_CrLf+SPACE(v_indent)),'')
	        +case when parent.ValueType='array' then '' else COALESCE(Concat('"',TheRow.NAME,'" : '),'') end
	        +CASE TheRow.valuetype
	        WHEN 'array' THEN Concat('  [',v_CrLf+SPACE(v_indent+2)
	           ,'@Object',CONVERT(VARCHAR(5),TheRow.[OBJECT_ID])+v_CrLf+SPACE(v_indent+2),']') 
	        WHEN 'object' then Concat('  {',v_CrLf+SPACE(v_indent+2)
	           ,'@Object',CONVERT(VARCHAR(5),TheRow.[OBJECT_ID])+v_CrLf+SPACE(v_indent+2),'}')
	        WHEN 'string' THEN Concat('"',dbo.JSONEscaped(TheRow.StringValue),'"')
	        ELSE TheRow.StringValue
	       END INTO v_NewJSON 
	     FROM @Hierarchy TheRow 
	     inner join @hierarchy Parent
	     on parent.element_ID=TheRow.parent_ID
	      WHERE TheRow.parent_id= SUBSTRING(v_JSON,v_Where+8, v_notNumber-1)
	     /* basically, we just lookup the structure based on the ID that is appended to the @Object token. Simple eh? */
	    -- now we replace the token with the structure, maybe with more tokens in it.
	    Set v_JSON=INSERT (v_JSON, v_Where+1, 8+v_notNumber-1, v_NewJSON),v_ii=v_ii-1
	    end
	  return v_JSON
	end
GO
/****** Object:  Table [dbo].[almacenamiento.BitacoCambio]    Script Date: 16/10/2019 16:05:23 ******/
/* SET ANSI_NULLS ON */
 
/* SET QUOTED_IDENTIFIER ON */
 
CREATE TABLE [almacenamiento(
	`idBitacoraCambio` int AUTO_INCREMENT NOT NULL,
	`idDetalleComplemento` int NOT NULL,
	`IdEstado` int NOT NULL,
	`FechaCambio` datetime(3) NOT NULL,
	`nombreusr` varchar(100) NULL,
	`correousr` varchar(150) NULL,
 CONSTRAINT `PK_almacenamiento.BitacoCambio` PRIMARY KEY 
(
	`idBitacoraCambio` ASC
) 
);
/****** Object:  Table [dbo].[almacenamiento.Cadena]    Script Date: 16/10/2019 16:05:23 ******/
/* SET ANSI_NULLS ON */
 
/* SET QUOTED_IDENTIFIER ON */
 
CREATE TABLE [almacenamiento(
	`idDetalleComplemento` int AUTO_INCREMENT NOT NULL,
	`idComplemento` int NOT NULL,
	`idlocalizacion` int NOT NULL,
	`idEstado` int NOT NULL,
	`cadena` Longtext NOT NULL,
	`nombreusr` varchar(100) NULL,
	`correousr` varchar(150) NULL,
	`idCadenaOriginal` int NULL,
 CONSTRAINT `PK_almacenamiento.CrearCadena` PRIMARY KEY 
(
	`idDetalleComplemento` ASC
) 
); TEXTIMAGE_ON `PRIMARY`
GO
/****** Object:  Table [dbo].[almacenamiento.Complemento]    Script Date: 16/10/2019 16:05:23 ******/
/* SET ANSI_NULLS ON */
 
/* SET QUOTED_IDENTIFIER ON */
 
CREATE TABLE [almacenamiento(
	`idComplemento` int AUTO_INCREMENT NOT NULL,
	`Complemento` varchar(60) NOT NULL,
	`nombreusr` varchar(100) NOT NULL,
	`correousr` varchar(150) NOT NULL,
	`idEstado` int NULL,
 CONSTRAINT `PK_almacenamiento.CrearComplemento` PRIMARY KEY 
(
	`idComplemento` ASC
) 
);
/****** Object:  Table [dbo].[almacenamiento.ComplementoLocalizacion]    Script Date: 16/10/2019 16:05:23 ******/
/* SET ANSI_NULLS ON */
 
/* SET QUOTED_IDENTIFIER ON */
 
CREATE TABLE [almacenamiento(
	`IdComplemento` int NOT NULL,
	`idlocalizacion` int NOT NULL,
	`idestado` int NOT NULL,
 CONSTRAINT `PK_almacenamiento.ComplementoLocalizacion` PRIMARY KEY 
(
	`IdComplemento` ASC,
	`idlocalizacion` ASC,
	`idestado` ASC
) 
);
/****** Object:  Table [dbo].[almacenamiento.Estado]    Script Date: 16/10/2019 16:05:23 ******/
/* SET ANSI_NULLS ON */
 
/* SET QUOTED_IDENTIFIER ON */
 
CREATE TABLE [almacenamiento(
	`idEstado` int AUTO_INCREMENT NOT NULL,
	`Estado` varchar(15) NOT NULL,
 CONSTRAINT `PK_almacenamiento.Estado` PRIMARY KEY 
(
	`idEstado` ASC
) 
);
/****** Object:  Table [dbo].[almacenamiento.Localizacion]    Script Date: 16/10/2019 16:05:23 ******/
/* SET ANSI_NULLS ON */
 
/* SET QUOTED_IDENTIFIER ON */
 
CREATE TABLE [almacenamiento(
	`idlocalizacion` int AUTO_INCREMENT NOT NULL,
	`Localizacion` nchar(10) NULL,
	`Internacionalizacion` nchar(10) NULL,
	`idEstado` int NOT NULL,
 CONSTRAINT `PK_almacenamiento.Localizacion` PRIMARY KEY 
(
	`idlocalizacion` ASC
) 
);
ALTER TABLE `dbo`.`almacenamiento.BitacoCambio`  WITH CHECK ADD  CONSTRAINT `FK_almacenamiento.BitacoCambio_almacenamiento.Cadena` FOREIGN KEY(`idDetalleComplemento`)
REFERENCES [dbo].[almacenamiento.Cadena] (`idDetalleComplemento`)
GO
ALTER TABLE `dbo`.`almacenamiento.BitacoCambio` CHECK CONSTRAINT `FK_almacenamiento.BitacoCambio_almacenamiento.Cadena`
GO
ALTER TABLE `dbo`.`almacenamiento.Cadena`  WITH CHECK ADD  CONSTRAINT `FK_almacenamiento.CrearCadena_almacenamiento.CrearComplemento` FOREIGN KEY(`idComplemento`)
REFERENCES [dbo].[almacenamiento.Complemento] (`idComplemento`)
GO
ALTER TABLE `dbo`.`almacenamiento.Cadena` CHECK CONSTRAINT `FK_almacenamiento.CrearCadena_almacenamiento.CrearComplemento`
GO
ALTER TABLE `dbo`.`almacenamiento.Cadena`  WITH CHECK ADD  CONSTRAINT `FK_almacenamiento.CrearCadena_almacenamiento.Estado` FOREIGN KEY(`idEstado`)
REFERENCES [dbo].[almacenamiento.Estado] (`idEstado`)
GO
ALTER TABLE `dbo`.`almacenamiento.Cadena` CHECK CONSTRAINT `FK_almacenamiento.CrearCadena_almacenamiento.Estado`
GO
ALTER TABLE `dbo`.`almacenamiento.Cadena`  WITH CHECK ADD  CONSTRAINT `FK_almacenamiento.CrearCadena_almacenamiento.Localizacion` FOREIGN KEY(`idlocalizacion`)
REFERENCES [dbo].[almacenamiento.Localizacion] (`idlocalizacion`)
GO
ALTER TABLE `dbo`.`almacenamiento.Cadena` CHECK CONSTRAINT `FK_almacenamiento.CrearCadena_almacenamiento.Localizacion`
GO
ALTER TABLE `dbo`.`almacenamiento.Complemento`  WITH CHECK ADD  CONSTRAINT `FK_almacenamiento.CrearComplemento_almacenamiento.Estado` FOREIGN KEY(`idEstado`)
REFERENCES [dbo].[almacenamiento.Estado] (`idEstado`)
GO
ALTER TABLE `dbo`.`almacenamiento.Complemento` CHECK CONSTRAINT `FK_almacenamiento.CrearComplemento_almacenamiento.Estado`
GO
ALTER TABLE `dbo`.`almacenamiento.ComplementoLocalizacion`  WITH CHECK ADD  CONSTRAINT `FK_almacenamiento.ComplementoLocalizacion_almacenamiento.Complemento` FOREIGN KEY(`IdComplemento`)
REFERENCES [dbo].[almacenamiento.Complemento] (`idComplemento`)
GO
ALTER TABLE `dbo`.`almacenamiento.ComplementoLocalizacion` CHECK CONSTRAINT `FK_almacenamiento.ComplementoLocalizacion_almacenamiento.Complemento`
GO
ALTER TABLE `dbo`.`almacenamiento.ComplementoLocalizacion`  WITH CHECK ADD  CONSTRAINT `FK_almacenamiento.ComplementoLocalizacion_almacenamiento.Estado` FOREIGN KEY(`idestado`)
REFERENCES [dbo].[almacenamiento.Estado] (`idEstado`)
GO
ALTER TABLE `dbo`.`almacenamiento.ComplementoLocalizacion` CHECK CONSTRAINT `FK_almacenamiento.ComplementoLocalizacion_almacenamiento.Estado`
GO
ALTER TABLE `dbo`.`almacenamiento.ComplementoLocalizacion`  WITH CHECK ADD  CONSTRAINT `FK_almacenamiento.ComplementoLocalizacion_almacenamiento.Localizacion` FOREIGN KEY(`idlocalizacion`)
REFERENCES [dbo].[almacenamiento.Localizacion] (`idlocalizacion`)
GO
ALTER TABLE `dbo`.`almacenamiento.ComplementoLocalizacion` CHECK CONSTRAINT `FK_almacenamiento.ComplementoLocalizacion_almacenamiento.Localizacion`
GO
/****** Object:  StoredProcedure [dbo].[sp_almacenamientoEliminaComplemento]    Script Date: 16/10/2019 16:05:24 ******/
/* SET ANSI_NULLS ON */
 
/* SET QUOTED_IDENTIFIER ON */
 
-- =============================================
-- Author:		Grupo 2
-- Create date: 2019-10-06
-- Description:	Elimina un complemento por identificacion o por nombre
-- =============================================
DELIMITER //

CREATE PROCEDURE sp_almacenamientoEliminaComplemento ( 
	-- Add the parameters for the stored procedure here
	p_idComplemento int /* = NULL */,
	p_complemento varchar(60) /* =  NULL */)
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	declare v_eliminado int;
	declare v_Resultado longtext;
	set v_eliminado = 0;


	BEGIN TRY
		IF ((p_idComplemento is not null and p_idComplemento >0) and v_eliminado = 0)
		THEN
			if (select count(*) from [almacenamiento where idComplemento = p_idComplemento) > 0
			THEN
				delete [dbo].[almacenamiento.Cadena] where idComplemento = p_idComplemento
			END IF;
			delete [dbo].[almacenamiento.Complemento] where idComplemento = p_idComplemento
			set v_eliminado = 1;
		END IF;
		IF (p_complemento is not null and v_eliminado = 0)
		THEN
			IF (select count(*) from [almacenamiento where idComplemento = (select top 1 idComplemento from [almacenamiento where complemento = p_complemento)) > 0
			THEN
				delete [dbo].[almacenamiento.Cadena] where idComplemento = (select top 1 idComplemento from `dbo`.`almacenamiento.Complemento` where complemento = p_complemento)
			END IF;
			delete [dbo].[almacenamiento.Complemento] where Complemento = p_complemento
		END IF;
		set v_Resultado = '{
							"estado" : "200",
							"mensaje" : "Se ha eliminado el complemento satisfactoriamente"
						  }';
	END; TRY		
	BEGIN CATCH
		set v_Resultado = ' 
						{
							"estado" : "500",
							"mensaje" : "Ha ocurrido un error al intentar eliminar el complemento"
						}
						';
	END; CATCH
    select v_Resultado;
END;
//

DELIMITER ;


/****** Object:  StoredProcedure [dbo].[sp_almacenamientoEliminarCatalogo]    Script Date: 16/10/2019 16:05:24 ******/
/* SET ANSI_NULLS ON */
 
/* SET QUOTED_IDENTIFIER ON */
 
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
DELIMITER //

CREATE PROCEDURE sp_almacenamientoEliminarCatalogo (
	p_idCatalogo int /* = null */,p_localizacion varchar(30) /* = null */,p_Internacionalizacion varchar(30) /* = null */)
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	declare v_Resultado longtext;
	BEGIN TRY 
		delete [dbo].[almacenamiento.Localizacion]
		where idlocalizacion = p_idCatalogo or Localizacion = p_localizacion or Internacionalizacion = p_Internacionalizacion
		set v_Resultado = '{
					 	 "estado": "200",
						 "mensaje":"Se elimino correctamente la Localizacion"
						}
						';

	END; TRY
	BEGIN CATCH
		set v_Resultado = '{
					 	 "estado": "401",
						 "mensaje":"Error al eliminar el catalogo"
						}
						';
	END; CATCH
   
END;
//

DELIMITER ;


/****** Object:  StoredProcedure [dbo].[sp_almacenamientoInsertaCadena]    Script Date: 16/10/2019 16:05:24 ******/
/* SET ANSI_NULLS ON */
 
/* SET QUOTED_IDENTIFIER ON */
 
-- =============================================
-- Author:		Grupo 2
-- Create date: 07/10/2019
-- Description:	Inserta una cadena relacionada a un complemento
-- =============================================
DELIMITER //

CREATE PROCEDURE sp_almacenamientoInsertaCadena (
	-- Recibe el parametro y guarda una cadena de traduccion
	p_Complemento varchar(60),p_Localizacion varchar(10)/* = nULL */,p_internacionalizacion varchar(10)/* =null */,
	p_cadena longtext,p_nombreusr varchar(100),p_correousr varchar(150))
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	declare v_Resultado longtext;
    declare v_idComplemento int;
	declare v_idLocalizacion int;
	declare v_idEstado int;
	

	begin try 
		-- Busca el complemento y la localizacion sobre la que se insertara la cadena
		select idComplemento into v_idComplemento  from [almacenamiento where Complemento = p_Complemento;
		-- La localizacion, puede no existir 
		if (select count(*) from [almacenamiento where (Localizacion = p_Localizacion or Internacionalizacion = p_internacionalizacion) ) = 0
		then
			call `dbo`.`sp_almacenamientoInsertaLocalizacion`( v_Localizacion,v_internacionalizacion);
		end if;
		
		select idlocalizacion into v_idLocalizacion from [almacenamiento where (Localizacion = p_Localizacion or Internacionalizacion = p_internacionalizacion); 
		
		-- ------------------------------------------
		select idEstado into v_idEstado from [almacenamiento where Estado = 'Activo';
		insert into [almacenamiento 
		values (v_idComplemento,v_idLocalizacion,v_idEstado,ifnull(p_cadena,'NA'),p_nombreusr,p_correousr,Null);

		set v_Resultado = CONCAT('{
					 	 "estado": "200",
						 "mensaje":"Cadena agregada correctamente al complemento "' , p_Complemento , 
						'}
						');


	end; try
	begin catch
		set v_Resultado = '{
					 		 "estado": "401",
							 "mensaje":"Error al Insertar la Cadena"
							}';
	end; catch
	select v_Resultado;
END;
//

DELIMITER ;


/****** Object:  StoredProcedure [dbo].[sp_almacenamientoInsertaComplemento]    Script Date: 16/10/2019 16:05:24 ******/
/* SET ANSI_NULLS ON */
 
/* SET QUOTED_IDENTIFIER ON */
 
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
DELIMITER //

CREATE PROCEDURE sp_almacenamientoInsertaComplemento (
	-- Add the parameters for the stored procedure here
	p_Json longtext,p_nombreusr varchar(100),p_correousr varchar(150),p_localizacion varchar(20) /* = null */,p_Estado varchar(15) /* =null */)
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
		DECLARE v_idLocalizacion int;
		DECLARE v_idEstado int;
		DECLARE v_resultado longtext;
		DECLARE v_Complemento varchar(60);
		DECLARE v_IdComplemento int;
	BEGIN TRY
		
		Select *
		into ##tmpJson
		from parseJSON(;p_Json)

		select idEstado into v_idEstado from [almacenamiento where Estado = 'Activo';

		select StringValue into v_Complemento 
		from ##tmpJson
		where Parent_ID = (select Object_ID  from ##tmpJson where Name = 'complementos')
		and Name = 'nombre';

		insert into [almacenamiento
		values (v_Complemento,p_nombreusr,p_correousr,v_idEstado);

		select idComplemento into v_IdComplemento from [almacenamiento where Complemento = v_Complemento;

		insert into [almacenamiento
		select v_IdComplemento,(select idlocalizacion from [almacenamiento where Localizacion =  StringValue),v_idEstado
		from ##tmpJson
		where  Parent_ID = (select Object_ID  from ##tmpJson where Name = 'localizaciones')
		and Name = 'nombre';
					   		 	  
		set v_resultado = ' 
						{
						  "estado": "200",
						  "mensaje": "OK",
						  "data": 
							{
							  "nombre": "Se ha insertado el Complemento Correctamente "							 
							}
						}
					';
	END; TRY
	BEGIN CATCH
		set v_resultado = '{
					 	 "estado": "401",
						 "mensaje":"Error al Crear el Complemento"
						}
						';
	end; CATCH
    -- Insert statements for procedure here
	SELECT v_resultado;
END;
//

DELIMITER ;


/****** Object:  StoredProcedure [dbo].[sp_almacenamientoInsertaEstado]    Script Date: 16/10/2019 16:05:24 ******/
/* SET ANSI_NULLS ON */
 
/* SET QUOTED_IDENTIFIER ON */
 
-- =============================================
-- Author:		Gupo 1
-- Create date: 06/10/2019
-- Description:	Inserta estado en la tabla de estados, devuelve
-- un string con formato json
-- =============================================
DELIMITER //

CREATE PROCEDURE sp_almacenamientoInsertaEstado (
	p_Estado varchar(25))
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	declare v_Resultado longtext;
	BEGIN TRY 
		-- inserta en la tabla de estados.
		insert into [almacenamiento values(p_Estado);
		set v_Resultado = CONCAT(' 
						{
						  "estado": "200",
						  "mensaje": "OK",
						  "data": 
							{
							  "nombre": "' , p_Estado ,'"							 
							}
						}
					');
	END; TRY
	BEGIN CATCH
		set v_Resultado = '{
					 	 "estado": "401",
						 "mensaje":"Error al Crear Estado"
						}
						';
	end; CATCH
    -- Insert statements for procedure here
	SELECT v_Resultado;
END;
//

DELIMITER ;


/****** Object:  StoredProcedure [dbo].[sp_almacenamientoInsertaLocalizacion]    Script Date: 16/10/2019 16:05:24 ******/
/* SET ANSI_NULLS ON */
 
/* SET QUOTED_IDENTIFIER ON */
 
-- =============================================
-- Author:		Grupo2
-- Create date: 2019-10-06
-- Description:	Se crea el catalogo de localizacion, cuando inserta lo crea como estado activo.
-- =============================================
DELIMITER //

CREATE PROCEDURE sp_almacenamientoInsertaLocalizacion (
	p_localizacion varchar(10) /* = null */, p_internacionalizacion varchar(10) /* = null */)
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	declare v_IdEstado int;
	declare v_Resultado longtext;
	BEGIN TRY 
		-- Busca el estado activo
		if (select count(*) from [almacenamiento where Estado = 'Activo') > 0
		then
			select idEstado into v_IdEstado from [almacenamiento where Estado = 'Activo';
		else
			call `dbo`.`sp_alamacenamientoInsertaEstado` 'Activo';
		end if; 

		if (select count(*) from [almacenamiento where (Internacionalizacion = p_localizacion or Localizacion = p_localizacion)) = 0
		-- inserta en la tabla de localizcaion.
		then
			insert into [almacenamiento values(p_localizacion,p_internacionalizacion,v_IdEstado);
			set v_Resultado = CONCAT(' 
						{
						  "estado": "200",
						  "mensaje": "OK",
						  "data": 
							{
							  "nombre": "' ,ifnull( p_localizacion,''),'-' ,ifnull(p_internacionalizacion,''),'"							 
							}
						}
					');
		 end if;
		 -- else
		 -- begin
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
		 -- end
	END; TRY
	BEGIN CATCH
		set v_Resultado = '{
					 	 "estado": "401",
						 "mensaje":"Error al Crear la Localizacion"
						}
						';
	end; CATCH
    -- Insert statements for procedure here
	SELECT v_Resultado;
END;
//

DELIMITER ;


/****** Object:  StoredProcedure [dbo].[sp_almacenamientoInsertaTraduccion]    Script Date: 16/10/2019 16:05:24 ******/
/* SET ANSI_NULLS ON */
 
/* SET QUOTED_IDENTIFIER ON */
 
-- =============================================
-- Author:		Grupo 2
-- Create date: 07/10/2019
-- Description:	Inserta una cadena relacionada a un complemento
-- =============================================
DELIMITER //

CREATE PROCEDURE sp_almacenamientoInsertaTraduccion (
	-- Recibe el parametro y guarda una cadena de traduccion
	p_Complemento varchar(60),p_Localizacion varchar(10)/* = nULL */,p_internacionalizacion varchar(10)/* =null */,
	p_cadenaOrginal longtext,p_cadena longtext,p_nombreusr varchar(100),p_correousr varchar(150))
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	declare v_Resultado longtext;
    declare v_idComplemento int;
	declare v_idLocalizacion int;
	declare v_idEstado int;
	declare v_idlocalizacionorginal int;
	declare v_idDetalleComplemento int default 0;
	

	begin try 
		-- Busca el complemento y la localizacion sobre la que se insertara la cadena
		select idComplemento, idlocalizacion into v_idComplemento, v_idlocalizacionorginal  from [almacenamiento where Complemento = p_Complemento;
		-- La localizacion, puede no existir 
		if (select count(*) from [almacenamiento where (Localizacion = p_Localizacion or Internacionalizacion = p_internacionalizacion) ) = 0
		then
			call `dbo`.`sp_almacenamientoInsertaLocalizacion`( v_Localizacion,v_internacionalizacion);
		end if;
		
		select idlocalizacion into v_idLocalizacion from [almacenamiento where (Localizacion = p_Localizacion or Internacionalizacion = p_internacionalizacion); 
		-- -----------------------------------------
		select idEstado into v_idEstado from [almacenamiento where Estado = 'Activo';
		-- --------------Busca la cadena Original
		select idDetalleComplemento into v_idDetalleComplemento from [almacenamiento 
		where idcomplemento = v_idComplemento 
		and cadena = p_cadenaOrginal and idlocalizacion = v_idlocalizacionorginal;

		-- Almacena Cadena Traducida
		if v_idDetalleComplemento != 0
		then
			insert into [almacenamiento 
			values (v_idComplemento,v_idLocalizacion,v_idEstado,ifnull(p_cadena,'NA'),p_nombreusr,p_correousr,v_idDetalleComplemento);

			set v_Resultado = CONCAT('{
					 		 "estado": "200",
							 "mensaje":"Traduccion agregada correctamente al complemento..."' , p_Complemento , 
							'}
							');
		else
			set v_Resultado = CONCAT('{
					 		 "estado": "400",
							 "mensaje":"No existe Cadena Original..."' , p_Complemento , 
							'}
							');
		end if;
	end; try
	begin catch
		set v_Resultado = '{
					 		 "estado": "401",
							 "mensaje":"Error al Insertar Traduccion..."
							}';
	end; catch
	select v_Resultado;
END;
//

DELIMITER ;


/****** Object:  StoredProcedure [dbo].[sp_almacenamientoObtenerCatalogo]    Script Date: 16/10/2019 16:05:24 ******/
/* SET ANSI_NULLS ON */
 
/* SET QUOTED_IDENTIFIER ON */
 
-- =============================================
-- Author:		Gupo 1
-- Create date: 06/10/2019
-- Description:	Muestra la tabla de catalogos
-- =============================================
DELIMITER //

CREATE PROCEDURE sp_almacenamientoObtenerCatalogo (
	p_idCatalogo int /* = null */,p_localizacion varchar(30) /* = null */,p_Internacionalizacion varchar(30) /* = null */)
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	declare v_Resultado longtext;
	BEGIN TRY 
		if (p_idCatalogo is not null or p_localizacion is not null or p_Internacionalizacion is not null)
		THEN
			SELECT idlocalizacion,Localizacion,Internacionalizacion,Estado 
			FROM [almacenamiento L
			inner join [dbo].[almacenamiento.Estado] E
				on l.idEstado = E.idEstado
			WHERE (L.idlocalizacion = p_idCatalogo or Localizacion = p_localizacion or Internacionalizacion = p_Internacionalizacion);
		ELSE
			SELECT idlocalizacion,Localizacion,Internacionalizacion,Estado 
			FROM [almacenamiento L
			inner join [dbo].[almacenamiento.Estado] E
				on l.idEstado = E.idEstado;
		END IF;
	END; TRY
	BEGIN CATCH
		set v_Resultado = '{
					 	 "estado": "401",
						 "mensaje":"Error al Desplegar los Catalogos"
						}
						';
	END; CATCH
END;
//

DELIMITER ;


/****** Object:  StoredProcedure [dbo].[sp_almacenamientoObtenerComplemento]    Script Date: 16/10/2019 16:05:24 ******/
/* SET ANSI_NULLS ON */
 
/* SET QUOTED_IDENTIFIER ON */
 
-- =============================================
-- Author:		Grupo 2
-- Create date: 2019-10-06
-- Description:	Lista de complementos, lo puede hacer por ID o todos
-- =============================================
DELIMITER //

CREATE PROCEDURE sp_almacenamientoObtenerComplemento (
	-- Add the parameters for the stored procedure here
	p_idComplemento int /* = null */,p_complemento varchar(60) /* = null */)
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	declare v_Resultado longtext;
	BEGIN TRY
		-- Insert statements for procedure here
		IF (p_idComplemento is null and p_complemento is null)
		THEN
			select C.idComplemento,C.Complemento,C.nombreusr,c.correousr,E.Estado,l.Internacionalizacion,
			l.Localizacion
			from `almacenamient`.Complemento] C
			inner join [dbo].[almacenamiento.ComplementoLocalizacion] CL
				on C.idComplemento = CL.idComplemento
			inner join 	[dbo].[almacenamiento.Estado] E
				on e.idEstado = c.idEstado	
			inner join [dbo].[almacenamiento.Localizacion] L
				on l.idlocalizacion = CL.idlocalizacion;
		ELSE
			select C.idComplemento,C.Complemento,C.nombreusr,c.correousr,E.Estado,l.Internacionalizacion,
			l.Localizacion
			from `almacenamient`.Complemento] C
			inner join [dbo].[almacenamiento.ComplementoLocalizacion] CL
				on C.idComplemento = CL.idComplemento
			inner join 	[dbo].[almacenamiento.Estado] E
				on e.idEstado = c.idEstado	
			inner join [dbo].[almacenamiento.Localizacion] L
				on l.idlocalizacion = CL.idlocalizacion
			where C.idComplemento = p_idComplemento or C.Complemento = p_complemento;	
		END IF;
	END; TRY
	BEGIN CATCH
			select  '{
					 		 "estado": "401",
							 "mensaje":"Error en la busqueda de complementos"
							}
							';
	END; CATCH
	-- SELECT @Resultado
END;
//

DELIMITER ;


/****** Object:  StoredProcedure [dbo].[sp_almacenamientoRetornaCadena]    Script Date: 16/10/2019 16:05:24 ******/
/* SET ANSI_NULLS ON */
 
/* SET QUOTED_IDENTIFIER ON */
 
-- =============================================
-- Author:		Grupo2
-- Create date: 2019-10-07
-- Description:	Retorna una cadena o todas las cadenas que han cargado al complemento por localizacion
-- =============================================
DELIMITER //

CREATE PROCEDURE sp_almacenamientoRetornaCadena (
	p_Complemento varchar(60),p_Cadena longtext /* = null */,p_localizacion varchar(20)/* =NULL */)
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	declare v_Resultado longtext;
	declare v_idComplemento int;
	declare v_idLocalizacion int;

	select idComplemento into v_idComplemento from [almacenamiento where Complemento = p_Complemento;
	if p_localizacion is not null
	then 
		-- Envia la localizacion 
		(select top 1 idlocalizacion into v_idLocalizacion from [almacenamiento where (Localizacion = p_localizacion or Internacionalizacion = p_localizacion))
	else
		-- Toma la localizacion original del complemento
		select idlocalizacion into v_idLocalizacion from `almacenamient`.Complemento] where Complemento = p_Complemento;
	end if;


	BEGIN TRY
	if p_Cadena is not null or p_Cadena <> ''
		then 
			select Co.idComplemento,Co.Complemento,Lo.Localizacion,c.cadena
			from [almacenamiento C
			inner join [dbo].[almacenamiento.Complemento] Co on C.idComplemento = Co.idComplemento
			inner join [dbo].[almacenamiento.Localizacion] Lo on Lo.idlocalizacion = C.idlocalizacion
			where C.idComplemento = v_idComplemento
			and C.idlocalizacion = v_idLocalizacion
			and cadena = p_Cadena;
		else
			select Co.idComplemento,Co.Complemento,Lo.Localizacion,c.cadena
			from [almacenamiento C
			inner join [dbo].[almacenamiento.Complemento] Co on C.idComplemento = Co.idComplemento
			inner join [dbo].[almacenamiento.Localizacion] Lo on Lo.idlocalizacion = C.idlocalizacion
			where C.idComplemento =v_idComplemento
			and C.idlocalizacion = v_idLocalizacion;-- (select top 1 idlocalizacion from [dbo].[almacenamiento.Localizacion] where (Localizacion = @localizacion or Internacionalizacion = @localizacion))
		end if;
	END; TRY
	BEGIN CATCH
			set v_Resultado = '{
					 		 "estado": "401",
							 "mensaje":"Error al listar complemento"
							}
							';
	END; CATCH
	-- SELECT @Resultado
END;
//

DELIMITER ;


/****** Object:  StoredProcedure [dbo].[sp_traduccionRevisar]    Script Date: 16/10/2019 16:05:24 ******/
/* SET ANSI_NULLS ON */
 
/* SET QUOTED_IDENTIFIER ON */
 
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
DELIMITER //

CREATE PROCEDURE sp_traduccionRevisar (
	-- Add the parameters for the stored procedure here
	 p_Complemento varchar(60), p_LocalizacionTraduccion varchar(10))
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

    select C.Complemento,Ca.cadena As CadenaOriginal, C.idlocalizacion IdioOriginal, ifnull(ca2.cadena,'No hay traduccion para esta cadena') CadenaTraducida
	,Ca2.nombreusr,ca2.correousr
		from [almacenamiento C
		inner join [dbo].[almacenamiento.Cadena] Ca on C.idComplemento = Ca.idComplemento and C.idlocalizacion = Ca.idlocalizacion
		left join [dbo].[almacenamiento.Cadena] Ca2 on C.idComplemento = Ca2.idComplemento 
			and Ca2.idlocalizacion = (select idlocalizacion from [almacenamiento where Localizacion = p_LocalizacionTraduccion)
			and Ca2.IdCadenaOriginal = Ca.idDetalleComplemento 
		where Complemento = p_Complemento;
END;
//

DELIMITER ;


USE `master`;
 
ALTER DATABASE `Almacenamiento` SET  READ_WRITE 
GO

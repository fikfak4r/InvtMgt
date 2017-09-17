USE [CustomerSupport_Default_v1]
GO
/****** Object:  Table [dbo].[Accounts]    Script Date: 9/17/2017 7:56:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Accounts](
	[AccountID] [int] IDENTITY(1,1) NOT NULL,
	[Date] [date] NOT NULL,
	[CompanyName] [varchar](250) NOT NULL,
	[Logo] [image] NULL,
	[Address] [nvarchar](max) NULL,
	[Email] [varchar](250) NULL,
	[PhoneNumber] [nvarchar](50) NULL,
	[WebsiteAddress] [nvarchar](250) NULL,
	[AgreeToTerms] [bit] NULL,
 CONSTRAINT [PK_Accounts] PRIMARY KEY CLUSTERED 
(
	[AccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ActionsLogs]    Script Date: 9/17/2017 7:56:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ActionsLogs](
	[ActionLogId] [int] IDENTITY(1,1) NOT NULL,
	[TicketId] [int] NULL,
	[Action] [varchar](50) NULL,
	[Date] [datetime] NULL,
	[UserId] [int] NULL,
 CONSTRAINT [PK_ActionsLogs] PRIMARY KEY CLUSTERED 
(
	[ActionLogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CallProcess]    Script Date: 9/17/2017 7:56:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CallProcess](
	[CallProcessID] [int] IDENTITY(1,1) NOT NULL,
	[CallID] [int] NOT NULL,
	[UserID] [int] NULL,
	[Date] [datetime] NOT NULL,
	[Description] [varchar](max) NOT NULL,
	[ReplyComment] [tinyint] NULL,
	[CreatorID] [int] NULL,
	[CallDirection] [tinyint] NOT NULL,
 CONSTRAINT [PK_CallProcess] PRIMARY KEY CLUSTERED 
(
	[CallProcessID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Calls]    Script Date: 9/17/2017 7:56:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Calls](
	[CallID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NOT NULL,
	[GroupID] [int] NULL,
	[UserID] [int] NULL,
	[Date] [datetime] NOT NULL,
	[Subject] [varchar](250) NULL,
	[Description] [varchar](max) NOT NULL,
	[CallDirection] [tinyint] NOT NULL,
	[Priority] [tinyint] NULL,
	[Status] [tinyint] NULL,
	[NextFollowUpDate] [datetime] NULL,
	[CreatorID] [int] NULL,
	[Me] [bit] NULL,
	[LocationID] [int] NOT NULL,
	[FollowUpAction] [varchar](max) NULL,
 CONSTRAINT [PK_Calls] PRIMARY KEY CLUSTERED 
(
	[CallID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Customers]    Script Date: 9/17/2017 7:56:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Customers](
	[CustomerID] [int] IDENTITY(1,1) NOT NULL,
	[LocationID] [int] NULL,
	[Date] [datetime] NULL,
	[FirstName] [varchar](150) NULL,
	[LastName] [varchar](150) NULL,
	[FullName] [varchar](150) NULL,
	[Sex] [tinyint] NULL,
	[DateOfBirth] [date] NULL,
	[PhoneNumber] [varchar](50) NULL,
	[Email] [varchar](50) NULL,
	[Address] [varchar](max) NULL,
 CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CustomersSms]    Script Date: 9/17/2017 7:56:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomersSms](
	[CustomerSmsId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NULL,
	[SmsId] [int] NULL,
	[Sent] [bit] NULL,
	[Delivered] [bit] NULL,
	[UnDelivered] [bit] NULL,
 CONSTRAINT [PK_CustomersSms] PRIMARY KEY CLUSTERED 
(
	[CustomerSmsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Exceptions]    Script Date: 9/17/2017 7:56:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Exceptions](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[GUID] [uniqueidentifier] NOT NULL,
	[ApplicationName] [nvarchar](50) NOT NULL,
	[MachineName] [nvarchar](50) NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[Type] [nvarchar](100) NOT NULL,
	[IsProtected] [bit] NOT NULL,
	[Host] [nvarchar](100) NULL,
	[Url] [nvarchar](500) NULL,
	[HTTPMethod] [nvarchar](10) NULL,
	[IPAddress] [nvarchar](40) NULL,
	[Source] [nvarchar](100) NULL,
	[Message] [nvarchar](1000) NULL,
	[Detail] [nvarchar](max) NULL,
	[StatusCode] [int] NULL,
	[SQL] [nvarchar](max) NULL,
	[DeletionDate] [datetime] NULL,
	[FullJson] [nvarchar](max) NULL,
	[ErrorHash] [int] NULL,
	[DuplicateCount] [int] NOT NULL,
 CONSTRAINT [PK_Exceptions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GetCode]    Script Date: 9/17/2017 7:56:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[GetCode](
	[GetCodeID] [int] IDENTITY(1,1) NOT NULL,
	[AccountID] [int] NULL,
	[LocationID] [int] NULL,
	[LinkCode] [varchar](350) NULL,
	[FormCode] [varchar](500) NULL,
 CONSTRAINT [PK_GetCode] PRIMARY KEY CLUSTERED 
(
	[GetCodeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[KB_Category]    Script Date: 9/17/2017 7:56:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[KB_Category](
	[KB_CategoryID] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [varchar](250) NOT NULL,
	[LocationID] [int] NULL,
 CONSTRAINT [PK_KB_Category] PRIMARY KEY CLUSTERED 
(
	[KB_CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[KBCategoryLocations]    Script Date: 9/17/2017 7:56:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KBCategoryLocations](
	[KBCategoryLocationID] [int] IDENTITY(1,1) NOT NULL,
	[KBCategoryID] [int] NULL,
	[LocationID] [int] NULL,
 CONSTRAINT [PK_KBCategoryLocations] PRIMARY KEY CLUSTERED 
(
	[KBCategoryLocationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[KnowledgeBase]    Script Date: 9/17/2017 7:56:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[KnowledgeBase](
	[KB_ID] [int] IDENTITY(1,1) NOT NULL,
	[KB_CategoryID] [int] NOT NULL,
	[Title] [varchar](250) NOT NULL,
	[KB_Content] [varchar](max) NOT NULL,
 CONSTRAINT [PK_KnowledgeBase] PRIMARY KEY CLUSTERED 
(
	[KB_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[KnowledgeBaseLocations]    Script Date: 9/17/2017 7:56:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KnowledgeBaseLocations](
	[KBLocationID] [int] IDENTITY(1,1) NOT NULL,
	[KBID] [int] NULL,
	[LocationID] [int] NULL,
 CONSTRAINT [PK_KnowledgeBaseLocations] PRIMARY KEY CLUSTERED 
(
	[KBLocationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Languages]    Script Date: 9/17/2017 7:56:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Languages](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LanguageId] [nvarchar](10) NOT NULL,
	[LanguageName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Languages] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Locations]    Script Date: 9/17/2017 7:56:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Locations](
	[LocationID] [int] IDENTITY(1,1) NOT NULL,
	[AccountID] [int] NOT NULL,
	[Date] [date] NULL,
	[PhoneNumber] [nvarchar](50) NULL,
	[Email] [nvarchar](50) NULL,
	[Website] [nvarchar](50) NULL,
	[LocationName] [nvarchar](250) NOT NULL,
	[Address] [nvarchar](max) NULL,
	[UserID] [int] NULL,
	[IsVisible] [bit] NULL,
 CONSTRAINT [PK_Locations] PRIMARY KEY CLUSTERED 
(
	[LocationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Notes]    Script Date: 9/17/2017 7:56:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Notes](
	[NoteID] [bigint] IDENTITY(1,1) NOT NULL,
	[CallDirection] [varchar](15) NULL,
	[EntityType] [nvarchar](100) NOT NULL,
	[EntityID] [bigint] NOT NULL,
	[Text] [nvarchar](max) NOT NULL,
	[InsertUserId] [int] NOT NULL,
	[InsertDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Notes] PRIMARY KEY CLUSTERED 
(
	[NoteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PaymentsDetails]    Script Date: 9/17/2017 7:56:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PaymentsDetails](
	[PaymentDetailId] [int] IDENTITY(1,1) NOT NULL,
	[TransactionId] [int] NULL,
	[Date] [datetime] NULL,
	[TotalAmount] [money] NULL,
	[AmountPaid] [money] NULL,
	[AmountLeft] [money] NULL,
	[IsTotalAmountRow] [bit] NOT NULL,
	[LocationID] [int] NULL,
 CONSTRAINT [PK_PaymentsDetails] PRIMARY KEY CLUSTERED 
(
	[PaymentDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Products]    Script Date: 9/17/2017 7:56:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Products](
	[ProductId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NULL,
	[UnitName] [varchar](50) NULL,
	[Price] [money] NULL,
 CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED 
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ProductsLocations]    Script Date: 9/17/2017 7:56:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductsLocations](
	[ProductLocationId] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NULL,
	[LocationId] [int] NULL,
 CONSTRAINT [PK_ProductsLocations] PRIMARY KEY CLUSTERED 
(
	[ProductLocationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RolePermissions]    Script Date: 9/17/2017 7:56:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RolePermissions](
	[RolePermissionId] [bigint] IDENTITY(1,1) NOT NULL,
	[RoleId] [int] NOT NULL,
	[PermissionKey] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_RolePermissions] PRIMARY KEY CLUSTERED 
(
	[RolePermissionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Roles]    Script Date: 9/17/2017 7:56:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Roles](
	[RoleId] [int] IDENTITY(1,1) NOT NULL,
	[RoleName] [nvarchar](100) NOT NULL,
	[AccountID] [int] NULL,
 CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED 
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RolesLocations]    Script Date: 9/17/2017 7:56:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RolesLocations](
	[RoleLocationID] [int] IDENTITY(1,1) NOT NULL,
	[RoleID] [int] NULL,
	[LocationID] [int] NULL,
 CONSTRAINT [PK_RolesLocations] PRIMARY KEY CLUSTERED 
(
	[RoleLocationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Sms]    Script Date: 9/17/2017 7:56:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Sms](
	[SmsId] [int] IDENTITY(1,1) NOT NULL,
	[Date] [smalldatetime] NULL,
	[Message] [varchar](500) NULL,
 CONSTRAINT [PK_Sms] PRIMARY KEY CLUSTERED 
(
	[SmsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SmsLocations]    Script Date: 9/17/2017 7:56:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SmsLocations](
	[SmsLocationId] [int] IDENTITY(1,1) NOT NULL,
	[SmsId] [int] NULL,
	[LocationId] [int] NULL,
 CONSTRAINT [PK_SmsLocations] PRIMARY KEY CLUSTERED 
(
	[SmsLocationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TicketProcess]    Script Date: 9/17/2017 7:56:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TicketProcess](
	[TicketProcessID] [int] IDENTITY(1,1) NOT NULL,
	[TicketID] [int] NULL,
	[Date] [datetime] NULL,
	[UserID] [int] NULL,
	[Description] [varchar](max) NULL,
	[ReplyComment] [tinyint] NULL,
	[CreatorID] [int] NULL,
 CONSTRAINT [PK_TicketProcess] PRIMARY KEY CLUSTERED 
(
	[TicketProcessID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Tickets]    Script Date: 9/17/2017 7:56:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tickets](
	[TicketID] [int] IDENTITY(1,1) NOT NULL,
	[TicketIdString] [varchar](50) NULL,
	[LocationID] [int] NULL,
	[Date] [datetime] NOT NULL,
	[CustomerID] [int] NULL,
	[TransactionId] [int] NULL,
	[CallDirection] [tinyint] NULL,
	[ProductId] [int] NULL,
	[Type] [tinyint] NULL,
	[Priority] [tinyint] NULL,
	[Status] [tinyint] NULL,
	[GroupID] [int] NULL,
	[UserID] [int] NULL,
	[Subject] [varchar](250) NULL,
	[CreatorID] [int] NULL,
	[Me] [bit] NULL,
	[PhoneNumber] [varchar](50) NULL,
	[NextFollowUpdate] [datetime] NULL,
	[FollowUpAction] [varchar](max) NULL,
 CONSTRAINT [PK_Tickets] PRIMARY KEY CLUSTERED 
(
	[TicketID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TicketsSms]    Script Date: 9/17/2017 7:56:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TicketsSms](
	[TicketSmsId] [int] IDENTITY(1,1) NOT NULL,
	[TicketId] [int] NULL,
	[SmsId] [int] NULL,
	[Sent] [bit] NULL,
	[Delivered] [bit] NULL,
	[UnDelivered] [bit] NULL,
 CONSTRAINT [PK_TicketsSms] PRIMARY KEY CLUSTERED 
(
	[TicketSmsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Transactions]    Script Date: 9/17/2017 7:56:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Transactions](
	[TransactionId] [int] IDENTITY(1,1) NOT NULL,
	[OrderID] [varchar](50) NOT NULL,
	[Date] [datetime] NOT NULL,
	[TicketId] [int] NULL,
	[CustomerId] [int] NULL,
	[Subject] [varchar](250) NULL,
	[TotalAmount] [money] NOT NULL,
	[TotalAmountPaid] [money] NULL,
	[TotalAmountLeft] [money] NULL,
	[HasTransactionsDetails] [bit] NOT NULL,
	[LocationID] [int] NULL,
	[IsIntegerTrailingOrderIDWithPrefixPO] [bit] NULL,
	[Status] [varchar](20) NOT NULL,
	[IsOpen] [bit] NOT NULL,
	[IsInProgress] [bit] NOT NULL,
	[IsFullyReceived] [bit] NOT NULL,
	[IsFullyPaid] [bit] NOT NULL,
	[IsAdvanced] [bit] NULL,
 CONSTRAINT [PK_Transactions] PRIMARY KEY CLUSTERED 
(
	[TransactionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TransactionsDetails]    Script Date: 9/17/2017 7:56:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TransactionsDetails](
	[TransactionDetailId] [int] IDENTITY(1,1) NOT NULL,
	[TransactionId] [int] NULL,
	[Date] [datetime] NULL,
	[ProductId] [int] NULL,
	[UnitPrice] [money] NULL,
	[UnitName] [varchar](50) NULL,
	[Discount] [money] NULL,
	[Amount] [money] NOT NULL,
	[Quantity] [int] NOT NULL,
	[LocationID] [int] NULL,
	[IsReceived] [bit] NULL,
 CONSTRAINT [PK_TransactionsDetails] PRIMARY KEY CLUSTERED 
(
	[TransactionDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TransactionsSms]    Script Date: 9/17/2017 7:56:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TransactionsSms](
	[TransactionSmsId] [int] IDENTITY(1,1) NOT NULL,
	[TransactionId] [int] NULL,
	[SmsId] [int] NULL,
	[Sent] [bit] NULL,
	[Delivered] [bit] NULL,
	[UnDelivered] [bit] NULL,
 CONSTRAINT [PK_TransactionsSms] PRIMARY KEY CLUSTERED 
(
	[TransactionSmsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UserPermissions]    Script Date: 9/17/2017 7:56:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserPermissions](
	[UserPermissionId] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[PermissionKey] [nvarchar](100) NOT NULL,
	[Granted] [bit] NOT NULL,
	[Grant] [bit] NOT NULL,
 CONSTRAINT [PK_UserPermissions] PRIMARY KEY CLUSTERED 
(
	[UserPermissionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UserPreferences]    Script Date: 9/17/2017 7:56:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserPreferences](
	[UserPreferenceId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[PreferenceType] [nvarchar](100) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[Value] [nvarchar](max) NULL,
 CONSTRAINT [PK_UserPreferences] PRIMARY KEY CLUSTERED 
(
	[UserPreferenceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UserRoles]    Script Date: 9/17/2017 7:56:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRoles](
	[UserRoleId] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[RoleId] [int] NOT NULL,
 CONSTRAINT [PK_UserRoles] PRIMARY KEY CLUSTERED 
(
	[UserRoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Users]    Script Date: 9/17/2017 7:56:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](100) NOT NULL,
	[DisplayName] [nvarchar](100) NOT NULL,
	[Email] [nvarchar](100) NULL,
	[Source] [nvarchar](4) NOT NULL,
	[PasswordHash] [nvarchar](86) NOT NULL,
	[PasswordSalt] [nvarchar](10) NOT NULL,
	[LastDirectoryUpdate] [datetime] NULL,
	[UserImage] [nvarchar](100) NULL,
	[InsertDate] [datetime] NOT NULL,
	[InsertUserId] [int] NOT NULL,
	[UpdateDate] [datetime] NULL,
	[UpdateUserId] [int] NULL,
	[AccountID] [int] NULL,
	[CustomerID] [int] NULL,
	[IsActive] [smallint] NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UsersLocations]    Script Date: 9/17/2017 7:56:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UsersLocations](
	[UserLocationID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NULL,
	[LocationID] [int] NULL,
 CONSTRAINT [PK_UsersLocations] PRIMARY KEY CLUSTERED 
(
	[UserLocationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[VersionInfo]    Script Date: 9/17/2017 7:56:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VersionInfo](
	[Version] [bigint] NOT NULL,
	[AppliedOn] [datetime] NULL,
	[Description] [nvarchar](1024) NULL
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[Exceptions] ADD  CONSTRAINT [DF_Exceptions_IsProtected]  DEFAULT ((1)) FOR [IsProtected]
GO
ALTER TABLE [dbo].[Exceptions] ADD  CONSTRAINT [DF_Exceptions_DuplicateCount]  DEFAULT ((1)) FOR [DuplicateCount]
GO
ALTER TABLE [dbo].[UserPermissions] ADD  CONSTRAINT [DF_UserPermissions_Granted]  DEFAULT ((1)) FOR [Granted]
GO
ALTER TABLE [dbo].[UserPermissions] ADD  CONSTRAINT [DF_UserPermissions_Grant]  DEFAULT ((1)) FOR [Grant]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[ActionsLogs]  WITH CHECK ADD  CONSTRAINT [FK_ActionsLogs_Tickets] FOREIGN KEY([TicketId])
REFERENCES [dbo].[Tickets] ([TicketID])
GO
ALTER TABLE [dbo].[ActionsLogs] CHECK CONSTRAINT [FK_ActionsLogs_Tickets]
GO
ALTER TABLE [dbo].[ActionsLogs]  WITH CHECK ADD  CONSTRAINT [FK_ActionsLogs_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[ActionsLogs] CHECK CONSTRAINT [FK_ActionsLogs_Users]
GO
ALTER TABLE [dbo].[CallProcess]  WITH CHECK ADD  CONSTRAINT [FK_CallProcess_Calls] FOREIGN KEY([CallID])
REFERENCES [dbo].[Calls] ([CallID])
GO
ALTER TABLE [dbo].[CallProcess] CHECK CONSTRAINT [FK_CallProcess_Calls]
GO
ALTER TABLE [dbo].[Calls]  WITH CHECK ADD  CONSTRAINT [FK_Calls_Customers] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customers] ([CustomerID])
GO
ALTER TABLE [dbo].[Calls] CHECK CONSTRAINT [FK_Calls_Customers]
GO
ALTER TABLE [dbo].[Calls]  WITH CHECK ADD  CONSTRAINT [FK_Calls_Locations] FOREIGN KEY([LocationID])
REFERENCES [dbo].[Locations] ([LocationID])
GO
ALTER TABLE [dbo].[Calls] CHECK CONSTRAINT [FK_Calls_Locations]
GO
ALTER TABLE [dbo].[Customers]  WITH CHECK ADD  CONSTRAINT [FK_Customers_Locations] FOREIGN KEY([LocationID])
REFERENCES [dbo].[Locations] ([LocationID])
GO
ALTER TABLE [dbo].[Customers] CHECK CONSTRAINT [FK_Customers_Locations]
GO
ALTER TABLE [dbo].[CustomersSms]  WITH CHECK ADD  CONSTRAINT [FK_CustomersSms_Customers] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customers] ([CustomerID])
GO
ALTER TABLE [dbo].[CustomersSms] CHECK CONSTRAINT [FK_CustomersSms_Customers]
GO
ALTER TABLE [dbo].[CustomersSms]  WITH CHECK ADD  CONSTRAINT [FK_CustomersSms_Sms] FOREIGN KEY([SmsId])
REFERENCES [dbo].[Sms] ([SmsId])
GO
ALTER TABLE [dbo].[CustomersSms] CHECK CONSTRAINT [FK_CustomersSms_Sms]
GO
ALTER TABLE [dbo].[GetCode]  WITH CHECK ADD  CONSTRAINT [FK_GetCode_Accounts] FOREIGN KEY([AccountID])
REFERENCES [dbo].[Accounts] ([AccountID])
GO
ALTER TABLE [dbo].[GetCode] CHECK CONSTRAINT [FK_GetCode_Accounts]
GO
ALTER TABLE [dbo].[GetCode]  WITH CHECK ADD  CONSTRAINT [FK_GetCode_Locations] FOREIGN KEY([LocationID])
REFERENCES [dbo].[Locations] ([LocationID])
GO
ALTER TABLE [dbo].[GetCode] CHECK CONSTRAINT [FK_GetCode_Locations]
GO
ALTER TABLE [dbo].[KB_Category]  WITH CHECK ADD  CONSTRAINT [FK_KB_Category_Locations] FOREIGN KEY([LocationID])
REFERENCES [dbo].[Locations] ([LocationID])
GO
ALTER TABLE [dbo].[KB_Category] CHECK CONSTRAINT [FK_KB_Category_Locations]
GO
ALTER TABLE [dbo].[KnowledgeBase]  WITH CHECK ADD  CONSTRAINT [FK_KnowledgeBase_KB_Category] FOREIGN KEY([KB_CategoryID])
REFERENCES [dbo].[KB_Category] ([KB_CategoryID])
GO
ALTER TABLE [dbo].[KnowledgeBase] CHECK CONSTRAINT [FK_KnowledgeBase_KB_Category]
GO
ALTER TABLE [dbo].[Locations]  WITH CHECK ADD  CONSTRAINT [FK_Locations_Accounts] FOREIGN KEY([AccountID])
REFERENCES [dbo].[Accounts] ([AccountID])
GO
ALTER TABLE [dbo].[Locations] CHECK CONSTRAINT [FK_Locations_Accounts]
GO
ALTER TABLE [dbo].[PaymentsDetails]  WITH CHECK ADD  CONSTRAINT [FK_PaymentsDetails_Transactions] FOREIGN KEY([TransactionId])
REFERENCES [dbo].[Transactions] ([TransactionId])
GO
ALTER TABLE [dbo].[PaymentsDetails] CHECK CONSTRAINT [FK_PaymentsDetails_Transactions]
GO
ALTER TABLE [dbo].[ProductsLocations]  WITH CHECK ADD  CONSTRAINT [FK_ProductsLocations_Locations] FOREIGN KEY([LocationId])
REFERENCES [dbo].[Locations] ([LocationID])
GO
ALTER TABLE [dbo].[ProductsLocations] CHECK CONSTRAINT [FK_ProductsLocations_Locations]
GO
ALTER TABLE [dbo].[ProductsLocations]  WITH CHECK ADD  CONSTRAINT [FK_ProductsLocations_Products] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([ProductId])
GO
ALTER TABLE [dbo].[ProductsLocations] CHECK CONSTRAINT [FK_ProductsLocations_Products]
GO
ALTER TABLE [dbo].[RolePermissions]  WITH CHECK ADD  CONSTRAINT [FK_RolePermissions_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Roles] ([RoleId])
GO
ALTER TABLE [dbo].[RolePermissions] CHECK CONSTRAINT [FK_RolePermissions_RoleId]
GO
ALTER TABLE [dbo].[SmsLocations]  WITH CHECK ADD  CONSTRAINT [FK_SmsLocations_Locations] FOREIGN KEY([LocationId])
REFERENCES [dbo].[Locations] ([LocationID])
GO
ALTER TABLE [dbo].[SmsLocations] CHECK CONSTRAINT [FK_SmsLocations_Locations]
GO
ALTER TABLE [dbo].[SmsLocations]  WITH CHECK ADD  CONSTRAINT [FK_SmsLocations_Sms] FOREIGN KEY([SmsId])
REFERENCES [dbo].[Sms] ([SmsId])
GO
ALTER TABLE [dbo].[SmsLocations] CHECK CONSTRAINT [FK_SmsLocations_Sms]
GO
ALTER TABLE [dbo].[Tickets]  WITH CHECK ADD  CONSTRAINT [FK_Tickets_Products] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([ProductId])
GO
ALTER TABLE [dbo].[Tickets] CHECK CONSTRAINT [FK_Tickets_Products]
GO
ALTER TABLE [dbo].[TicketsSms]  WITH CHECK ADD  CONSTRAINT [FK_TicketsSms_Sms] FOREIGN KEY([TicketSmsId])
REFERENCES [dbo].[Sms] ([SmsId])
GO
ALTER TABLE [dbo].[TicketsSms] CHECK CONSTRAINT [FK_TicketsSms_Sms]
GO
ALTER TABLE [dbo].[TicketsSms]  WITH CHECK ADD  CONSTRAINT [FK_TicketsSms_Tickets] FOREIGN KEY([TicketId])
REFERENCES [dbo].[Tickets] ([TicketID])
GO
ALTER TABLE [dbo].[TicketsSms] CHECK CONSTRAINT [FK_TicketsSms_Tickets]
GO
ALTER TABLE [dbo].[Transactions]  WITH CHECK ADD  CONSTRAINT [FK_Transactions_Locations] FOREIGN KEY([LocationID])
REFERENCES [dbo].[Locations] ([LocationID])
GO
ALTER TABLE [dbo].[Transactions] CHECK CONSTRAINT [FK_Transactions_Locations]
GO
ALTER TABLE [dbo].[TransactionsDetails]  WITH CHECK ADD  CONSTRAINT [FK_TransactionsDetails_Products] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([ProductId])
GO
ALTER TABLE [dbo].[TransactionsDetails] CHECK CONSTRAINT [FK_TransactionsDetails_Products]
GO
ALTER TABLE [dbo].[TransactionsDetails]  WITH CHECK ADD  CONSTRAINT [FK_TransactionsDetails_Transactions] FOREIGN KEY([TransactionId])
REFERENCES [dbo].[Transactions] ([TransactionId])
GO
ALTER TABLE [dbo].[TransactionsDetails] CHECK CONSTRAINT [FK_TransactionsDetails_Transactions]
GO
ALTER TABLE [dbo].[TransactionsSms]  WITH CHECK ADD  CONSTRAINT [FK_TransactionsSms_Sms] FOREIGN KEY([SmsId])
REFERENCES [dbo].[Sms] ([SmsId])
GO
ALTER TABLE [dbo].[TransactionsSms] CHECK CONSTRAINT [FK_TransactionsSms_Sms]
GO
ALTER TABLE [dbo].[TransactionsSms]  WITH CHECK ADD  CONSTRAINT [FK_TransactionsSms_Transactions] FOREIGN KEY([TransactionId])
REFERENCES [dbo].[Transactions] ([TransactionId])
GO
ALTER TABLE [dbo].[TransactionsSms] CHECK CONSTRAINT [FK_TransactionsSms_Transactions]
GO
ALTER TABLE [dbo].[UserPermissions]  WITH CHECK ADD  CONSTRAINT [FK_UserPermissions_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[UserPermissions] CHECK CONSTRAINT [FK_UserPermissions_UserId]
GO
ALTER TABLE [dbo].[UserRoles]  WITH CHECK ADD  CONSTRAINT [FK_UserRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Roles] ([RoleId])
GO
ALTER TABLE [dbo].[UserRoles] CHECK CONSTRAINT [FK_UserRoles_RoleId]
GO
ALTER TABLE [dbo].[UserRoles]  WITH CHECK ADD  CONSTRAINT [FK_UserRoles_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[UserRoles] CHECK CONSTRAINT [FK_UserRoles_UserId]
GO
ALTER TABLE [dbo].[UsersLocations]  WITH CHECK ADD  CONSTRAINT [FK_UsersLocations_Locations] FOREIGN KEY([LocationID])
REFERENCES [dbo].[Locations] ([LocationID])
GO
ALTER TABLE [dbo].[UsersLocations] CHECK CONSTRAINT [FK_UsersLocations_Locations]
GO
ALTER TABLE [dbo].[UsersLocations]  WITH CHECK ADD  CONSTRAINT [FK_UsersLocations_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[UsersLocations] CHECK CONSTRAINT [FK_UsersLocations_Users]
GO

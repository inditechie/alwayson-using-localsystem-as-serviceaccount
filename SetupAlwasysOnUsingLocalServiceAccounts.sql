/*

	Setup AlwaysOn using
	Local System as the SQL Service account
	ALso Without endpoint certificate.

Info: 
	Port for AlwaysOn Port: "5022"
	
By:
	Ghufran Khan
	FB: https://www.facebook.com/GhufranKhan89
	Youtube: https://youtu.be/ryRTTyGDcfA
	GitHub: https://github.com/inditechie/alwayson-using-localsystem-as-serviceaccount
*/
 
-- First Step
-- Run on Primary node :
USE [master]
GO

CREATE ENDPOINT [Hadr_endpoint]
	AS TCP (LISTENER_PORT = 5022)
    FOR DATA_MIRRORING (
	    ROLE = ALL,
	    AUTHENTICATION = WINDOWS NEGOTIATE,
		ENCRYPTION = REQUIRED ALGORITHM AES
		);
 
 
ALTER ENDPOINT [Hadr_endpoint] STATE = STARTED;
GO
 
CREATE LOGIN [<Domain\SecondaryNode>$] FROM WINDOWS -- Example: [CONTOSO\N2$]
GO
 
GRANT CONNECT ON ENDPOINT::[Hadr_endpoint] TO [<Domain\SecondaryNode>$]
GO

GRANT ALTER ANY AVAILABILITY GROUP TO [NT AUTHORITY\SYSTEM]
GO

GRANT VIEW SERVER STATE TO [NT AUTHORITY\SYSTEM]
GO

GRANT CONNECT SQL TO [NT AUTHORITY\SYSTEM]
GO
 
-- Second Step
-- Run on Secondary node :
USE [master]
GO

CREATE ENDPOINT [Hadr_endpoint]
	AS TCP (LISTENER_PORT = 5022)
    FOR DATA_MIRRORING (
	    ROLE = ALL,
	    AUTHENTICATION = WINDOWS NEGOTIATE,
		ENCRYPTION = REQUIRED ALGORITHM AES
		);
 
ALTER ENDPOINT [Hadr_endpoint] STATE = STARTED;
GO
 
CREATE LOGIN [<Domain\PrimaryNode>$] FROM WINDOWS -- Example: [CONTOSO\N1$]
GO
 
GRANT CONNECT ON ENDPOINT::[Hadr_endpoint] TO [<Domain\PrimaryNode>$]
GO

GRANT ALTER ANY AVAILABILITY GROUP TO [NT AUTHORITY\SYSTEM]
GO

GRANT VIEW SERVER STATE TO [NT AUTHORITY\SYSTEM]
GO

GRANT CONNECT SQL TO [NT AUTHORITY\SYSTEM]
GO
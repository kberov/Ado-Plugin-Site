/**
  This file contains data to be initially loaded when this plugin is installed
**/

PRAGMA foreign_keys = OFF;
-- fallback domain
INSERT OR IGNORE INTO domains 
VALUES(1,'localhost','LocalHost',
'Localhost - used only for testing purposes or one-site deployments',1,1,'-rwxr-xr-x',1);

-- some default pages
-- WARNING! this page is not to be used!!! If you request it it will cause an endles loop
-- and your computer will die in pain. It is just the root of all the pages in the system.
INSERT OR IGNORE INTO pages
VALUES(0,0,0,'root','root',1,NULL,0,86400,'-rwxr-xr-xr',3,3,1,1,1,0,1,1,3);
PRAGMA foreign_keys = ON;

INSERT OR IGNORE INTO pages
VALUES(1,0,1,'home','root',1,NULL,0,86400,'-rwxr-xr-xr',3,3,0,0,0,0,0,0,3);
INSERT OR IGNORE INTO pages
VALUES(2,1,1,'about','regular',1,NULL,0,86400,'-rwxr-xr-xr',3,3,1427662919,1427662919,0,0,0,0,3);
INSERT OR IGNORE INTO pages
VALUES(3,1,1,'contacts','regular',1,NULL,0,86400,'-rwxr-xr-xr',3,3,1427663173,1427663173,0,0,0,0,3);
INSERT OR IGNORE INTO pages
VALUES(4,1,1,'news','folder',1,NULL,0,86400,'-rwxr-xr-xr',3,3,1427663173,1427663173,0,0,0,0,3);
INSERT OR IGNORE INTO pages
VALUES(5,4,1,'politics','regular',1,NULL,0,86400,'-rwxr-xr-xr',3,3,1427663592,1427663592,0,0,0,0,3);
INSERT OR IGNORE INTO pages
VALUES(6,4,1,'business','regular',1,NULL,0,86400,'-rwxr-xr-xr',3,3,1427663592,1427663592,0,0,0,0,3);
INSERT OR IGNORE INTO pages
VALUES(7,4,1,'opininions','regular',1,NULL,0,86400,'-rwxr-xr-xr',3,3,1427664592,1427664592,0,0,0,0,3);

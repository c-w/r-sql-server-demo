CREATE CREDENTIAL [https://$(StorageAccount).blob.core.windows.net/$(BackupContainerName)]
WITH IDENTITY = 'SHARED ACCESS SIGNATURE',
SECRET = '$(BackupSAS)';

RESTORE DATABASE NYCTaxi_Sample
FROM URL = 'https://$(StorageAccount).blob.core.windows.net/$(BackupContainerName)/$(Database).bak'
WITH MOVE '$(Database)_log' TO 'https://$(StorageAccount).blob.core.windows.net/$(BackupContainerName)/$(Database)_log.ldf',
STATS = 10;

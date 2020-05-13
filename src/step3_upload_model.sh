export AZURE_STORAGE_CONNECTION_STRING="$CHANGEME_insert_azure_storage_account_connection_string_here"
az storage blob upload -c models -n model.rds -f model.rds

  Class Sql{

    [MySql.Data.MySqlClient.MySqlConnection]ConnectDB([String]$MySqlInfo){
        try{
            $db = New-Object MySql.Data.MySqlClient.MySqlConnection;
            $db.ConnectionString = $mysqlInfo;
            $db.Open();
        return $db
        }
        catch{
            return $Error
        }
    }
    
    [System.Data.Dataset]QueryDB([MySql.Data.MySqlClient.MySqlConnection]$db, [String]$Query){
        try{
            $command = New-Object MySql.Data.MySqlClient.MySqlCommand($query, $db)
            $dataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($command)
            $dataSet = New-Object System.Data.DataSet
            $recordCount = $dataAdapter.Fill($dataSet, "data")
            $dataSet.Tables["data"] | Format-Table
            return $dataSet
        }
        catch{
            return $Error
        }
    }

    CloseDB([MySql.Data.MySqlClient.MySqlConnection]$db){
        $db.Close()
    }

}
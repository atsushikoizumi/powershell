#
# [Description] 
#  vacuum analyze tables in pg_stat_user_tables
#
# [Args]
#  $1 = \full_path\postgres_param.ps1
#

$Error.Clear()  # clear $Error
$ErrorActionPreference = "Stop"

#==========================================================
# log file
#==========================================================
$Filename = "vacuum.log"
$LogFile = "$PSScriptRoot\$Filename"
if ( -not (Test-Path -Path $LogFile)) {
    New-Item $LogFile -ItemType "file"
    Write-Output "make log file."  | Out-File -Append -Encoding default $LogFile
}

#==========================================================
# message
#==========================================================
function LOG_MSG_FMT()
{
    param (
        [parameter(Mandatory,Position=0)][ValidateNotNullOrEmpty()][ValidateRange(0, 9)][int32]$type,
        [parameter(Mandatory=$false,Position=1)][string]$msg
    )
    switch( $type ){
    1 {
        Write-Output "$(Get-date -format "yyyy/MM/dd HH:mm:ss") $msg"  | Out-File -Append -Encoding default $LogFile
        break
       }
    2 {
        Write-Output "$(Get-date -format "yyyy/MM/dd HH:mm:ss") [ERROR] $msg"  | Out-File -Append -Encoding default $LogFile
        Write-Host $msg -ForegroundColor Red
        break
      }
    3 { 
        Write-Output $Error | Out-String | Out-File -Append -Encoding default $LogFile
        break
      }
    4 { 
        Write-Output $msg | Out-File -Append -Encoding default $LogFile
        break
      }
    5 { 
        Write-Error $msg
        break
      }
    }
}

LOG_MSG_FMT 1 "=========================================================="
LOG_MSG_FMT 1 "start."

#==========================================================
#  check args
#==========================================================
if (($Args.Count -eq 1) -And ($Args[0].Split("\")[-1] = "postgres_env.ps1")) {
    LOG_MSG_FMT 1 "parameter file check. seccess."
    . $Args[0]
} else {
    LOG_MSG_FMT 2 "parameter file check. failed."
    exit
}

#==========================================================
#  check parameters
#==========================================================
function check_param ( $postgres_env_key, $postgres_env_value )
{
   if ([string]::IsNullOrEmpty($postgres_env_value)){
        LOG_MSG_FMT 2 "please set ${postgres_env_key}."
        exit
   } else {
        LOG_MSG_FMT 1 "${postgres_env_key} = ${postgres_env_value}"
   }
}

check_param "HOSTNAME"     $HOSTNAME
check_param "DBNAME"       $DBNAME
check_param "PORT"         $PORT
check_param "DBUSER"       $DBUSER
check_param "DBUSER_PASS"  $DBUSER_PASS
$env:PGPASSWORD = $DBUSER_PASS  # set PGPASSWORD

#==================================================
# TableListSelect
#==================================================
$TableListSelect = @"
SELECT
    schemaname,
    relname,
    to_char(last_analyze, 'yyyy.mm.dd hh24:mi:ss')
FROM
    pg_stat_user_tables
order by
    schemaname,
    relname
;
"@

#==================================================
# psql -c TableListSelect1
#==================================================
try
{
    $SelectResult1 = psql -t -w -h $HOSTNAME -U $DBUSER -p $PORT -d $DBNAME -c $TableListSelect
    if ( -Not ($?)) {
        LOG_MSG_FMT 5 "failed."
    }
}
catch
{
    LOG_MSG_FMT 2 "psql -c TableListSelect. failed."
    LOG_MSG_FMT 3
    exit
}

#==================================================
# select 0 rows
#==================================================
if ([string]::IsNullOrEmpty($SelectResult1)) {
    LOG_MSG_FMT 2 "select 0 rows. failed."
    exit
}

#==================================================
# VACUUM ANALYZE
#==================================================
for ( $i = 0; $i -lt $SelectResult1.Count ; $i++ ) {
    if ( -Not ([string]::IsNullOrEmpty($SelectResult1[$i]))) {

        $SplitResult = $SelectResult1[$i].Split("|").Trim()
        $V_A_sql = "VACUUM ANALYZE `"$($SplitResult[0])`".`"$($SplitResult[1])`";`r`n"

        try
        {
            $V_A_sql_Result = psql -w -a -h $HOSTNAME -U $DBUSER -p $PORT -d $DBNAME -c $V_A_sql
            if ( -Not ($?)) {
                LOG_MSG_FMT 5 "failed."
            } else {
                LOG_MSG_FMT 4 "$V_A_sql $V_A_sql_Result"
            }
        }
        catch
        {
            LOG_MSG_FMT 2 "psql -c V_A_sql. failed."
            LOG_MSG_FMT 3
            exit
        }
        finally
        {
            LOG_MSG_FMT 4 "$V_A_sql_Result"
        }
    }
}

#==================================================
# psql -c TableListSelect2
#==================================================
Start-Sleep 5
try
{
    $SelectResult2 = psql -t -w -h $HOSTNAME -U $DBUSER -p $PORT -d $DBNAME -c $TableListSelect
    if ( -Not ($?)) {
        LOG_MSG_FMT 5 "failed."
    }
}
catch
{
    LOG_MSG_FMT 2 "psql -c TableListSelect. failed."
    LOG_MSG_FMT 3
    exit
}


#==================================================
# result
#==================================================
LOG_MSG_FMT 4 "$SelectResult1"
LOG_MSG_FMT 4 "$SelectResult2"

$env:PGPASSWORD = ""  # clear PGPASSWORD
$ErrorActionPreference = "Continue"
Aurora PostgreSQL 11 への VACUUM, ANALYZE を自動実行するスクリプトです。

# 処理内容
pg_stat_user_tables に存在するテーブル全てに対して、<br>
VACUUM ANALYZE schema.table;<br>
を実行します。

# ファイル構成
・postgres_env.ps1   ・・・DB接続情報<br>
・postgres_vaxuum.ps1・・・実行スクリプト

# 実行方法
.\postgres_vaxuum.ps1 C:\User\...\postgres_env.ps1<br>
[postgres_env.ps1] は古パスを指定すること。

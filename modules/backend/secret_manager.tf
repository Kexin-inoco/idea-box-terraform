resource "aws_secretsmanager_secret" "idea_box_bck_creds" {
  name = "IDEA_BOX_BCK_CLUSTER_CREDS"
}

resource "aws_secretsmanager_secret_version" "idea_box_bck_creds_version" {
  secret_id = aws_secretsmanager_secret.idea_box_bck_creds.id
  secret_string = jsonencode({
    dbClusterIdentifier = local.rds_dbClusterIdentifier,
    password            = local.rds_password,
    db_name             = "idea-box-db",
    engine              = "postgres",
    port                = 5432,
    host                = local.rds_endpoint,
    username            = "devuser",
  })
}

resource "aws_secretsmanager_secret" "conito_creds" {
  name = "COGNITO_CREDS"
}

resource "aws_secretsmanager_secret_version" "conito_creds_version" {
  secret_id = aws_secretsmanager_secret.conito_creds.id
  secret_string = jsonencode({
    poolId       = "eu-west-3_yMrVcoRVQ",
    poolDomain   = "ideabox-app-test",
    clientId     = "455uaua8osdasejlefqfo3pi7q",
    clientSecret = "tbhrc8hqcp77qq5s4122re3pavgh88gs0ednd53r8nn2g3l3ui6",
  })
}
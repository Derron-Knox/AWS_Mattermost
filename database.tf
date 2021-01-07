#create database for mattermost

resource "aws_db_subnet_group" "mm-subgroup" {
  name       = "main"
  subnet_ids = [aws_subnet.pubsub-1.id, aws_subnet.pubsub-2.id, aws_subnet.pubsub-3.id]

  tags = {
    Name = "mm DB subnet group"
  }
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count                = var.db-instance-count
  identifier           = "mattermost-demo-${count.index}"
  cluster_identifier   = aws_rds_cluster.mattermost.id
  instance_class       = var.db-instance-type
  db_subnet_group_name = aws_db_subnet_group.mm-subgroup.name
  engine               = aws_rds_cluster.mattermost.engine
  engine_version       = aws_rds_cluster.mattermost.engine_version
}

resource "aws_rds_cluster" "mattermost" {
  cluster_identifier      = "mattermost-demo"
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.07.2"
  db_subnet_group_name    = aws_db_subnet_group.mm-subgroup.name
  database_name           = "database"
  master_username         = "Masterusername"
  master_password         = "Masterpassword!"
  vpc_security_group_ids  = [aws_security_group.mattermost-database-sg.id]
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  skip_final_snapshot     = true
}
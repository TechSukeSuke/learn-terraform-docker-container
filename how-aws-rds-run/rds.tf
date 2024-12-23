####################################################
# RDS SSM
####################################################
data "aws_ssm_parameter" "rds_DB_NAME" {
  name = "${local.ssm_parameter_store_base}/DB_NAME"
}

data "aws_ssm_parameter" "rds_DB_HOST" {
  name = "${local.ssm_parameter_store_base}/DB_HOST"
}

data "aws_ssm_parameter" "rds_DB_PORT" {
  name = "${local.ssm_parameter_store_base}/DB_PORT"
}

data "aws_ssm_parameter" "rds_DB_USER" {
  name = "${local.ssm_parameter_store_base}/DB_USER"
}

data "aws_ssm_parameter" "rds_DB_PASS" {
  name = "${local.ssm_parameter_store_base}/DB_PASS"
}

####################################################
# RDS SG
####################################################
resource "aws_security_group" "rds_sg" {
  name = "${local.app_name}-rds-sg"
  description = "${local.app_name}-rds-sg"
  vpc_id = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.app_name}-database-sg"
  }
}

resource "aws_security_group_rule" "rds_sg_rule" {
  type              = "ingress"
  from_port         = data.aws_ssm_parameter.rds_DB_PORT.value
  to_port           = data.aws_ssm_parameter.rds_DB_PORT.value
  protocol          = "tcp"
  security_group_id = aws_security_group.rds_sg.id
  cidr_blocks       = [aws_vpc.main.cidr_block]
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "${local.app_name}-rds-subnet-group"
  description = "${local.app_name}-rds-subnet-group"
  subnet_ids = [aws_subnet.private-1a.id, aws_subnet.private-1c.id]
}

####################################################
# RDS Cluster
####################################################
resource "aws_rds_cluster" "main" {
  cluster_identifier = "${local.app_name}-rds-cluster"

  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  engine = "aurora-postgresql"
  engine_version = "16"
  port = data.aws_ssm_parameter.rds_DB_PORT.value

  database_name = data.aws_ssm_parameter.rds_DB_NAME.value
  master_username = data.aws_ssm_parameter.rds_DB_USER.value
  master_password = data.aws_ssm_parameter.rds_DB_PASS.value

  skip_final_snapshot = true

  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.main.name
}

####################################################
# RDS Cluster Instance
####################################################
resource "aws_rds_cluster_instance" "main" {
  identifier = "${local.app_name}-rds-cluster-instance"
  cluster_identifier = aws_rds_cluster.main.id

  engine = aws_rds_cluster.main.engine
  engine_version = aws_rds_cluster.main.engine_version

  instance_class = "db.t3.medium"
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name

  tags = {
    Name = "${local.app_name}-rds-cluster-instance"
  }
}

####################################################
# RDS cluster config
####################################################
resource "aws_rds_cluster_parameter_group" "main" {
  name = "${local.app_name}-rds-cluster-parameter-group"
  family = "aurora-postgresql16"

  parameter {
    name  = "timezone"
    value = "Asia/Tokyo"
  }
}

####################################################
# Create SSM DB url
####################################################
resource "aws_ssm_parameter" "rds_url" {
  name = "${local.ssm_parameter_store_base}/DB_URL"
  type = "String"
  value = aws_rds_cluster.main.endpoint
}

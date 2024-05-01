provider "aws" {
    region     = "${var.region}"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
}

resource "aws_security_group" "rds_dt" {
  name        = "rds-dt"
  description = "Security group for dittodb RDS MySQL instance"

  ingress {
    description = "MySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_db_instance" "dittodb" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "8.0.33"
  instance_class       = "db.t2.micro"
  username             = "clusteradmin"
  password             = "cladmin"
  publicly_accessible  = true
  identifier           = "ditto-tf-db"
  storage_type         = "gp2"
  db_name              = "dittodb"
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.rds_dt.id]

  tags = {
    Name = "DittoDB"
  }
}
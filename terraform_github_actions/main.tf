provider "aws" {
    region     = "ap-south-1"
}

resource "aws_vpc" "ditto_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "ditto_vpc"
  }
}

resource "aws_subnet" "ditto_subnet1" {
  vpc_id            = aws_vpc.ditto_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "ditto_subnet1"
  }
}

resource "aws_subnet" "ditto_subnet2" {
  vpc_id            = aws_vpc.ditto_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "ditto_subnet2"
  }
}

resource "aws_db_subnet_group" "ditto_db_subnet_group" {
  name       = "ditto-db-subnet-group"
  subnet_ids = [aws_subnet.ditto_subnet1.id, aws_subnet.ditto_subnet2.id]

  tags = {
    Name = "Ditto DB Subnet Group"
  }
}

resource "aws_security_group" "rds_ditto" {
  name        = "rds-dt"
  description = "Security group for dittodb RDS MySQL instance"
  vpc_id      = aws_vpc.ditto_vpc.id

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
  instance_class       = "db.t3.micro"
  username             = "clusteradmin"
  password             = "cladminuser"
  storage_type         = "gp2"
  db_name              = "dittodb"
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.rds_ditto.id]
  db_subnet_group_name = aws_db_subnet_group.ditto_db_subnet_group.name
  

  tags = {
    Name = "DittoDB"
  }
}
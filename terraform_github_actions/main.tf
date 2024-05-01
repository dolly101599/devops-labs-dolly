provider "aws" {
  region = "ap-south-1"
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
}
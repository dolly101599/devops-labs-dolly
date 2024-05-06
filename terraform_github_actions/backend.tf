terraform {
  backend "s3" {
    bucket         = "dittodb-bucket"
    key            = "terrraform.tfstate"
    region         = "ap-south-1"
    }
}
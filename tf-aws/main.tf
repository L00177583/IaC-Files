provider "aws" {
  region = "us-east-1"
  //version = "~>4.48.0"
}

resource "aws_instance" "Web" {
  ami             = "ami-0b5eea76982371e91"
  instance_type   = "t2.micro"
  key_name        = "mp1ubuntu"
  security_groups = [aws_security_group.web.name]
  tags = {
    name = "WebServerbyTf"
  }
}

resource "aws_s3_bucket" "S3" {
  bucket = "my-tf-test-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_security_group" "web" {
  name        = "web-security-group"
  description = "allow access to web user"

  ingress {
    description = "allow ssh"
    to_port     = 22
    from_port   = 22
    protocol    = "tcp"
    cidr_blocks = [var.remote_user_addr]
  }

}

  resource "aws_s3_bucket_public_access_block" "S3" {
    bucket = aws_s3_bucket.S3.id

     block_public_acls       = true
     block_public_policy     = true
     ignore_public_acls      = true
     restrict_public_buckets = true
  }

output "instance_public_dns" {
  value = aws_instance.Web.public_dns
}

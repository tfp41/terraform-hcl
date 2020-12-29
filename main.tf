terraform {
  backend "remote" {
    organization = "xxxxxxxx"

    workspaces {
      name = "xxxxxxxxx"
    }
  }
}

provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "~/.aws/credentials"
}

resource "aws_s3_bucket" "tfs3" {
  bucket = var.tfs3
  acl    = "private"

  versioning {
    enabled = true
  }
}

resource "aws_iam_group" "s3admgrp" {
  name = var.iam_group
}

resource "aws_iam_group_policy" "s3admin_policy" {
  name  = "s3admin_policy"
  group = aws_iam_group.s3admgrp.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.tfs3.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_user" "s3admin" {
  for_each = toset(var.iam_user)
  name = each.key
  
  tags = {
    role = "s3 admin"
  }
}

resource "aws_iam_user_group_membership" "s3grpmember" {
  for_each = toset(var.iam_user)
  user = each.key 
  #user = aws_iam_user.s3admin.name

  groups = [
    aws_iam_group.s3admgrp.name
  ]
}

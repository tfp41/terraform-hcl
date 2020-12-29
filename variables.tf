variable "tfs3" {
  description = "s3 bucket"
  type      = string
}

variable "iam_group" {
  description = "iam group"
  type      = string
}

variable "iam_user" {
  description = "iam user /*use list*/"
  type      = list(string)
}

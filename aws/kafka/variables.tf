variable "id" {
	default = "fc91e0a0-b40f-11e4-978a-0242ac110002"
}

variable "key_name" {
	default = "us-east-1"
}

variable "instance_type" {
	default = "m3.medium"
}

variable "s3_bucket" {
	default = "kafka-benchmarking"
}

variable "instance_count_kafka" {
	default = 1
}

variable "instance_count_generators" {
	default = 1
}

variable "iam_profile" {
	default = "kafka"
}

variable "volume_size" {
  default = 250
}

# # Amazon Linux AMI 2014.09.2 (HVM)
# variable "images" {
#     default = {
#         "us-west-1" = "ami-42908907"
#         "us-east-1" = "ami-146e2a7c"
#     }
# }

# Ubuntu Trusty 14.04 LTS (x64) (ebs-ssd)
variable "images" {
    default = {
        "us-east-1" = "ami-36f8b15e"
    }
}

## private key that has access to instances
variable "key_path" {
    default = "/Users/matt/.ssh/us-east-1.pem"
}
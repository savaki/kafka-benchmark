resource "aws_security_group" "allow_all" {
  name        = "allow-all-${var.id}"
  description = "Allow all inbound traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      self        = true
  }
}


resource "aws_instance" "zookeeper" {
    associate_public_ip_address = "1"
    ami                  = "${lookup(var.images, var.region)}"
    iam_instance_profile = "${var.iam_profile}"
    instance_type        = "${var.instance_type}"
    key_name             = "${var.key_name}"
    security_groups      = ["${aws_security_group.allow_all.id}"]
    subnet_id            = "${var.subnet_id}"

    tags {
        Name    = "${var.id} - ZooKeeper"
        test-id = "${var.id}"
        node    = "zookeeper"
    }

    connection {
        user     = "ec2-user"
        key_file = "${var.key_path}"
    }

    provisioner "remote-exec" {
        scripts = [
            "scripts/prepare.sh",
            "scripts/start_zookeeper.sh"
        ]
    }
}

resource "aws_instance" "kafka_1" {
    associate_public_ip_address = "1"
    ami                  = "${lookup(var.images, var.region)}"
    iam_instance_profile = "${var.iam_profile}"
    instance_type        = "${var.instance_type}"
    key_name             = "${var.key_name}"
    security_groups      = ["${aws_security_group.allow_all.id}"]
    subnet_id            = "${var.subnet_id}"

    tags {
        Name    = "${var.id} - Kafka 1"
        test-id = "${var.id}"
        node    = "kafka"
    }

    connection {
        user     = "ec2-user"
        key_file = "${var.key_path}"
    }

    provisioner "remote-exec" {
        scripts = [
            "scripts/prepare.sh",
            "scripts/start_kafka.sh"
        ]
    }
}

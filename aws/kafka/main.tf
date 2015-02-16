resource "aws_instance" "zookeeper" {
    associate_public_ip_address = "1"
    ami                  = "${lookup(var.images, var.region)}"
    iam_instance_profile = "${var.iam_profile}"
    instance_type        = "${var.instance_type}"
    key_name             = "${var.key_name}"
    security_groups      = ["${var.security_group_id}"]
    subnet_id            = "${var.subnet_id}"

    tags {
        Name    = "${var.id} - ZooKeeper"
        test-id = "${var.id}"
        node    = "zookeeper"
    }

    connection {
        user     = "ubuntu"
        key_file = "${var.key_path}"
    }

    provisioner "remote-exec" {
        scripts = [
            "scripts/prepare.sh",
            "scripts/start_zookeeper.sh",
        ]
    }
}

#------------------------------------------------------------------------------------------

resource "aws_instance" "kafka_1" {
    associate_public_ip_address = "1"
    ami                  = "${lookup(var.images, var.region)}"
    iam_instance_profile = "${var.iam_profile}"
    instance_type        = "${var.instance_type}"
    key_name             = "${var.key_name}"
    security_groups      = ["${var.security_group_id}"]
    subnet_id            = "${var.subnet_id}"

    tags {
        Name    = "${var.id} - Kafka 1"
        test-id = "${var.id}"
        node    = "kafka"
    }

    connection {
        user     = "ubuntu"
        key_file = "${var.key_path}"
    }

    provisioner "remote-exec" {
        scripts = [
            "scripts/mount_devices.sh",
            "scripts/prepare.sh",
            "scripts/start_kafka.sh"
        ]
    }

    block_device {
        device_name = "/dev/sdf"
        volume_type = "gp2"
        volume_size = "${var.volume_size}"
    }

    block_device {
        device_name = "/dev/sdg"
        volume_type = "gp2"
        volume_size = "${var.volume_size}"
    }

    block_device {
        device_name = "/dev/sdh"
        volume_type = "gp2"
        volume_size = "${var.volume_size}"
    }

    block_device {
        device_name = "/dev/sdi"
        volume_type = "gp2"
        volume_size = "${var.volume_size}"
    }

    block_device {
        device_name = "/dev/sdj"
        volume_type = "gp2"
        volume_size = "${var.volume_size}"
    }

    block_device {
        device_name = "/dev/sdk"
        volume_type = "gp2"
        volume_size = "${var.volume_size}"
    }

    block_device {
        device_name = "/dev/sdl"
        volume_type = "gp2"
        volume_size = "${var.volume_size}"
    }
}

#------------------------------------------------------------------------------------------

resource "aws_instance" "generator_1" {
    associate_public_ip_address = "1"
    ami                  = "${lookup(var.images, var.region)}"
    iam_instance_profile = "${var.iam_profile}"
    instance_type        = "${var.instance_type}"
    key_name             = "${var.key_name}"
    security_groups      = ["${var.security_group_id}"]
    subnet_id            = "${var.subnet_id}"

    tags {
        Name    = "${var.id} - Load Generator 1"
        test-id = "${var.id}"
        node    = "generator"
    }
}
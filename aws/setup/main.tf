# --- vpc ----------------------------------------------------------

resource "aws_vpc" "default" {
	cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "default" {
	vpc_id = "${aws_vpc.default.id}"
}

# --- public subnet ------------------------------------------------

resource "aws_subnet" "public" {
	vpc_id = "${aws_vpc.default.id}"

	cidr_block        = "10.0.0.0/24"
	availability_zone = "${var.availability_zone}"
}

# --- routing ------------------------------------------------------

resource "aws_route_table" "public" {
	vpc_id = "${aws_vpc.default.id}"

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_internet_gateway.default.id}"
	}
}

resource "aws_route_table_association" "public" {
	subnet_id      = "${aws_subnet.public.id}"
	route_table_id = "${aws_route_table.public.id}"
}

# --- security group -----------------------------------------------

resource "aws_security_group" "default" {
  name        = "kafka-benchmarking"
  description = "Allow all ssh + all inter-host traffic"
  vpc_id      = "${aws_vpc.default.id}"

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

# --- outputs ------------------------------------------------------

output "vpc_id" {
  value = "${aws_vpc.default.id}"
}

output "subnet_id" {
  value = "${aws_subnet.public.id}"
}

output "security_group_id" {
  value = "${aws_security_group.default.id}"
}
resource "aws_instance" "springbootapp" {
  ami           = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "t2.micro"
  key_name = "north_virginia_batman"
  subnet_id = "${aws_subnet.private-subnet-1.id}"
  vpc_security_group_ids = ["${aws_security_group.allow-all-traffic.id}"]
  
}

resource "aws_instance" "nginx" {
  ami           = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "t2.micro"
  key_name = "north_virginia_batman"
  subnet_id = "${aws_subnet.public-subnet-1.id}"
  vpc_security_group_ids = ["${aws_security_group.allow-all-traffic.id}"]
  associate_public_ip_address = true
  
}


#Creating ebs volume for springboot
resource "aws_ebs_volume" "ebs-volume-springbootapp" {
    availability_zone = "us-east-1a"
    size = 20
    type = "gp2" 
    tags = {
        Name = "extra volume data"
    }
}

#Attaching volume to springboot
resource "aws_volume_attachment" "ebs-volume-springbootapp-attachment" {
  device_name = "/dev/xvdh"
  volume_id = "${aws_ebs_volume.ebs-volume-springbootapp.id}"
  instance_id = "${aws_instance.springbootapp.id}"
}

#Creating ebs volume for nginx
resource "aws_ebs_volume" "ebs-volume-nginx" {
    availability_zone = "us-east-1a"
    size = 20
    type = "gp2" 
    tags = {
        Name = "extra volume data"
    }
}

#Attaching volume to nginx
resource "aws_volume_attachment" "ebs-volume-nginx-attachment" {
  device_name = "/dev/xvdh"
  volume_id = "${aws_ebs_volume.ebs-volume-nginx.id}"
  instance_id = "${aws_instance.nginx.id}"
}




#Define the subnet group for RDS
resource "aws_db_subnet_group" "db-subnet" {
name = "subnet group"
subnet_ids = ["${aws_subnet.private-subnet-1.id}", "${aws_subnet.private-subnet-2.id}"]

 tags= {
    Name = "themusk_flowerapp_rds_subnetgroup"
  }
}

#Define the RDS instance
resource "aws_db_instance" "themusk_flowerapp_rds" {
allocated_storage = 20
identifier = "testinstance"
storage_type = "gp2"
engine = "mysql"
engine_version = "5.7"
# security_group_names = [ "${aws_security_group.allow-all-traffic.id}" ]
instance_class = "db.t2.micro"
name = "themusk_flowerapp_rdsinstance"
username = "${var.DB_USERNAME}"
password = "${var.DB_PASSWORD}"
parameter_group_name = "default.mysql5.7"

tags= {
    Name = "themusk_flowerapp_rdsinstance"
  }
}



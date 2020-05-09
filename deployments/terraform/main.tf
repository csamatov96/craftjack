resource "aws_instance" "docker_server" {
    count                       = "${var.count_instances}"
    instance_type               = "${var.instance_type}"
    ami                         = "${var.instance_ami}"
    key_name                    = "${var.key_name}"
    associate_public_ip_address = "true"
    security_groups             = ["open_security_group"]
    iam_instance_profile        = "${aws_iam_instance_profile.docker_profile.name}"


  provisioner "remote-exec" {
    connection {
      host        = "${self.public_ip}"
      type        = "ssh"
      user        = "${var.user}"
      private_key = "${file(var.ssh_key_location)}"
    }

    inline = [ #Tunji, please install awscli, docker, .NET Core version 3.1.201, add a line docker pull 951251854577.dkr.ecr.us-east-1.amazonaws.com/repo:latest and then run an image  
      "sudo curl -O https://bootstrap.pypa.io/get-pip.py && sudo python get-pip.py",
      "sudo /usr/local/bin/pip --version",
      "sudo /usr/local/bin/pip install awscli",
      "sudo /usr/local/bin/aws ecr get-login --no-include-email --region us-east-1 > login_script.sh",
      "export PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/ec2-user/.local/bin:/home/ec2-user/bin &&  sh login_script.sh",
      "docker run -dti -p 8080:8080 676918110389.dkr.ecr.us-east-1.amazonaws.com/interview:latest"
    ]
  }

  tags = {
    Name = "Docker Server"
  }
}

resource "local_file" "public_ip_address" {
    content     = "${aws_instance.docker_server.0.public_ip}\n${aws_instance.docker_server.1.public_ip}"
    filename = "${path.module}/public_ip_address.txt"
}

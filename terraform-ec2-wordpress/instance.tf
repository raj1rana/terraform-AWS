resource "aws_key_pair" "sshKey" {
  key_name   = "mykey"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "automationn" {
  ami           = var.AMIS[var.AWS_REGION]
  instance_type = "t2.micro"
  key_name      = aws_key_pair.sshKey.key_name
  tags = {
      Name = "Test Ubuntu"
  }
  provisioner "file" {
    source      = "apache2-php-mysql-wordpress.sh"
    destination = "/tmp/apache2-php-mysql-wordpress.sh"
  }
  connection {
    host        = coalesce(self.public_ip, self.private_ip)
    type        = "ssh"
    user        = var.INSTANCE_USERNAME
    private_key = file(var.PATH_TO_PRIVATE_KEY)
  }
   provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get upgrade -y",
      "sudo apt-get install apache2 -y",
      "sudo apt-get install mysql-server -y",
      
    ]
  }
  provisioner "local-exec" {
    command = "ssh -i automaton ubuntu@${aws_instance.automationn.public_ip} && cd /tmp/"
  }
}
output "ip" {
  value = aws_instance.automationn.public_ip
}
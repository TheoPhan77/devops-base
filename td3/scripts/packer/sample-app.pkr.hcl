packer {
  required_plugins {
    amazon = {
      version = ">= 1.3.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "aws_region" {
  type    = string
  default = "us-east-2"
}

source "amazon-ebs" "amazon_linux" {
  ami_name        = "sample-app-packer-${uuidv4()}"
  ami_description = "Amazon Linux AMI with Node.js sample app + PM2"
  instance_type   = "t3.micro"
  region          = var.aws_region
  ssh_username    = "ec2-user"

  # robuste: ne pas hardcoder une AMI
  source_ami_filter {
    filters = {
      name                = "al2023-ami-*-x86_64"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    owners      = ["amazon"]
    most_recent = true
  }
}

build {
  sources = ["source.amazon-ebs.amazon_linux"]

  provisioner "file" {
    sources     = ["app.js", "app.config.js"]
    destination = "/tmp/"
  }

  provisioner "shell" {
    inline = [
      "sudo yum update -y",
      "curl -fsSL https://rpm.nodesource.com/setup_21.x | sudo bash - || true",
      "sudo yum install -y nodejs",
      "sudo useradd -m -s /bin/bash app-user || true",
      "sudo mv /tmp/app.js /tmp/app.config.js /home/app-user/",
      "sudo chown -R app-user:app-user /home/app-user",
      "sudo npm install pm2@latest -g",
      # Démarre l'app + sauvegarde la liste PM2 (pour redémarrer après reboot)
      "sudo -iu app-user pm2 start /home/app-user/app.config.js",
      "sudo -iu app-user pm2 save",
      # IMPORTANT: pm2 startup doit être exécuté en root (pas via su app-user)
      "sudo env PATH=$PATH:/usr/bin pm2 startup systemd -u app-user --hp /home/app-user",
      "sudo systemctl enable pm2-app-user"
    ]
  }
}

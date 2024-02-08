provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
}


resource "kubernetes_namespace" "test" {
  metadata {
    name = "app"
  }
}
resource "kubernetes_deployment" "test" {
  metadata {
    name      = "flask-app"
    namespace = kubernetes_namespace.test.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "flask-app"
      }
    }
    template {
      metadata {
        labels = {
          app = "flask-app"
        }
      }
      spec {
        container {
          image = "jesusod/python-app:latest"
          name  = "flask-app"
          port {
            container_port = 8181
          }
          env {
            name  = "MYSQL_HOST"
            value = "mysql-service.default.svc.cluster.local"
          }
          env {
            name  = "MYSQL_USER"
            value = "dev"
          }
          env {
            name  = "MYSQL_DB"
            value = "crud_flask"
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "mysql" {
    metadata {
    name = "mysql"
    namespace = kubernetes_namespace.test.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "mysql"
      }
    }

    template {
      metadata {
        labels = {
          app = "mysql"
        }
      }

      spec {
        container {
          name  = "mysql"
          image = "mysql:5.5"

          port {
            container_port = 3306
          }

          env {
            name  = "MYSQL_ROOT_PASSWORD"
            value = "root"
          }

          env {
            name  = "MYSQL_DATABASE"
            value = "crud_flask"
          }

          env {
            name  = "MYSQL_USER"
            value = "dev"
          }

          env {
            name  = "MYSQL_PASSWORD"
            value = "dev"
          }

          volume_mount {
            name       = "mysql-initdb"
            mount_path = "/docker-entrypoint-initdb.d"
          }

          volume_mount {
            name       = "mysql-storage"
            mount_path = "/var/lib/mysql"
          }
        }

        volume {
          name = "mysql-initdb"
          config_map {
            name = kubernetes_config_map.mysql_preload_data_config.metadata[0].name
          }
        }

        volume {
          name = "mysql-storage"
          empty_dir {}
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.mysql_pv_claim.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "test" {
  metadata {
    name      = "flask-app-service"
    namespace = kubernetes_namespace.test.metadata[0].name
  }
  spec {
    selector = {
      app = "flask-app"
    }
    type = "NodePort"
    port {
      port        = 8181
      target_port = 8181
      node_port   = 30001
    }
  }
}

resource "kubernetes_service" "mysql_service" {
  metadata {
    name = "mysql-service"
    namespace = kubernetes_namespace.test.metadata[0].name
  }

  spec {
    selector = {
      app = "mysql"
    }

    port {
      port     = 3306
      protocol = "TCP"
    }

    cluster_ip = "None"
  }
}

resource "kubernetes_persistent_volume_claim" "mysql_pv_claim" {
  metadata {
    name = "mysql-pv-claim"
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "20Gi"
      }
    }
    volume_name = "mysql-pv-claim"
  }
}

resource "kubernetes_config_map" "mysql_preload_data_config" {
  metadata {
    name = "mysql-preload-data-config"
  }

  data = {
    "crud_flask.sql" = <<-EOT
      -- phpMyAdmin SQL Dump
      -- version 4.4.15.7
      -- http://www.phpmyadmin.net
      --
      -- Host: localhost
      -- Generation Time: Jan 30, 2017 at 10:34 AM
      -- Server version: 5.7.17-0ubuntu0.16.04.1
      -- PHP Version: 7.0.13-0ubuntu0.16.04.1
    
      SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
      SET time_zone = "+00:00";
    
      /*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
      /*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
      /*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
      /*!40101 SET NAMES utf8mb4 */;
    
      --
      -- Database: `crud_flask`
      --
      CREATE DATABASE IF NOT EXISTS crud_flask;
      USE crud_flask;
      -- --------------------------------------------------------
    
      --
      -- Table structure for table `phone_book`
      --
    
      CREATE TABLE IF NOT EXISTS `phone_book` (
        `id` int(5) NOT NULL,
        `name` varchar(255) NOT NULL,
        `phone` varchar(50) NOT NULL,
        `address` varchar(255) NOT NULL
      ) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=latin1;
    
      --
      -- Dumping data for table `phone_book`
      --
    
      INSERT INTO `phone_book` (`id`, `name`, `phone`, `address`) VALUES
      (16, 'Muhammad Hanif', '085733492411', 'Lamongan');
    
      --
      -- Indexes for dumped tables
      --
    
      --
      -- Indexes for table `phone_book`
      --
      ALTER TABLE `phone_book`
        ADD PRIMARY KEY (`id`);
    
      --
      -- AUTO_INCREMENT for dumped tables
      --
    
      --
      -- AUTO_INCREMENT for table `phone_book`
      --
      ALTER TABLE `phone_book`
        MODIFY `id` int(5) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=21;
      /*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
      /*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
      /*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
    EOT
  }
}

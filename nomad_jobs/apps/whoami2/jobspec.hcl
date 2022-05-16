job "docs" {
    datacenters = "dc1"
    priority = "50"
    type = "service"
    update {
        max_parallel = 1
        health_check = "checks"
        min_healthy_time = "10s"
        healthy_deadline = "3m"
        auto_revert = false
    }
    migrate {
        max_parallel = 1
        health_check = "checks"
        min_healthy_time = "10s"
        healthy_deadline = "5m"
    }

    group "docs" {
        count = 1
        restart {
            interval = "30m"
            attempts = 3
            delay    = "15s"
            mode     = "fail"
        }
        network {
            port "http" {
                to = -1
                host_network = "private"
            }
        }
        service {
            name = "docs"
            port = "http"
            tags = [
                "type=service",
                "environment=demo",
                "name=docs",
                "traefik.enable=true",
                "traefik.http.routers.docs.rule=Host(`docs.service.consul`)",
                "traefik.http.routers.docs.entrypoints=web,websecure",
#                "traefik.http.routers.docs.middlewares=strip-docs",
#                "traefik.http.middlewares.strip-docs.stripprefix.prefixes=/",
            ]

            check {
                name = "alive"
                type = "tcp"
                port = "http"
                interval = "10s"
                timeout  = "5s"
            }
            check_restart {
                limit = 3
                grace = "90s"
                ignore_warnings = "false"
            }
        }
        task "docs" {
            driver = "docker"
            config {
                image = "traefik/whoami:latest"
                ports = [ "http" ]
            }
	    env {
		HOST="0.0.0.0"
	    }
            resources {
                cpu     = 100
                memory  = 100
            }
        }
    }
}

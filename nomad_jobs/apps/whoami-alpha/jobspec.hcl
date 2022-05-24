job "alpha" {
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

    group "alpha" {
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
            name = "alpha"
            port = "http"
            tags = [
                "type=service",
                "environment=demo",
                "name=alpha",
                "traefik.enable=true",
                "traefik.http.routers.alpha.rule=Host(`proxima.service.consul`) && PathPrefix(`/alpha`)",
                "traefik.http.routers.alpha.entrypoints=web,websecure",
                "traefik.http.routers.alpha.middlewares=strip-alpha",
                "traefik.http.middlewares.strip-alpha.stripprefix.prefixes=/",
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
        task "alpha" {
            driver = "docker"
            config {
                image = "jwilder/whoami"
                ports = ["http"]
            }
	    env {
		HOST="0.0.0.0"
		PORT="${NOMAD_PORT_http}"
	    }
            resources {
                cpu     = 100
                memory  = 100
            }
        }
    }
}

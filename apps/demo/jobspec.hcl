job "demo-app" {
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

    group "demo-app" {
        count = 1
        restart {
            interval = "30m"
            attempts = 3
            delay    = "15s"
            mode     = "fail"
        }
        network {
            port  "http" {
            to = -1
            }
        }

        service {
            name = "demo-app"
            port = "http"
            tags = [
                "type=service",
                "environment=demo",
                "name=demo-app",
                "traefik.enable=true",
                "traefik.http.routers.demo-app.entrypoints=web,websecure",
                "traefik.http.routers.demo-app.entrypoints=web",
                "traefik.http.routers.demo-app.middlewares=strip-demo-app",
                "traefik.http.middlewares.strip-demo-app.stripprefix.prefixes=/",
                "traefik.http.routers.demo-app.rule=Host(`demo-app.service.consul`) && PathPrefix(`/`)",
            ]
            
            check {
                name = "alive"
                type = "http"
                path = "/"
                interval = "10s"
                timeout  = "5s"
            }
            check_restart {
                limit = 3
                grace = "90s"
                ignore_warnings = "false"
            }
        }
        
        task "server" {        
            driver = "docker"
            config {
                image = "hashicorp/http-echo"
                args  = ["-text", "hello world"]
            }
            resources {
                cpu     = 20
                memory  = 100
            }
        }
    }
}

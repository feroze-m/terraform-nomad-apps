locals {}

resource "nomad_job" "all_jobs" {
    for_each = fileset(path.module, "apps/*/*.hcl")
    jobspec = file("${path.module}/${each.value}")
    deregister_on_destroy   = true
    purge_on_destroy        = true
}


variable "traefik_cpu" {
    type = number
    default = 100
}
variable "traefik_mem" {
    type = number
    default = 100
}

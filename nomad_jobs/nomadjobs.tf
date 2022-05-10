locals {}

resource "nomad_job" "all_jobs" {
    for_each = fileset(path.module, "apps/*")
    jobspec = templatefile("${path.module}/${each.value}/${each.value}.tmpl", {
        traefik_cpu = var.traefik_cpu
        traefik_mem = var.traefik_mem
    })
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

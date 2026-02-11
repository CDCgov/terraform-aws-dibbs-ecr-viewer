# resource "aws_ce_cost_allocation_tag" "this" {
#   for_each = var.tags
#   tag_key  = each.key
#   status   = "Active"
# }

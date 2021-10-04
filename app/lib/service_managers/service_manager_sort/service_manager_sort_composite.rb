# autoload :ServiceManager, "service_managers/service_manager.rb"
#
# module ServiceManager
#     class ServiceManagerSortComposite
#
#         def initialize(service_managers)
#             @service_managers = { truthy: Array(service_managers), falsy: [] }
#         end
#
#         def is_satisfied_by?(candidate)
#             truthy_check = ->(spec) { spec.new.is_satisfied_by?(candidate) }
#             falsy_check = ->(spec) { !spec.new.is_satisfied_by?(candidate) }
#
#             @service_managers[:truthy].all?(&truthy_check) && @service_managers[:falsy].all?(&falsy_check)
#         end
#
#         def and(service_managers)
#             @service_managers[:truthy] = (@service_managers[:truthy] + Array(service_managers)).uniq
#             self
#         end
#
#         def not(service_managers)
#             @service_managers[:falsy] = (@service_managers[:falsy] + Array(specs)).uniq
#             self
#         end
#
#     end
# end

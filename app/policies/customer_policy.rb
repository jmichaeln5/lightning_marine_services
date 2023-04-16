###        Noticed in prod that users are added by organizations' divisions
###        EG:
###
###    first_name                  last_name                      email
###    OrganizationName@ShipName	 OrganizationName@ShipName	    OrganizationName@pennsylvania
###    OrganizationName@ShipName	 OrganizationName@ShipName      OrganizationName@AmericanPride
###    OrganizationName@ShipName 	 OrganizationName@ShipName      OrganizationName@GardenState
###
###        All users are ships, not vendors
###        Keep in mind for policies/feature access

class CustomerPolicy
  attr_reader :user, :resource

  def initialize(user, resource)
    @user = user
    @resource = resource
  end

  def displayable?
    return true if user.has_role? "vendor"
    return true if user.has_role? "staff"
    return true if user.has_role? "customer"
  end
end

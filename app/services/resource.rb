class Resource
  attr_accessor :user, :parent_class

  def initialize(user, parent_class)
    @user = user
    @parent_class = parent_class
  end

end

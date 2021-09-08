require "administrate/field/base"

# class HasManyRolesField < Administrate::Field::Base
class HasManyRolesField < Administrate::Field::HasMany

  def to_s
    data
  end
end

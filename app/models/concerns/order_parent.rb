module OrderParent
  extend ActiveSupport::Concern

  included do
    # after_find do |order_parent|
    #   establish_order_amount
    # end
    #
    # after_initialize do |order_parent|
    #   establish_order_amount
    # end

    after_find do |order_parent|
      establish_order_amount
    end

    after_initialize do |order_parent|
      establish_order_amount
    end

    has_many :orders
    attribute :order_amount, :integer
    # scope :sort_by_order_amount, order('jobs_count DESC')
    # scope :sort_by_order_amount, ->(sort_direction) { reorder("name" + " " + sort_direction) }

    # ######################################################
    # ######################################################
    # ######################################################
    # # NOTE change to validates_with in Validator and call
    # #  E.Gs below
    # # atom /Users/jonathannorton/Desktop/code/rails-projects/apps/rails-7-apps/documentality
    #
    # ### Document
    # # atom /Users/jonathannorton/Desktop/code/rails-projects/apps/rails-7-apps/documentality/app/models/document.rb
    #
    # ### Documentable::Document
    # # atom /Users/jonathannorton/Desktop/code/rails-projects/apps/rails-7-apps/documentality/app/models/concerns/documentable/document.rb
    #
    # ### DocumentValidator
    # # atom /Users/jonathannorton/Desktop/code/rails-projects/apps/rails-7-apps/documentality/app/models/validators/documentable/document_validator.rb
    # ######################################################
    # ######################################################
    before_destroy :check_associated_orders
    # ######################################################
    # ######################################################



  end

  def establish_order_amount
    self.order_ids.size
    self.order_amount = self.order_ids.size
    return self.order_amount
  end

  # ######################################################
  # ######################################################
  # ######################################################
  private

    def check_associated_orders
      if self.orders.any?
        self.errors.add(:base, "Unable to delete. #{self.orders.count} associated orders. You must update associated orders before deleting.")
        throw(:abort)
      end
    end
  # ######################################################
  # ######################################################
  # ######################################################

end

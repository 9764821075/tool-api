module SoftDeleteable
  extend ActiveSupport::Concern

  class_methods do
    def soft_deleteable(options = {})
      has_one  = options[:has_one]  || []
      has_many = options[:has_many] || []

      scope :existing, -> { where(deleted: false) }
      scope :with_deleted, -> { unscope(where: :deleted) }
      scope :only_deleted, -> { with_deleted.where(deleted: true) }

      default_scope { existing }

      define_method :soft_delete do
        transaction do
          update_column(:deleted, true)

          has_one.each do |association|
            record = public_send(association)
            record.update_column(:deleted, true) if record
          end

          has_many.each do |association|
            public_send(association).update_all(deleted: true)
          end
        end
      end

      define_method :restore do
        transaction do
          update_column(:deleted, false)

          has_one.each do |association|
            record = public_send(association)
            record.update_column(:deleted, false) if record
          end

          has_many.each do |association|
            public_send(association).unscoped.update_all(deleted: false)
          end
        end
      end
    end
  end

  def soft_deleted?
    deleted?
  end

end

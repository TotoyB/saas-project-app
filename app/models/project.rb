class Project < ApplicationRecord
  belongs_to :tenant
  validates_uniqueness_of :title
  validate :free_plan_can_only_have_one_project

  def free_plan_can_only_have_one_project
    if self.new_record? && (tenant.project.count > 0) && (tenant.plan  == 'free')
      errors.add(:base, 'Free Plans cannot have more than one project')
    end
  end

  def self.by_plan_and_tenant(tenant_id)
    tenant = Tenant.find(tenant_id)
    if tenant == 'Premium'
      tenant.projects
    else
      tenant.projects.order(:id).limit(1)
    end
  end
end

class ManageIQ::Providers::Openshift::ContainerManager < ManageIQ::Providers::ContainerManager
  include ManageIQ::Providers::Openshift::ContainerManagerMixin

  require_nested :EventCatcher
  require_nested :EventParser
  require_nested :MetricsCollectorWorker
  require_nested :RefreshParser
  require_nested :RefreshWorker
  require_nested :Refresher

  has_many :openshift_container_images, :foreign_key => :ems_id, :dependent => :destroy

  def self.ems_type
    @ems_type ||= "openshift".freeze
  end

  def self.description
    @description ||= "OpenShift".freeze
  end

  def self.event_monitor_class
    ManageIQ::Providers::Openshift::ContainerManager::EventCatcher
  end

  def create_project(project)
    connect.create_project_request(project)
  rescue KubeException => e
    raise MiqException::MiqProvisionError, "Unexpected Exception while creating project: #{e}"
  end
end

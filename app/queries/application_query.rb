class ApplicationQuery
  attr_reader :relation, :options
  class_attribute :relation_class

  class << self
    def call(*args) = new(*args).call

    def query_on(object)
      raise StandardError, "#{name} class's query_on method require param as a model class name, can not be blank." if object.blank?

      self.relation_class = object.is_a?(String) ? object.constantize : object
    end

    def base_relation
      raise StandardError, "#{name} class require relation class defined. Use query_on method to define it." unless relation_class

      relation_class.all
    end
  end

  def initialize(*args)
    @options = args.extract_options!
    @relation = args.first || self.class.base_relation
  end

  def call = raise NotImplementedError, "You must define `call` as instance method in #{self.class.name} class."
end

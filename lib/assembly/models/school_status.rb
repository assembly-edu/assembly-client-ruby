module Assembly
  class SchoolStatus < ApiModel
    include Assembly::Actions::List

    # Override: use a nested path to the endpoint
    def self.path
      "/school/status"
    end
  end

  Resource.build(SchoolStatus)
end

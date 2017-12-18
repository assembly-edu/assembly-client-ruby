module Assembly
  class Assessment < ApiModel
    include Assembly::Actions::Read
    include Assembly::Actions::List
  
    def grade_set(params={})
      response = client.get(path + '/grade_set', params)
      Util.build(response[:grade_set], client)
    end
  end

  Resource.build(Assessment)
end

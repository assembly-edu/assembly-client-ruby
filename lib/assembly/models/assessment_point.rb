module Assembly
  class AssessmentPoint < ApiModel
    include Assembly::Actions::Read
    include Assembly::Actions::List

    def pages(path, params)
      results = []
      page = 1
      while page
        response = client.get(path, {page: page, per_page: 100}.merge(params))
        ret = Util.build(response, client)
        results += ret.data
        page = ret.next_page
      end
      results
    end

    def results(params={})
      pages(path + "#{rank}/results", params)
    end
  end

  Resource.build(AssessmentPoint)
end
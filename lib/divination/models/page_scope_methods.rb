module Divination
  module PageScopeMethods
    # Specify the <tt>per_page</tt> value for the preceding <tt>page</tt> scope
    #   Model.page(3).per(10)
    def per(num)
      if (n = num.to_i) <= 0
        self
      elsif max_per_page && max_per_page < n
        @_per_page = max_per_page
        limit(max_per_page)
      else
        @_per_page = n
        limit(n)
      end
    end

    def next_max_id
      @_next_max_id ||= self[next_index].try(:id)
    end

    def next_url request_url
      base, params = url_parts(request_url)
      params.merge!(max_id: next_max_id) unless next_max_id.nil?
      params.to_query.length > 0 ? "#{base}?#{CGI.unescape(params.to_query)}" : base
    end

    def pagination request_url
      h = { next_max_id: next_max_id }
      h[:next_url] = next_url(request_url) unless next_max_id.nil?
      h
    end

    private

    def next_index
      (@_per_page || default_per_page) - 1
    end

    def url_parts request_url
      base, params = request_url.split('?', 2)
      params = Rack::Utils.parse_nested_query(params || '')
      params.stringify_keys!
      params.delete('max_id')
      [base, params]
    end
  end
end
